part of 'ledger.dart';

const usdMonthlySavingsGoalMinor = 50000;

enum CashMovementKind {
  opening,
  bankWithdrawal,
  externalIncome,
  expense,
  settlement,
  reversal,
  other,
}

typedef CashMovement = ({
  int entryId,
  DateTime effectiveAt,
  CashMovementKind kind,
  int minor,
  String? note,
  bool reversed,
  int? reversalOf,
  int? correctionOf,
  int? priorMinor,
  int? countedMinor,
});

typedef UsdCashOverview = ({
  LedgerAccount? account,
  List<LedgerAccount> cashAccounts,
  List<LedgerAccount> bankAccounts,
  int minor,
  bool balanceKnown,
  bool canRecordOpening,
  int withdrawalLimitMinor,
  BigInt withdrawnMinor,
  List<CashMovement> movements,
});

extension UsdCashLedger on Ledger {
  Future<UsdCashOverview> usdCashOverview(DateTime month) =>
      _db.transaction(() async {
        final settings = await _cashSetting();
        final accounts = await _usdCashAccounts();
        final wallet = _activeCashAccount(settings, accounts);
        final banks =
            await (_db.select(_db.ledgerAccounts)
                  ..where(
                    (row) =>
                        row.currency.equals(usdCurrency) &
                        row.kind.equalsValue(AccountKind.bank),
                  )
                  ..orderBy([(row) => OrderingTerm.asc(row.id)]))
                .get();
        final cash = wallet == null ? null : await balance(wallet.id);
        final hasCount = wallet != null && await _hasCashCount(wallet.id);
        return (
          account: wallet,
          cashAccounts: accounts,
          bankAccounts: banks,
          minor: cash?.minor ?? 0,
          balanceKnown: (cash?.openingKnown ?? false) || hasCount,
          canRecordOpening: cash != null && !cash.openingKnown && !hasCount,
          withdrawalLimitMinor: settings.withdrawalLimitMinor,
          withdrawnMinor: await _usdWithdrawals(month),
          movements: wallet == null
              ? <CashMovement>[]
              : await _cashMovements(wallet.id),
        );
      });

  Future<int> setupUsdCash({int? existingAccountId}) =>
      _db.transaction(() async {
        final settings = await _cashSetting();
        final accounts = await _usdCashAccounts();
        final active = _activeCashAccount(settings, accounts);
        final int id;
        if (active != null) {
          if (existingAccountId != null && existingAccountId != active.id) {
            throw const CashException(CashIssue.walletAlreadySelected);
          }
          id = active.id;
        } else if (accounts.isEmpty && existingAccountId == null) {
          id = await createAccount(
            name: 'النقد بالدولار',
            currency: usdCurrency,
            kind: AccountKind.cash,
          );
        } else if (accounts.any((account) => account.id == existingAccountId)) {
          id = existingAccountId!;
        } else {
          throw const CashException(CashIssue.walletRequired);
        }
        if (settings.cashAccountId != id) {
          await (_db.update(_db.cashSettings)..where((row) => row.id.equals(1)))
              .write(CashSettingsCompanion(cashAccountId: Value(id)));
        }
        return id;
      });

  Future<void> setUsdWithdrawalLimit(int minor) async {
    if (minor < 0) throw const CashException(CashIssue.invalidAmount);
    await (_db.update(_db.cashSettings)..where((row) => row.id.equals(1)))
        .write(CashSettingsCompanion(withdrawalLimitMinor: Value(minor)));
  }

  Future<int> withdrawUsdCash({
    required String operationId,
    required int bankId,
    required int minor,
    required DateTime effectiveAt,
  }) => _db.transaction(() async {
    _positiveCashAmount(minor);
    final wallet = await _requireCashWallet();
    final bank = await _personalAccount(bankId);
    if (bank.kind != AccountKind.bank || bank.currency != usdCurrency) {
      throw const LedgerException(LedgerIssue.invalidInput);
    }
    return transfer(
      operationId: operationId,
      from: bankId,
      to: wallet.id,
      minor: minor,
      effectiveAt: effectiveAt,
    );
  });

