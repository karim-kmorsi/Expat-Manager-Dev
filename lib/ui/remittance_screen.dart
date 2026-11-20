import 'dart:math';

import 'package:material_ui/material_ui.dart';

import '../data/database.dart';
import '../finance/ledger.dart';
import '../finance/model.dart';
import 'amount.dart';
import 'date_picker.dart';
import 'digits.dart';

class RemittanceScreen extends StatefulWidget {
  const RemittanceScreen({required this.ledger, super.key});

  final Ledger ledger;

  @override
  State<RemittanceScreen> createState() => _RemittanceScreenState();
}

class _RemittanceScreenState extends State<RemittanceScreen> {
  late Future<List<RemittanceView>> _items = widget.ledger.remittances();
  bool _busy = false;

  Future<void> _plan() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final accounts = await widget.ledger.accounts();
      final currencies = await widget.ledger.currencies();
      if (!mounted) return;
      if (accounts.every((account) => account.kind != AccountKind.bank)) {
        _showMessage(context, 'أضف حساب البنك المصدر من شاشة الحسابات أولًا.');
        return;
      }
      final id = await showDialog<int>(
        context: context,
        barrierDismissible: false,
        builder: (_) => _PlanDialog(
          ledger: widget.ledger,
          accounts: accounts,
          currencies: currencies,
        ),
      );
      if (id != null && mounted) await _open(id);
    } catch (error) {
      if (mounted) _showMessage(context, _errorMessage(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _open(int id) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => _RemittanceDetail(ledger: widget.ledger, id: id),
      ),
    );
    if (mounted) setState(() => _items = widget.ledger.remittances());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('الحوالات إلى مصر')),
    body: SafeArea(
      child: FutureBuilder(
        future: _items,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('تعذّر تحميل الحوالات.'));
          }
          final items = snapshot.data;
          if (items == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (items.isEmpty) {
            return const Center(child: Text('لا توجد حوالات مسجّلة.'));
          }
          return ListView(
            padding: const EdgeInsets.only(bottom: 88),
            children: [
              for (final item in items)
                ListTile(
                  title: Text(
                    '${latinDigits(item.source.name)} ← ${latinDigits(item.destinationName)}',
                  ),
                  subtitle: Text(_status(item.status)),
                  trailing: Text(
                    _money(
                      item.received,
                      item.destinationScale,
                      item.record.destinationCurrency,
                    ),
                  ),
                  onTap: _busy ? null : () => _open(item.record.id),
                ),
            ],
          );
        },
      ),
    ),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: _busy ? null : _plan,
      icon: const Icon(Icons.add),
      label: const Text('تخطيط حوالة'),
    ),
  );
}

class _PlanDialog extends StatefulWidget {
  const _PlanDialog({
    required this.ledger,
    required this.accounts,
    required this.currencies,
  });
  final Ledger ledger;
  final List<LedgerAccount> accounts;
  final List<Currency> currencies;

  @override
  State<_PlanDialog> createState() => _PlanDialogState();
}

