part of 'ledger.dart';

enum SalaryIssue {
  invalidInput,
  bankAccountRequired,
  duplicateReceipt,
  missingPlan,
  reversedSalary,
  planLimit,
  allocationLocked,
  missingAllocation,
  allocationLimit,
  ineligibleMovement,
  reversedMovement,
  movementLimit,
  duplicateExecution,
  unlinkedMovement,
  alreadyConfirmed,
}

class SalaryException implements Exception {
  const SalaryException(this.issue);
  final SalaryIssue issue;
}

enum SalaryProgress { planned, partial, executed, confirmed }

typedef SalaryDeposit = ({
  int id,
  int accountId,
  String account,
  String currency,
  int scale,
  int minor,
  DateTime receivedOn,
  String? reference,
  bool reversed,
  bool hasPlan,
});

typedef SalaryExecutionView = ({
  int entryId,
  int minor,
  bool reversed,
  String? evidence,
});

typedef SalaryAllocationView = ({
  int id,
  String label,
  int planned,
  int executed,
  int confirmed,
  int remaining,
  List<SalaryExecutionView> executions,
});

typedef SalaryPlanView = ({
  SalaryDeposit salary,
  List<SalaryAllocationView> allocations,
  int planned,
  int executed,
  int confirmed,
  int unallocated,
});

typedef SalaryMovement = ({
  JournalEntry entry,
  List<
    ({
      int accountId,
      String account,
      AccountKind kind,
      String currency,
      int scale,
      int minor,
    })
  >
  lines,
  bool reversed,
});

typedef ExecutionCandidate = ({SalaryMovement movement, int available});

SalaryProgress salaryProgress(int planned, int executed, int confirmed) {
  if (executed == 0) return SalaryProgress.planned;
  if (executed < planned) return SalaryProgress.partial;
  return confirmed == planned
      ? SalaryProgress.confirmed
      : SalaryProgress.executed;
}

extension SalaryLedger on Ledger {
  Future<int> recordSalary({
    required String operationId,
    required int accountId,
    required int minor,
    required DateTime receivedOn,
    String? reference,
  }) => _db.transaction(() async {
    if (minor <= 0) throw const SalaryException(SalaryIssue.invalidInput);
    final account = await _account(accountId);
    if (account.kind != AccountKind.bank) {
      throw const SalaryException(SalaryIssue.bankAccountRequired);
    }
    final ref = reference?.trim();
    final bankReference = ref == null || ref.isEmpty ? null : ref;
    if (bankReference != null && bankReference.length > 120) {
      throw const SalaryException(SalaryIssue.invalidInput);
    }
    final date = DateTime.utc(
      receivedOn.year,
      receivedOn.month,
      receivedOn.day,
    );
    final income = await _offset(account.currency, AccountKind.income);
    final previous =
        await (_db.select(_db.journalEntries)
              ..where((entry) => entry.operationId.equals(operationId)))
            .getSingleOrNull();
    if (previous == null) {
      final duplicate = await _db
          .customSelect(
            '''
        SELECT 1 FROM salary_receipts s
        JOIN journal_entries j ON j.id = s.entry_id
        JOIN journal_postings p ON p.entry_id = s.entry_id AND p.account_id = s.account_id
        WHERE s.account_id = ? AND (
          s.reference = ? OR (
            (s.reference IS NULL OR ? IS NULL) AND j.effective_micros = ? AND p.minor = ?
          )
        )
        LIMIT 1
      ''',
            variables: [
              Variable(accountId),
              Variable<String>(bankReference),
              Variable<String>(bankReference),
              Variable(date.microsecondsSinceEpoch),
              Variable(minor),
            ],
          )
          .getSingleOrNull();
      if (duplicate != null) {
        throw const SalaryException(SalaryIssue.duplicateReceipt);
      }
    }

    final id = await _persist(operationId, JournalKind.salary, date, [
      (accountId: accountId, minor: minor),
      (accountId: income.id, minor: -minor),
    ]);
    if (previous == null) {
      await _db
          .into(_db.salaryReceipts)
          .insert(
            SalaryReceiptsCompanion.insert(
              entryId: Value(id),
              accountId: accountId,
              reference: Value(bankReference),
            ),
          );
    } else {
      final receipt = await _salary(id);
      if (receipt.reference != bankReference) {
        throw const LedgerException(LedgerIssue.duplicateConflict);
      }
    }
    return id;
  });

