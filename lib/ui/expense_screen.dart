import 'package:material_ui/material_ui.dart';

import '../finance/ledger.dart';
import '../finance/model.dart';
import 'amount.dart';

typedef _ExpenseOverview = ({
  List<ExpenseAccount> accounts,
  List<ExpenseView> history,
});

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({
    required this.ledger,
    required this.newOperationId,
    super.key,
  });

  final Ledger ledger;
  final String Function() newOperationId;

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  Ledger get ledger => widget.ledger;
  late Future<_ExpenseOverview> _data = _load();
  bool _busy = false;

  Future<_ExpenseOverview> _load() async => (
    accounts: await ledger.expenseAccounts(),
    history: await ledger.recentExpenses(),
  );

  Future<void> _run(Future<void> Function() work) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await work();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(_expenseError(error))));
      }
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
          _data = _load();
        });
      }
    }
  }

  Future<void> _record(List<ExpenseAccount> accounts, [ExpenseView? old]) =>
      _run(() async {
        final input = await showDialog<ExpenseInput>(
          context: context,
          builder: (_) => _ExpenseDialog(accounts: accounts, old: old),
        );
        if (input == null || !mounted) return;
        final operation = widget.newOperationId();
        final reversal = old == null ? null : widget.newOperationId();
        await saveWithExpenseReview(context, (acknowledged) async {
          if (old == null) {
            await ledger.recordExpense(
              operationId: operation,
              input: input,
              acknowledged: acknowledged,
            );
          } else {
            await ledger.correctExpense(
              entryId: old.id,
              input: input,
              reversalOperationId: reversal!,
              replacementOperationId: operation,
              acknowledged: acknowledged,
            );
          }
        });
      });

  Future<void> _cancel(ExpenseView expense) => _run(() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إلغاء المصروف؟'),
        content: const Text(
          'سيُسجّل قيد عكس يعيد المبلغ إلى حساب الدفع ويحفظ القيد الأصلي في السجل.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('رجوع'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('إلغاء المصروف'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ledger.cancelExpense(
        entryId: expense.id,
        operationId: widget.newOperationId(),
        effectiveAt: DateTime.now(),
      );
    }
  });

  Future<void> _reconcile() => _run(() async {
    final accounts = await ledger.expenseAccounts();
    if (!mounted || accounts.isEmpty) return;
    final result = await showDialog<({ExpenseAccount account, int observed})>(
      context: context,
      builder: (_) => _ReconcileDialog(accounts: accounts),
    );
    if (result == null || !mounted) return;
    final account = result.account;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('معاينة المطابقة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(account.account.name),
            Text(
              account.balanceKnown ? 'الرصيد المسجّل' : 'صافي الحركات المسجّلة',
            ),
            _money(account.minor, account.account.currency, account.scale),
            const Text('الرصيد الفعلي'),
            _money(result.observed, account.account.currency, account.scale),
            const Text('سيُسجّل الفرق كتسوية رصيد دون تصنيفه كمصروف.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('رجوع'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('تأكيد المطابقة'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ledger.confirmAccountBalance(
        accountId: account.account.id,
        operationId: widget.newOperationId(),
        priorMinor: account.minor,
        countedMinor: result.observed,
        effectiveAt: DateTime.now(),
      );
    }
  });

  @override
  Widget build(BuildContext context) => FutureBuilder(
    future: _data,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(
          child: TextButton(
            onPressed: () => setState(() {
              _data = _load();
            }),
            child: const Text('تعذّر تحميل المصروفات. أعد المحاولة'),
          ),
        );
      }
      final data = snapshot.data;
      if (data == null) return const Center(child: CircularProgressIndicator());
      final enabled = !_busy && data.accounts.isNotEmpty;
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              FilledButton(
                onPressed: enabled ? () => _record(data.accounts) : null,
                child: const Text('تسجيل مصروف'),
              ),
              OutlinedButton(
                onPressed: enabled ? _reconcile : null,
                child: const Text('مطابقة الرصيد'),
              ),
            ],
          ),
          if (data.accounts.isEmpty)
            const ListTile(title: Text('أضف حسابًا نقديًا أو بنكيًا أولًا.')),
          if (data.history.isEmpty)
            const ListTile(title: Text('لا توجد مصروفات مسجّلة.')),
          for (final item in data.history) _history(item, data.accounts),
        ],
      );
    },
  );

  Widget _history(ExpenseView item, List<ExpenseAccount> accounts) {
    final input = item.input;
    final details = [
      item.account,
      _coverage(context, input.date, input.period),
      if (input.note != null) input.note!,
      if (item.correctionOf != null) 'تصحيح للقيد ${item.correctionOf}',
    ];
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        '${_category(input.category)} · ${_period(input.period)}${item.reversed ? ' · معكوس' : ''}',
      ),
      subtitle: Text(details.join('\n')),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _money(input.minor, item.currency, item.scale),
          if (!item.reversed)
            PopupMenuButton<String>(
              enabled: !_busy,
              tooltip: 'خيارات المصروف',
              onSelected: (action) {
                if (action == 'edit') {
                  _record(
                    accounts
                        .where((row) => row.account.currency == item.currency)
                        .toList(),
                    item,
                  );
                } else {
                  _cancel(item);
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('تعديل')),
                PopupMenuItem(value: 'cancel', child: Text('إلغاء المصروف')),
              ],
            ),
        ],
      ),
    );
  }
}

