part of 'ledger.dart';

enum RemittanceStatus { planned, sent, pending, received, cancelled, refunded }

enum RemittanceIssue {
  invalidInput,
  notFound,
  duplicateEvidence,
  invalidStatus,
  sourceLimit,
  purposeLimit,
  protectedCorrection,
}

class RemittanceException implements Exception {
  const RemittanceException(this.issue);
  final RemittanceIssue issue;
}

typedef RemittanceActivity = ({
  RemittanceEvent event,
  String? actualRate,
  SalaryMovement movement,
  JournalEntry? reversal,
  int transit,
  int received,
});

class RemittanceView {
  RemittanceView({
    required this.record,
    required this.source,
    required this.destinationName,
    required this.sourceScale,
    required this.destinationScale,
    required this.activity,
    required this.purposes,
    required this.familyPayments,
  });

  final Remittance record;
  final LedgerAccount source;
  final String destinationName;
  final int sourceScale;
  final int destinationScale;
  final List<RemittanceActivity> activity;
  final List<RemittancePurpose> purposes;
  final Map<String, List<ExpenseView>> familyPayments;

  Iterable<RemittanceActivity> get active =>
      activity.where((row) => !row.movement.reversed);
  RemittanceActivity? get debit => active
      .where((row) => row.event.kind == RemittanceEventKind.debit)
      .firstOrNull;
  int get outstanding => active.fold(0, (sum, row) => sum + row.transit);
  int get received => checkedMinor(
    active.fold(BigInt.zero, (sum, row) => sum + BigInt.from(row.received)),
  );
  int get unallocated =>
      received - purposes.fold(0, (sum, row) => sum + row.minor);

  bool needsSourceProof(RemittanceActivity row) =>
      row.event.kind == RemittanceEventKind.receipt &&
      source.currency != record.destinationCurrency &&
      row.transit == 0 &&
      !active.any((proof) => proof.event.receiptEntryId == row.event.entryId);

  RemittanceStatus get status {
    if (debit == null) {
      return record.cancelled
          ? RemittanceStatus.cancelled
          : RemittanceStatus.planned;
    }
    if (outstanding == 0 && !active.any(needsSourceProof)) {
      return received > 0
          ? RemittanceStatus.received
          : RemittanceStatus.refunded;
    }
    return record.awaiting || record.cancelled || active.length > 1
        ? RemittanceStatus.pending
        : RemittanceStatus.sent;
  }
}

extension RemittanceLedger on Ledger {
  Future<int> planRemittance({
    required String operationId,
    required int sourceAccountId,
    required RemittanceDestination destination,
    required String destinationCurrency,
    int? destinationAccountId,
    String? beneficiary,
  }) => _db.transaction(() async {
    _remittanceText(operationId, 200);
    final source = await _personalAccount(sourceAccountId);
    final name = beneficiary?.trim();
    if (source.kind != AccountKind.bank ||
        !(await currencies()).any(
          (currency) => currency.code == destinationCurrency,
        )) {
      throw const RemittanceException(RemittanceIssue.invalidInput);
    }
    if (destination == RemittanceDestination.personal) {
      if (destinationAccountId == null ||
          destinationAccountId == sourceAccountId ||
          name != null) {
        throw const RemittanceException(RemittanceIssue.invalidInput);
      }
      final target = await _personalAccount(destinationAccountId);
      if (target.currency != destinationCurrency ||
          (target.kind != AccountKind.bank &&
              target.kind != AccountKind.savings)) {
        throw const RemittanceException(RemittanceIssue.invalidInput);
      }
    } else {
      if (destinationAccountId != null) {
        throw const RemittanceException(RemittanceIssue.invalidInput);
      }
      _remittanceText(name ?? '', 100);
    }
    final previous = await (_db.select(
      _db.remittances,
    )..where((row) => row.draftKey.equals(operationId))).getSingleOrNull();
    if (previous != null) {
      if (previous.sourceAccountId == sourceAccountId &&
          previous.destination == destination &&
          previous.destinationAccountId == destinationAccountId &&
          previous.destinationCurrency == destinationCurrency &&
          previous.beneficiary == name) {
        return previous.id;
      }
      throw const LedgerException(LedgerIssue.duplicateConflict);
    }
    return _db
        .into(_db.remittances)
        .insert(
          RemittancesCompanion.insert(
            draftKey: operationId,
            sourceAccountId: sourceAccountId,
            destination: destination,
            destinationCurrency: destinationCurrency,
            destinationAccountId: Value(destinationAccountId),
            beneficiary: Value(name),
          ),
        );
  });

