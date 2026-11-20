import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:expat_manager/data/database.dart';
import 'package:expat_manager/data/schema_recovery.dart';
import 'package:expat_manager/finance/ledger.dart';
import 'package:expat_manager/finance/model.dart';
import 'package:expat_manager/leave/model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

import 'support/legacy_schema.dart';

int day(int day) => leaveDay(DateTime.utc(2024, 10, day));

GoldDetails piece({
  String label = 'قطعة تجريبية',
  int weight = 10050,
  int karat = 2100,
  String owner = 'المستخدم',
  bool complete = false,
}) => GoldDetails(
  label: label,
  kind: GoldKind.bar,
  weightMg: weight,
  karatHundredths: karat,
  owner: owner,
  purchaseDay: complete ? day(1) : null,
  purchase: complete ? (minor: 1200000, currency: 'EGP') : null,
  notes: complete ? 'عينة اختبار' : null,
);

Matcher goldError(GoldIssue issue) => throwsA(
  isA<GoldException>().having((error) => error.issue, 'issue', issue),
);
Matcher ledgerError(LedgerIssue issue) => throwsA(
  isA<LedgerException>().having((error) => error.issue, 'issue', issue),
);

void main() {
  late Directory temporary;
  late File file;
  late LedgerDatabase db;
  late Ledger ledger;

  Future<void> open() async {
    db = await LedgerDatabase.open(
      file,
      Uint8List.fromList(List.filled(32, 51)),
    );
    ledger = Ledger(db);
  }

  Future<int> add([String id = 'fixture']) =>
      ledger.addGold(operationId: id, details: piece(), custodian: 'الوالدة');

  setUp(() async {
    temporary = await Directory.systemTemp.createTemp('expat-t015-');
    file = File('${temporary.path}/ledger.sqlite');
    await open();
  });

  tearDown(() async {
    await db.close();
    await temporary.delete(recursive: true);
  });

  test(
    'adds complete and unknown-cost pieces without cash postings or duplicates',
    () async {
      final details = piece(complete: true);
      final ids = await Future.wait([
        ledger.addGold(
          operationId: 'one',
          details: details,
          custodian: 'الوالدة',
        ),
        ledger.addGold(
          operationId: 'one',
          details: details,
          custodian: 'الوالدة',
        ),
      ]);
      expect(ids.toSet(), hasLength(1));
      final full = (await ledger.goldRecord(ids.first));
      expect(full.item.piece.label, details.label);
      expect(full.item.piece.kind, GoldKind.bar);
      expect(full.item.piece.weightMg, 10050);
      expect(full.item.piece.karatHundredths, 2100);
      expect(full.item.piece.purchaseDay, day(1));
      expect(full.item.piece.purchaseMinor, 1200000);
      expect(full.item.piece.purchaseCurrency, 'EGP');
      expect(full.item.piece.owner, 'المستخدم');
      expect(full.item.piece.custodian, 'الوالدة');
      expect(full.item.piece.notes, 'عينة اختبار');
      expect(full.events.single.kind, GoldEventKind.added);

      final second = await add();
      final unknown = (await ledger.goldRecord(second)).item.piece;
      expect(unknown.purchaseDay, isNull);
      expect(unknown.purchaseMinor, isNull);
      expect(unknown.purchaseCurrency, isNull);
      await expectLater(
        ledger.addGold(
          operationId: 'bad',
          details: piece(),
          custodian: 'المستخدم ',
        ),
        goldError(GoldIssue.samePerson),
      );
      await expectLater(
        ledger.addGold(
          operationId: 'one',
          details: piece(weight: 7),
          custodian: 'الوالدة',
        ),
        goldError(GoldIssue.stale),
      );
      expect(await ledger.goldInventory(), hasLength(2));
      expect(await ledger.entries(), isEmpty);
    },
  );

  test(
    'preserves edited weight and karat and both custodians after reopening',
    () async {
      final id = await add();
      final original = (await ledger.goldRecord(id)).item.piece;
      await ledger.editGold(original, piece(weight: 10600, karat: 2250));
      final edited = (await ledger.goldRecord(id)).item.piece;
      await ledger.moveGold(edited, 'الأخ');
      await ledger.moveGold(edited, 'الأخ');
      await expectLater(
        ledger.moveGold(edited, 'حائز آخر'),
        goldError(GoldIssue.stale),
      );
      await db.close();
      await open();

      final record = await ledger.goldRecord(id);
      expect(record.item.piece.weightMg, 10600);
      expect(record.item.piece.karatHundredths, 2250);
      expect(record.item.piece.owner, 'المستخدم');
      expect(record.item.piece.custodian, 'الأخ');
      expect(record.events.map((event) => event.kind), [
        GoldEventKind.moved,
        GoldEventKind.edited,
        GoldEventKind.added,
      ]);
      expect(jsonDecode(record.events.first.changes), {
        'custodian': ['الوالدة', 'الأخ'],
      });
      expect(jsonDecode(record.events[1].changes), {
        'weight': [10050, 10600],
        'karat': [2100, 2250],
      });
      expect(await ledger.entries(), isEmpty);
    },
  );

  test('records and corrects sale metadata without income and totals only held weight', () async {
    final id = await add();
    await ledger.addGold(
      operationId: 'held-21',
      details: piece(weight: 2000),
      custodian: 'الأخ',
    );
    await ledger.addGold(
      operationId: 'held-24',
      details: piece(weight: 3000, karat: 2400),
      custodian: 'الأخ',
    );
    final original = (await ledger.goldRecord(id)).item.piece;
    await ledger.saveGoldSale(pieceId: id, expected: null, saleDay: day(5));
    await ledger.saveGoldSale(pieceId: id, expected: null, saleDay: day(5));
    var sold = await ledger.goldRecord(id);
    expect(sold.item.sale!.priceMinor, isNull);
    expect(sold.receipt, isNull);
    expect(sold.events.map((event) => event.kind), [
      GoldEventKind.sold,
      GoldEventKind.added,
    ]);
    await expectLater(
      ledger.moveGold(original, 'الأخ'),
      goldError(GoldIssue.sold),
    );
    await ledger.saveGoldSale(
      pieceId: id,
      expected: sold.item.sale,
      saleDay: day(6),
      price: (minor: 1500000, currency: 'EGP'),
    );
    sold = await ledger.goldRecord(id);
    expect(sold.item.sale!.priceMinor, 1500000);
    expect(sold.events.first.kind, GoldEventKind.saleEdited);
    await ledger.saveGoldSale(
      pieceId: id,
      expected: sold.item.sale,
      saleDay: day(6),
    );
    expect((await ledger.goldRecord(id)).item.sale!.priceCurrency, isNull);
    expect(await ledger.goldInventory(), hasLength(3));
    expect(goldWeightByKarat(await ledger.goldInventory()), {
      2100: BigInt.from(2000),
      2400: BigInt.from(3000),
    });
    expect(await ledger.entries(), isEmpty);
  });

  test('posts a confirmed receipt once across restart and uses linked corrections and undo', () async {
    final account = await ledger.createAccount(
      name: 'Synthetic Egypt bank',
      currency: 'EGP',
      kind: AccountKind.bank,
    );
    final id = await add();
    final receipt = (accountId: account, minor: 5000, day: day(6));
    await expectLater(
      ledger.confirmGoldReceipt(
        pieceId: id,
        expectedRevision: 0,
        receipt: receipt,
      ),
      goldError(GoldIssue.notSold),
    );
    await ledger.saveGoldSale(pieceId: id, expected: null, saleDay: day(5));
    Future<void> confirm() => ledger.confirmGoldReceipt(
      pieceId: id,
      expectedRevision: 0,
      receipt: receipt,
    );
    await Future.wait([confirm(), confirm()]);
    await db.close();
    await open();
    await confirm();
    final original = (await ledger.entries()).single;
    expect(original.kind, JournalKind.goldSaleIncome);
    expect((await ledger.balance(account)).minor, 5000);
    await expectLater(
      ledger.confirmGoldReceipt(
        pieceId: id,
        expectedRevision: 0,
        receipt: (accountId: account, minor: 5200, day: day(7)),
      ),
      goldError(GoldIssue.stale),
    );
    await expectLater(
      ledger.reverse(
        operationId: 'generic',
        entryId: original.id,
        effectiveAt: DateTime.utc(2024, 10, 6),
        reason: 'Test',
      ),
      ledgerError(LedgerIssue.reversalNotAllowed),
    );
    await expectLater(
      ledger.confirmGoldReceipt(
        pieceId: id,
        expectedRevision: 1,
        receipt: (accountId: account, minor: 0, day: day(6)),
        reason: 'Invalid',
      ),
      ledgerError(LedgerIssue.invalidInput),
    );
    expect(await ledger.entries(), hasLength(1));
    final updated = (accountId: account, minor: 4800, day: day(7));
    await ledger.confirmGoldReceipt(
      pieceId: id,
      expectedRevision: 1,
      receipt: updated,
      reason: 'Test correction',
    );
    final record = await ledger.goldRecord(id);
    expect(record.receipt, updated);
    expect(
      (await ledger.entries())
          .singleWhere((e) => e.id == record.item.sale!.receiptId)
          .correctionOf,
      original.id,
    );
    expect((await ledger.balance(account)).minor, 4800);
    await ledger.confirmGoldReceipt(
      pieceId: id,
      expectedRevision: 2,
      receipt: null,
      reason: 'Test undo',
    );
    final ended = await ledger.goldRecord(id);
    expect(ended.receipt, isNull);
    expect(ended.item.sale, isNotNull);
    expect(ended.events.first.kind, GoldEventKind.receiptReversed);
    expect(ended.events.first.journalId, isNotNull);
    expect(await ledger.entries(), hasLength(4));
    expect((await ledger.balance(account)).minor, 0);
    expect(await ledger.netExpenses('EGP'), BigInt.zero);
  });

  test('honors the existing reconciliation gate', () async {
    final account = await ledger.createAccount(
      name: 'Synthetic Egypt bank',
      currency: 'EGP',
      kind: AccountKind.bank,
    );
    final id = await add();
    await ledger.saveGoldSale(pieceId: id, expected: null, saleDay: day(5));
    final receipt = (accountId: account, minor: 1000, day: day(6));
    await ledger.confirmGoldReceipt(
      pieceId: id,
      expectedRevision: 0,
      receipt: receipt,
    );
    await ledger.confirmAccountBalance(
      accountId: account,
      operationId: 'statement',
      priorMinor: 1000,
      countedMinor: 1000,
      effectiveAt: dateOfLeaveDay(day(8)),
    );
    await expectLater(
      ledger.confirmGoldReceipt(
        pieceId: id,
        expectedRevision: 1,
        receipt: null,
        reason: 'Test',
      ),
      ledgerError(LedgerIssue.reconciledPeriod),
    );
    expect((await ledger.goldRecord(id)).receipt, receipt);
    expect(await ledger.entries(), hasLength(2));
  });

  test('migrates encrypted schema 7 with all previous rows intact', () async {
    final account = await ledger.createAccount(
      name: 'Synthetic bank',
      currency: 'USD',
      kind: AccountKind.bank,
    );
    await ledger.recordOpening(
      operationId: 'opening',
      accountId: account,
      minor: 12300,
      effectiveAt: dateOfLeaveDay(day(1)),
    );
    final leave = await ledger.personalLeave.save(
      kind: LeaveKind.annual,
      status: LeaveStatus.approved,
      period: LeavePeriod(day(3), day(5)),
    );
    await ledger.saveTicket(
      year: 2024,
      expected: null,
      receivedDay: day(2),
      leaveId: leave,
    );
    await ledger.saveTravelGoal(
      currency: 'USD',
      targetDay: day(30),
      tripMinor: 1000,
      airfareMinor: 0,
    );
    await ledger.contributeToTravel(
      operationId: 'travel',
      accountId: account,
      day: day(2),
      minor: 700,
    );
    await db.close();
    final hexKey = List.filled(32, '33').join();
    Map<String, List<Map<String, Object?>>> rows(sqlite.Database raw) => {
      for (final table in raw.select(
        """SELECT name FROM sqlite_schema WHERE type = 'table'
        AND name NOT LIKE 'sqlite_%' AND name NOT LIKE 'gold_%' ORDER BY name""",
      ))
        table['name'] as String: [
          for (final row in raw.select(
            'SELECT * FROM "${table['name']}" ORDER BY rowid',
          ))
            Map<String, Object?>.of(row),
        ],
    };
    final old = sqlite.sqlite3.open(file.path);
    late final Map<String, List<Map<String, Object?>>> previous;
    try {
      unlockDatabase(old, hexKey);
      dropGoldSchema(old);
      old.execute('PRAGMA user_version = 7');
      previous = rows(old);
    } finally {
      old.close();
    }
    await open();
    expect(db.schemaVersion, 8);
    expect((await ledger.personalLeave.overview()).entries.single.id, leave);
    expect((await ledger.ticket(2024))!.leaveId, leave);
    expect((await ledger.travelSavings())!.progress.saved, 700);
    expect((await ledger.balance(account)).minor, 12300);
    await add();
    expect(await db.customSelect('PRAGMA foreign_key_check').get(), isEmpty);
    expect(
      (await db.customSelect('PRAGMA integrity_check').getSingle())
          .data
          .values
          .single,
      'ok',
    );
    for (final (path, version) in [
      (file.path, 8),
      ('${file.path}.v7.backup', 7),
    ]) {
      final raw = sqlite.sqlite3.open(path, mode: sqlite.OpenMode.readOnly);
      try {
        unlockDatabase(raw, hexKey);
        expect(raw.select('PRAGMA user_version').single.values.single, version);
        expect(rows(raw), previous);
      } finally {
        raw.close();
      }
    }
  });
}