  Future<List<SalaryDeposit>> salaries() async =>
      _salaryRows().then((rows) => rows.map(_readDeposit).toList());

  Future<void> createSalaryPlan(int salaryId) => _db.transaction(() async {
    final salary = await _activeSalary(salaryId);
    if (!salary.hasPlan) {
      await _db.into(_db.salaryPlans).insert(SalaryPlan(salaryId: salaryId));
    }
  });

  Future<SalaryPlanView> salaryPlan(int salaryId) => _db.transaction(() async {
    final salary = await _salary(salaryId);
    final rows = await _allocations(salaryId);
    final allocations = <SalaryAllocationView>[];
    for (final row in rows) {
      final links = await _executions(row.id);
      final active = links.where((link) => !link.reversed);
      final executed = active.fold(0, (sum, link) => sum + link.minor);
      final confirmed = active
          .where((link) => link.evidence != null)
          .fold(0, (sum, link) => sum + link.minor);
      allocations.add((
        id: row.id,
        label: row.label,
        planned: row.plannedMinor,
        executed: executed,
        confirmed: confirmed,
        remaining: row.plannedMinor - executed,
        executions: links,
      ));
    }
    final planned = allocations.fold(0, (sum, row) => sum + row.planned);
    return (
      salary: salary,
      allocations: allocations,
      planned: planned,
      executed: allocations.fold(0, (sum, row) => sum + row.executed),
      confirmed: allocations.fold(0, (sum, row) => sum + row.confirmed),
      unallocated: salary.minor - planned,
    );
  });

  Future<int> addSalaryAllocation(int salaryId, String label, int minor) =>
      _db.transaction(() async {
        final salary = await _activePlan(salaryId);
        final name = _allocationInput(label, minor);
        await _checkBudget(salary, minor);
        return _db
            .into(_db.salaryAllocations)
            .insert(
              SalaryAllocationsCompanion.insert(
                salaryId: salaryId,
                label: name,
                plannedMinor: minor,
              ),
            );
      });

  Future<void> updateSalaryAllocation(
    int allocationId,
    String label,
    int minor,
  ) => _db.transaction(() async {
    final allocation = await _allocation(allocationId);
    final salary = await _activePlan(allocation.salaryId);
    final name = _allocationInput(label, minor);
    await _requireDraft(allocationId);
    await _checkBudget(salary, minor, except: allocationId);
    await (_db.update(
      _db.salaryAllocations,
    )..where((a) => a.id.equals(allocationId))).write(
      SalaryAllocationsCompanion(
        label: Value(name),
        plannedMinor: Value(minor),
      ),
    );
  });

  Future<void> deleteSalaryAllocation(int allocationId) =>
      _db.transaction(() async {
        final allocation = await _allocation(allocationId);
        await _activePlan(allocation.salaryId);
        await _requireDraft(allocationId);
        await (_db.delete(
          _db.salaryAllocations,
        )..where((a) => a.id.equals(allocationId))).go();
      });

  Future<void> linkSalaryExecution({
    required int allocationId,
    required int entryId,
    required int minor,
  }) => _db.transaction(() async {
    if (minor <= 0) throw const SalaryException(SalaryIssue.invalidInput);
    final allocation = await _allocation(allocationId);
    final salary = await _activePlan(allocation.salaryId);
    final links = await _executions(allocationId);
    for (final link in links.where((link) => link.entryId == entryId)) {
      if (link.minor == minor) return;
      throw const SalaryException(SalaryIssue.duplicateExecution);
    }
    final executed = links
        .where((link) => !link.reversed)
        .fold(0, (sum, link) => sum + link.minor);
    if (minor > allocation.plannedMinor - executed) {
      throw const SalaryException(SalaryIssue.allocationLimit);
    }

    final movement = await salaryMovement(entryId);
    final capacity = _movementCapacity(salary, movement);
    final used = await _linkedMinor(entryId);
    if (minor > capacity - used) {
      throw const SalaryException(SalaryIssue.movementLimit);
    }
    await _db
        .into(_db.salaryExecutions)
        .insert(
          SalaryExecution(
            allocationId: allocationId,
            entryId: entryId,
            minor: minor,
          ),
        );
  });

