import 'dart:math';

import 'package:material_ui/material_ui.dart';

import '../data/database.dart';
import '../data/ledger_backup.dart';
import '../finance/ledger.dart';
import '../finance/model.dart';
import 'amount.dart';
import 'app_theme.dart';
import 'backup_screen.dart';
import 'digits.dart';
import 'entitlement_screen.dart';
import 'expense_screen.dart';
import 'gold_screen.dart';
import 'leave_screen.dart';
import 'remittance_screen.dart';
import 'salary_screen.dart';
import 'usd_cash_screen.dart';

typedef _AccountView = ({LedgerAccount account, Balance balance});
typedef _Overview = ({
  List<Currency> currencies,
  List<_AccountView> accounts,
  List<JournalEntry> entries,
});

class FinanceHome extends StatefulWidget {
  const FinanceHome({
    required this.ledger,
    this.openBackup,
    this.appearance = ThemeMode.system,
    this.onAppearance,
    super.key,
  });

  final Ledger ledger;
  final Future<LedgerBackup> Function()? openBackup;
  final ThemeMode appearance;
  final Future<void> Function(ThemeMode)? onAppearance;

  @override
  State<FinanceHome> createState() => _FinanceHomeState();
}

class _FinanceHomeState extends State<FinanceHome> {
  int _tab = 0;
  bool _busy = false;
  late Future<_Overview> _overview = _load();

  Ledger get ledger => widget.ledger;

  Future<_Overview> _load() async => (
    currencies: await ledger.currencies(),
    accounts: [
      for (final account in await ledger.accounts())
        (account: account, balance: await ledger.balance(account.id)),
    ],
    entries: await ledger.entries(),
  );

  void _refresh() {
    setState(() {
      _overview = _load();
    });
  }

