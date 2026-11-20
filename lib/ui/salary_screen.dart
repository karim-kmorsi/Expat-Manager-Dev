import 'package:material_ui/material_ui.dart';

import '../data/database.dart';
import '../finance/ledger.dart';
import '../finance/model.dart';
import '../finance/transfer_quote.dart';
import 'amount.dart';
import 'app_theme.dart';
import 'date_picker.dart';
import 'digits.dart';
import 'remittance_screen.dart';
import 'salary_transfer_dialog.dart';

class SalaryScreen extends StatefulWidget {
  const SalaryScreen({
    required this.ledger,
    required this.newOperationId,
    super.key,
  });

  final Ledger ledger;
  final String Function() newOperationId;

  @override
  State<SalaryScreen> createState() => _SalaryScreenState();
}

class _SalaryScreenState extends State<SalaryScreen> {
  late Future<List<SalaryDeposit>> _salaries = widget.ledger.salaries();
  bool _busy = false;

  Future<void> _record() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final accounts = (await widget.ledger.accounts())
          .where((account) => account.kind == AccountKind.bank)
          .toList();
      final scales = {
        for (final currency in await widget.ledger.currencies())
          currency.code: currency.scale,
      };
      if (!mounted) return;
      if (accounts.isEmpty) {
        _message(context, 'أضف حسابًا بنكيًا أولًا.');
        return;
      }
      final input = await showDialog<_ReceiptInput>(
        context: context,
        builder: (_) => _ReceiptDialog(accounts: accounts, scales: scales),
      );
      if (input == null || !mounted) return;
      await widget.ledger.recordSalary(
        operationId: widget.newOperationId(),
        accountId: input.accountId,
        minor: input.minor,
        receivedOn: input.date,
        reference: input.reference,
      );
      if (mounted) {
        setState(() {
          _salaries = widget.ledger.salaries();
        });
      }
    } catch (error) {
      if (mounted) _message(context, _explain(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
    future: _salaries,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return const Center(child: Text('تعذّر تحميل الرواتب.'));
      }
      final salaries = snapshot.data;
      if (salaries == null) {
        return const Center(child: CircularProgressIndicator());
      }
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: FilledButton(
              onPressed: _busy ? null : _record,
              child: const Text('تسجيل راتب'),
            ),
          ),
          if (salaries.isEmpty)
            const ListTile(title: Text('لا توجد رواتب مسجّلة.')),
          for (final salary in salaries)
            ListTile(
              title: Text(latinDigits(salary.account)),
              subtitle: Text(
                '${_date(context, salary.receivedOn)} · ${salary.reversed
                    ? 'قيد الراتب معكوس'
                    : salary.hasPlan
                    ? 'له خطة توزيع'
                    : 'بلا خطة توزيع'}',
              ),
              trailing: _money(salary.minor, salary.scale, salary.currency),
              onTap: () async {
                await Navigator.of(context).push<void>(
                  MaterialPageRoute(
                    builder: (_) =>
                        _PlanPage(ledger: widget.ledger, salaryId: salary.id),
                  ),
                );
                if (mounted) {
                  setState(() {
                    _salaries = widget.ledger.salaries();
                  });
                }
              },
            ),
        ],
      );
    },
  );
}

class _PlanPage extends StatefulWidget {
  const _PlanPage({required this.ledger, required this.salaryId});
  final Ledger ledger;
  final int salaryId;