  Future<void> confirmSalaryMovement(int entryId, String evidence) =>
      _db.transaction(() async {
        final note = evidence.trim();
        if (note.isEmpty || note.length > 500) {
          throw const SalaryException(SalaryIssue.invalidInput);
        }
        if (await _linkedMinor(entryId) == 0) {
          throw const SalaryException(SalaryIssue.unlinkedMovement);
        }
        final existing = await (_db.select(
          _db.movementConfirmations,
        )..where((row) => row.entryId.equals(entryId))).getSingleOrNull();
        if (existing != null) {
          if (existing.evidence == note) return;
          throw const SalaryException(SalaryIssue.alreadyConfirmed);
        }
        if (await _isReversed(entryId)) {
          throw const SalaryException(SalaryIssue.reversedMovement);
        }
        await _db
            .into(_db.movementConfirmations)
            .insert(
              MovementConfirmation(
                entryId: entryId,
                evidence: note,
                confirmedMicros: DateTime.now().microsecondsSinceEpoch,
              ),
            );
      });

  Future<SalaryMovement> salaryMovement(int entryId) async {
    final entry = await (_db.select(
      _db.journalEntries,
    )..where((row) => row.id.equals(entryId))).getSingleOrNull();
    if (entry == null) throw const LedgerException(LedgerIssue.entryNotFound);
    final rows = await _db
        .customSelect(
          '''
      SELECT a.name, a.kind, a.currency, a.id, c.scale, p.minor
      FROM journal_postings p JOIN ledger_accounts a ON a.id = p.account_id
      JOIN currencies c ON c.code = a.currency WHERE p.entry_id = ?
      ORDER BY p.minor
    ''',
          variables: [Variable(entryId)],
        )
        .get();
    return (
      entry: entry,
      lines: rows
          .map(
            (row) => (
              account: row.read<String>('name'),
              kind: AccountKind.values.byName(row.read<String>('kind')),
              currency: row.read<String>('currency'),
              scale: row.read<int>('scale'),
              minor: row.read<int>('minor'),
              accountId: row.read<int>('id'),
            ),
          )
          .toList(),
      reversed: await _isReversed(entryId),
    );
  }

  Future<List<ExecutionCandidate>> salaryCandidates(int allocationId) =>
      _db.transaction(() async {
        final allocation = await _allocation(allocationId);
        final salary = await _activePlan(allocation.salaryId);
        final rows = await _db
            .customSelect(
              '''
      SELECT j.id FROM journal_postings p JOIN journal_entries j ON p.entry_id = j.id
      WHERE p.account_id = ? AND p.minor < 0 AND j.kind IN ('entry', 'internalTransfer')
        AND NOT EXISTS (SELECT 1 FROM journal_entries r WHERE r.reversal_of = j.id)
        AND NOT EXISTS (SELECT 1 FROM salary_executions e WHERE e.entry_id = j.id AND e.allocation_id = ?)
      ORDER BY j.effective_micros DESC, j.id DESC
    ''',
              variables: [Variable(salary.accountId), Variable(allocationId)],
            )
            .get();
        final results = <ExecutionCandidate>[];
        for (final row in rows) {
          final entryId = row.read<int>('id');
          final movement = await salaryMovement(entryId);
          if (!_eligibleMovement(salary, movement)) continue;
          final available =
              -movement.lines.first.minor - await _linkedMinor(entryId);
          if (available > 0) {
            results.add((movement: movement, available: available));
          }
        }
        return results;
      });

  Future<List<QueryRow>> _salaryRows([int? id]) => _db
      .customSelect(
        '''
    SELECT s.entry_id, s.account_id, a.name, a.currency, c.scale, p.minor,
           j.effective_micros, s.reference, pl.salary_id,
           EXISTS (SELECT 1 FROM journal_entries r WHERE r.reversal_of = j.id) AS reversed
    FROM salary_receipts s JOIN journal_entries j ON j.id = s.entry_id
    JOIN ledger_accounts a ON a.id = s.account_id JOIN currencies c ON c.code = a.currency
    JOIN journal_postings p ON p.entry_id = s.entry_id AND p.account_id = s.account_id
    LEFT JOIN salary_plans pl ON pl.salary_id = s.entry_id
    ${id != null ? 'WHERE s.entry_id = ?' : ''}
    ORDER BY j.effective_micros DESC, j.id DESC
  ''',
        variables: [if (id != null) Variable(id)],
      )
      .get();

  Future<SalaryDeposit> _salary(int id) async {
    final rows = await _salaryRows(id);
    if (rows.isEmpty) throw const LedgerException(LedgerIssue.entryNotFound);
    return _readDeposit(rows.single);
  }

  Future<SalaryDeposit> _activeSalary(int id) async {
    final salary = await _salary(id);
    if (salary.reversed) {
      throw const SalaryException(SalaryIssue.reversedSalary);
    }
    return salary;
  }