class _PlanDialogState extends State<_PlanDialog> {
  final _key = _operation('draft');
  final _beneficiary = TextEditingController();
  LedgerAccount? _source;
  LedgerAccount? _destinationAccount;
  String? _currency;
  RemittanceDestination _destination = RemittanceDestination.personal;
  bool _verifiedRoute = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _beneficiary.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final currency = _destination == RemittanceDestination.personal
        ? _destinationAccount?.currency
        : _currency;
    final source = _source;
    if (currency == null || source == null || !_verifiedRoute) {
      setState(() => _error = 'اختر المصدر والوجهة وأكّد مسار الحوالة.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final id = await widget.ledger.planRemittance(
        operationId: _key,
        sourceAccountId: source.id,
        destination: _destination,
        destinationCurrency: currency,
        destinationAccountId: _destination == RemittanceDestination.personal
            ? _destinationAccount?.id
            : null,
        beneficiary: _destination == RemittanceDestination.personal
            ? null
            : _beneficiary.text,
      );
      if (mounted) Navigator.pop(context, id);
    } catch (error) {
      if (mounted) setState(() => _error = _errorMessage(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('تخطيط حوالة'),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _choice(
            'حساب البنك في نيبال',
            _source,
            [
              for (final account in widget.accounts)
                if (account.kind == AccountKind.bank)
                  DropdownMenuItem(
                    value: account,
                    child: Text(
                      '${latinDigits(account.name)} · ${account.currency}',
                    ),
                  ),
            ],
            (account) => setState(() {
              _source = account;
              if (account == _destinationAccount) _destinationAccount = null;
            }),
          ),
          _choice('نوع الوجهة', _destination, [
            for (final item in RemittanceDestination.values)
              DropdownMenuItem(
                value: item,
                child: Text(_destinationType(item)),
              ),
          ], (item) => setState(() => _destination = item!)),
          if (_destination == RemittanceDestination.personal)
            _choice('حسابي في مصر', _destinationAccount, [
              for (final account in widget.accounts)
                if (account != _source &&
                    (account.kind == AccountKind.bank ||
                        account.kind == AccountKind.savings))
                  DropdownMenuItem(
                    value: account,
                    child: Text(
                      '${latinDigits(account.name)} · ${account.currency}',
                    ),
                  ),
            ], (account) => setState(() => _destinationAccount = account))
          else ...[
            TextField(
              controller: _beneficiary,
              decoration: const InputDecoration(labelText: 'اسم المستفيد'),
            ),
            _choice('عملة الاستلام', _currency, [
              for (final item in widget.currencies)
                DropdownMenuItem(value: item.code, child: Text(item.code)),
            ], (item) => setState(() => _currency = item)),
          ],
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _verifiedRoute,
            onChanged: _busy
                ? null
                : (value) => setState(() => _verifiedRoute = value!),
            title: const Text('أؤكد أن المصدر في نيبال والوجهة في مصر'),
          ),
          if (_error != null) Text(_error!),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: _busy ? null : () => Navigator.pop(context),
        child: const Text('رجوع'),
      ),
      FilledButton(
        onPressed: _busy ? null : _save,
        child: const Text('حفظ الخطة'),
      ),
    ],
  );

  Widget _choice<T>(
    String label,
    T? value,
    List<DropdownMenuItem<T>> items,
    ValueChanged<T?> change,
  ) => InputDecorator(
    decoration: InputDecoration(labelText: label),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<T>(
        value: value,
        items: items,
        onChanged: _busy ? null : change,
        isExpanded: true,
      ),
    ),
  );
}

class _RemittanceDetail extends StatefulWidget {
  const _RemittanceDetail({required this.ledger, required this.id});
  final Ledger ledger;
  final int id;

  @override
  State<_RemittanceDetail> createState() => _RemittanceDetailState();
}