  Future<void> _save(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
      if (mounted) _refresh();
    } on CashException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error.issue == CashIssue.openingAfterSettlement
                  ? 'الرصيد محدّد بتسوية سابقة. استخدم تسوية الرصيد للتصحيح.'
                  : 'يوجد حساب نقدي بالدولار بالفعل.',
            ),
          ),
        );
      }
    } on LedgerException catch (error) {
      if (!mounted) return;
      final message = switch (error.issue) {
        LedgerIssue.openingAlreadyRecorded => 'الرصيد الافتتاحي مسجّل بالفعل.',
        LedgerIssue.overflow => 'تجاوز المبلغ الحد المدعوم.',
        _ => 'تعذّر تسجيل العملية. تحقق من المدخلات.',
      };
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('حدث خطأ أثناء الحفظ.')));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _openSection(Widget screen) async {
    await Navigator.of(context)
        .push<void>(MaterialPageRoute(builder: (_) => screen));
    if (mounted) _refresh();
  }

  Future<void> _openBackup() async {
    final openBackup = widget.openBackup;
    if (openBackup == null) return;
    final restored = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => BackupScreen(openBackup: openBackup)),
    );
    if (restored == true && mounted) {
      setState(() {
        _tab = 0;
        _overview = _load();
      });
    }
  }

  Future<void> _changeAppearance(ThemeMode mode) async {
    try {
      await widget.onAppearance?.call(mode);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذّر حفظ تفضيل المظهر.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
        [
          'Expat Manager',
          'سجل القيود',
          'توزيع الراتب',
          'محفظة الدولار',
          'سجل المصروفات',
        ][_tab],
      ),
      actions: [
        if (widget.openBackup != null)
          IconButton(
            tooltip: 'النسخ الاحتياطي',
            icon: const Icon(Icons.backup_outlined),
            onPressed: _busy ? null : _openBackup,
          ),
        if (widget.onAppearance != null)
          PopupMenuButton<ThemeMode>(
            tooltip: 'المظهر',
            icon: const Icon(Icons.contrast_outlined),
            initialValue: widget.appearance,
            onSelected: _changeAppearance,
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: ThemeMode.system,
                child: Text('مظهر الجهاز'),
              ),
              PopupMenuItem(
                value: ThemeMode.light,
                child: Text('المظهر الفاتح'),
              ),
              PopupMenuItem(
                value: ThemeMode.dark,
                child: Text('المظهر الداكن'),
              ),
            ],
          ),
      ],
    ),
    bottomNavigationBar: NavigationBar(
      selectedIndex: _tab,
      onDestinationSelected: (value) => setState(() {
        if (_tab >= 2) _overview = _load();
        _tab = value;
      }),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.account_balance_wallet_outlined),
          label: 'الحسابات',
        ),
        NavigationDestination(
          icon: Icon(Icons.receipt_long_outlined),
          label: 'القيود',
        ),
        NavigationDestination(
          icon: Icon(Icons.payments_outlined),
          label: 'الرواتب',
        ),
        NavigationDestination(
          icon: Icon(Icons.wallet_outlined),
          label: 'النقد',
        ),
        NavigationDestination(
          icon: Icon(Icons.receipt_outlined),
          label: 'المصروفات',
        ),
      ],
    ),
    body: SafeArea(
      child: _tab == 4
          ? ExpenseScreen(ledger: ledger, newOperationId: _operationId)
          : _tab == 3
          ? UsdCashScreen(ledger: ledger, newOperationId: _operationId)
          : _tab == 2
          ? SalaryScreen(ledger: ledger, newOperationId: _operationId)
          : _tab == 0
          ? _dashboard()
          : _withOverview((data) => _journalList(data.entries)),
    ),
  );

  Widget _withOverview(Widget Function(_Overview) build) => FutureBuilder(
    future: _overview,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(
          child: TextButton(
            onPressed: _refresh,
            child: const Text('تعذّر تحميل البيانات. أعد المحاولة'),
          ),
        );
      }
      final data = snapshot.data;
      return data == null
          ? const Center(child: CircularProgressIndicator())
          : build(data);
    },
  );

  Widget _dashboard() {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Text('نظرة عامة', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, layout) {
            final largeText = MediaQuery.textScalerOf(context).scale(16) >= 24;
            final width = layout.maxWidth < 300 || largeText
                ? layout.maxWidth
                : (layout.maxWidth - 10) / 2;
            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _shortcut(
                  width,
                  'الحوالات',
                  Icons.currency_exchange,
                  () => _openSection(RemittanceScreen(ledger: ledger)),
                ),
                _shortcut(
                  width,
                  'الإجازات',
                  Icons.event_available_outlined,
                  () => _openSection(LeaveScreen(book: ledger.personalLeave)),
                ),
                _shortcut(
                  width,
                  'الاستحقاقات والادخار',
                  Icons.card_giftcard_outlined,
                  () => _openSection(EntitlementScreen(ledger: ledger)),
                ),
                _shortcut(
                  width,
                  'الذهب الفعلي',
                  Icons.diamond_outlined,
                  () => _openSection(GoldScreen(ledger: ledger)),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        Text('أرصدتك', style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        _withOverview(_accountContent),
      ],
    );
  }

  Widget _accountContent(_Overview data) {
    final scale = {
      for (final currency in data.currencies) currency.code: currency.scale,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton.icon(
              onPressed: _busy ? null : () => _addAccount(data.currencies),
              icon: const Icon(Icons.add),
              label: const Text('إضافة حساب'),
            ),
            OutlinedButton.icon(
              onPressed: _busy || !_hasTransferPair(data.accounts)
                  ? null
                  : () => _transfer(data, scale),
              icon: const Icon(Icons.swap_horiz),
              label: const Text('تحويل داخلي'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (data.accounts.isEmpty)
          const Card(child: ListTile(title: Text('أضف حسابًا للبدء.'))),
        for (final view in data.accounts)
          Card(
            child: ListTile(
              title: Text(latinDigits(view.account.name)),
              leading: Icon(switch (view.account.kind) {
                AccountKind.bank => Icons.account_balance_outlined,
                AccountKind.cash => Icons.wallet_outlined,
                _ => Icons.savings_outlined,
              }),
              subtitle: Text(
                view.balance.openingKnown
                    ? 'الرصيد المحسوب'
                    : 'صافي الحركات المسجلة · لم يُسجّل رصيد افتتاحي',
              ),
              trailing: AmountLabel(
                '${formatMinor(view.balance.minor, scale[view.account.currency]!)} ${view.account.currency}',
              ),
              onTap: _busy || view.balance.openingKnown
                  ? null
                  : () => _setOpening(
                      view.account,
                      scale[view.account.currency]!,
                    ),
            ),
          ),
      ],
    );
  }

  Widget _shortcut(
    double width,
    String label,
    IconData icon,
    VoidCallback open,
  ) => SizedBox(
    width: width,
    child: Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: _busy ? null : open,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
            child: Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(child: Text(label)),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Widget _journalList(List<JournalEntry> entries) {
    final managedIncomeIds = {
      for (final entry in entries)
        if (entry.kind.isManagedIncome) entry.id,
    };
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (entries.isEmpty) const Text('لا توجد قيود مسجّلة.'),
        for (final entry in entries)
          ListTile(
            title: Text(switch (entry.kind) {
              JournalKind.opening => 'رصيد افتتاحي',
              JournalKind.entry => 'قيد مالي',
              JournalKind.internalTransfer => 'تحويل داخلي',
              JournalKind.reversal => 'عكس قيد',
              JournalKind.salary => 'إيداع راتب',
              JournalKind.dashainBonus => 'مكافأة الدساي',
              JournalKind.goldSaleIncome => 'استلام ثمن بيع ذهب',
              JournalKind.cashIncome => 'دخل نقدي خارجي',
              JournalKind.cashExpense => 'مصروف نقدي',
              JournalKind.expense => 'مصروف',
              JournalKind.cashAdjustment => 'تسوية رصيد',
              JournalKind.remittanceDebit => 'خصم حوالة',
              JournalKind.remittanceReceipt => 'استلام حوالة',
              JournalKind.remittanceRefund => 'استرداد حوالة',
              JournalKind.remittanceSettlement => 'تسوية حوالة',
            }),
            subtitle: entry.reason == null
                ? null
                : Text(latinDigits(entry.reason!)),
            trailing: Text(
              MaterialLocalizations.of(context).formatShortDate(
                DateTime.fromMicrosecondsSinceEpoch(
                  entry.effectiveMicros,
                  isUtc:
                      managedIncomeIds.contains(entry.id) ||
                      managedIncomeIds.contains(entry.reversalOf),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _addAccount(List<Currency> currencies) async {
    final input =
        await showDialog<({String name, String currency, AccountKind kind})>(
          context: context,
          builder: (_) => _AccountDialog(currencies: currencies),
        );
    if (input == null || !mounted) return;
    await _save(() async {
      await ledger.createAccount(
        name: input.name,
        currency: input.currency,
        kind: input.kind,
      );
    });
  }

  Future<void> _setOpening(LedgerAccount account, int scale) async {
    final minor = await showDialog<int>(
      context: context,
      builder: (_) => _AmountDialog(account: account, scale: scale),
    );
    if (minor == null || !mounted) return;
    final operation = _operationId();
    final date = DateTime.now();
    await _save(() async {
      await ledger.recordOpening(
        operationId: operation,
        accountId: account.id,
        minor: minor,
        effectiveAt: date,
      );
    });
  }

  Future<void> _transfer(_Overview data, Map<String, int> scales) async {
    final accounts = data.accounts.map((view) => view.account).toList();
    final result = await showDialog<({int from, int to, int minor})>(
      context: context,
      builder: (_) => _TransferDialog(accounts: accounts, scales: scales),
    );
    if (result == null || !mounted) return;
    final operation = _operationId();
    final date = DateTime.now();
    await _save(() async {
      await ledger.transfer(
        operationId: operation,
        from: result.from,
        to: result.to,
        minor: result.minor,
        effectiveAt: date,
      );
    });
  }
}

class _AccountDialog extends StatefulWidget {
  const _AccountDialog({required this.currencies});
  final List<Currency> currencies;

  @override
  State<_AccountDialog> createState() => _AccountDialogState();
}

class _AccountDialogState extends State<_AccountDialog> {
  final _name = TextEditingController();
  final _form = GlobalKey<FormState>();
  String _currency = 'USD';
  AccountKind _kind = AccountKind.bank;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('إضافة حساب'),
    content: Form(
      key: _form,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _name,
              maxLength: 100,
              decoration: const InputDecoration(labelText: 'اسم الحساب'),
              validator: (value) =>
                  (value ?? '').trim().isEmpty ? 'أدخل اسم الحساب' : null,
            ),
            DropdownButtonFormField<String>(
              initialValue: _currency,
              decoration: const InputDecoration(labelText: 'العملة'),
              items: [
                for (final currency in widget.currencies)
                  DropdownMenuItem(
                    value: currency.code,
                    child: Text(currency.code),
                  ),
              ],
              onChanged: (value) => _currency = value!,
            ),
            DropdownButtonFormField<AccountKind>(
              initialValue: _kind,
              decoration: const InputDecoration(labelText: 'نوع الحساب'),
              items: const [
                DropdownMenuItem(value: AccountKind.bank, child: Text('بنك')),
                DropdownMenuItem(value: AccountKind.cash, child: Text('نقد')),
                DropdownMenuItem(
                  value: AccountKind.savings,
                  child: Text('ادخار'),
                ),
              ],
              onChanged: (value) => _kind = value!,
            ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('إلغاء'),
      ),
      FilledButton(
        onPressed: () {
          if (_form.currentState!.validate()) {
            Navigator.pop(context, (
              name: _name.text,
              currency: _currency,
              kind: _kind,
            ));
          }
        },
        child: const Text('حفظ'),
      ),
    ],
  );
}

class _AmountDialog extends StatefulWidget {
  const _AmountDialog({required this.account, required this.scale});
  final LedgerAccount account;
  final int scale;

  @override
  State<_AmountDialog> createState() => _AmountDialogState();
}

class _AmountDialogState extends State<_AmountDialog> {
  final _form = GlobalKey<FormState>();
  final _amount = TextEditingController();

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('تسجيل الرصيد الافتتاحي'),
    content: Form(
      key: _form,
      child: TextFormField(
        controller: _amount,
        inputFormatters: amountInputFormatters,
        textDirection: TextDirection.ltr,
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
          signed: true,
        ),
        decoration: InputDecoration(
          labelText: 'المبلغ · ${widget.account.currency}',
        ),
        validator: (text) => parseMinor(text ?? '', widget.scale) == null
            ? 'أدخل مبلغًا صالحًا'
            : null,
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('إلغاء'),
      ),
      FilledButton(
        onPressed: () {
          if (_form.currentState!.validate()) {
            Navigator.pop(context, parseMinor(_amount.text, widget.scale));
          }
        },
        child: const Text('حفظ'),
      ),
    ],
  );
}

class _TransferDialog extends StatefulWidget {
  const _TransferDialog({required this.accounts, required this.scales});
  final List<LedgerAccount> accounts;
  final Map<String, int> scales;

  @override
  State<_TransferDialog> createState() => _TransferDialogState();
}

class _TransferDialogState extends State<_TransferDialog> {
  final _form = GlobalKey<FormState>();
  final _amount = TextEditingController();
  late final List<LedgerAccount> _sources = widget.accounts
      .where(
        (account) => widget.accounts.any(
          (other) =>
              other.id != account.id && other.currency == account.currency,
        ),
      )
      .toList();
  late LedgerAccount _source = _sources.first;
  late LedgerAccount _destination = _destinations.first;

  List<LedgerAccount> get _destinations => widget.accounts
      .where(
        (account) =>
            account.id != _source.id && account.currency == _source.currency,
      )
      .toList();

  int? _minor(String input) =>
      parseMinor(input, widget.scales[_source.currency]!);

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('تحويل داخلي'),
    content: Form(
      key: _form,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<LedgerAccount>(
              initialValue: _source,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'من حساب'),
              items: _items(_sources),
              onChanged: (account) => setState(() {
                _source = account!;
                _destination = _destinations.first;
              }),
            ),
            DropdownButtonFormField<LedgerAccount>(
              key: ValueKey(_source.id),
              initialValue: _destination,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'إلى حساب'),
              items: _items(_destinations),
              onChanged: (account) => _destination = account!,
            ),
            TextFormField(
              controller: _amount,
              inputFormatters: amountInputFormatters,
              textDirection: TextDirection.ltr,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: 'المبلغ · ${_source.currency}',
              ),
              validator: (text) => (_minor(text ?? '') ?? 0) > 0
                  ? null
                  : 'أدخل مبلغًا أكبر من صفر',
            ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('إلغاء'),
      ),
      FilledButton(
        onPressed: () {
          if (_form.currentState!.validate()) {
            Navigator.pop(context, (
              from: _source.id,
              to: _destination.id,
              minor: _minor(_amount.text)!,
            ));
          }
        },
        child: const Text('تسجيل التحويل'),
      ),
    ],
  );

  static List<DropdownMenuItem<LedgerAccount>> _items(
    List<LedgerAccount> accounts,
  ) => [
    for (final account in accounts)
      DropdownMenuItem(
        value: account,
        child: Text('${latinDigits(account.name)} · ${account.currency}'),
      ),
  ];
}

bool _hasTransferPair(List<_AccountView> accounts) {
  final currencies = <String>{};
  return accounts.any((view) => !currencies.add(view.account.currency));
}

String _operationId() {
  final random = Random.secure();
  return List.generate(
    16,
    (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
  ).join();
}