  @override
  State<_PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends State<_PlanPage> {
  late Future<SalaryPlanView> _future = ledger.salaryPlan(widget.salaryId);
  bool _busy = false;
  late final Future<Map<String, int>> _scales = ledger.currencies().then(
    (currencies) => {
      for (final currency in currencies) currency.code: currency.scale,
    },
  );

  Ledger get ledger => widget.ledger;

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
      if (mounted) {
        setState(() {
          _future = ledger.salaryPlan(widget.salaryId);
        });
      }
    } catch (error) {
      if (mounted) _message(context, _explain(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _allocation(
    SalaryDeposit salary, [
    SalaryAllocationView? item,
  ]) => _run(() async {
    final result =
        await showDialog<
          ({String label, int minor, AllocationCategory? category})
        >(
          context: context,
          builder: (_) => _AllocationDialog(scale: salary.scale, item: item),
        );
    if (result == null) return;
    if (item == null) {
      await ledger.addSalaryAllocation(
        salary.id,
        result.label,
        result.minor,
        category: result.category,
      );
    } else {
      await ledger.updateSalaryAllocation(
        item.id,
        result.label,
        result.minor,
        category: result.category,
      );
    }
  });

  Future<void> _calculate(SalaryPlanView plan, [SalaryAllocationView? item]) =>
      _run(() async {
        final scales = await _scales;
        final lastRates = await ledger.salaryExchangeRates();
        if (!mounted) return;
        final result = await showDialog<TransferPlan>(
          context: context,
          builder: (_) => SalaryTransferDialog(
            available: plan.unallocated + (item?.planned ?? 0),
            scales: scales,
            lastRates: lastRates,
            item: item,
          ),
        );
        if (result == null) return;
        const label = 'احتياجات التحويل';
        if (item == null) {
          await ledger.addSalaryAllocation(
            plan.salary.id,
            label,
            0,
            transfer: result,
          );
        } else {
          await ledger.updateSalaryAllocation(
            item.id,
            label,
            0,
            transfer: result,
          );
        }
      });

  Future<void> _link(SalaryDeposit salary, SalaryAllocationView item) =>
      _run(() async {
        final candidates = await ledger.salaryCandidates(item.id);
        if (!mounted) return;
        if (candidates.isEmpty) {
          _message(
            context,
            'لا يوجد خصم مؤهل من حساب الراتب بالعملة نفسها له قيمة غير مرتبطة.',
          );
          return;
        }
        final input = await showDialog<({int id, int minor})>(
          context: context,
          builder: (_) =>
              _LinkDialog(salary: salary, item: item, candidates: candidates),
        );
        if (input != null) {
          await ledger.linkSalaryExecution(
            allocationId: item.id,
            entryId: input.id,
            minor: input.minor,
          );
        }
      });

  Future<void> _confirm(int id) => _run(() async {
    final note = await showDialog<String>(
      context: context,
      builder: (_) => const _EvidenceDialog(),
    );
    if (note != null) await ledger.confirmSalaryMovement(id, note);
  });

  void _openMovement(int id) {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => _MovementPage(ledger: ledger, id: id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('خطة توزيع الراتب')),
    body: SafeArea(
      child: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('تعذّر تحميل الخطة.'));
          }
          final plan = snapshot.data;
          if (plan == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final salary = plan.salary;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('الراتب الفعلي'),
                subtitle: Text(
                  '${latinDigits(salary.account)} · ${_date(context, salary.receivedOn)}',
                ),
                trailing: _money(salary.minor, salary.scale, salary.currency),
                onTap: () => _openMovement(salary.id),
              ),
              if (salary.reversed)
                const Text('قيد الراتب معكوس. الخطة للعرض فقط.'),
              if (!salary.hasPlan && !salary.reversed)
                FilledButton(
                  onPressed: _busy
                      ? null
                      : () => _run(() => ledger.createSalaryPlan(salary.id)),
                  child: const Text('إنشاء خطة توزيع'),
                ),
              if (salary.hasPlan) ...[
                Text(
                  _status(
                    salaryProgress(plan.planned, plan.executed, plan.confirmed),
                  ),
                ),
                _totals(salary, [
                  ('المخطط', plan.planned),
                  ('غير الموزّع', plan.unallocated),
                  ('المنفّذ', plan.executed),
                  ('المؤكّد', plan.confirmed),
                  ('المتبقي للتنفيذ', plan.planned - plan.executed),
                ]),
                if (!salary.reversed)
                  Wrap(
                    spacing: 8,
                    children: [
                      FilledButton(
                        onPressed: _busy ? null : () => _allocation(salary),
                        child: const Text('إضافة توزيع'),
                      ),
                      if (salary.currency == usdCurrency)
                        OutlinedButton(
                          onPressed: _busy ? null : () => _calculate(plan),
                          child: const Text('احسب التحويل المطلوب'),
                        ),
                    ],
                  ),
                for (final item in plan.allocations) _item(plan, item),
              ],
            ],
          );
        },
      ),
    ),
  );

  Widget _item(SalaryPlanView plan, SalaryAllocationView item) {
    final salary = plan.salary;
    final editable = !_busy && !salary.reversed;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              latinDigits(item.label),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              _status(
                salaryProgress(item.planned, item.executed, item.confirmed),
              ),
            ),
            if (item.category case final category?)
              Text(allocationCategoryLabel(category)),
            if (item.transfer case final transfer?)
              FutureBuilder(
                future: _scales,
                builder: (context, snapshot) {
                  final scales = snapshot.data;
                  if (scales == null) return const SizedBox.shrink();
                  final quote = transfer.calculate(scales);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final need in transfer.needs)
                        Text(
                          '${allocationCategoryLabel(need.category)}'
                          '${need.label.isEmpty ? '' : ' · ${latinDigits(need.label)}'}'
                          ' · ${formatMinor(need.minor, scales[need.currency]!)} ${need.currency}',
                        ),
                      if (transfer.terms.isNotEmpty)
                        Text(
                          'الرسوم المقدّرة: ${formatMinor(quote.fee, salary.scale)} USD',
                        ),
                      for (final MapEntry(:key, :value)
                          in transfer.terms.entries)
                        Text('السعر التقديري: ${value.rate} $key لكل 1 USD'),
                    ],
                  );
                },
              ),
            _totals(salary, [
              ('المخطط', item.planned),
              ('المنفّذ', item.executed),
              ('المؤكّد', item.confirmed),
              ('المتبقي', item.remaining),
            ]),
            Wrap(
              children: [
                if (item.executions.isEmpty && !salary.reversed) ...[
                  TextButton(
                    onPressed: editable
                        ? () => item.transfer == null
                              ? _allocation(salary, item)
                              : _calculate(plan, item)
                        : null,
                    child: const Text('تعديل'),
                  ),
                  TextButton(
                    onPressed: editable
                        ? () => _run(() async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('حذف البند؟'),
                                content: Text(latinDigits(item.label)),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('إلغاء'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('حذف'),
                                  ),
                                ],
                              ),
                            );
                            if (confirmed == true) {
                              await ledger.deleteSalaryAllocation(item.id);
                            }
                          })
                        : null,
                    child: const Text('حذف'),
                  ),
                ],
                if (item.remaining > 0 && !salary.reversed)
                  TextButton(
                    onPressed: editable ? () => _link(salary, item) : null,
                    child: const Text('ربط دفعة'),
                  ),
              ],
            ),
            for (final link in item.executions)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'القيد ${link.entryId} · ${link.reversed
                      ? 'معكوس'
                      : link.evidence == null
                      ? 'منفّذ'
                      : 'مؤكّد'}',
                ),
                subtitle: link.evidence == null
                    ? null
                    : Text(latinDigits(link.evidence!)),
                trailing: _money(link.minor, salary.scale, salary.currency),
                onTap: () => _openMovement(link.entryId),
              ),
            for (final link in item.executions.where(
              (row) => !row.reversed && row.evidence == null,
            ))
              TextButton(
                onPressed: editable ? () => _confirm(link.entryId) : null,
                child: Text('تأكيد القيد ${link.entryId}'),
              ),
          ],
        ),
      ),
    );
  }
}