  Future<SalaryDeposit> _activePlan(int id) async {
    final salary = await _activeSalary(id);
    if (!salary.hasPlan) throw const SalaryException(SalaryIssue.missingPlan);
    return salary;
  }

  Future<List<SalaryAllocation>> _allocations(int id) =>
      (_db.select(_db.salaryAllocations)
            ..where((a) => a.salaryId.equals(id))
            ..orderBy([(a) => OrderingTerm.asc(a.id)]))
          .get();

  Future<SalaryAllocation> _allocation(int id) async {
    final result = await (_db.select(
      _db.salaryAllocations,
    )..where((a) => a.id.equals(id))).getSingleOrNull();
    if (result == null) {
      throw const SalaryException(SalaryIssue.missingAllocation);
    }
    return result;
  }

  Future<List<SalaryExecutionView>> _executions(int id) async =>
      (await _db
              .customSelect(
                '''
    SELECT e.entry_id, e.minor, c.evidence,
           EXISTS (SELECT 1 FROM journal_entries r WHERE r.reversal_of = e.entry_id) AS reversed
    FROM salary_executions e LEFT JOIN movement_confirmations c ON c.entry_id = e.entry_id
    WHERE e.allocation_id = ? ORDER BY e.entry_id
  ''',
                variables: [Variable(id)],
              )
              .get())
          .map(
            (row) => (
              entryId: row.read<int>('entry_id'),
              minor: row.read<int>('minor'),
              reversed: row.read<int>('reversed') != 0,
              evidence: row.readNullable<String>('evidence'),
            ),
          )
          .toList();

  Future<int> _linkedMinor(int entryId) async =>
      (await _db
              .customSelect(
                'SELECT COALESCE(SUM(minor), 0) AS total FROM salary_executions WHERE entry_id = ?',
                variables: [Variable(entryId)],
              )
              .getSingle())
          .read<int>('total');

  Future<bool> _isReversed(int entryId) =>
      _hasEntry((row) => row.reversalOf.equals(entryId));

  Future<void> _requireDraft(int id) async {
    if ((await _executions(id)).isNotEmpty) {
      throw const SalaryException(SalaryIssue.allocationLocked);
    }
  }

  Future<void> _checkBudget(
    SalaryDeposit salary,
    int minor, {
    int? except,
  }) async {
    final current = (await _allocations(salary.id))
        .where((item) => item.id != except)
        .fold(0, (sum, item) => sum + item.plannedMinor);
    if (minor > salary.minor - current) {
      throw const SalaryException(SalaryIssue.planLimit);
    }
  }
}

SalaryDeposit _readDeposit(QueryRow row) => (
  id: row.read<int>('entry_id'),
  accountId: row.read<int>('account_id'),
  account: row.read<String>('name'),
  currency: row.read<String>('currency'),
  scale: row.read<int>('scale'),
  minor: row.read<int>('minor'),
  receivedOn: DateTime.fromMicrosecondsSinceEpoch(
    row.read<int>('effective_micros'),
    isUtc: true,
  ),
  reference: row.readNullable<String>('reference'),
  reversed: row.read<int>('reversed') != 0,
  hasPlan: row.readNullable<int>('salary_id') != null,
);

String _allocationInput(String label, int minor) {
  final name = label.trim();
  if (minor <= 0 || name.isEmpty || name.length > 100) {
    throw const SalaryException(SalaryIssue.invalidInput);
  }
  return name;
}

bool _eligibleMovement(SalaryDeposit salary, SalaryMovement movement) {
  if (!{
        JournalKind.entry,
        JournalKind.internalTransfer,
      }.contains(movement.entry.kind) ||
      movement.lines.length != 2) {
    return false;
  }
  final debit = movement.lines.first;
  final credit = movement.lines.last;
  return debit.accountId == salary.accountId &&
      debit.currency == salary.currency &&
      debit.minor < 0 &&
      credit.minor == -debit.minor &&
      credit.currency == debit.currency &&
      (credit.kind.isPersonal || credit.kind == AccountKind.expense);
}

int _movementCapacity(SalaryDeposit salary, SalaryMovement movement) {
  if (movement.reversed) {
    throw const SalaryException(SalaryIssue.reversedMovement);
  }
  if (!_eligibleMovement(salary, movement)) {
    throw const SalaryException(SalaryIssue.ineligibleMovement);
  }
  return -movement.lines.first.minor;
}
