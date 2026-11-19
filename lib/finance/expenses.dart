part of 'ledger.dart';

typedef ExpenseInput = ({
  int accountId,
  int minor,
  DateTime date,
  ExpensePeriod period,
  ExpenseCategory? category,
  String? note,
});

typedef ExpenseView = ({
  int id,
  ExpenseInput input,
  String account,
  String currency,
  int scale,
  bool reversed,
  int? correctionOf,
});

typedef ExpenseAccount = ({
  LedgerAccount account,
  int scale,
  int minor,
  bool balanceKnown,
});

class ExpenseOverlap implements Exception {
  const ExpenseOverlap({required this.known, required this.entryIds});

  final bool known;
  final Set<int> entryIds;
}

extension ExpenseLedger on Ledger {
  Future<List<ExpenseAccount>> expenseAccounts() => _db.transaction(() async {
    final scales = {
      for (final currency in await currencies()) currency.code: currency.scale,
    };
    return [
      for (final account in await accounts())
        if (_canPayExpense(account))
          await _expenseAccount(account, scales[account.currency]!),
    ];
  });

  Future<ExpenseAccount> _expenseAccount(
    LedgerAccount account,
    int scale,
  ) async {
    final book = await balance(account.id);
    return (
      account: account,
      scale: scale,
      minor: book.minor,
      balanceKnown: book.openingKnown || await _hasCashCount(account.id),
    );
  }

  Future<List<ExpenseView>> recentExpenses() => _expenseRows(limit: true);

  Future<int> recordExpense({
    required String operationId,
    required ExpenseInput input,
    Set<int> acknowledged = const {},
  }) => _db.transaction(() async {
    final account = await _checkedExpense(input);
    return _writeExpense(
      operationId,
      account,
      input,
      acknowledged: acknowledged,
    );
  });

  Future<int> correctExpense({
    required int entryId,
    required ExpenseInput input,
    required String reversalOperationId,
    required String replacementOperationId,
    Set<int> acknowledged = const {},
  }) => _db.transaction(() async {
    final original = await _expense(entryId);
    final account = await _checkedExpense(input);
    if (account.currency != original.currency) {
      throw const LedgerException(LedgerIssue.currencyMismatch);
    }
    final entry = await _reversibleEntry(entryId);
    await _reverse(reversalOperationId, entry, input.date, 'تصحيح مصروف');
    return _writeExpense(
      replacementOperationId,
      account,
      input,
      acknowledged: acknowledged,
      correctionOf: entryId,
    );
  });

  Future<int> cancelExpense({
    required int entryId,
    required String operationId,
    required DateTime effectiveAt,
  }) => _db.transaction(() async {
    await _expense(entryId);
    return reverse(
      operationId: operationId,
      entryId: entryId,
      effectiveAt: effectiveAt,
      reason: 'إلغاء مصروف',
    );
  });

  Future<LedgerAccount> _checkedExpense(ExpenseInput input) async {
    final account = await _personalAccount(input.accountId);
    if (input.minor <= 0 ||
        !_canPayExpense(account) ||
        (input.note?.trim().length ?? 0) > 500) {
      throw const LedgerException(LedgerIssue.invalidInput);
    }
    return account;
  }

  Future<int> _writeExpense(
    String operationId,
    LedgerAccount account,
    ExpenseInput input, {
    required Set<int> acknowledged,
    int? correctionOf,
  }) async {
    final isUsdCash =
        account.kind == AccountKind.cash && account.currency == usdCurrency;
    final kind = isUsdCash ? JournalKind.cashExpense : JournalKind.expense;
    final expense = await _offset(account.currency, AccountKind.expense);
    final note = input.note?.trim();
    final existing = await _findOperation(operationId);
    final start = expenseDay(input.date);
    if (existing == null) {
      await _checkExpenseOverlap(account, input, acknowledged);
    }
    final entryId = await _persist(
      operationId,
      kind,
      input.date,
      [
        (accountId: account.id, minor: -input.minor),
        (accountId: expense.id, minor: input.minor),
      ],
      correctionOf: correctionOf,
      reason: note == '' ? null : note,
    );
    if (existing == null) {
      if (isUsdCash && (await _total(account.id)).isNegative) {
        throw const CashException(CashIssue.insufficientCash);
      }
      await _db
          .into(_db.expenseDetails)
          .insert(
            ExpenseDetail(
              entryId: entryId,
              startDay: start.microsecondsSinceEpoch,
              period: input.period,
              category: input.category,
            ),
          );
    } else {
      final prior = await _expense(entryId);
      if (expenseDay(prior.input.date) != start ||
          prior.input.period != input.period ||
          prior.input.category != input.category) {
        throw const LedgerException(LedgerIssue.duplicateConflict);
      }
    }
    return entryId;
  }

