import 'dart:io';
import 'dart:typed_data';

import 'package:expat_manager/data/database.dart';
import 'package:expat_manager/finance/ledger.dart';
import 'package:expat_manager/finance/model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  final date = DateTime.utc(2026, 1, 2);
  late Directory directory;
  late File file;
  late LedgerDatabase db;
  late Ledger ledger;

  Future<LedgerDatabase> open({int byte = 42}) =>
      LedgerDatabase.open(file, Uint8List.fromList(List.filled(32, byte)));

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('expat-ledger-test-');
    file = File('${directory.path}/test.sqlite');
    db = await open();
    ledger = Ledger(db);
  });

  tearDown(() async {
    await db.close();
    await directory.delete(recursive: true);
  });

  Future<int> account(String name, [String currency = 'USD']) => ledger
      .createAccount(name: name, currency: currency, kind: AccountKind.bank);

  Future<int> opening(int id, int value, [String? key]) => ledger.recordOpening(
    operationId: key ?? 'opening-$id',
    accountId: id,
    minor: value,
    effectiveAt: date,
  );

  Future<int> move(int from, int to, int value, [String key = 'transfer']) =>
      ledger.transfer(
        operationId: key,
        from: from,
        to: to,
        minor: value,
        effectiveAt: date,
      );

  Matcher issue(LedgerIssue value) => throwsA(
    isA<LedgerException>().having((error) => error.issue, 'issue', value),
  );

  test(
    'seeds three currencies and distinguishes unknown from zero opening',
    () async {
      expect(
        {for (final row in await ledger.currencies()) row.code: row.scale},
        {'USD': 2, 'NPR': 2, 'EGP': 2},
      );
      final usd = await account('Synthetic bank');
      final npr = await account('Synthetic NPR', 'NPR');
      final egp = await account('Synthetic EGP', 'EGP');
      expect(await ledger.balance(usd), (openingKnown: false, minor: 0));
      final zero = await opening(usd, 0);
      expect(await opening(usd, 0), zero);
      await opening(npr, 12345);
      await opening(egp, -800);
      expect(await ledger.balance(usd), (openingKnown: true, minor: 0));
      expect(await ledger.balance(npr), (openingKnown: true, minor: 12345));
      expect(await ledger.balance(egp), (openingKnown: true, minor: -800));
      await expectLater(
        opening(usd, 5, 'second-opening'),
        issue(LedgerIssue.openingAlreadyRecorded),
      );
      await expectLater(
        account('Wrong currency', 'XXX'),
        issue(LedgerIssue.invalidInput),
      );
      await expectLater(account('   '), issue(LedgerIssue.invalidInput));
    },
  );

  test(
    'requires a zero sum in each currency, independently of the overall sum',
    () async {
      final usd1 = await account('USD 1');
      final usd2 = await account('USD 2');
      final npr1 = await account('NPR 1', 'NPR');
      final npr2 = await account('NPR 2', 'NPR');
      await expectLater(
        ledger.post(
          operationId: 'wrong',
          effectiveAt: date,
          postings: [
            (accountId: usd1, minor: -100),
            (accountId: npr1, minor: 100),
          ],
        ),
        issue(LedgerIssue.unbalanced),
      );
      await expectLater(
        ledger.post(
          operationId: 'same-currency-not-balanced',
          effectiveAt: date,
          postings: [
            (accountId: usd1, minor: -100),
            (accountId: usd2, minor: 99),
          ],
        ),
        issue(LedgerIssue.unbalanced),
      );
      await ledger.post(
        operationId: 'right',
        effectiveAt: date,
        postings: [
          (accountId: usd1, minor: -100),
          (accountId: usd2, minor: 100),
          (accountId: npr1, minor: -500),
          (accountId: npr2, minor: 500),
        ],
      );
      expect(await ledger.entries(), hasLength(1));
      expect(await ledger.balance(usd1), (openingKnown: false, minor: -100));
      expect(await ledger.balance(npr2), (openingKnown: false, minor: 500));
    },
  );

  test('internal transfer has no expense and retry is idempotent, even concurrently', () async {
    final source = await account('Synthetic bank');
    final destination = await ledger.createAccount(
      name: 'Synthetic cash',
      currency: 'USD',
      kind: AccountKind.cash,
    );
    await opening(source, 10000);
    final ids = await Future.wait([
      move(source, destination, 3000),
      move(source, destination, 3000),
    ]);
    expect(ids.first, ids.last);
    await expectLater(
      move(source, destination, 3001),
      issue(LedgerIssue.duplicateConflict),
    );
    expect((await ledger.balance(source)).minor, 7000);
    expect(await ledger.balance(destination), (
      openingKnown: false,
      minor: 3000,
    ));
    expect(await ledger.netExpenses('USD'), BigInt.zero);
    final transfers = (await ledger.entries()).where(
      (entry) => entry.kind == JournalKind.internalTransfer,
    );
    expect(transfers, hasLength(1));
  });

  test('rejects zero or negative transfer, self transfer, missing account and cross-currency transfer', () async {
    final source = await account('USD Bank');
    final target = await account('USD Cash');
    final npr = await account('NPR Bank', 'NPR');
    for (final value in [0, -1]) {
      await expectLater(
        move(source, target, value),
        issue(LedgerIssue.invalidInput),
      );
    }
    await expectLater(move(source, source, 1), issue(LedgerIssue.invalidInput));
    await expectLater(move(source, 999, 1), issue(LedgerIssue.accountNotFound));
    await expectLater(
      move(source, npr, 1),
      issue(LedgerIssue.currencyMismatch),
    );
    await expectLater(
      ledger.post(
        operationId: 'zero-lines',
        effectiveAt: date,
        postings: [
          (accountId: source, minor: 0),
          (accountId: target, minor: 0),
        ],
      ),
      issue(LedgerIssue.invalidInput),
    );
    expect(await ledger.entries(), isEmpty);
  });

  test('checks higher and lower balance bounds and avoids wraparound in journal sums', () async {
    final upper = await account('Upper');
    final lower = await account('Lower');
    final available = await account('Available');
    await opening(upper, maxMinor);
    await opening(lower, minMinor);
    await opening(available, 1);
    await expectLater(
      opening(available, minMinor - 1, 'out-of-range'),
      issue(LedgerIssue.overflow),
    );
    await expectLater(move(available, upper, 1), issue(LedgerIssue.overflow));
    await expectLater(move(lower, available, 1), issue(LedgerIssue.overflow));
    final another = await account('Another');
    await expectLater(
      ledger.post(
        operationId: 'wrap',
        effectiveAt: date,
        postings: [
          (accountId: upper, minor: maxMinor),
          (accountId: lower, minor: maxMinor),
          (accountId: available, minor: 2),
        ],
      ),
      issue(LedgerIssue.unbalanced),
    );
    await ledger.post(
      operationId: 'large balanced',
      effectiveAt: date,
      postings: [
        (accountId: upper, minor: -maxMinor),
        (accountId: available, minor: -maxMinor),
        (accountId: lower, minor: maxMinor),
        (accountId: another, minor: maxMinor),
      ],
    );
    expect((await ledger.balance(upper)).minor, 0);
    expect((await ledger.balance(another)).minor, maxMinor);
  });

  test(
    'reversal preserves original history and cannot be applied twice',
    () async {
      final source = await account('Bank');
      final target = await account('Cash');
      final original = await move(source, target, 100);
      Future<int> reverse(String key) => ledger.reverse(
        entryId: original,
        operationId: key,
        effectiveAt: date,
        reason: 'Synthetic duplicate',
      );
      final reversal = await reverse('reverse');
      expect(await reverse('reverse'), reversal);
      await expectLater(
        reverse('reverse again'),
        issue(LedgerIssue.alreadyReversed),
      );
      expect((await ledger.balance(source)).minor, 0);
      expect((await ledger.balance(target)).minor, 0);
      final entries = await ledger.entries();
      expect(entries.map((entry) => entry.id), [reversal, original]);
      expect(entries.first.reversalOf, original);
      expect(entries.first.reason, 'Synthetic duplicate');
    },
  );

  test(
    'corrects with a linked reversal and replacement, all or nothing',
    () async {
      final source = await account('Bank');
      final target = await account('Cash');
      final original = await move(source, target, 100);
      Future<int> correct(int debit, int credit) => ledger.correct(
        entryId: original,
        reversalOperationId: 'reverse',
        replacementOperationId: 'replace',
        effectiveAt: date,
        reason: 'Synthetic amount correction',
        replacement: [
          (accountId: source, minor: debit),
          (accountId: target, minor: credit),
        ],
      );
      await expectLater(correct(-70, 71), issue(LedgerIssue.unbalanced));
      expect(await ledger.entries(), hasLength(1));
      expect((await ledger.balance(target)).minor, 100);
      final corrected = await correct(-70, 70);
      expect(await correct(-70, 70), corrected);
      final entries = await ledger.entries();
      expect(entries, hasLength(3));
      expect(entries.first.correctionOf, original);
      expect(entries[1].reversalOf, original);
      expect((await ledger.balance(source)).minor, -70);
      expect((await ledger.balance(target)).minor, 70);
      expect(await ledger.netExpenses('USD'), BigInt.zero);
    },
  );

  test(
    'SQL write failure rolls back journal and postings and allows retry',
    () async {
      final source = await account('Bank');
      final target = await account('Cash');
      await opening(source, 100);
      await db.customStatement('''
      CREATE TRIGGER reject_test_posting BEFORE INSERT ON journal_postings
      WHEN NEW.account_id = $target
      BEGIN SELECT RAISE(ABORT, 'injected failure'); END
    ''');
      await expectLater(
        move(source, target, 10),
        throwsA(isA<SqliteException>()),
      );
      expect(await ledger.entries(), hasLength(1));
      expect((await ledger.balance(source)).minor, 100);
      expect((await ledger.balance(target)).minor, 0);
      await db.customStatement('DROP TRIGGER reject_test_posting');
      await move(source, target, 10);
      expect((await ledger.balance(source)).minor, 90);
      expect((await ledger.balance(target)).minor, 10);
    },
  );

  test(
    'reopens the same encrypted file and rejects incorrect or missing key',
    () async {
      final id = await account('Synthetic encrypted account', 'EGP');
      await opening(id, 789);
      await db.close();
      expect(
        await file.openRead(0, 16).first,
        isNot('SQLite format 3\u0000'.codeUnits),
      );
      await expectLater(open(byte: 43), throwsA(isA<StorageLocked>()));
      final noKey = sqlite3.open(file.path, mode: OpenMode.readOnly);
      try {
        expect(
          () => noKey.select('SELECT count(*) FROM sqlite_schema'),
          throwsA(isA<SqliteException>()),
        );
      } finally {
        noKey.close();
      }
      db = await open();
      ledger = Ledger(db);
      expect(await ledger.balance(id), (openingKnown: true, minor: 789));
    },
  );
}