Widget _totals(SalaryDeposit salary, List<(String, int)> rows) => Column(
  children: [
    for (final (label, amount) in rows)
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            _money(amount, salary.scale, salary.currency),
          ],
        ),
      ),
  ],
);

Widget _money(int minor, int scale, String currency) =>
    AmountLabel('${formatMinor(minor, scale)} $currency');

String _status(SalaryProgress progress) => switch (progress) {
  SalaryProgress.planned => 'مخطط',
  SalaryProgress.partial => 'منفّذ جزئيًا',
  SalaryProgress.executed => 'منفّذ',
  SalaryProgress.confirmed => 'مؤكّد',
};

String _date(BuildContext context, DateTime date) =>
    MaterialLocalizations.of(context).formatShortDate(date);

void _message(BuildContext context, String message) =>
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));

String _explain(Object error) {
  if (error is LedgerException && error.issue == LedgerIssue.overflow) {
    return 'تجاوز المبلغ الحد المدعوم.';
  }
  if (error is LedgerException &&
      error.issue == LedgerIssue.duplicateConflict) {
    return 'تعارض مع عملية مسجّلة.';
  }
  if (error is! SalaryException) return 'تعذّر حفظ البيانات أو فتحها.';
  return switch (error.issue) {
    SalaryIssue.invalidInput => 'المدخلات غير صالحة.',
    SalaryIssue.bankAccountRequired => 'اختر حسابًا بنكيًا لتسجيل الراتب.',
    SalaryIssue.duplicateReceipt => 'يوجد راتب مطابق. راجع الإيداع أو استخدم مراجع مصرفية مميزة للإيداعات المتشابهة.',
    SalaryIssue.missingPlan => 'أنشئ خطة توزيع أولًا.',
    SalaryIssue.reversedSalary => 'قيد الراتب معكوس.',
    SalaryIssue.planLimit => 'إجمالي التخصيصات يتجاوز مبلغ الراتب.',
    SalaryIssue.allocationLocked => 'يحتوي هذا البند على سجل تنفيذ.',
    SalaryIssue.missingAllocation => 'البند غير موجود.',
    SalaryIssue.allocationLimit => 'مبلغ الدفعة يتجاوز المتبقي للبند.',
    SalaryIssue.ineligibleMovement => 'يجب أن تكون الحركة خصمًا من حساب الراتب بالعملة نفسها إلى حساب شخصي أو مصروف.',
    SalaryIssue.reversedMovement => 'القيد المرتبط معكوس.',
    SalaryIssue.movementLimit =>
      'مبلغ الدفعة يتجاوز القيمة غير المرتبطة من القيد.',
    SalaryIssue.duplicateExecution => 'هذا القيد مرتبط بالفعل بالبند.',
    SalaryIssue.unlinkedMovement => 'اربط القيد ببند قبل تأكيده.',
    SalaryIssue.alreadyConfirmed => 'لهذا القيد تأكيد محفوظ بالفعل.',
  };
}