class _RemittanceDetailState extends State<_RemittanceDetail> {
  late Future<RemittanceView> _data = widget.ledger.remittance(widget.id);
  bool _busy = false;

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
      if (mounted) setState(() => _data = widget.ledger.remittance(widget.id));
    } catch (error) {
      if (mounted) _showMessage(context, _errorMessage(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _event(
    RemittanceView view,
    RemittanceEventKind kind, {
    int? receiptId,
    RemittanceActivity? original,
    bool reverse = false,
  }) => _run(() async {
    final key = _operation(kind.name);
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _EventDialog(
        view: view,
        kind: kind,
        correction: original != null,
        reverse: reverse,
        save: (input) async {
          if (original == null) {
            await widget.ledger.recordRemittanceEvent(
              remittanceId: widget.id,
              operationId: key,
              kind: kind,
              minor: input.minor,
              evidence: input.evidence,
              effectiveAt: input.date,
              feeMinor: input.fee,
              sourceMinor: input.share,
              receiptEntryId: receiptId,
            );
          } else if (reverse) {
            await widget.ledger.reverseRemittanceEvent(
              entryId: original.event.entryId,
              operationId: key,
              reason: input.reason,
              effectiveAt: input.date,
            );
          } else {
            await widget.ledger.correctRemittanceEvent(
              entryId: original.event.entryId,
              operationId: key,
              minor: input.minor,
              reason: input.reason,
              evidence: input.evidence,
              effectiveAt: input.date,
              feeMinor: input.fee,
              sourceMinor: input.share,
            );
          }
        },
      ),
    );
  });

  Future<void> _purpose(RemittanceView view) => _run(() async {
    final key = _operation('purpose');
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _PurposeDialog(
        view: view,
        save: (label, minor, family) => widget.ledger.addRemittancePurpose(
          widget.id,
          key,
          label,
          minor,
          family: family,
        ),
      ),
    );
  });

  Future<void> _linkFamily(RemittancePurpose purpose) => _run(() async {
    final items = await widget.ledger.remittanceFamilyCandidates(
      widget.id,
      purpose.operationKey,
    );
    if (!mounted) return;
    if (items.isEmpty) {
      _showMessage(
        context,
        'سجّل دفعة الأسرة الفعلية من الحساب المستلم في المصروفات أولًا.',
      );
      return;
    }
    final id = await showDialog<int>(
      context: context,
      builder: (dialog) => SimpleDialog(
        title: const Text('ربط مصروف دعم الأسرة'),
        children: [
          for (final item in items)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(dialog, item.id),
              child: Text(
                '#${item.id} · ${_date(item.input.date)} · '
                '${_money(item.input.minor, item.scale, item.currency)} '
                '${latinDigits(item.input.note ?? '')}',
              ),
            ),
        ],
      ),
    );
    if (id != null) {
      await widget.ledger.linkRemittanceFamilyPayment(
        widget.id,
        purpose.operationKey,
        id,
      );
    }
  });

  Future<void> _cancel() => _run(() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: const Text('إلغاء تعليمات الحوالة'),
        content: const Text(
          'إذا تم الخصم، تبقى الحوالة معلّقة إلى أن تسجّل الاستلام أو الاسترداد الفعلي.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog),
            child: const Text('رجوع'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialog, true),
            child: const Text('تأكيد الإلغاء'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await widget.ledger.updateRemittanceStatus(widget.id, cancel: true);
    }
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('تفاصيل الحوالة')),
    body: SafeArea(
      child: FutureBuilder(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('تعذّر تحميل الحوالة.'));
          }
          final view = snapshot.data;
          if (view == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return _details(view);
        },
      ),
    ),
  );

  Widget _details(RemittanceView view) {
    final status = view.status;
    final inFlight =
        status == RemittanceStatus.sent || status == RemittanceStatus.pending;
    final debit = view.debit;
    final latest = view.active.lastOrNull;
    String source(int value) =>
        _money(value, view.sourceScale, view.source.currency);
    String destination(int value) =>
        _money(value, view.destinationScale, view.record.destinationCurrency);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          '${latinDigits(view.source.name)} ← ${latinDigits(view.destinationName)}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(_destinationType(view.record.destination)),
        Text(_status(status), style: Theme.of(context).textTheme.titleMedium),
        if (view.record.cancelled && inFlight)
          const Text('طُلب الإلغاء. الخصم ما زال مسجّلًا.'),
        if (debit != null) ...[
          Text(
            'الخصم البنكي: ${source(-debit.movement.lines.singleWhere((line) => line.accountId == view.source.id).minor)}',
          ),
          Text('المتبقي من المصدر: ${source(view.outstanding)}'),
          Text(
            debit.event.feeMinor == null
                ? 'الرسوم غير موثّقة'
                : 'الرسوم المضمّنة: ${source(debit.event.feeMinor!)}',
          ),
          Text(
            'قيد الخصم #${debit.event.entryId} · يمكن اختياره من خطة الراتب إذا كان مؤهلًا.',
          ),
        ],
        Text('المستلم فعليًا: ${destination(view.received)}'),
        Wrap(
          spacing: 8,
          children: [
            if (status == RemittanceStatus.planned)
              FilledButton(
                onPressed: _busy
                    ? null
                    : () => _event(view, RemittanceEventKind.debit),
                child: Text(
                  status == RemittanceStatus.cancelled
                      ? 'تسجيل خصم فعلي بعد الإلغاء'
                      : 'تسجيل الخصم المرسل',
                ),
              ),
            if (status == RemittanceStatus.sent)
              OutlinedButton(
                onPressed: _busy
                    ? null
                    : () => _run(
                        () => widget.ledger.updateRemittanceStatus(
                          widget.id,
                          cancel: false,
                        ),
                      ),
                child: const Text('قيد الانتظار'),
              ),
            if (inFlight) ...[
              FilledButton(
                onPressed: _busy
                    ? null
                    : () => _event(view, RemittanceEventKind.receipt),
                child: const Text('تسجيل الاستلام'),
              ),
              if (view.outstanding > 0)
                OutlinedButton(
                  onPressed: _busy
                      ? null
                      : () => _event(view, RemittanceEventKind.refund),
                  child: const Text('تسجيل الاسترداد'),
                ),
            ],
            if (!view.record.cancelled &&
                (inFlight || status == RemittanceStatus.planned))
              TextButton(
                onPressed: _busy ? null : _cancel,
                child: const Text('إلغاء التعليمات'),
              ),
          ],
        ),
        const Divider(),
        Text('سجل الحركات', style: Theme.of(context).textTheme.titleMedium),
        for (final row in view.activity.reversed) ...[
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              '${_eventLabel(row.event.kind)} #${row.event.entryId}'
              '${row.movement.reversed ? ' · معكوس' : ''}',
            ),
            subtitle: Text(
              '${_date(DateTime.fromMicrosecondsSinceEpoch(row.movement.entry.effectiveMicros))}'
              ' · ${latinDigits(row.event.evidence)}'
              '${row.movement.entry.correctionOf == null ? '' : ' · تصحيح #${row.movement.entry.correctionOf}'}'
              '${row.reversal == null ? '' : '\nعكس #${row.reversal!.id} · ${latinDigits(row.reversal!.reason ?? '')}'}',
            ),
            trailing: Text(
              row.received > 0
                  ? destination(row.received)
                  : source(row.transit.abs()),
            ),
          ),
          if (!row.movement.reversed && view.needsSourceProof(row))
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: OutlinedButton(
                onPressed: _busy || view.outstanding <= 0
                    ? null
                    : () => _event(
                        view,
                        RemittanceEventKind.sourceProof,
                        receiptId: row.event.entryId,
                      ),
                child: const Text('توثيق حصة الاستلام من المصدر'),
              ),
            ),
          if (row == latest)
            Wrap(
              spacing: 8,
              children: [
                TextButton(
                  onPressed: _busy
                      ? null
                      : () => _event(view, row.event.kind, original: row),
                  child: const Text('تصحيح آخر حركة'),
                ),
                TextButton(
                  onPressed: _busy
                      ? null
                      : () => _event(
                          view,
                          row.event.kind,
                          original: row,
                          reverse: true,
                        ),
                  child: const Text('عكس آخر حركة'),
                ),
              ],
            ),
        ],
        const Divider(),
        Text(
          'الأغراض · غير مخصّص: ${destination(view.unallocated)}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        if (view.record.destination == RemittanceDestination.personal)
          const Text(
            'تخصيص دعم الأسرة خطة. سجّل الدفع الفعلي في المصروفات ثم اربطه بالغرض.',
          ),
        for (final purpose in view.purposes) ...[
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(latinDigits(purpose.label)),
            subtitle: purpose.family
                ? Text(
                    'مدفوع فعليًا: ${destination((view.familyPayments[purpose.operationKey] ?? []).where((item) => !item.reversed).fold(0, (sum, item) => sum + item.input.minor))}',
                  )
                : null,
            trailing: Text(destination(purpose.minor)),
          ),
          Wrap(
            spacing: 8,
            children: [
              if (purpose.family)
                TextButton(
                  onPressed: _busy ? null : () => _linkFamily(purpose),
                  child: const Text('ربط مصروف موجود'),
                ),
              if (!view.familyPayments.containsKey(purpose.operationKey))
                TextButton(
                  onPressed: _busy
                      ? null
                      : () => _run(
                          () => widget.ledger.removeRemittancePurpose(
                            widget.id,
                            purpose.operationKey,
                          ),
                        ),
                  child: const Text('حذف الغرض'),
                ),
            ],
          ),
        ],
        if (view.unallocated > 0)
          OutlinedButton(
            onPressed: _busy ? null : () => _purpose(view),
            child: const Text('إضافة غرض'),
          ),
      ],
    );
  }
}

