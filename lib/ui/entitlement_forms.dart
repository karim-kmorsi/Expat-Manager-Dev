part of 'entitlement_screen.dart';

class _BenefitDialog extends StatefulWidget {
  const _BenefitDialog({
    required this.title,
    required this.body,
    required this.save,
    required this.action,
  });
  final String title;
  final Widget Function(BuildContext, StateSetter) body;
  final Future<void> Function() save;
  final String action;

  @override
  State<_BenefitDialog> createState() => _BenefitDialogState();
}

class _BenefitDialogState extends State<_BenefitDialog> {
  bool _busy = false;
  String? _error;

  Future<void> _save() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await widget.save();
      if (mounted) Navigator.of(context).pop(true);
    } on LedgerException catch (error) {
      if (mounted) {
        setState(() {
          _error = switch (error.issue) {
            LedgerIssue.reconciledPeriod =>
              'القيد ضمن فترة تمت تسويتها. لا يمكن تصحيحه من هنا.',
            LedgerIssue.duplicateConflict =>
              'تغيّر السجل أثناء التحرير. أغلق النموذج وافتحه مجددًا.',
            LedgerIssue.currencyMismatch =>
              'اختر حسابًا بعملة الهدف. لا يمكن تغيير عملة هدف له مساهمات.',
            LedgerIssue.overflow => 'المبلغ يتجاوز النطاق المتاح.',
            _ => 'تحقق من التواريخ والمبالغ والرصيد المتاح.',
          };
        });
      }
    } catch (_) {
      if (mounted) setState(() => _error = 'تعذّر حفظ السجل.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_busy,
    child: AlertDialog(
      scrollable: true,
      title: Text(widget.title),
      content: IgnorePointer(
        ignoring: _busy,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            widget.body(context, setState),
            if (_error != null)
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.of(context).pop(),
          child: const Text('رجوع'),
        ),
        FilledButton(
          onPressed: _busy ? null : _save,
          child: Text(widget.action),
        ),
      ],
    ),
  );
}

Widget _fields(List<Widget> children) => Column(
  mainAxisSize: MainAxisSize.min,
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    for (final field in children)
      Padding(padding: const EdgeInsets.only(bottom: 10), child: field),
  ],
);

Widget _cashField(String title, String value, ValueChanged<String> change) =>
    TextFormField(
      initialValue: value,
      decoration: InputDecoration(labelText: title),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: amountInputFormatters,
      textDirection: TextDirection.ltr,
      onChanged: change,
    );

Widget _choices<T>(
  String label,
  T? value,
  List<DropdownMenuItem<T>> items,
  ValueChanged<T?> change,
) => DropdownButtonFormField<T>(
  initialValue: value,
  isExpanded: true,
  decoration: InputDecoration(labelText: label),
  items: items,
  onChanged: change,
);

Widget _pickBenefitDate(
  BuildContext context,
  String label,
  int date,
  ValueChanged<int> change, {
  int? first,
  int? last,
}) => OutlinedButton(
  onPressed: () async {
    final day = await showAppDatePicker(
      context: context,
      initialDate: dateOfLeaveDay(date),
      firstDate: first == null ? firstLeaveDate : dateOfLeaveDay(first),
      lastDate: last == null ? lastLeaveDate : dateOfLeaveDay(last),
    );
    if (context.mounted && day != null) change(leaveDay(day));
  },
  child: Text('$label ${_displayDay(context, date)}'),
);

