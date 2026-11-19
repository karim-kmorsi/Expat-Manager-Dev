import 'package:drift/drift.dart';

import '../data/database.dart';
import 'model.dart';

part 'salary.dart';
part 'usd_cash.dart';

class Ledger {
  Ledger(this._db);
  final LedgerDatabase _db;

  Future<List<Currency>> currencies() => (_db.select(
    _db.currencies,
  )..orderBy([(row) => OrderingTerm.asc(row.code)])).get();

  Future<List<LedgerAccount>> accounts() =>
      (_db.select(_db.ledgerAccounts)
            ..where(
              (row) => row.kind.isInValues([
                AccountKind.bank,
                AccountKind.cash,
                AccountKind.savings,
              ]),
            )
            ..orderBy([(row) => OrderingTerm.asc(row.id)]))
          .get();

  Future<List<JournalEntry>> entries() =>
      (_db.select(_db.journalEntries)..orderBy([
            (row) => OrderingTerm.desc(row.effectiveMicros),
            (row) => OrderingTerm.desc(row.id),
          ]))
          .get();

  Future<int> createAccount({
    required String name,
    required String currency,
    required AccountKind kind,
  }) => _db.transaction(() async {
    final label = name.trim();
    if (label.isEmpty ||
        label.length > 100 ||
        !kind.isPersonal ||
        await (_db.select(
              _db.currencies,
            )..where((row) => row.code.equals(currency))).getSingleOrNull() ==
            null) {
      throw const LedgerException(LedgerIssue.invalidInput);
    }
    if (kind == AccountKind.cash &&
        currency == usdCurrency &&
        (await _usdCashAccounts()).isNotEmpty) {
      throw const CashException(CashIssue.duplicateCashAccount);
    }
    return _db
        .into(_db.ledgerAccounts)
        .insert(
          LedgerAccountsCompanion.insert(
            name: label,
            currency: currency,
            kind: kind,
          ),
        );
  });

  Future<Balance> balance(int accountId) => _db.transaction(() async {
    await _personalAccount(accountId);
    final opening =
        await (_db.select(_db.journalEntries)
              ..where((row) => row.openingAccountId.equals(accountId)))
            .getSingleOrNull();
    return (
      minor: checkedMinor(await _total(accountId)),
      openingKnown: opening != null,
    );
  });

  Future<BigInt> netExpenses(String currency) async =>
      _total((await _offset(currency, AccountKind.expense)).id);

  Future<int> recordOpening({
    required String operationId,
    required int accountId,
    required int minor,
    required DateTime effectiveAt,
  }) => _db.transaction(() async {
    final account = await _personalAccount(accountId);
    if (account.kind == AccountKind.cash &&
        account.currency == usdCurrency &&
        await _findOperation(operationId) == null &&
        await _hasCashCount(accountId)) {
      throw const CashException(CashIssue.openingAfterSettlement);
    }
    _checkRange(minor);
    final offset = await _offset(account.currency, AccountKind.opening);
    final postings = <Posting>[
      if (minor != 0) ...[
        (accountId: accountId, minor: minor),
        (accountId: offset.id, minor: -minor),
      ],
    ];
    return _persist(
      operationId,
      JournalKind.opening,
      effectiveAt,
      postings,
      openingAccountId: accountId,
    );
  });

  Future<int> post({
    required String operationId,
    required DateTime effectiveAt,
    required List<Posting> postings,
  }) => _db.transaction(
    () => _persist(operationId, JournalKind.entry, effectiveAt, postings),
  );

  Future<int> transfer({
    required String operationId,
    required int from,
    required int to,
    required int minor,
    required DateTime effectiveAt,
  }) => _db.transaction(() async {
    if (from == to || minor <= 0) {
      throw const LedgerException(LedgerIssue.invalidInput);
    }
    final source = await _personalAccount(from);
    final destination = await _personalAccount(to);
    if (source.currency != destination.currency) {
      throw const LedgerException(LedgerIssue.currencyMismatch);
    }
    return _persist(operationId, JournalKind.internalTransfer, effectiveAt, [
      (accountId: from, minor: -minor),
      (accountId: to, minor: minor),
    ]);
  });