typedef _EventInput = ({
  int minor,
  int? fee,
  int? share,
  String evidence,
  String reason,
  DateTime date,
});

class _EventDialog extends StatefulWidget {
  const _EventDialog({
    required this.view,
    required this.kind,
    required this.correction,
    required this.reverse,
    required this.save,
  });
  final RemittanceView view;
  final RemittanceEventKind kind;
  final bool correction;
  final bool reverse;
  final Future<void> Function(_EventInput) save;

  @override
  State<_EventDialog> createState() => _EventDialogState();
}

class _EventDialogState extends State<_EventDialog> {
  final _amount = TextEditingController();
  final _extra = TextEditingController();
  final _evidence = TextEditingController();
  final _reason = TextEditingController();
  DateTime _day = DateUtils.dateOnly(DateTime.now());
  bool _busy = false;
  String? _error;

  bool get _receipt => widget.kind == RemittanceEventKind.receipt;
  bool get _debit => widget.kind == RemittanceEventKind.debit;
  bool get _extraVisible =>
      _debit ||
      (_receipt &&
          widget.view.source.currency !=
              widget.view.record.destinationCurrency);

  @override
  void dispose() {
    for (final controller in [_amount, _extra, _evidence, _reason]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDay() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final picked = await showAppDatePicker(
      context: context,
      initialDate: _day,
      firstDate: DateTime(1900),
      lastDate: today,
    );
    if (picked != null && mounted) setState(() => _day = picked);
  }

  Future<void> _save() async {
    final minor = widget.reverse
        ? 0
        : parseMinor(
            _amount.text,
            _receipt ? widget.view.destinationScale : widget.view.sourceScale,
          );
    final extra = _extra.text.trim().isEmpty
        ? null
        : parseMinor(_extra.text, widget.view.sourceScale);
    if (minor == null ||
        (!widget.reverse && minor <= 0) ||
        (_extra.text.trim().isNotEmpty && extra == null)) {
      setState(() => _error = 'أدخل مبلغًا صالحًا بالعملة المعروضة.');
      return;
    }
    setState(() {
      _error = null;
      _busy = true;
    });
    try {
      await widget.save((
        minor: minor,
        fee: _debit ? extra : null,
        share: _receipt ? extra : null,
        evidence: _evidence.text,
        reason: _reason.text,
        date: _day,
      ));
      if (mounted) Navigator.pop(context);
    } catch (error) {
      if (mounted) setState(() => _error = _errorMessage(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currency = _receipt
        ? widget.view.record.destinationCurrency
        : widget.view.source.currency;
    return AlertDialog(
      title: Text(
        widget.reverse
            ? 'عكس الحركة'
            : widget.correction
            ? 'تصحيح الحركة'
            : _eventLabel(widget.kind),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.correction)
              TextField(
                controller: _reason,
                decoration: const InputDecoration(
                  labelText: 'سبب التصحيح أو العكس',
                ),
              ),
            if (!widget.reverse) ...[
              _amountField(_amount, 'المبلغ الفعلي · $currency'),
              if (_extraVisible)
                _amountField(
                  _extra,
                  _debit
                      ? 'رسوم مضمّنة موثّقة، اختياري'
                      : 'حصة الخصم المثبتة · ${widget.view.source.currency}، اختياري',
                ),
              TextField(
                controller: _evidence,
                decoration: const InputDecoration(labelText: 'مرجع الإثبات'),
              ),
            ],
            TextButton(
              onPressed: _busy ? null : _pickDay,
              child: Text('تاريخ الحركة: ${_date(_day)}'),
            ),
            if (_error != null) Text(_error!),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.pop(context),
          child: const Text('رجوع'),
        ),
        FilledButton(onPressed: _busy ? null : _save, child: const Text('حفظ')),
      ],
    );
  }
}

class _PurposeDialog extends StatefulWidget {
  const _PurposeDialog({required this.view, required this.save});
  final RemittanceView view;
  final Future<void> Function(String, int, bool) save;

  @override
  State<_PurposeDialog> createState() => _PurposeDialogState();
}

class _PurposeDialogState extends State<_PurposeDialog> {
  final _label = TextEditingController();
  final _amount = TextEditingController();
  bool _family = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _label.dispose();
    _amount.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final minor = parseMinor(_amount.text, widget.view.destinationScale);
    if (minor == null || minor <= 0) {
      setState(() => _error = 'أدخل مبلغًا صالحًا.');
      return;
    }
    setState(() {
      _error = null;
      _busy = true;
    });
    try {
      await widget.save(_label.text, minor, _family);
      if (mounted) Navigator.pop(context);
    } catch (error) {
      if (mounted) setState(() => _error = _errorMessage(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('إضافة غرض'),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _label,
            decoration: const InputDecoration(labelText: 'اسم الغرض'),
          ),
          _amountField(
            _amount,
            'المبلغ · ${widget.view.record.destinationCurrency}',
          ),
          if (widget.view.record.destination == RemittanceDestination.personal)
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _family,
              onChanged: _busy
                  ? null
                  : (value) => setState(() => _family = value!),
              title: const Text('مخصّص لدعم الأسرة'),
            ),
          if (_error != null) Text(_error!),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: _busy ? null : () => Navigator.pop(context),
        child: const Text('رجوع'),
      ),
      FilledButton(onPressed: _busy ? null : _save, child: const Text('حفظ')),
    ],
  );
}

