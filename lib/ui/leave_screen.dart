import 'package:material_ui/material_ui.dart';

import '../data/database.dart';
import '../leave/leave_book.dart';
import '../leave/model.dart';

part 'leave_forms.dart';

String _kind(LeaveKind kind) => switch (kind) {
  LeaveKind.annual => 'سنوية',
  LeaveKind.casual => 'عارضة',
  LeaveKind.sick => 'مرضية',
};

String _status(LeaveStatus status) => switch (status) {
  LeaveStatus.requested => 'مطلوبة',
  LeaveStatus.approved => 'معتمدة',
  LeaveStatus.used => 'مستخدمة',
  LeaveStatus.cancelled => 'ملغاة',
};

String _report(MedicalReport report) => switch (report) {
  MedicalReport.unspecified => 'غير محدد',
  MedicalReport.pending => 'قيد الانتظار',
  MedicalReport.recorded => 'التقرير موجود',
};

String _message(LeaveIssue issue) => switch (issue) {
  LeaveIssue.dates => 'تحقق من التواريخ وعدد الأيام.',
  LeaveIssue.balance => 'الرصيد المتبقي لا يكفي لهذا التغيير.',
  LeaveIssue.overlap => 'الفترة تتداخل مع إجازة معتمدة أو مستخدمة.',
  LeaveIssue.duplicate => 'هذه الإجازة مسجّلة بالفعل للنوع والفترة نفسيهما.',
  LeaveIssue.used =>
    'الأيام المستخدمة تظل مخصومة. يمكن تعديل بيانات السجل فقط.',
  LeaveIssue.missing => 'لم يعد هذا السجل متاحًا للتعديل.',
  LeaveIssue.holiday => 'أدخل اسمًا للعطلة واختر تاريخًا غير مسجّل.',
  LeaveIssue.policy => 'اختر سنة مستقبلية غير مسجّلة وأرصدة من 0 إلى 366.',
};

String _date(BuildContext context, int day) =>
    MaterialLocalizations.of(context).formatCompactDate(dateOfLeaveDay(day));

int _yearDay(int year) =>
    leaveDay(year == DateTime.now().year ? DateTime.now() : DateTime.utc(year));

class LeaveScreen extends StatefulWidget {
  const LeaveScreen({required this.book, super.key});
  final LeaveBook book;

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  late Future<LeaveOverview> _overview = widget.book.overview();
  int _year = DateTime.now().year;

  void _refresh([int? year]) => setState(() {
    if (year != null) _year = year;
    _overview = widget.book.overview();
  });