Future<void> saveWithExpenseReview(
  BuildContext context,
  Future<void> Function(Set<int>) save,
) async {
  final acknowledged = <int>{};
  while (context.mounted) {
    try {
      await save(acknowledged);
      return;
    } on ExpenseOverlap catch (error) {
      if (error.known) rethrow;
      if (!context.mounted) return;
      final keep = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('مصروف مشابه مسجّل'),
          content: Text(
            'وجدنا مبلغًا مطابقًا أو إجماليًا لحساب آخر يتقاطع مع الفترة بنفس العملة. '
            'تابع فقط إذا كان هذا مصروفًا آخر. أرقام القيود ${error.entryIds.join('، ')}.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('رجوع'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('حفظ كمصروف آخر'),
            ),
          ],
        ),
      );
      if (keep != true) return;
      acknowledged.addAll(error.entryIds);
    }
  }
}

String _expenseError(Object error) => switch (error) {
  ExpenseOverlap() => 'هناك مصروف مسجّل في فترة متداخلة للحساب نفسه. صحّح القيد السابق أو ألغِه قبل الحفظ.',
  CashException(issue: CashIssue.staleBalance) =>
    'تغيّر الرصيد المسجّل. راجع المطابقة مرة أخرى.',
  CashException(issue: CashIssue.insufficientCash) =>
    'المبلغ يتجاوز النقد المسجّل.',
  LedgerException(issue: LedgerIssue.duplicateConflict) =>
    'تعارض مع عملية مسجّلة.',
  LedgerException(issue: LedgerIssue.currencyMismatch) =>
    'اختر حسابًا بالعملة نفسها.',
  LedgerException(issue: LedgerIssue.overflow) => 'تجاوز المبلغ الحد المدعوم.',
  _ => 'تعذّر حفظ العملية.',
};

class _ExpenseDialog extends StatefulWidget {
  const _ExpenseDialog({required this.accounts, this.old});
  final List<ExpenseAccount> accounts;
  final ExpenseView? old;

  @override
  State<_ExpenseDialog> createState() => _ExpenseDialogState();
}

class _ExpenseDialogState extends State<_ExpenseDialog> {
  final _form = GlobalKey<FormState>();
  late ExpenseAccount _account = widget.accounts.firstWhere(
    (row) => row.account.id == widget.old?.input.accountId,
    orElse: () => widget.accounts.first,
  );
  late ExpensePeriod _kind =
      widget.old?.input.period ?? ExpensePeriod.individual;
  late ExpenseCategory? _selection = widget.old?.input.category;
  late DateTime _date = widget.old == null
      ? DateTime.now()
      : DateTime(
          widget.old!.input.date.year,
          widget.old!.input.date.month,
          widget.old!.input.date.day,
        );
  late final _amount = TextEditingController(
    text: widget.old == null
        ? null
        : formatMinor(widget.old!.input.minor, _account.scale),
  );
  late final _note = TextEditingController(text: widget.old?.input.note);

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.old == null ? 'تسجيل مصروف' : 'تعديل المصروف'),
    content: Form(
      key: _form,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _accountInput(
              widget.accounts,
              _account,
              (value) => setState(() => _account = value),
            ),
            _moneyInput(_amount, _account, positive: true),
            DropdownButtonFormField<ExpensePeriod>(
              initialValue: _kind,
              decoration: const InputDecoration(labelText: 'نوع التسجيل'),
              items: [
                for (final value in ExpensePeriod.values)
                  DropdownMenuItem(value: value, child: Text(_period(value))),
              ],
              onChanged: (value) => setState(() => _kind = value!),
            ),
            if (_kind != ExpensePeriod.individual)
              const Text('يغطي الإجمالي جميع مصروفات حساب الدفع خلال الفترة.'),
            TextButton(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );
                if (mounted && picked != null) setState(() => _date = picked);
              },
              child: Text(
                'تاريخ المصروف أو بداية الفترة · ${_coverage(context, _date, _kind)}',
              ),
            ),
            DropdownButtonFormField<ExpenseCategory?>(
              initialValue: _selection,
              decoration: const InputDecoration(labelText: 'التصنيف (اختياري)'),
              items: [
                const DropdownMenuItem<ExpenseCategory?>(
                  child: Text('غير مصنّف'),
                ),
                for (final value in ExpenseCategory.values)
                  DropdownMenuItem(value: value, child: Text(_category(value))),
              ],
              onChanged: (value) => _selection = value,
            ),
            TextFormField(
              controller: _note,
              maxLength: 500,
              decoration: const InputDecoration(labelText: 'ملاحظة (اختيارية)'),
            ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('رجوع'),
      ),
      FilledButton(
        onPressed: () {
          if (!_form.currentState!.validate()) return;
          final ExpenseInput input = (
            accountId: _account.account.id,
            minor: parseMinor(_amount.text, _account.scale)!,
            date: _date,
            period: _kind,
            category: _selection,
            note: _note.text,
          );
          Navigator.pop(context, input);
        },
        child: const Text('حفظ'),
      ),
    ],
  );
}