Widget _amountField(TextEditingController controller, String label) =>
    TextField(
      controller: controller,
      inputFormatters: amountInputFormatters,
      textDirection: TextDirection.ltr,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: label),
    );

String _operation(String kind) =>
    'remittance-$kind-${DateTime.now().microsecondsSinceEpoch}-${Random.secure().nextInt(1 << 32)}';

String _money(int minor, int scale, String code) =>
    '${formatMinor(minor, scale)} $code';

String _date(DateTime day) => day.toIso8601String().split('T').first;

String _status(RemittanceStatus status) => switch (status) {
  RemittanceStatus.planned => 'مخططة',
  RemittanceStatus.sent => 'مرسلة · بانتظار الاستلام',
  RemittanceStatus.pending => 'معلّقة · قيد التسوية',
  RemittanceStatus.received => 'مستلمة',
  RemittanceStatus.cancelled => 'ملغاة قبل الخصم',
  RemittanceStatus.refunded => 'مستردة',
};

String _destinationType(RemittanceDestination type) => switch (type) {
  RemittanceDestination.personal => 'حسابي الشخصي في مصر',
  RemittanceDestination.family => 'دعم الأسرة مباشرة',
  RemittanceDestination.beneficiary => 'مستفيد خارجي',
};

String _eventLabel(RemittanceEventKind kind) => switch (kind) {
  RemittanceEventKind.debit => 'الخصم البنكي',
  RemittanceEventKind.receipt => 'الاستلام الفعلي',
  RemittanceEventKind.refund => 'الاسترداد البنكي',
  RemittanceEventKind.sourceProof => 'تسوية حصة المصدر',
};