class _MovementPage extends StatefulWidget {
  const _MovementPage({required this.ledger, required this.id});

  final Ledger ledger;
  final int id;

  @override
  State<_MovementPage> createState() => _MovementPageState();
}

class _MovementPageState extends State<_MovementPage> {
  late final movement = widget.ledger.salaryMovement(widget.id);
  late final remittance = widget.ledger.remittanceForEntry(widget.id);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('تفاصيل القيد')),
    body: FutureBuilder(
      future: movement,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('تعذّر تحميل القيد.'));
        }
        final data = snapshot.data;
        if (data == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final date = DateTime.fromMicrosecondsSinceEpoch(
          data.entry.effectiveMicros,
          isUtc: data.entry.kind == JournalKind.salary,
        );
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ListTile(
              title: Text('القيد ${data.entry.id}'),
              subtitle: Text(_date(context, date)),
              trailing: Text(data.reversed ? 'معكوس' : 'مسجّل'),
            ),
            if (data.entry.kind.isRemittance)
              FutureBuilder(
                future: remittance,
                builder: (context, snapshot) {
                  final view = snapshot.data;
                  if (view == null) return const SizedBox.shrink();
                  return ListTile(
                    title: const Text('تفاصيل التحويل الفعلي'),
                    subtitle: Text(
                      'المستلم: ${formatMinor(view.received, view.destinationScale)} ${view.record.destinationCurrency}',
                    ),
                    onTap: () => Navigator.of(context).push<void>(
                      MaterialPageRoute(
                        builder: (_) => RemittanceDetail(
                          ledger: widget.ledger,
                          id: view.record.id,
                        ),
                      ),
                    ),
                  );
                },
              ),
            for (final line in data.lines)
              ListTile(
                title: Text(switch (line.kind) {
                  AccountKind.income => 'الدخل',
                  AccountKind.expense => 'المصروف',
                  AccountKind.opening => 'الرصيد الافتتاحي',
                  _ => latinDigits(line.account),
                }),
                trailing: _money(line.minor, line.scale, line.currency),
              ),
          ],
        );
      },
    ),
  );
}