  Future<List<RemittanceView>> remittances() => _db.transaction(() async {
    final rows = await (_db.select(
      _db.remittances,
    )..orderBy([(row) => OrderingTerm.desc(row.id)])).get();
    return [for (final row in rows) await _remittanceView(row)];
  });

  Future<RemittanceView> remittance(int id) =>
      _db.transaction(() async => _remittanceView(await _remittance(id)));

  Future<void> updateRemittanceStatus(int id, {required bool cancel}) =>
      _db.transaction(() async {
        final view = await _remittanceView(await _remittance(id));
        if (cancel && view.record.cancelled ||
            !cancel && view.record.awaiting) {
          return;
        }
        if (view.status != RemittanceStatus.sent &&
            view.status != RemittanceStatus.pending &&
            !(cancel && view.status == RemittanceStatus.planned)) {
          throw const RemittanceException(RemittanceIssue.invalidStatus);
        }
        await (_db.update(
          _db.remittances,
        )..where((row) => row.id.equals(id))).write(
          cancel
              ? const RemittancesCompanion(cancelled: Value(true))
              : const RemittancesCompanion(awaiting: Value(true)),
        );
      });

  /// [minor] is the observed bank debit, receipt, refund or proven source share.
  /// [feeMinor] is an actual fee included in the debit, if documented.
  /// [sourceMinor] for a foreign receipt is its evidenced share of the source.
  Future<int> recordRemittanceEvent({
    required int remittanceId,
    required String operationId,
    required RemittanceEventKind kind,
    required int minor,
    required String evidence,
    required DateTime effectiveAt,
    int? feeMinor,
    int? sourceMinor,
    int? receiptEntryId,
    String? actualRate,
  }) => _db.transaction(
    () => _recordRemittanceEvent(
      remittanceId: remittanceId,
      operationId: operationId,
      kind: kind,
      minor: minor,
      evidence: evidence,
      effectiveAt: effectiveAt,
      feeMinor: feeMinor,
      sourceMinor: sourceMinor,
      receiptEntryId: receiptEntryId,
      actualRate: actualRate,
    ),
  );