  Future<int> receiveExternalUsdCash({
    required String operationId,
    required int minor,
    required DateTime effectiveAt,
  }) => _db.transaction(() async {
    _positiveCashAmount(minor);
    final wallet = await _requireCashWallet();
    final income = await _offset(usdCurrency, AccountKind.income);
    return _persist(operationId, JournalKind.cashIncome, effectiveAt, [
      (accountId: wallet.id, minor: minor),
      (accountId: income.id, minor: -minor),
    ]);
  });

  Future<int> useUsdCash({
    required String operationId,
    required int minor,
    required DateTime effectiveAt,
    String? note,
    Set<int> acknowledged = const {},
  }) => _db.transaction(() async {
    _positiveCashAmount(minor);
    final wallet = await _requireCashWallet();
    return recordExpense(
      operationId: operationId,
      input: (
        accountId: wallet.id,
        minor: minor,
        date: effectiveAt,
        period: ExpensePeriod.individual,
        note: note,
        category: null,
      ),
      acknowledged: acknowledged,
    );
  });

  /// The counted amount and the book amount shown at confirmation must match
  /// this request on retry. Subsequent movements never change its journal delta.
  Future<int> confirmUsdCashBalance({
    required String operationId,
    required int priorMinor,
    required int countedMinor,
    required DateTime effectiveAt,
  }) => _db.transaction(() async {
    final wallet = await _requireCashWallet();
    return confirmAccountBalance(
      accountId: wallet.id,
      operationId: operationId,
      priorMinor: priorMinor,
      countedMinor: countedMinor,
      effectiveAt: effectiveAt,
    );
  });

  Future<int> confirmAccountBalance({
    required int accountId,
    required String operationId,
    required int priorMinor,
    required int countedMinor,
    required DateTime effectiveAt,
  }) => _db.transaction(() async {
    final wallet = await _personalAccount(accountId);
    if (!_canPayExpense(wallet) ||
        (wallet.kind == AccountKind.cash && countedMinor < 0)) {
      throw const CashException(CashIssue.invalidAmount);
    }
    _checkRange(countedMinor);
    final delta = checkedMinor(
      BigInt.from(countedMinor) - BigInt.from(priorMinor),
    );
    final previous = await _findOperation(operationId);
    if (previous == null &&
        await _total(wallet.id) != BigInt.from(priorMinor)) {
      throw const CashException(CashIssue.staleBalance);
    }
    final offset = await _offset(wallet.currency, AccountKind.cashAdjustment);
    final id = await _persist(
      operationId,
      JournalKind.cashAdjustment,
      effectiveAt,
      [
        if (delta != 0) ...[
          (accountId: wallet.id, minor: delta),
          (accountId: offset.id, minor: -delta),
        ],
      ],
    );
    if (previous == null) {
      await _db
          .into(_db.cashReconciliations)
          .insert(
            CashReconciliation(
              entryId: id,
              accountId: wallet.id,
              priorMinor: priorMinor,
              countedMinor: countedMinor,
            ),
          );
    } else {
      final saved = await (_db.select(
        _db.cashReconciliations,
      )..where((row) => row.entryId.equals(id))).getSingle();
      if (saved.accountId != wallet.id ||
          saved.priorMinor != priorMinor ||
          saved.countedMinor != countedMinor) {
        throw const LedgerException(LedgerIssue.duplicateConflict);
      }
    }
    return id;
  });