String _errorMessage(Object error) {
  if (error is RemittanceException) {
    return switch (error.issue) {
      RemittanceIssue.invalidInput =>
        'تحقق من الحسابات والمبالغ والمرجع وأدخل سبب التصحيح.',
      RemittanceIssue.notFound => 'الحوالة أو الحركة غير موجودة.',
      RemittanceIssue.duplicateEvidence =>
        'مرجع الإثبات مستخدم بالفعل لهذه الحركة أو الحساب.',
      RemittanceIssue.invalidStatus =>
        'الحركة أو تاريخها غير صالحين في الحالة الحالية للحوالة.',
      RemittanceIssue.sourceLimit => 'المبلغ يتجاوز المتبقي من المصدر.',
      RemittanceIssue.purposeLimit =>
        'المبلغ يتجاوز المتاح أو يتعارض مع الأغراض المسجّلة.',
      RemittanceIssue.protectedCorrection =>
        'تعذّر التعديل بسبب حركة لاحقة أو رابط مالي أو مطابقة رصيد.',
    };
  }
  if (error is LedgerException) {
    return switch (error.issue) {
      LedgerIssue.overflow => 'تجاوز المبلغ الحد المدعوم.',
      LedgerIssue.duplicateConflict => 'معرّف العملية مستخدم ببيانات مختلفة.',
      _ => 'تعذّر حفظ الحركة. راجع البيانات.',
    };
  }
  return 'تعذّر إكمال الطلب.';
}

void _showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