  Future<void> _checkExpenseOverlap(
    LedgerAccount account,
    ExpenseInput input,
    Set<int> acknowledged,
  ) async {
    final first = expenseDay(input.date);
    final end = expenseEndExclusive(first, input.period);
    final matches = await _expenseRows(
      currency: account.currency,
      activeOnly: true,
      window: (first: first, end: end),
    );
    final known = <int>{};
    final possible = <int>{};
    for (final match in matches) {
      final other = match.input;
      final otherFirst = expenseDay(other.date);
      if (!otherFirst.isBefore(end) ||
          !first.isBefore(expenseEndExclusive(otherFirst, other.period))) {
        continue;
      }
      final includesPeriod =
          input.period != ExpensePeriod.individual ||
          other.period != ExpensePeriod.individual;
      if (includesPeriod && other.accountId == input.accountId) {
        known.add(match.id);
      } else if ((includesPeriod || other.minor == input.minor) &&
          !acknowledged.contains(match.id)) {
        possible.add(match.id);
      }
    }
    if (known.isNotEmpty) throw ExpenseOverlap(known: true, entryIds: known);
    if (possible.isNotEmpty) {
      throw ExpenseOverlap(known: false, entryIds: possible);
    }
  }

  Future<ExpenseView> _expense(int id) async {
    final rows = await _expenseRows(entryId: id);
    if (rows.isEmpty) throw const LedgerException(LedgerIssue.entryNotFound);
    return rows.single;
  }

  Future<List<ExpenseView>> _expenseRows({
    int? entryId,
    String? currency,
    bool activeOnly = false,
    bool limit = false,
    ({DateTime first, DateTime end})? window,
  }) async {
    final rows = await _db
        .customSelect(
          '''
      SELECT j.id, j.effective_micros, j.reason, j.correction_of,
             d.start_day, d.period, d.category, a.id AS account_id,
             a.name, a.currency, c.scale, -p.minor AS amount,
             EXISTS (SELECT 1 FROM journal_entries r WHERE r.reversal_of = j.id) AS reversed
      FROM journal_entries j
      JOIN journal_postings p ON p.entry_id = j.id AND p.minor < 0
      JOIN ledger_accounts a ON a.id = p.account_id AND a.kind IN ('cash', 'bank')
      JOIN currencies c ON c.code = a.currency
      LEFT JOIN expense_details d ON d.entry_id = j.id
      WHERE j.kind IN ('cashExpense', 'expense', 'entry')
        AND (SELECT count(*) FROM journal_postings q WHERE q.entry_id = j.id) = 2
        AND EXISTS (
          SELECT 1 FROM journal_postings q JOIN ledger_accounts expense ON expense.id = q.account_id
          WHERE q.entry_id = j.id AND q.minor = -p.minor
            AND expense.kind = 'expense' AND expense.currency = a.currency
        )
        ${entryId == null ? '' : 'AND j.id = ?'}
        ${currency == null ? '' : 'AND a.currency = ?'}
        ${activeOnly ? 'AND NOT EXISTS (SELECT 1 FROM journal_entries r WHERE r.reversal_of = j.id)' : ''}
        ${window == null ? '' : 'AND ((d.entry_id IS NOT NULL AND d.start_day >= ? AND d.start_day < ?) OR (d.entry_id IS NULL AND j.effective_micros >= ? AND j.effective_micros < ?))'}

      ORDER BY j.effective_micros DESC, j.id DESC
      ${limit ? 'LIMIT 40' : ''}
    ''',
          variables: [
            if (entryId != null) Variable(entryId),
            if (currency != null) Variable(currency),
            if (window != null) ...[
              Variable(
                window.first
                    .subtract(const Duration(days: 6))
                    .microsecondsSinceEpoch,
              ),
              Variable(window.end.microsecondsSinceEpoch),
              // Legacy events are timestamps. Allow for a local date on either
              // side of UTC midnight, then compare their civil day in Dart.
              Variable(
                window.first
                    .subtract(const Duration(days: 1))
                    .microsecondsSinceEpoch,
              ),
              Variable(
                window.end.add(const Duration(days: 1)).microsecondsSinceEpoch,
              ),
            ],
          ],
        )
        .get();
    return [
      for (final row in rows)
        (
          id: row.read<int>('id'),
          account: row.read<String>('name'),
          currency: row.read<String>('currency'),
          scale: row.read<int>('scale'),
          reversed: row.read<int>('reversed') == 1,
          correctionOf: row.readNullable<int>('correction_of'),
          input: (
            accountId: row.read<int>('account_id'),
            minor: row.read<int>('amount'),
            date: DateTime.fromMicrosecondsSinceEpoch(
              row.readNullable<int>('start_day') ??
                  row.read<int>('effective_micros'),
              isUtc: row.readNullable<int>('start_day') != null,
            ),
            period: ExpensePeriod.values.byName(
              row.readNullable<String>('period') ?? 'individual',
            ),
            category: ExpenseCategory.values
                .asNameMap()[row.readNullable<String>('category')],
            note: row.readNullable<String>('reason'),
          ),
        ),
    ];
  }
}

bool _canPayExpense(LedgerAccount account) =>
    account.kind == AccountKind.cash || account.kind == AccountKind.bank;

DateTime expenseDay(DateTime date) =>
    DateTime.utc(date.year, date.month, date.day);

DateTime expenseEndExclusive(DateTime first, ExpensePeriod period) =>
    expenseDay(first).add(Duration(days: period == ExpensePeriod.week ? 7 : 1));