  Future<int> correctUsdCashAmount({
    required String reversalOperationId,
    required String replacementOperationId,
    required int entryId,
    required int minor,
    Set<int> acknowledged = const {},
  }) => _db.transaction(() async {
    _positiveCashAmount(minor);
    final wallet = await _requireCashWallet();
    final original = await _reversibleEntry(entryId);
    final postings = await _postingsFor(entryId);
    if (postings.length != 2 ||
        !postings.any((line) => line.accountId == wallet.id)) {
      throw const CashException(CashIssue.uncorrectableMovement);
    }
    if (original.kind == JournalKind.cashExpense) {
      final old = await _expense(entryId);
      return correctExpense(
        entryId: entryId,
        reversalOperationId: reversalOperationId,
        replacementOperationId: replacementOperationId,
        acknowledged: acknowledged,
        input: (
          accountId: wallet.id,
          minor: minor,
          date: DateTime.fromMicrosecondsSinceEpoch(original.effectiveMicros),
          period: old.input.period,
          category: old.input.category,
          note: old.input.note,
        ),
      );
    }
    if (original.kind != JournalKind.cashIncome) {
      final other = await _account(
        postings.singleWhere((line) => line.accountId != wallet.id).accountId,
      );
      if (!_isBankWithdrawal(original.kind, postings, wallet.id, other)) {
        throw const CashException(CashIssue.uncorrectableMovement);
      }
    }
    final existed = await _findOperation(replacementOperationId) != null;
    final id = await correct(
      reversalOperationId: reversalOperationId,
      replacementOperationId: replacementOperationId,
      entryId: entryId,
      effectiveAt: DateTime.fromMicrosecondsSinceEpoch(
        original.effectiveMicros,
      ),
      reason: 'تصحيح مبلغ حركة نقدية',
      replacement: [
        for (final line in postings)
          (accountId: line.accountId, minor: line.minor < 0 ? -minor : minor),
      ],
    );
    if (!existed && (await _total(wallet.id)).isNegative) {
      throw const CashException(CashIssue.insufficientCash);
    }
    return id;
  });

  Future<LedgerAccount> _requireCashWallet() async {
    final active = _activeCashAccount(
      await _cashSetting(),
      await _usdCashAccounts(),
    );
    if (active == null) throw const CashException(CashIssue.walletRequired);
    return active;
  }

  Future<CashSetting> _cashSetting() => (_db.select(
    _db.cashSettings,
  )..where((row) => row.id.equals(1))).getSingle();

  Future<List<LedgerAccount>> _usdCashAccounts() =>
      (_db.select(_db.ledgerAccounts)
            ..where(
              (row) =>
                  row.kind.equalsValue(AccountKind.cash) &
                  row.currency.equals(usdCurrency),
            )
            ..orderBy([(row) => OrderingTerm.asc(row.id)]))
          .get();

  Future<bool> _hasCashCount(int accountId) async =>
      (await _db
          .customSelect(
            '''
        SELECT 1 FROM cash_reconciliations c WHERE c.account_id = ?
        AND NOT EXISTS (SELECT 1 FROM journal_entries r WHERE r.reversal_of = c.entry_id)
        LIMIT 1
      ''',
            variables: [Variable(accountId)],
          )
          .getSingleOrNull()) !=
      null;

  Future<BigInt> _usdWithdrawals(DateTime month) async {
    final calendar = month.isUtc ? DateTime.utc : DateTime.new;
    final start = calendar(month.year, month.month).microsecondsSinceEpoch;
    final end = calendar(month.year, month.month + 1).microsecondsSinceEpoch;
    final rows = await _db
        .customSelect(
          '''
      SELECT p.minor FROM journal_postings p
      JOIN journal_entries j ON j.id = p.entry_id
      JOIN ledger_accounts a ON a.id = p.account_id
      WHERE a.kind = 'cash' AND a.currency = 'USD'
        AND j.effective_micros >= ? AND j.effective_micros < ?
        AND $_withdrawalSql
        AND NOT EXISTS (SELECT 1 FROM journal_entries r WHERE r.reversal_of = j.id)
    ''',
          variables: [Variable(start), Variable(end)],
        )
        .get();
    return rows.fold<BigInt>(
      BigInt.zero,
      (sum, row) => sum + BigInt.from(row.read<int>('minor')),
    );
  }