extension _BenefitEditors on _EntitlementScreenState {
  Future<void> _editBonusPlan(_Benefits data) async {
    final old = data.bonus?.plan;
    final year = _year;
    final first = leaveDay(DateTime.utc(year));
    final last = leaveDay(DateTime.utc(year, 12, 31));
    var date = old?.festivalDay ?? _today().clamp(first, last);
    String? code = old?.currency;
    var base = old == null
        ? ''
        : formatMinor(old.salaryMinor, _scale(data, old.currency));
    var allowances = old == null
        ? ''
        : formatMinor(old.allowancesMinor, _scale(data, old.currency));
    await _edit(
      'إعداد مكافأة الدساي',
      (context, update) => _fields([
        _pickBenefitDate(
          context,
          'تاريخ الاحتفال',
          date,
          (value) => update(() => date = value),
          first: first,
          last: last,
        ),
        _choices('عملة الراتب', code, [
          for (final currency in data.currencies)
            DropdownMenuItem(value: currency.code, child: Text(currency.code)),
        ], (value) => update(() => code = value)),
        _cashField('الراتب الأساسي', base, (value) => base = value),
        _cashField(
          'البدلات الشهرية (إن وجدت)',
          allowances,
          (value) => allowances = value,
        ),
      ]),
      () async {
        if (code == null) throw const LedgerException(LedgerIssue.invalidInput);
        await ledger.saveDashainPlan(
          year: year,
          festivalDay: date,
          currency: code!,
          salaryMinor: _amount(data, base, code!),
          allowancesMinor: allowances.trim().isEmpty
              ? 0
              : _amount(data, allowances, code!),
        );
      },
    );
  }

  Future<void> _editBonusReceipt(_Benefits data, DashainView view) async {
    final old = view.receipt;
    int? accountId = old?.accountId;
    final previous = accountId == null
        ? null
        : _account(data, accountId).currency;
    var amount = old == null
        ? ''
        : formatMinor(old.minor, _scale(data, previous!));
    var day = old?.day ?? _today();
    var reason = '';
    await _edit(
      old == null ? 'تأكيد الاستلام' : 'تصحيح استلام المكافأة',
      (context, update) => _fields([
        _choices(
          'حساب الاستلام',
          accountId,
          _accountChoices(data.accounts),
          (value) => update(() => accountId = value),
        ),
        _cashField(
          accountId == null
              ? 'المبلغ الفعلي'
              : 'المبلغ الفعلي · ${_account(data, accountId!).currency}',
          amount,
          (value) => amount = value,
        ),
        _pickBenefitDate(
          context,
          'تاريخ الاستلام',
          day,
          (value) => update(() => day = value),
          last: _today(),
        ),
        if (old != null)
          TextFormField(
            decoration: const InputDecoration(labelText: 'سبب التصحيح'),
            onChanged: (value) => reason = value,
          ),
      ]),
      () async {
        if (accountId == null) {
          throw const LedgerException(LedgerIssue.invalidInput);
        }
        final id = accountId!;
        await ledger.confirmDashain(
          year: view.plan.year,
          expectedRevision: view.plan.revision,
          receipt: (
            accountId: id,
            minor: _amount(data, amount, _account(data, id).currency),
            day: day,
          ),
          reason: reason,
        );
      },
      action: 'تأكيد',
    );
  }

  Future<void> _reverseBonus(DashainView view) {
    var reason = '';
    return _edit(
      'التراجع عن تأكيد المكافأة',
      (_, _) => TextFormField(
        decoration: const InputDecoration(labelText: 'سبب التراجع'),
        onChanged: (value) => reason = value,
      ),
      () => ledger.confirmDashain(
        year: view.plan.year,
        expectedRevision: view.plan.revision,
        receipt: null,
        reason: reason,
      ),
      action: 'تأكيد التراجع',
    );
  }