  Future<int> reverse({
    required String operationId,
    required int entryId,
    required DateTime effectiveAt,
    required String reason,
  }) => _db.transaction(() async {
    final original = await _reversibleEntry(entryId);
    return _reverse(operationId, original, effectiveAt, _reason(reason));
  });

  Future<int> correct({
    required String reversalOperationId,
    required String replacementOperationId,
    required int entryId,
    required DateTime effectiveAt,
    required String reason,
    required List<Posting> replacement,
  }) => _db.transaction(() async {
    final original = await _reversibleEntry(entryId);
    if (original.kind == JournalKind.salary ||
        original.kind == JournalKind.cashAdjustment) {
      throw const LedgerException(LedgerIssue.reversalNotAllowed);
    }
    final explanation = _reason(reason);
    await _reverse(reversalOperationId, original, effectiveAt, explanation);
    return _persist(
      replacementOperationId,
      original.kind,
      effectiveAt,
      replacement,
      correctionOf: entryId,
      reason: explanation,
    );
  });

  Future<int> _reverse(
    String operationId,
    JournalEntry original,
    DateTime effectiveAt,
    String explanation,
  ) async {
    final postings = await _postingsFor(original.id);
    return _persist(
      operationId,
      JournalKind.reversal,
      effectiveAt,
      [
        for (final posting in postings)
          (accountId: posting.accountId, minor: -posting.minor),
      ],
      reversalOf: original.id,
      reason: explanation,
    );
  }