typedef _ReceiptInput = ({
  int accountId,
  int minor,
  DateTime date,
  String reference,
});

class _ReceiptDialog extends StatefulWidget {
  const _ReceiptDialog({required this.accounts, required this.scales});
  final List<LedgerAccount> accounts;
  final Map<String, int> scales;

  @override
  State<_ReceiptDialog> createState() => _ReceiptDialogState();
}

class _ReceiptDialogState extends State<_ReceiptDialog> {
  final _form = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _reference = TextEditingController();
  late LedgerAccount _account = widget.accounts.first;
  DateTime _dateValue = DateTime.now();

  @override
  void dispose() {
    _amount.dispose();
    _reference.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale = widget.scales[_account.currency]!;
    return _dialog(
      context,
      'تسجيل راتب',
      _form,
      [
        DropdownButtonFormField<LedgerAccount>(
          initialValue: _account,
          isExpanded: true,
          decoration: const InputDecoration(labelText: 'حساب الإيداع'),
          items: [
            for (final account in widget.accounts)
              DropdownMenuItem(
                value: account,
                child: Text(
                  '${latinDigits(account.name)} · ${account.currency}',
                ),
              ),
          ],
          onChanged: (value) => setState(() => _account = value!),
        ),
        _amountField(_amount, scale, 'مبلغ الراتب · ${_account.currency}'),
        TextFormField(
          controller: _reference,
          maxLength: 120,
          decoration: const InputDecoration(
            labelText: 'مرجع الإيداع المصرفي (اختياري)',
          ),
        ),
        TextButton(
          onPressed: () async {
            final day = await showAppDatePicker(
              context: context,
              initialDate: _dateValue,
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (mounted && day != null) setState(() => _dateValue = day);
          },
          child: Text('تاريخ الإيداع · ${_date(context, _dateValue)}'),
        ),
      ],
      () {
        final _ReceiptInput result = (
          accountId: _account.id,
          minor: parseMinor(_amount.text, scale)!,
          date: _dateValue,
          reference: _reference.text,
        );
        Navigator.pop(context, result);
      },
    );
  }
}

class _AllocationDialog extends StatefulWidget {
  const _AllocationDialog({required this.scale, this.item});
  final int scale;
  final SalaryAllocationView? item;

  @override
  State<_AllocationDialog> createState() => _AllocationDialogState();
}

class _AllocationDialogState extends State<_AllocationDialog> {
  final _form = GlobalKey<FormState>();
  late final _label = TextEditingController(text: widget.item?.label);
  late AllocationCategory? _category =
      widget.item?.category ??
      (widget.item == null ? AllocationCategory.personal : null);
  late final _amount = TextEditingController(
    text: widget.item == null
        ? null
        : formatMinor(widget.item!.planned, widget.scale),
  );