  Future<int> _recordRemittanceEvent({
    required int remittanceId,
    required String operationId,
    required RemittanceEventKind kind,
    required int minor,
    required String evidence,
    required DateTime effectiveAt,
    int? feeMinor,
    int? sourceMinor,
    int? receiptEntryId,
    int? correctionOf,
    String? actualRate,
  }) async {
    final note = _remittanceText(evidence, 500);
    final view = await _remittanceView(await _remittance(remittanceId));
    final record = view.record;
    final foreign = view.source.currency != record.destinationCurrency;
    final rate = actualRate?.trim();
    if (minor <= 0 ||
        (rate != null &&
            (!foreign ||
                kind != RemittanceEventKind.receipt ||
                exchangeRateUnits(rate) == null)) ||
        (feeMinor != null &&
            (kind != RemittanceEventKind.debit ||
                feeMinor < 0 ||
                feeMinor >= minor)) ||
        (sourceMinor != null &&
            (kind != RemittanceEventKind.receipt ||
                !foreign ||
                sourceMinor <= 0)) ||
        (receiptEntryId != null) != (kind == RemittanceEventKind.sourceProof) ||
        (receiptEntryId != null && !foreign)) {
      throw const RemittanceException(RemittanceIssue.invalidInput);
    }
    final transit = await _offset(
      view.source.currency,
      AccountKind.remittanceTransit,
    );
    final sourceReduction = switch (kind) {
      RemittanceEventKind.debit => 0,
      RemittanceEventKind.refund || RemittanceEventKind.sourceProof => minor,
      RemittanceEventKind.receipt => foreign ? sourceMinor ?? 0 : minor,
    };
    final previous = await _findOperation(operationId);
    if (previous != null) {
      final existing = await _remittanceEvent(previous.id);
      if (existing == null ||
          existing.remittanceId != remittanceId ||
          existing.kind != kind ||
          existing.evidence != note ||
          existing.receiptEntryId != receiptEntryId ||
          existing.feeMinor != feeMinor ||
          await _actualRemittanceRate(previous.id) != rate) {
        throw const LedgerException(LedgerIssue.duplicateConflict);
      }
    } else {
      final debit = view.debit;
      if (kind == RemittanceEventKind.debit) {
        if (debit != null) {
          throw const RemittanceException(RemittanceIssue.invalidStatus);
        }
      } else {
        if (debit == null ||
            effectiveAt.microsecondsSinceEpoch <
                debit.movement.entry.effectiveMicros ||
            view.status == RemittanceStatus.refunded ||
            view.status == RemittanceStatus.received) {
          throw const RemittanceException(RemittanceIssue.invalidStatus);
        }
        if (sourceReduction > view.outstanding) {
          throw const RemittanceException(RemittanceIssue.sourceLimit);
        }
      }
      if (kind == RemittanceEventKind.receipt) {
        checkedMinor(BigInt.from(view.received) + BigInt.from(minor));
      }
      if (receiptEntryId != null &&
          !view.active.any(
            (row) =>
                row.event.entryId == receiptEntryId &&
                view.needsSourceProof(row) &&
                effectiveAt.microsecondsSinceEpoch >=
                    row.movement.entry.effectiveMicros,
          )) {
        throw const RemittanceException(RemittanceIssue.invalidStatus);
      }
      await _checkRemittanceEvidence(record, kind, note);
    }

    final lines = <Posting>[];
    final JournalKind journalKind;
    switch (kind) {
      case RemittanceEventKind.debit:
        journalKind = JournalKind.remittanceDebit;
        lines.addAll([
          (accountId: view.source.id, minor: -minor),
          (accountId: transit.id, minor: minor - (feeMinor ?? 0)),
          if (feeMinor != null && feeMinor > 0)
            (
              accountId: (await _offset(
                view.source.currency,
                AccountKind.expense,
              )).id,
              minor: feeMinor,
            ),
        ]);
      case RemittanceEventKind.refund:
        journalKind = JournalKind.remittanceRefund;
        lines.addAll([
          (accountId: transit.id, minor: -minor),
          (accountId: view.source.id, minor: minor),
        ]);
      case RemittanceEventKind.sourceProof:
      case RemittanceEventKind.receipt:
        final receipt = kind == RemittanceEventKind.receipt;
        journalKind = receipt
            ? JournalKind.remittanceReceipt
            : JournalKind.remittanceSettlement;
        if (sourceReduction > 0) {
          lines.add((accountId: transit.id, minor: -sourceReduction));
          if (foreign) {
            final exchange = await _offset(
              view.source.currency,
              AccountKind.remittanceExchange,
            );
            lines.add((accountId: exchange.id, minor: sourceReduction));
          }
        }
        if (receipt) {
          if (foreign) {
            final exchange = await _offset(
              record.destinationCurrency,
              AccountKind.remittanceExchange,
            );
            lines.add((accountId: exchange.id, minor: -minor));
          }
          final target =
              record.destinationAccountId ??
              (await _offset(
                record.destinationCurrency,
                AccountKind.expense,
              )).id;
          lines.add((accountId: target, minor: minor));
        }
    }
    final id = await _persist(
      operationId,
      journalKind,
      effectiveAt,
      lines,
      correctionOf: correctionOf,
    );
    if (previous == null) {
      await _db
          .into(_db.remittanceEvents)
          .insert(
            RemittanceEvent(
              entryId: id,
              remittanceId: remittanceId,
              kind: kind,
              evidence: note,
              receiptEntryId: receiptEntryId,
              feeMinor: feeMinor,
            ),
          );
      if (rate != null) {
        await _db
            .into(_db.remittanceExchangeRates)
            .insert(RemittanceExchangeRate(entryId: id, rate: rate));
      }
    }
    return id;
  }

