part of 'entitlement_screen.dart';

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
      (context, update) => recordFields([
        recordDateButton(
          context,
          'تاريخ الاحتفال',
          date,
          (value) => update(() => date = value),
          first: first,
          last: last,
        ),
        recordChoices('عملة الراتب', code, [
          for (final currency in data.currencies)
            DropdownMenuItem(value: currency.code, child: Text(currency.code)),
        ], (value) => update(() => code = value)),
        recordNumberField('الراتب الأساسي', base, (value) => base = value),
        recordNumberField(
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
      (context, update) => recordFields([
        recordChoices(
          'حساب الاستلام',
          accountId,
          _accountChoices(data.accounts),
          (value) => update(() => accountId = value),
        ),
        recordNumberField(
          accountId == null
              ? 'المبلغ الفعلي'
              : 'المبلغ الفعلي · ${_account(data, accountId!).currency}',
          amount,
          (value) => amount = value,
        ),
        recordDateButton(
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
      (context, update) => recordFields([
        if (old?.receivedDay != null && !markUsed)
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('إلغاء تأكيد استلام خاطئ'),
            value: clear,
            onChanged: (value) => update(() => clear = value),
          ),
        if (!clear) ...[
          recordDateButton(
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
            recordDateButton(
              context,
              'تاريخ الاستخدام',
              used!,
              (value) => update(() => used = value),
              first: received,
              last: last,
            ),
          recordChoices('ربط بإجازة (اختياري)', leaveId ?? 0, [
            const DropdownMenuItem(value: 0, child: Text('بدون ارتباط')),
            for (final leave in data.leaves)
              if (leave.status != LeaveStatus.cancelled || leave.id == leaveId)
                DropdownMenuItem(
                  value: leave.id,
                  child: Text(
                    '${recordDayLabel(context, leave.startDay)} ${latinDigits(leave.occasion)}',
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
      (context, update) => recordFields([
        recordChoices('العملة', code, [
          for (final currency in data.currencies)
            DropdownMenuItem(value: currency.code, child: Text(currency.code)),
        ], (value) => update(() => code = value)),
        recordDateButton(
          context,
          'موعد الهدف',
          date,
          (value) => update(() => date = value),
        ),
        recordNumberField('المبلغ المستهدف', base, (value) => base = value),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('تضمين تذكرة على نفقتي'),
          value: personalAirfare,
          onChanged: (value) => update(() => personalAirfare = value),
        ),
        if (personalAirfare)
          recordNumberField(
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
      (context, update) => recordFields([
        const Text('خصص مبلغًا من الرصيد المسجّل في أحد حساباتك.'),
        recordChoices(
          'الحساب',
          id,
          _accountChoices(choices),
          (value) => update(() => id = value),
        ),
        recordDateButton(
          context,
          'تاريخ المساهمة',
          date,
          (value) => update(() => date = value),
          last: _today(),
        ),
        recordNumberField('المبلغ · $code', amount, (value) => amount = value),
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