  @override
  void dispose() {
    _label.dispose();
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _dialog(
    context,
    widget.item == null ? 'إضافة توزيع' : 'تعديل التوزيع',
    _form,
    [
      allocationCategoryField(
        _category,
        (value) => setState(() => _category = value),
      ),
      TextFormField(
        controller: _label,
        maxLength: 100,
        decoration: InputDecoration(
          labelText: _category == null
              ? 'اسم البند'
              : 'الوجهة أو الغرض (اختياري)',
        ),
        validator: (value) => _category == null && (value ?? '').trim().isEmpty
            ? 'هذا الحقل مطلوب'
            : null,
      ),
      _amountField(_amount, widget.scale, 'المبلغ المخطط'),
    ],
    () => Navigator.pop(context, (
      label: _label.text.trim().isEmpty
          ? allocationCategoryLabel(_category!)
          : _label.text,
      category: _category,
      minor: parseMinor(_amount.text, widget.scale)!,
    )),
  );
}

class _LinkDialog extends StatefulWidget {
  const _LinkDialog({
    required this.salary,
    required this.item,
    required this.candidates,
  });
  final SalaryDeposit salary;
  final SalaryAllocationView item;
  final List<ExecutionCandidate> candidates;

  @override
  State<_LinkDialog> createState() => _LinkDialogState();
}

class _LinkDialogState extends State<_LinkDialog> {
  final _form = GlobalKey<FormState>();
  final _amount = TextEditingController();
  late ExecutionCandidate _candidate = widget.candidates.first;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _dialog(
    context,
    'ربط دفعة بقيد مسجّل',
    _form,
    [
      DropdownButtonFormField<ExecutionCandidate>(
        initialValue: _candidate,
        isExpanded: true,
        decoration: const InputDecoration(labelText: 'القيد المالي'),
        items: [
          for (final candidate in widget.candidates)
            DropdownMenuItem(
              value: candidate,
              child: Text(
                'القيد ${candidate.movement.entry.id} · ${_date(context, DateTime.fromMicrosecondsSinceEpoch(candidate.movement.entry.effectiveMicros))}',
              ),
            ),
        ],
        onChanged: (value) => setState(() => _candidate = value!),
      ),
      _totals(widget.salary, [
        ('المتاح من القيد', _candidate.available),
        ('متبقي البند', widget.item.remaining),
      ]),
      _amountField(_amount, widget.salary.scale, 'قيمة الدفعة'),
    ],
    () => Navigator.pop(context, (
      id: _candidate.movement.entry.id,
      minor: parseMinor(_amount.text, widget.salary.scale)!,
    )),
  );
}

class _EvidenceDialog extends StatefulWidget {
  const _EvidenceDialog();

  @override
  State<_EvidenceDialog> createState() => _EvidenceDialogState();
}

class _EvidenceDialogState extends State<_EvidenceDialog> {
  final _form = GlobalKey<FormState>();
  final _note = TextEditingController();

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _dialog(
    context,
    'تأكيد الحركة',
    _form,
    [_requiredField(_note, 'دليل التأكيد أو مرجعه', 500)],
    () => Navigator.pop(context, _note.text),
  );
}

Widget _requiredField(
  TextEditingController controller,
  String label,
  int maxLength,
) => TextFormField(
  controller: controller,
  maxLength: maxLength,
  decoration: InputDecoration(labelText: label),
  validator: (value) =>
      value == null || value.trim().isEmpty ? 'هذا الحقل مطلوب' : null,
);

Widget _amountField(
  TextEditingController controller,
  int scale,
  String label,
) => TextFormField(
  controller: controller,
  inputFormatters: amountInputFormatters,
  textDirection: TextDirection.ltr,
  keyboardType: const TextInputType.numberWithOptions(decimal: true),
  decoration: InputDecoration(labelText: label),
  validator: (value) => (parseMinor(value ?? '', scale) ?? 0) > 0
      ? null
      : 'أدخل مبلغًا صالحًا أكبر من صفر',
);

Widget _dialog(
  BuildContext context,
  String title,
  GlobalKey<FormState> form,
  List<Widget> fields,
  VoidCallback save,
) => AlertDialog(
  title: Text(title),
  content: Form(
    key: form,
    child: SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(mainAxisSize: MainAxisSize.min, children: fields),
    ),
  ),
  actions: [
    TextButton(
      onPressed: () => Navigator.pop(context),
      child: const Text('إلغاء'),
    ),
    FilledButton(
      onPressed: () {
        if (form.currentState!.validate()) save();
      },
      child: const Text('حفظ'),
    ),
  ],
);