  Future<void> _editTicket(_Benefits data, bool markUsed) async {
    final year = _year;
    final old = data.ticket;
    final cycle = old == null
        ? annualTicketCycle(year)
        : annualTicketCycle(year, policyVersion: old.policyVersion);
    final first = cycle.startDay;
    final last = min(_today(), cycle.endDay);
    var received = old?.receivedDay ?? last;
    var used = old?.usedDay ?? (markUsed ? last : null);
    var leaveId = old?.leaveId;
    var clear = false;
    await _edit(
      markUsed
          ? 'تسجيل استخدام التذكرة'
          : old?.receivedDay == null
          ? 'تأكيد استلام التذكرة'
          : 'تصحيح بيانات التذكرة',
      (context, update) => _fields([
        if (old?.receivedDay != null && !markUsed)
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('إلغاء تأكيد استلام خاطئ'),
            value: clear,
            onChanged: (value) => update(() => clear = value),
          ),
        if (!clear) ...[
          _pickBenefitDate(
            context,
            'تاريخ الاستلام',
            received,
            (value) => update(() => received = value),
            first: first,
            last: used ?? last,
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('تم استخدام التذكرة'),
            value: used != null,
            onChanged: (value) => update(() => used = value ? last : null),
          ),
          if (used != null)
            _pickBenefitDate(
              context,
              'تاريخ الاستخدام',
              used!,
              (value) => update(() => used = value),
              first: received,
              last: last,
            ),
          _choices('ربط بإجازة (اختياري)', leaveId ?? 0, [
            const DropdownMenuItem(value: 0, child: Text('بدون ارتباط')),
            for (final leave in data.leaves)
              if (leave.status != LeaveStatus.cancelled || leave.id == leaveId)
                DropdownMenuItem(
                  value: leave.id,
                  child: Text(
                    '${_displayDay(context, leave.startDay)} ${latinDigits(leave.occasion)}',
                  ),
                ),
          ], (value) => update(() => leaveId = value == 0 ? null : value)),
        ],
      ]),
      () => ledger.saveTicket(
        year: year,
        expected: old,
        receivedDay: clear ? null : received,
        usedDay: clear ? null : used,
        leaveId: clear ? null : leaveId,
      ),
      action: 'تأكيد',
    );
  }

  Future<void> _editGoal(_Benefits data) {
    final old = data.travel?.goal;
    String? code = old?.currency;
    var date = old?.targetDay ?? _today();
    var base = old == null
        ? ''
        : formatMinor(old.tripMinor, _scale(data, old.currency));
    var airfare = old == null
        ? ''
        : formatMinor(old.airfareMinor, _scale(data, old.currency));
    var personalAirfare = (old?.airfareMinor ?? 0) > 0;
    return _edit(
      'هدف ادخار الإجازة',
      (context, update) => _fields([
        _choices('العملة', code, [
          for (final currency in data.currencies)
            DropdownMenuItem(value: currency.code, child: Text(currency.code)),
        ], (value) => update(() => code = value)),
        _pickBenefitDate(
          context,
          'موعد الهدف',
          date,
          (value) => update(() => date = value),
        ),
        _cashField('المبلغ المستهدف', base, (value) => base = value),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('تضمين تذكرة على نفقتي'),
          value: personalAirfare,
          onChanged: (value) => update(() => personalAirfare = value),
        ),
        if (personalAirfare)
          _cashField(
            'تكلفة التذكرة الشخصية',
            airfare,
            (value) => airfare = value,
          ),
      ]),
      () async {
        if (code == null) throw const LedgerException(LedgerIssue.invalidInput);
        await ledger.saveTravelGoal(
          currency: code!,
          targetDay: date,
          tripMinor: _amount(data, base, code!),
          airfareMinor: personalAirfare ? _amount(data, airfare, code!) : 0,
        );
      },
    );
  }

  Future<void> _editContribution(
    _Benefits data,
    String code, {
    TravelContribution? old,
  }) {
    final choices = data.accounts.where((account) => account.currency == code);
    final operationId =
        old?.operationId ??
        't014-travel:${DateTime.now().microsecondsSinceEpoch}:${Random.secure().nextInt(1 << 32)}';
    int? id = old?.accountId;
    var date = old?.day ?? _today();
    var amount = old == null ? '' : formatMinor(old.minor, _scale(data, code));
    return _edit(
      old == null ? 'تسجيل مساهمة' : 'تعديل المساهمة',
      (context, update) => _fields([
        const Text('خصص مبلغًا من الرصيد المسجّل في أحد حساباتك.'),
        _choices(
          'الحساب',
          id,
          _accountChoices(choices),
          (value) => update(() => id = value),
        ),
        _pickBenefitDate(
          context,
          'تاريخ المساهمة',
          date,
          (value) => update(() => date = value),
          last: _today(),
        ),
        _cashField('المبلغ · $code', amount, (value) => amount = value),
      ]),
      () async {
        if (id == null) throw const LedgerException(LedgerIssue.invalidInput);
        await ledger.contributeToTravel(
          operationId: operationId,
          expected: old,
          accountId: id!,
          day: date,
          minor: _amount(data, amount, code),
        );
      },
    );
  }
}

List<DropdownMenuItem<int>> _accountChoices(Iterable<LedgerAccount> accounts) =>
    [
      for (final account in accounts)
        DropdownMenuItem(
          value: account.id,
          child: Text('${latinDigits(account.name)} · ${account.currency}'),
        ),
    ];