  Future<void> _editEntry(
    LeaveOverview data, {
    LeaveEntry? entry,
    _PlannedLeave? plan,
  }) async {
    var start = entry?.startDay ?? plan?.period.startDay ?? _yearDay(_year);
    var end = entry?.endDay ?? plan?.period.endDay ?? start;
    var kind = entry?.kind ?? plan?.kind ?? LeaveKind.annual;
    var status = entry?.status ?? LeaveStatus.requested;
    var report = entry?.medicalReport ?? MedicalReport.unspecified;
    var label = entry?.occasion ?? plan?.occasion ?? '';
    final used = entry?.status == LeaveStatus.used;
    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _LeaveForm(
        title: entry == null
            ? 'إضافة إجازة'
            : used
            ? 'تعديل بيانات الإجازة'
            : 'تعديل الإجازة',
        fields: (context, update) {
          final period = LeavePeriod(start, end);
          return [
            if (used)
              Text(
                '${_kind(kind)} · مستخدمة\n'
                'من ${_date(context, start)} إلى ${_date(context, end)}',
              )
            else ...[
              _select(
                'نوع الإجازة',
                kind,
                LeaveKind.values,
                _kind,
                (value) => update(() => kind = value),
              ),
              _select(
                'الحالة',
                status,
                const [
                  LeaveStatus.requested,
                  LeaveStatus.approved,
                  LeaveStatus.used,
                ],
                _status,
                (value) => update(() => status = value),
              ),
              _dayButton(
                context,
                'البداية',
                start,
                (value) => update(() {
                  start = value;
                  if (end < start) end = start;
                }),
              ),
              _dayButton(
                context,
                'النهاية',
                end,
                (value) => update(() => end = value),
              ),
            ],
            if (period.days > 0)
              Text(
                '${period.days} يوم · رصيد ${period.chargeYear}\n'
                'المباشرة ${_date(context, data.calendar.returnDay(period))}',
              ),
            TextFormField(
              initialValue: label,
              maxLength: 120,
              decoration: const InputDecoration(
                labelText: 'المناسبة (اختياري)',
              ),
              onChanged: (value) => label = value,
            ),
            if (kind == LeaveKind.sick)
              _select(
                'حالة التقرير الطبي',
                report,
                MedicalReport.values,
                _report,
                (value) => update(() => report = value),
              ),
          ];
        },
        save: () => widget.book.save(
          id: entry?.id,
          kind: kind,
          status: status,
          period: LeavePeriod(start, end),
          occasion: label,
          medicalReport: report,
        ),
      ),
    );
    if (mounted && saved == true) _refresh(dateOfLeaveDay(start).year);
  }

  Future<void> _cancelEntry(LeaveEntry entry) async {
    int? usedThrough;
    final canCancelRemainder =
        entry.status == LeaveStatus.approved && entry.startDay < entry.endDay;
    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _LeaveForm(
        title: 'إلغاء الإجازة',
        action: 'تأكيد الإلغاء',
        fields: (context, update) => [
          if (canCancelRemainder)
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('استخدمت جزءًا من الإجازة'),
              value: usedThrough != null,
              onChanged: (value) =>
                  update(() => usedThrough = value ? entry.startDay : null),
            ),
          if (usedThrough != null) ...[
            _dayButton(
              context,
              'آخر يوم مستخدم',
              usedThrough!,
              (day) => update(() => usedThrough = day),
              minimum: entry.startDay,
              maximum: entry.endDay - 1,
            ),
            Text(
              'يبقى ${usedThrough! - entry.startDay + 1} يوم مخصومًا، '
              'ويعود ${entry.endDay - usedThrough!} يوم إلى الرصيد.',
            ),
          ] else if (entry.status == LeaveStatus.approved)
            const Text(
              'أكّد الإلغاء الكامل فقط إذا لم تستخدم أي يوم من هذه الإجازة.',
            ),
        ],
        save: () => widget.book.cancel(entry.id, usedThrough: usedThrough),
      ),
    );
    if (mounted && saved == true) _refresh();
  }

  Future<void> _editHoliday({LeaveHoliday? holiday}) async {
    var day = holiday?.day ?? _yearDay(_year);
    var name = holiday?.name ?? '';
    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _LeaveForm(
        title: holiday == null ? 'إضافة عطلة رسمية' : 'تعديل العطلة',
        fields: (context, update) => [
          TextFormField(
            initialValue: name,
            maxLength: 120,
            decoration: const InputDecoration(labelText: 'اسم العطلة'),
            onChanged: (value) => name = value,
          ),
          _dayButton(
            context,
            'تاريخ العطلة',
            day,
            (value) => update(() => day = value),
          ),
        ],
        save: () =>
            widget.book.saveHoliday(oldDay: holiday?.day, day: day, name: name),
      ),
    );
    if (mounted && saved == true) _refresh(dateOfLeaveDay(day).year);
  }

  Future<void> _confirm(String title, Future<void> Function() action) async {
    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _LeaveForm(title: title, action: 'تأكيد', save: action),
    );
    if (mounted && saved == true) _refresh();
  }

  Future<void> _addRule(LeaveOverview data) async {
    final year = DateTime.now().year + 1;
    if (year > lastLeaveDate.year) return;
    final current = data.ruleFor(year);
    int? effectiveYear = year;
    int? annual = current.annualDays;
    int? casual = current.casualDays;
    int? sick = current.sickDays;
    Widget input(String label, int value, ValueChanged<int?> change) =>
        TextFormField(
          initialValue: '$value',
          decoration: InputDecoration(labelText: label),
          keyboardType: TextInputType.number,
          onChanged: (text) => change(_number(text)),
        );
    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _LeaveForm(
        title: 'رصيد لسنة مستقبلية',
        fields: (_, _) => [
          const Text(
            'يسري الإعداد من 1 يناير وتبقى إعدادات السنوات السابقة محفوظة.',
          ),
          input('سنة السريان', year, (value) => effectiveYear = value),
          input('السنوية', current.annualDays, (value) => annual = value),
          input('العارضة', current.casualDays, (value) => casual = value),
          input('المرضية', current.sickDays, (value) => sick = value),
        ],
        save: () async {
          if ([effectiveYear, annual, casual, sick].contains(null)) {
            throw const LeaveException(LeaveIssue.policy);
          }
          await widget.book.addRule(
            year: effectiveYear!,
            annual: annual!,
            casual: casual!,
            sick: sick!,
          );
        },
      ),
    );
    if (mounted && saved == true) _refresh(effectiveYear);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('الإجازات')),
    body: SafeArea(
      child: FutureBuilder(
        future: _overview,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: TextButton(
                onPressed: _refresh,
                child: const Text('تعذّر التحميل. أعد المحاولة'),
              ),
            );
          }
          final data = snapshot.data;
          if (data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return _body(data);
        },
      ),
    ),
  );

  Widget _body(LeaveOverview data) {
    final entries = data.entries.where(
      (entry) => entryPeriod(entry).chargeYear == _year,
    );
    final holidays = data.holidays.where(
      (holiday) => dateOfLeaveDay(holiday.day).year == _year,
    );
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              tooltip: 'السنة السابقة',
              onPressed: _year > firstLeaveDate.year
                  ? () => setState(() => _year--)
                  : null,
              icon: const Icon(Icons.chevron_right),
            ),
            Text('أرصدة $_year', style: Theme.of(context).textTheme.titleLarge),
            IconButton(
              tooltip: 'السنة التالية',
              onPressed: _year < lastLeaveDate.year
                  ? () => setState(() => _year++)
                  : null,
              icon: const Icon(Icons.chevron_left),
            ),
          ],
        ),
        for (final kind in LeaveKind.values)
          _balanceTile(kind, data.balance(_year, kind)),
        const Text(
          'المطلوبة لا تخصم من الرصيد، والمعتمدة تحجزه، والمستخدمة تُخصم منه. أرصدة العارضة والمرضية مؤقتة حتى تحديد التجديد والترحيل.',
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton(
              onPressed: () => _editEntry(data),
              child: const Text('إضافة إجازة'),
            ),
            OutlinedButton(
              onPressed: () async {
                final plan = await showDialog<_PlannedLeave>(
                  context: context,
                  builder: (_) => _LeavePlanner(data: data, year: _year),
                );
                if (mounted && plan != null) await _editEntry(data, plan: plan);
              },
              child: const Text('تخطيط إجازة'),
            ),
          ],
        ),
        const Divider(),
        Text('السجل', style: Theme.of(context).textTheme.titleLarge),
        if (entries.isEmpty)
          const ListTile(title: Text('لا توجد إجازات لهذه السنة.')),
        for (final entry in entries) _entryTile(data, entry),
        ExpansionTile(
          title: const Text('تقويم العطلات الرسمية'),
          subtitle: Text(
            'الجمعة والسبت راحة أسبوعية · ${holidays.length} عطلة مسجّلة',
          ),
          children: [
            TextButton.icon(
              onPressed: () => _editHoliday(),
              icon: const Icon(Icons.add),
              label: const Text('إضافة عطلة'),
            ),
            if (holidays.isEmpty)
              const ListTile(title: Text('لا توجد عطلات مسجّلة لهذه السنة.')),
            for (final holiday in holidays)
              ListTile(
                title: Text(holiday.name),
                subtitle: Text(_date(context, holiday.day)),
                onTap: () => _editHoliday(holiday: holiday),
                trailing: IconButton(
                  tooltip: 'حذف العطلة',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _confirm(
                    'حذف ${holiday.name}؟',
                    () => widget.book.deleteHoliday(holiday.day),
                  ),
                ),
              ),
          ],
        ),
        ExpansionTile(
          title: const Text('قواعد الأرصدة وتواريخ السريان'),
          children: [
            for (final rule in data.rules)
              ListTile(
                title: Text(
                  rule == data.rules.first
                      ? 'الإعداد الأساسي'
                      : 'يسري من ${_date(context, rule.effectiveDay)}',
                ),
                subtitle: Text(
                  'سنوية ${rule.annualDays} · عارضة ${rule.casualDays} · مرضية ${rule.sickDays}',
                ),
              ),
            TextButton(
              onPressed: () => _addRule(data),
              child: const Text('إضافة إعداد مستقبلي'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _balanceTile(LeaveKind kind, LeaveBalance balance) => ListTile(
    title: Text(_kind(kind)),
    subtitle: Text(
      'الاستحقاق ${balance.entitlement} · مستخدم ${balance.used} · محجوز ${balance.reserved}',
    ),
    trailing: Text('المتبقي ${balance.remaining}'),
  );

  Widget _entryTile(LeaveOverview data, LeaveEntry entry) {
    final period = entryPeriod(entry);
    final start = _date(context, period.startDay);
    final end = _date(context, period.endDay);
    final cancelled = entry.status == LeaveStatus.cancelled;
    final used = entry.status == LeaveStatus.used;
    return ListTile(
      title: Text(
        '${_kind(entry.kind)} · ${_status(entry.status)}'
        '${entry.occasion.isEmpty ? '' : ' · ${entry.occasion}'}',
      ),
      subtitle: Text(
        '$start – $end · ${period.days} يوم'
        '${cancelled ? '' : '\nالمباشرة ${_date(context, data.calendar.returnDay(period))}'}'
        '${entry.kind == LeaveKind.sick ? '\nالتقرير الطبي: ${_report(entry.medicalReport)}' : ''}',
      ),
      onTap: cancelled ? null : () => _editEntry(data, entry: entry),
      trailing: cancelled
          ? null
          : used
          ? IconButton(
              tooltip: 'تعديل بيانات الإجازة',
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => _editEntry(data, entry: entry),
            )
          : PopupMenuButton<bool>(
              tooltip: 'خيارات الإجازة',
              onSelected: (edit) {
                if (edit) {
                  _editEntry(data, entry: entry);
                } else {
                  _cancelEntry(entry);
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: true, child: Text('تعديل')),
                PopupMenuItem(value: false, child: Text('إلغاء الإجازة')),
              ],
            ),
    );
  }
}