  Future<void> addRemittancePurpose(
    int id,
    String key,
    String label,
    int minor, {
    bool family = false,
  }) => _db.transaction(() async {
    _remittanceText(key, 200);
    final name = _remittanceText(label, 100);
    final existing = await (_db.select(
      _db.remittancePurposes,
    )..where((row) => row.operationKey.equals(key))).getSingleOrNull();
    if (existing != null) {
      if (existing.remittanceId == id &&
          existing.label == name &&
          existing.minor == minor &&
          existing.family == family) {
        return;
      }
      throw const LedgerException(LedgerIssue.duplicateConflict);
    }
    final view = await _remittanceView(await _remittance(id));
    if (minor <= 0 || minor > view.unallocated) {
      throw const RemittanceException(RemittanceIssue.purposeLimit);
    }
    await _db
        .into(_db.remittancePurposes)
        .insert(
          RemittancePurpose(
            operationKey: key,
            remittanceId: id,
            label: name,
            minor: minor,
            family: family,
          ),
        );
  });

  Future<void> removeRemittancePurpose(int id, String key) =>
      _db.transaction(() async {
        final payment =
            await (_db.select(_db.remittanceFamilyPayments)
                  ..where((row) => row.purposeKey.equals(key))
                  ..limit(1))
                .getSingleOrNull();
        if (payment != null) {
          throw const RemittanceException(RemittanceIssue.protectedCorrection);
        }
        await (_db.delete(_db.remittancePurposes)..where(
              (row) =>
                  row.remittanceId.equals(id) & row.operationKey.equals(key),
            ))
            .go();
      });

  Future<List<ExpenseView>> remittanceFamilyCandidates(int id, String key) =>
      _db.transaction(() async {
        final view = await _remittanceView(await _remittance(id));
        final remaining = _familyPurposeRemaining(view, key);
        final linked = (await _db.select(_db.remittanceFamilyPayments).get())
            .map((row) => row.entryId)
            .toSet();
        return [
          for (final expense in await recentExpenses())
            if (_eligibleFamilyExpense(view, expense, remaining) &&
                !linked.contains(expense.id))
              expense,
        ];
      });

  Future<void> linkRemittanceFamilyPayment(int id, String key, int entryId) =>
      _db.transaction(() async {
        final view = await _remittanceView(await _remittance(id));
        final remaining = _familyPurposeRemaining(view, key);
        final existing = await (_db.select(
          _db.remittanceFamilyPayments,
        )..where((row) => row.entryId.equals(entryId))).getSingleOrNull();
        if (existing != null) {
          if (existing.purposeKey == key) return;
          throw const RemittanceException(RemittanceIssue.duplicateEvidence);
        }
        if (!_eligibleFamilyExpense(view, await _expense(entryId), remaining)) {
          throw const RemittanceException(RemittanceIssue.invalidStatus);
        }
        await _db
            .into(_db.remittanceFamilyPayments)
            .insert(RemittanceFamilyPayment(entryId: entryId, purposeKey: key));
      });

  int _familyPurposeRemaining(RemittanceView view, String key) {
    final purpose = view.purposes
        .where((row) => row.operationKey == key && row.family)
        .firstOrNull;
    if (view.record.destination != RemittanceDestination.personal ||
        purpose == null) {
      throw const RemittanceException(RemittanceIssue.invalidInput);
    }
    return purpose.minor -
        (view.familyPayments[key] ?? [])
            .where((expense) => !expense.reversed)
            .fold(0, (sum, expense) => sum + expense.input.minor);
  }

  bool _eligibleFamilyExpense(
    RemittanceView view,
    ExpenseView expense,
    int remaining,
  ) {
    final firstReceipt = view.active
        .where((row) => row.received > 0)
        .map((row) => row.movement.entry.effectiveMicros)
        .reduce((a, b) => a < b ? a : b);
    return !expense.reversed &&
        expense.input.accountId == view.record.destinationAccountId &&
        expense.input.period == ExpensePeriod.individual &&
        expense.input.date.microsecondsSinceEpoch >= firstReceipt &&
        expense.input.minor <= remaining;
  }