  Future<List<CashMovement>> _cashMovements(int accountId) async {
    final rows = await _db
        .customSelect(
          '''
      SELECT j.id, j.kind, j.effective_micros, j.reason, j.reversal_of, j.correction_of,
             COALESCE(p.minor, 0) AS minor, c.prior_minor, c.counted_minor,
             CASE WHEN $_withdrawalSql THEN 1 ELSE 0 END AS withdrawal,
             EXISTS (SELECT 1 FROM journal_entries r WHERE r.reversal_of = j.id) AS reversed
      FROM journal_entries j
      LEFT JOIN journal_postings p ON p.entry_id = j.id AND p.account_id = ?
      LEFT JOIN cash_reconciliations c ON c.entry_id = j.id AND c.account_id = ?
      WHERE p.account_id IS NOT NULL OR c.account_id IS NOT NULL OR j.opening_account_id = ?
      ORDER BY j.effective_micros DESC, j.id DESC LIMIT 40
    ''',
          variables: [
            Variable(accountId),
            Variable(accountId),
            Variable(accountId),
          ],
        )
        .get();
    return [
      for (final row in rows)
        (
          entryId: row.read<int>('id'),
          effectiveAt: DateTime.fromMicrosecondsSinceEpoch(
            row.read<int>('effective_micros'),
          ),
          kind: switch (JournalKind.values.byName(row.read<String>('kind'))) {
            JournalKind.opening => CashMovementKind.opening,
            JournalKind.cashIncome => CashMovementKind.externalIncome,
            JournalKind.cashExpense => CashMovementKind.expense,
            JournalKind.cashAdjustment => CashMovementKind.settlement,
            JournalKind.reversal => CashMovementKind.reversal,
            _ =>
              row.read<int>('withdrawal') == 1
                  ? CashMovementKind.bankWithdrawal
                  : CashMovementKind.other,
          },
          minor: row.read<int>('minor'),
          note: row.readNullable<String>('reason'),
          reversed: row.read<int>('reversed') == 1,
          reversalOf: row.readNullable<int>('reversal_of'),
          correctionOf: row.readNullable<int>('correction_of'),
          priorMinor: row.readNullable<int>('prior_minor'),
          countedMinor: row.readNullable<int>('counted_minor'),
        ),
    ];
  }

  Future<void> _validateCashPostings(
    JournalKind kind,
    List<Posting> postings,
  ) async {
    if (postings.length != 2) {
      throw const LedgerException(LedgerIssue.invalidInput);
    }
    final accounts = [
      for (final posting in postings) await _account(posting.accountId),
    ];
    final walletIndex = accounts.indexWhere(_canPayExpense);
    if (walletIndex < 0 || accounts.first.currency != accounts.last.currency) {
      throw const LedgerException(LedgerIssue.invalidInput);
    }
    final account = accounts[walletIndex];
    final offset = accounts[1 - walletIndex].kind;
    final minor = postings[walletIndex].minor;
    final usdCash =
        account.kind == AccountKind.cash && account.currency == usdCurrency;
    final valid = switch (kind) {
      JournalKind.cashIncome =>
        usdCash && offset == AccountKind.income && minor > 0,
      JournalKind.cashExpense =>
        usdCash && offset == AccountKind.expense && minor < 0,
      JournalKind.expense =>
        !usdCash && offset == AccountKind.expense && minor < 0,
      JournalKind.cashAdjustment => offset == AccountKind.cashAdjustment,
      _ => false,
    };
    if (!valid) throw const LedgerException(LedgerIssue.invalidInput);
  }
}

LedgerAccount? _activeCashAccount(
  CashSetting settings,
  List<LedgerAccount> accounts,
) {
  final selected = settings.cashAccountId;
  return selected == null
      ? (accounts.length == 1 ? accounts.single : null)
      : accounts.singleWhere((account) => account.id == selected);
}

void _positiveCashAmount(int minor) {
  if (minor <= 0) throw const CashException(CashIssue.invalidAmount);
}

bool _isBankWithdrawal(
  JournalKind kind,
  List<JournalPosting> postings,
  int walletId,
  LedgerAccount other,
) =>
    (kind == JournalKind.internalTransfer || kind == JournalKind.entry) &&
    other.kind == AccountKind.bank &&
    other.currency == usdCurrency &&
    postings.singleWhere((posting) => posting.accountId == walletId).minor > 0;

const _withdrawalSql = '''
  j.kind IN ('internalTransfer', 'entry') AND p.minor > 0
  AND (SELECT count(*) FROM journal_postings q WHERE q.entry_id = j.id) = 2
  AND EXISTS (
    SELECT 1 FROM journal_postings b JOIN ledger_accounts bank ON bank.id = b.account_id
    WHERE b.entry_id = j.id AND b.minor = -p.minor AND bank.kind = 'bank' AND bank.currency = 'USD'
  )
''';