  Future<JournalEntry> _reversibleEntry(int id) async {
    final entry = await (_db.select(
      _db.journalEntries,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
    if (entry == null) throw const LedgerException(LedgerIssue.entryNotFound);
    if (entry.kind == JournalKind.opening ||
        entry.kind == JournalKind.reversal) {
      throw const LedgerException(LedgerIssue.reversalNotAllowed);
    }
    return entry;
  }

  Future<int> _persist(
    String operationId,
    JournalKind kind,
    DateTime effectiveAt,
    List<Posting> lines, {
    int? openingAccountId,
    int? reversalOf,
    int? correctionOf,
    String? reason,
  }) async {
    if (operationId.trim().isEmpty || operationId.length > 200) {
      throw const LedgerException(LedgerIssue.invalidInput);
    }
    final micros = effectiveAt.microsecondsSinceEpoch;
    final postings = [...lines]
      ..sort((a, b) => a.accountId.compareTo(b.accountId));
    final existing = await _findOperation(operationId);
    if (existing != null) {
      if (existing.kind != kind ||
          existing.effectiveMicros != micros ||
          existing.openingAccountId != openingAccountId ||
          existing.reversalOf != reversalOf ||
          existing.correctionOf != correctionOf ||
          existing.reason != reason ||
          !_samePostings(postings, await _postingsFor(existing.id))) {
        throw const LedgerException(LedgerIssue.duplicateConflict);
      }
      return existing.id;
    }

    if (openingAccountId != null &&
        await _hasEntry(
          (row) => row.openingAccountId.equals(openingAccountId),
        )) {
      throw const LedgerException(LedgerIssue.openingAlreadyRecorded);
    }
    if (reversalOf != null &&
        await _hasEntry((row) => row.reversalOf.equals(reversalOf))) {
      throw const LedgerException(LedgerIssue.alreadyReversed);
    }
    await _validatePostings(kind, postings);

    final entryId = await _db
        .into(_db.journalEntries)
        .insert(
          JournalEntriesCompanion.insert(
            operationId: operationId,
            kind: kind,
            effectiveMicros: micros,
            openingAccountId: Value(openingAccountId),
            reversalOf: Value(reversalOf),
            correctionOf: Value(correctionOf),
            reason: Value(reason),
          ),
        );
    // The zero opening entry records that the opening balance is known.
    if (postings.isNotEmpty) {
      await _db.batch(
        (batch) => batch.insertAll(_db.journalPostings, [
          for (final posting in postings)
            JournalPosting(
              entryId: entryId,
              accountId: posting.accountId,
              minor: posting.minor,
            ),
        ]),
      );
    }
    return entryId;
  }

  Future<void> _validatePostings(
    JournalKind kind,
    List<Posting> postings,
  ) async {
    if ((kind == JournalKind.opening || kind == JournalKind.cashAdjustment) &&
        postings.isEmpty) {
      return;
    }
    if (kind == JournalKind.cashIncome ||
        kind == JournalKind.cashExpense ||
        kind == JournalKind.cashAdjustment) {
      await _validateCashPostings(kind, postings);
    }
    if (postings.length < 2 ||
        (kind == JournalKind.internalTransfer && postings.length != 2) ||
        postings.map((posting) => posting.accountId).toSet().length !=
            postings.length) {
      throw const LedgerException(LedgerIssue.invalidInput);
    }
    final currencies = <String, BigInt>{};
    final personalChanges = <int, BigInt>{};
    for (final posting in postings) {
      _checkRange(posting.minor);
      if (posting.minor == 0) {
        throw const LedgerException(LedgerIssue.invalidInput);
      }
      final account = await _account(posting.accountId);
      if ((account.kind == AccountKind.opening &&
              kind != JournalKind.opening) ||
          (kind == JournalKind.internalTransfer && !account.kind.isPersonal) ||
          (account.kind == AccountKind.cashAdjustment &&
              kind != JournalKind.cashAdjustment &&
              kind != JournalKind.reversal)) {
        throw const LedgerException(LedgerIssue.invalidInput);
      }
      final delta = BigInt.from(posting.minor);
      currencies.update(
        account.currency,
        (sum) => sum + delta,
        ifAbsent: () => delta,
      );
      if (account.kind.isPersonal) personalChanges[account.id] = delta;
    }
    if (currencies.values.any((total) => total != BigInt.zero)) {
      throw const LedgerException(LedgerIssue.unbalanced);
    }
    for (final change in personalChanges.entries) {
      checkedMinor(await _total(change.key) + change.value);
    }
  }

  Future<JournalEntry?> _findOperation(String operationId) => (_db.select(
    _db.journalEntries,
  )..where((row) => row.operationId.equals(operationId))).getSingleOrNull();

  Future<bool> _hasEntry(
    Expression<bool> Function($JournalEntriesTable) predicate,
  ) async =>
      (await (_db.select(_db.journalEntries)
                ..where(predicate)
                ..limit(1))
              .get())
          .isNotEmpty;

  Future<LedgerAccount> _personalAccount(int id) async {
    final account = await _account(id);
    if (!account.kind.isPersonal) {
      throw const LedgerException(LedgerIssue.invalidInput);
    }
    return account;
  }

  Future<LedgerAccount> _account(int id) async {
    final found = await (_db.select(
      _db.ledgerAccounts,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
    if (found == null) throw const LedgerException(LedgerIssue.accountNotFound);
    return found;
  }

  Future<LedgerAccount> _offset(String currency, AccountKind kind) async =>
      (_db.select(_db.ledgerAccounts)..where(
            (row) => row.currency.equals(currency) & row.kind.equalsValue(kind),
          ))
          .getSingle();

  Future<List<JournalPosting>> _postingsFor(int entryId) =>
      (_db.select(_db.journalPostings)
            ..where((row) => row.entryId.equals(entryId))
            ..orderBy([(row) => OrderingTerm.asc(row.accountId)]))
          .get();

  Future<BigInt> _total(int accountId) async {
    final query = _db.selectOnly(_db.journalPostings)
      ..addColumns([_db.journalPostings.minor])
      ..where(_db.journalPostings.accountId.equals(accountId));
    return (await query.get()).fold<BigInt>(
      BigInt.zero,
      (total, row) => total + BigInt.from(row.read(_db.journalPostings.minor)!),
    );
  }
}

bool _samePostings(List<Posting> expected, List<JournalPosting> actual) {
  if (expected.length != actual.length) return false;
  for (var i = 0; i < expected.length; i++) {
    if (expected[i].accountId != actual[i].accountId ||
        expected[i].minor != actual[i].minor) {
      return false;
    }
  }
  return true;
}

void _checkRange(int minor) => checkedMinor(BigInt.from(minor));

String _reason(String value) {
  final reason = value.trim();
  if (reason.isEmpty || reason.length > 500) {
    throw const LedgerException(LedgerIssue.invalidInput);
  }
  return reason;
}
