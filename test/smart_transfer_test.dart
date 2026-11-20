import 'dart:io';
import 'dart:typed_data';

import 'package:expat_manager/data/database.dart';
import 'package:expat_manager/data/schema_recovery.dart';
import 'package:expat_manager/finance/ledger.dart';
import 'package:expat_manager/finance/model.dart';
import 'package:expat_manager/finance/transfer_quote.dart';
import 'package:expat_manager/leave/model.dart';
import 'package:expat_manager/ui/localizations.dart';
import 'package:expat_manager/ui/salary_transfer_dialog.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

import 'support/legacy_schema.dart';

const scales = {'USD': 2, 'EGP': 2, 'NPR': 2};

TransferTerms terms(
  String rate, {
  int fixed = 0,
  int fee = 0,
  int margin = 0,
}) => (rate: rate, fixedFee: fixed, feeBps: fee, marginBps: margin);

TransferNeed need(
  String currency,
  int minor, {
  AllocationCategory category = AllocationCategory.family,
  String label = '',
}) => (category: category, label: label, currency: currency, minor: minor);

void main() {
  test(
    'converts EGP and NPR in both directions and rounds to cover the target',
    () {
      final egp = TransferCalculator(
        sourceScale: 2,
        destinationScale: 2,
        terms: terms('50'),
      );
      expect(egp.receivedForPrincipal(2000), 100000);
      expect(egp.forTarget(100000).principal, 2000);
      expect(egp.forTarget(100001).principal, 2001);
      final npr = TransferCalculator(
        sourceScale: 2,
        destinationScale: 2,
        terms: terms('132.5'),
      );
      expect(npr.receivedForPrincipal(2000), 265000);
      expect(npr.forTarget(265000).principal, 2000);
      expect(npr.forTarget(265001).principal, 2001);
      expect(npr.receivedForPrincipal(1), 132);
      expect(() => npr.forTarget(0), throwsA(isA<LedgerException>()));
      expect(
        () => npr.receivedForPrincipal(maxMinor),
        throwsA(isA<LedgerException>()),
      );
    },
  );

  test('percentage applies to gross debit, margin only reduces the rate', () {
    final fees = TransferCalculator(
      sourceScale: 2,
      destinationScale: 2,
      terms: terms('50', fixed: 200, fee: 1000),
    );
    expect(fees.forTarget(500000), (
      received: 500000,
      principal: 10000,
      fee: 1334,
      debit: 11334,
    ));
    expect(200 + (11334 * 1000 / 10000).ceil(), 1334);
    expect(11333 - 200 - (11333 * 1000 / 10000).ceil(), lessThan(10000));
    final withMargin = TransferCalculator(
      sourceScale: 2,
      destinationScale: 2,
      terms: terms('50', margin: 200),
    );
    final netRate = TransferCalculator(
      sourceScale: 2,
      destinationScale: 2,
      terms: terms('49'),
    );
    expect(withMargin.forTarget(490000), netRate.forTarget(490000));
    expect(withMargin.receivedForPrincipal(10000), 490000);
    expect(withMargin.forTarget(490000).fee, 0);
  });

  group('encrypted ledger', () {
    late Directory directory;
    late File file;
    late LedgerDatabase db;
    late Ledger ledger;
    late int bank;
    late int salary;
    final date = DateTime.utc(2026, 11, 1);

    Future<void> open() async {
      db = await LedgerDatabase.open(
        file,
        Uint8List.fromList(List.filled(32, 19)),
      );
      ledger = Ledger(db);
    }

    setUp(() async {
      directory = await Directory.systemTemp.createTemp('smart-transfer-test-');
      file = File('${directory.path}/accounts.sqlite');
      await open();
      bank = await ledger.createAccount(
        name: 'Payroll',
        currency: 'USD',
        kind: AccountKind.bank,
      );
      salary = await ledger.recordSalary(
        operationId: 'salary',
        accountId: bank,
        minor: 170000,
        receivedOn: date,
      );
      await ledger.createSalaryPlan(salary);
    });

    tearDown(() async {
      await db.close();
      await directory.delete(recursive: true);
    });

    test('calculates USD 1700 budget, groups native needs, edits and cancels safely', () async {
      final transfer = TransferPlan(
        needs: [
          need('EGP', 60000),
          need('EGP', 40000),
          need(
            'USD',
            10000,
            category: AllocationCategory.savings,
            label: 'Egypt savings',
          ),
          need(
            'USD',
            10000,
            category: AllocationCategory.savings,
            label: 'Thndr',
          ),
          need('NPR', 1325000, category: AllocationCategory.living),
        ],
        terms: {'EGP': terms('50', fixed: 100), 'NPR': terms('132.5')},
      );
      final quote = transfer.calculate(scales);
      expect(quote.routes['EGP']!.received, 100000);
      expect(quote.routes['EGP']!.fee, 100);
      expect(quote.principal, 32000);
      expect(quote.debit, 32100);
      final id = await ledger.addSalaryAllocation(
        salary,
        'Needs',
        0,
        transfer: transfer,
      );
      final cash = await ledger.addSalaryAllocation(
        salary,
        'Cash',
        20000,
        category: AllocationCategory.cash,
      );
      final debt = await ledger.addSalaryAllocation(
        salary,
        'Card',
        25000,
        category: AllocationCategory.obligations,
      );
      await ledger.addSalaryAllocation(
        salary,
        'Personal budget',
        30000,
        category: AllocationCategory.personal,
      );
      expect((await ledger.salaryPlan(salary)).unallocated, 62900);
      expect((await ledger.balance(bank)).minor, 170000);
      expect(await ledger.entries(), hasLength(1));
      await db.close();
      await open();
      final plan = await ledger.salaryPlan(salary);
      expect(plan.allocations.first.transfer!.needs, transfer.needs);
      expect(plan.allocations[1].category, AllocationCategory.cash);
      expect(await ledger.salaryExchangeRates(), {'EGP': '50', 'NPR': '132.5'});
      final updated = TransferPlan(
        needs: [need('EGP', 100000)],
        terms: {'EGP': terms('40')},
      );
      await ledger.updateSalaryAllocation(id, 'Updated', 0, transfer: updated);
      expect((await ledger.salaryPlan(salary)).allocations.first.planned, 2500);
      await expectLater(
        ledger.updateSalaryAllocation(cash, 'Too much', 200000),
        throwsA(isA<SalaryException>()),
      );
      await ledger.deleteSalaryAllocation(debt);
      await ledger.deleteSalaryAllocation(id);
      expect((await ledger.salaryPlan(salary)).unallocated, 120000);
      expect((await ledger.salaryExchangeRates())['EGP'], '40');
      expect((await ledger.balance(bank)).minor, 170000);
      expect(await db.customSelect('PRAGMA foreign_key_check').get(), isEmpty);
    });

    test(
      'links existing debits once and records actual rate apart from estimate',
      () async {
        final transfer = TransferPlan(
          needs: [need('EGP', 100000)],
          terms: {'EGP': terms('50', fixed: 500)},
        );
        final allocation = await ledger.addSalaryAllocation(
          salary,
          'Family',
          0,
          transfer: transfer,
        );
        final remittance = await ledger.planRemittance(
          operationId: 'remit',
          sourceAccountId: bank,
          destination: RemittanceDestination.family,
          destinationCurrency: 'EGP',
          beneficiary: 'Fixture',
        );
        final debit = await ledger.recordRemittanceEvent(
          remittanceId: remittance,
          operationId: 'debit',
          kind: RemittanceEventKind.debit,
          minor: 2300,
          feeMinor: 200,
          evidence: 'bank debit',
          effectiveAt: date,
        );
        Future<int> receive(String rate) => ledger.recordRemittanceEvent(
          remittanceId: remittance,
          operationId: 'receipt',
          kind: RemittanceEventKind.receipt,
          minor: 100800,
          sourceMinor: 2100,
          actualRate: rate,
          evidence: 'receipt',
          effectiveAt: date,
        );
        final receipt = await receive('48');
        expect(await receive('48'), receipt);
        await expectLater(receive('49'), throwsA(isA<LedgerException>()));
        for (var retry = 0; retry < 2; retry++) {
          await ledger.linkSalaryExecution(
            allocationId: allocation,
            entryId: debit,
            minor: 2300,
          );
        }
        final cash = await ledger.createAccount(
          name: 'Wallet',
          currency: 'USD',
          kind: AccountKind.cash,
        );
        final saved = await ledger.createAccount(
          name: 'Savings',
          currency: 'USD',
          kind: AccountKind.savings,
        );
        for (final target in [cash, saved]) {
          final movement = await ledger.transfer(
            operationId: 'own-$target',
            from: bank,
            to: target,
            minor: 10000,
            effectiveAt: date,
          );
          final view = await ledger.salaryMovement(movement);
          expect(view.entry.kind, JournalKind.internalTransfer);
          expect(view.lines.every((line) => line.kind.isPersonal), isTrue);
        }
        await db.close();
        await open();
        expect((await ledger.salaryPlan(salary)).executed, 2300);
        final recorded = (await ledger.remittanceForEntry(debit))!;
        expect(recorded.debit!.event.feeMinor, 200);
        expect(recorded.received, 100800);
        expect(recorded.activity.last.actualRate, '48');
        expect((await ledger.salaryExchangeRates())['EGP'], '50');
        expect(await ledger.entries(), hasLength(5));
        expect((await ledger.balance(bank)).minor, 147700);
      },
    );

    test(
      'migrates v8 additively with the original encrypted data intact',
      () async {
        await ledger.addSalaryAllocation(salary, 'Old plan', 1234);
        final leave = await ledger.personalLeave.save(
          kind: LeaveKind.annual,
          status: LeaveStatus.approved,
          period: LeavePeriod(leaveDay(date), leaveDay(date)),
        );
        await ledger.saveTicket(
          year: date.year,
          expected: null,
          receivedDay: leaveDay(date),
          leaveId: leave,
        );
        await ledger.addGold(
          operationId: 'fixture-gold',
          details: const GoldDetails(
            label: 'Fixture gold',
            kind: GoldKind.bar,
            weightMg: 5000,
            karatHundredths: 2400,
            owner: 'Owner',
          ),
          custodian: 'Holder',
        );
        await db.close();
        final raw = sqlite.sqlite3.open(file.path);
        try {
          unlockDatabase(raw, List.filled(32, '13').join());
          dropSmartTransferSchema(raw);
          raw.execute('PRAGMA user_version = 8');
        } finally {
          raw.close();
        }
        await open();
        expect(db.schemaVersion, 9);
        expect(File('${file.path}.v8.backup').existsSync(), isTrue);
        expect(
          (await ledger.salaryPlan(salary)).allocations.single.planned,
          1234,
        );
        expect((await ledger.balance(bank)).minor, 170000);
        expect((await ledger.ticket(date.year))!.leaveId, leave);
        expect(
          (await db.select(db.goldPieces).get()).single.label,
          'Fixture gold',
        );
        expect(
          await db.customSelect('PRAGMA foreign_key_check').get(),
          isEmpty,
        );
      },
    );
  });

  testWidgets(
    'Arabic RTL calculator previews a saved rate and updates with Arabic input',
    (tester) async {
      tester.view.physicalSize = const Size(380, 720);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      TransferPlan? result;
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ar'),
          supportedLocales: const [Locale('ar')],
          localizationsDelegates: const [
            LatinArabicLocalizationsDelegate(),
            ...GlobalMaterialLocalizations.delegates,
          ],
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () async => result = await showDialog<TransferPlan>(
                  context: context,
                  builder: (_) => const SalaryTransferDialog(
                    available: 170000,
                    scales: scales,
                    lastRates: {'EGP': '50'},
                  ),
                ),
                child: const Text('فتح'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('فتح'));
      await tester.pumpAndSettle();
      final dialog = tester.element(find.byType(AlertDialog));
      expect(Directionality.of(dialog), TextDirection.rtl);
      await tester.tap(find.text('USD').hitTestable());
      await tester.pumpAndSettle();
      await tester.tap(find.text('EGP').last);
      await tester.pumpAndSettle();
      final amount = find.widgetWithText(TextField, 'المبلغ المطلوب · EGP');
      await tester.ensureVisible(amount);
      await tester.enterText(amount, '١٠٠٠');
      await tester.pumpAndSettle();
      expect(find.text('1000'), findsOneWidget);
      expect(find.text('إجمالي المطلوب: 20.00 USD'), findsOneWidget);
      expect(find.textContaining('آخر سعر مدخل'), findsOneWidget);
      final rate = find.widgetWithText(TextField, 'كم EGP لكل 1 USD؟');
      await tester.ensureVisible(rate);
      await tester.enterText(rate, '٤٠');
      await tester.pumpAndSettle();
      expect(find.text('إجمالي المطلوب: 25.00 USD'), findsOneWidget);
      await tester.showKeyboard(rate);
      expect(tester.testTextInput.isVisible, isTrue);
      final calculator = find.text('التحويل من USD إلى EGP');
      await tester.ensureVisible(calculator);
      await tester.tap(calculator);
      await tester.pumpAndSettle();
      expect(tester.testTextInput.isVisible, isFalse);
      await tester.tap(find.text('حفظ التوزيع'));
      await tester.pumpAndSettle();
      expect(result!.calculate(scales).debit, 2500);
      expect(tester.takeException(), isNull);
    },
  );
}
