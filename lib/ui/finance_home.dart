import 'dart:math';

import 'package:material_ui/material_ui.dart';

import '../data/database.dart';
import '../finance/ledger.dart';
import '../finance/model.dart';
import 'amount.dart';

typedef _AccountView = ({LedgerAccount account, Balance balance});
typedef _Overview = ({
  List<Currency> currencies,
  List<_AccountView> accounts,
  List<JournalEntry> entries,
});

class FinanceHome extends StatefulWidget {
  const FinanceHome({required this.ledger, super.key});

  final Ledger ledger;

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

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Expat Manager')),
    bottomNavigationBar: NavigationBar(
      selectedIndex: _tab,
      onDestinationSelected: (value) => setState(() => _tab = value),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.account_balance_wallet_outlined),
          label: 'الحسابات',
        ),
        NavigationDestination(
          icon: Icon(Icons.receipt_long_outlined),
          label: 'القيود',
        ),
      ],
    ),
    body: SafeArea(
      child: FutureBuilder(
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
          if (data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return _tab == 0 ? _accountList(data) : _journalList(data.entries);
        },
      ),
    ),
  );

  Widget _accountList(_Overview data) {
    final scale = {
      for (final currency in data.currencies) currency.code: currency.scale,
    };
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            FilledButton(
              onPressed: _busy ? null : () => _addAccount(data.currencies),
              child: const Text('إضافة حساب'),
            ),
            OutlinedButton(
              onPressed: _busy || !_hasTransferPair(data.accounts)
                  ? null
                  : () => _transfer(data, scale),
              child: const Text('تحويل داخلي'),
            ),
          ],
        ),
        if (data.accounts.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Text('أضف حسابًا للبدء.'),
          ),
        for (final view in data.accounts)
          ListTile(
            title: Text(view.account.name),
            subtitle: Text(
              view.balance.openingKnown
                  ? 'الرصيد المحسوب'
                  : 'صافي الحركات المسجلة · الرصيد الفعلي غير معلوم',
            ),
            trailing: Text(
              '${formatMinor(view.balance.minor, scale[view.account.currency]!)} ${view.account.currency}',
              textDirection: TextDirection.ltr,
            ),
            onTap: _busy || view.balance.openingKnown
                ? null
                : () =>
                      _setOpening(view.account, scale[view.account.currency]!),
          ),
      ],
    );
  }

  Widget _journalList(List<JournalEntry> entries) => ListView(
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
          }),
          subtitle: entry.reason == null ? null : Text(entry.reason!),
          trailing: Text(
            MaterialLocalizations.of(context).formatShortDate(
              DateTime.fromMicrosecondsSinceEpoch(entry.effectiveMicros),
            ),
          ),
        ),
    ],
  );

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
        child: Text('${account.name} · ${account.currency}'),
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