class _ReconcileDialog extends StatefulWidget {
  const _ReconcileDialog({required this.accounts});
  final List<ExpenseAccount> accounts;

  @override
  State<_ReconcileDialog> createState() => _ReconcileDialogState();
}

class _ReconcileDialogState extends State<_ReconcileDialog> {
  final _form = GlobalKey<FormState>();
  late ExpenseAccount _account = widget.accounts.first;
  final _count = TextEditingController();

  @override
  void dispose() {
    _count.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('مطابقة الرصيد'),
    content: Form(
      key: _form,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _accountInput(
            widget.accounts,
            _account,
            (value) => setState(() => _account = value),
          ),
          _moneyInput(
            _count,
            _account,
            positive: false,
            label: 'الرصيد الفعلي',
          ),
          Text(
            _account.balanceKnown ? 'الرصيد المسجّل' : 'صافي الحركات المسجّلة',
          ),
          _money(_account.minor, _account.account.currency, _account.scale),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('رجوع'),
      ),
      FilledButton(
        onPressed: () {
          if (!_form.currentState!.validate()) return;
          Navigator.pop(context, (
            account: _account,
            observed: parseMinor(_count.text, _account.scale)!,
          ));
        },
        child: const Text('مراجعة المطابقة'),
      ),
    ],
  );
}

Widget _accountInput(
  List<ExpenseAccount> accounts,
  ExpenseAccount selection,
  ValueChanged<ExpenseAccount> change,
) => DropdownButtonFormField<ExpenseAccount>(
  isExpanded: true,
  initialValue: selection,
  decoration: const InputDecoration(labelText: 'حساب الدفع'),
  items: [
    for (final row in accounts)
      DropdownMenuItem(
        value: row,
        child: Text(
          '${row.account.name} · ${row.account.currency} · ${row.account.kind == AccountKind.cash ? 'نقد' : 'بنك'}',
        ),
      ),
  ],
  onChanged: (value) => change(value!),
);

Widget _moneyInput(
  TextEditingController controller,
  ExpenseAccount account, {
  required bool positive,
  String label = 'المبلغ',
}) => TextFormField(
  controller: controller,
  keyboardType: TextInputType.numberWithOptions(
    decimal: true,
    signed: !positive,
  ),
  decoration: InputDecoration(
    labelText: '$label · ${account.account.currency}',
  ),
  validator: (text) {
    final value = parseMinor(text ?? '', account.scale);
    if (value == null ||
        (positive && value <= 0) ||
        (account.account.kind == AccountKind.cash && value < 0)) {
      return 'أدخل مبلغًا صالحًا';
    }
    return null;
  },
);

Widget _money(int minor, String currency, int scale) => Text(
  '${formatMinor(minor, scale)} $currency',
  textDirection: TextDirection.ltr,
);

String _coverage(BuildContext context, DateTime date, ExpensePeriod period) {
  final locale = MaterialLocalizations.of(context);
  final start = locale.formatShortDate(expenseDay(date));
  return period == ExpensePeriod.week
      ? '$start – ${locale.formatShortDate(expenseEndExclusive(date, period).subtract(const Duration(days: 1)))}'
      : start;
}

String _period(ExpensePeriod period) => switch (period) {
  ExpensePeriod.individual => 'فردي',
  ExpensePeriod.day => 'إجمالي يوم',
  ExpensePeriod.week => 'إجمالي ٧ أيام',
};

String _category(ExpenseCategory? category) => switch (category) {
  null => 'غير مصنّف',
  ExpenseCategory.food => 'طعام',
  ExpenseCategory.transport => 'مواصلات',
  ExpenseCategory.housing => 'سكن',
  ExpenseCategory.bills => 'فواتير',
  ExpenseCategory.health => 'صحة',
  ExpenseCategory.other => 'أخرى',
};