  Future<int> reverseRemittanceEvent({
    required int entryId,
    required String operationId,
    required String reason,
    required DateTime effectiveAt,
  }) => _db.transaction(
    () => _reverseRemittanceEvent(entryId, operationId, reason, effectiveAt),
  );

  Future<int> correctRemittanceEvent({
    required int entryId,
    required String operationId,
    required String reason,
    required DateTime effectiveAt,
    required int minor,
    required String evidence,
    int? feeMinor,
    int? sourceMinor,
    String? actualRate,
  }) => _db.transaction(() async {
    final event = await _remittanceEvent(entryId);
    if (event == null) {
      throw const RemittanceException(RemittanceIssue.notFound);
    }
    await _reverseRemittanceEvent(
      entryId,
      '$operationId:reverse',
      reason,
      effectiveAt,
      replacementMinor: minor,
    );
    return _recordRemittanceEvent(
      remittanceId: event.remittanceId,
      operationId: operationId,
      kind: event.kind,
      minor: minor,
      evidence: evidence,
      effectiveAt: effectiveAt,
      sourceMinor: sourceMinor,
      feeMinor: feeMinor,
      receiptEntryId: event.receiptEntryId,
      correctionOf: entryId,
      actualRate: actualRate,
    );
  });

  Future<int> _reverseRemittanceEvent(
    int entryId,
    String operationId,
    String reason,
    DateTime effectiveAt, {
    int? replacementMinor,
  }) async {
    final event = await _remittanceEvent(entryId);
    if (event == null) {
      throw const RemittanceException(RemittanceIssue.notFound);
    }
    final original = await salaryMovement(entryId);
    final explanation = _remittanceText(reason, 500);
    if (await _findOperation(operationId) == null) {
      final view = await _remittanceView(await _remittance(event.remittanceId));
      final reconciled = await _hasReconciliationOnOrAfter(
        original.lines.map((line) => line.accountId),
        original.entry.effectiveMicros,
      );
      if (view.active.lastOrNull?.event.entryId != entryId ||
          effectiveAt.microsecondsSinceEpoch < original.entry.effectiveMicros ||
          await _linkedMinor(entryId) != 0 ||
          reconciled) {
        throw const RemittanceException(RemittanceIssue.protectedCorrection);
      }
      if (event.kind == RemittanceEventKind.receipt) {
        if (view.familyPayments.values
            .expand((items) => items)
            .any((expense) => !expense.reversed)) {
          throw const RemittanceException(RemittanceIssue.protectedCorrection);
        }
        final removed = view.active.last.received;
        if (BigInt.from(removed) >
            BigInt.from(view.unallocated) +
                BigInt.from(replacementMinor ?? 0)) {
          throw const RemittanceException(RemittanceIssue.purposeLimit);
        }
      }
    }
    return _reverse(operationId, original.entry, effectiveAt, explanation);
  }

  Future<bool> _remittanceHasRefundForDebit(int entryId) async {
    final event = await _remittanceEvent(entryId);
    if (event == null) return false;
    final view = await _remittanceView(await _remittance(event.remittanceId));
    return view.active.any(
      (row) => row.event.kind == RemittanceEventKind.refund,
    );
  }

  Future<Remittance?> _findRemittance(int id) => (_db.select(
    _db.remittances,
  )..where((row) => row.id.equals(id))).getSingleOrNull();

  Future<Remittance> _remittance(int id) async =>
      await _findRemittance(id) ??
      (throw const RemittanceException(RemittanceIssue.notFound));

  Future<RemittanceEvent?> _remittanceEvent(int id) => (_db.select(
    _db.remittanceEvents,
  )..where((row) => row.entryId.equals(id))).getSingleOrNull();

  Future<void> _checkRemittanceEvidence(
    Remittance record,
    RemittanceEventKind kind,
    String note,
  ) async {
    // The same bank or beneficiary evidence must not fund multiple drafts.
    final (scope, values) = switch (kind) {
      RemittanceEventKind.debit || RemittanceEventKind.refund => (
        't.source_account_id = ?',
        [Variable(record.sourceAccountId)],
      ),
      RemittanceEventKind.receipt when record.destinationAccountId != null => (
        't.destination_account_id = ?',
        [Variable(record.destinationAccountId!)],
      ),
      RemittanceEventKind.receipt => (
        't.beneficiary = ? COLLATE NOCASE AND t.destination_currency = ?',
        [Variable(record.beneficiary!), Variable(record.destinationCurrency)],
      ),
      RemittanceEventKind.sourceProof => ('t.id = ?', [Variable(record.id)]),
    };
    final matches = await _db
        .customSelect(
          """
      SELECT e.entry_id FROM remittance_events e
      JOIN remittances t ON t.id = e.remittance_id
      WHERE e.kind = ? AND e.evidence = ? COLLATE NOCASE
        AND $scope
        AND NOT EXISTS (SELECT 1 FROM journal_entries j WHERE j.reversal_of = e.entry_id)
    """,
          variables: [Variable(kind.name), Variable(note), ...values],
        )
        .get();
    if (matches.isNotEmpty) {
      throw const RemittanceException(RemittanceIssue.duplicateEvidence);
    }
  }

  Future<RemittanceView?> remittanceForEntry(int entryId) =>
      _db.transaction(() async {
        final event = await _remittanceEvent(entryId);
        return event == null
            ? null
            : _remittanceView(await _remittance(event.remittanceId));
      });

  Future<String?> _actualRemittanceRate(int entryId) async =>
      (await (_db.select(
        _db.remittanceExchangeRates,
      )..where((row) => row.entryId.equals(entryId))).getSingleOrNull())?.rate;

  Future<RemittanceView> _remittanceView(Remittance record) async {
    final source = await _account(record.sourceAccountId);
    final currenciesByCode = {
      for (final currency in await currencies()) currency.code: currency.scale,
    };
    final events =
        await (_db.select(_db.remittanceEvents)
              ..where((row) => row.remittanceId.equals(record.id))
              ..orderBy([(row) => OrderingTerm.asc(row.entryId)]))
            .get();
    final activity = <RemittanceActivity>[];
    for (final event in events) {
      final movement = await salaryMovement(event.entryId);
      activity.add((
        event: event,
        actualRate: await _actualRemittanceRate(event.entryId),
        movement: movement,
        reversal: movement.reversed
            ? await (_db.select(_db.journalEntries)
                    ..where((row) => row.reversalOf.equals(event.entryId)))
                  .getSingle()
            : null,
        transit:
            movement.lines
                .where((line) => line.kind == AccountKind.remittanceTransit)
                .firstOrNull
                ?.minor ??
            0,
        received: event.kind == RemittanceEventKind.receipt
            ? movement.lines
                  .singleWhere(
                    (line) =>
                        line.kind.isPersonal ||
                        line.kind == AccountKind.expense,
                  )
                  .minor
            : 0,
      ));
    }
    final purposes = await (_db.select(
      _db.remittancePurposes,
    )..where((row) => row.remittanceId.equals(record.id))).get();
    final payments =
        await (_db.select(_db.remittanceFamilyPayments)..where(
              (row) =>
                  row.purposeKey.isIn(purposes.map((row) => row.operationKey)),
            ))
            .get();
    final familyPayments = <String, List<ExpenseView>>{};
    for (final payment in payments) {
      (familyPayments[payment.purposeKey] ??= []).add(
        await _expense(payment.entryId),
      );
    }
    return RemittanceView(
      record: record,
      source: source,
      destinationName:
          record.beneficiary ??
          (await _account(record.destinationAccountId!)).name,
      sourceScale: currenciesByCode[source.currency]!,
      destinationScale: currenciesByCode[record.destinationCurrency]!,
      activity: activity,
      purposes: purposes,
      familyPayments: familyPayments,
    );
  }
}

String _remittanceText(String value, int limit) {
  final label = value.trim();
  if (label.isEmpty || label.length > limit) {
    throw const RemittanceException(RemittanceIssue.invalidInput);
  }
  return label;
}
