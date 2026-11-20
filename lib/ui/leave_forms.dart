part of 'leave_screen.dart';

int? _number(String text) => int.tryParse(latinDigits(text.trim()));

DropdownButtonFormField<T> _select<T>(
  String label,
  T selected,
  Iterable<T> options,
  String Function(T) name,
  ValueChanged<T> onChanged,
) => DropdownButtonFormField<T>(
  isExpanded: true,
  initialValue: selected,
  decoration: InputDecoration(labelText: label),
  items: [
    for (final option in options)
      DropdownMenuItem(value: option, child: Text(name(option))),
  ],
  onChanged: (value) {
    if (value != null) onChanged(value);
  },
);

Widget _dayButton(
  BuildContext context,
  String label,
  int day,
  ValueChanged<int> onChanged, {
  int? minimum,
  int? maximum,
}) => OutlinedButton(
  onPressed: () async {
    final picked = await showAppDatePicker(
      context: context,
      initialDate: dateOfLeaveDay(day),
      firstDate: minimum == null ? firstLeaveDate : dateOfLeaveDay(minimum),
      lastDate: maximum == null ? lastLeaveDate : dateOfLeaveDay(maximum),
    );
    if (context.mounted && picked != null) onChanged(leaveDay(picked));
  },
  child: Text('$label ${_date(context, day)}'),
);

class _LeaveForm extends StatefulWidget {
  const _LeaveForm({
    required this.title,
    required this.save,
    this.fields,
    this.action = 'حفظ',
  });
  final String title;
  final String action;
  final Future<void> Function() save;
  final List<Widget> Function(BuildContext, StateSetter)? fields;

  @override
  State<_LeaveForm> createState() => _LeaveFormState();
}

class _LeaveFormState extends State<_LeaveForm> {
  bool _saving = false;
  String? _error;

  Future<void> _submit() async {
    if (_saving) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await widget.save();
      if (mounted) Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = error is LeaveException
            ? _message(error.issue)
            : 'تعذّر الحفظ. أعد المحاولة.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final fields = widget.fields?.call(context, setState) ?? [];
    return PopScope(
      canPop: !_saving,
      child: AlertDialog(
        scrollable: true,
        title: Text(widget.title),
        content: fields.isEmpty && _error == null
            ? null
            : IgnorePointer(
                ignoring: _saving,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final field in fields)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: field,
                      ),
                    if (_error != null)
                      Text(
                        _error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                  ],
                ),
              ),
        actions: [
          TextButton(
            onPressed: _saving ? null : () => Navigator.of(context).pop(),
            child: const Text('رجوع'),
          ),
          FilledButton(
            onPressed: _saving ? null : _submit,
            child: Text(_saving ? 'جارٍ الحفظ…' : widget.action),
          ),
        ],
      ),
    );
  }
}

typedef _PlannedLeave = ({LeavePeriod period, LeaveKind kind, String occasion});

class _LeavePlanner extends StatefulWidget {
  const _LeavePlanner({required this.data, required this.year});

  final LeaveOverview data;
  final int year;

  @override
  State<_LeavePlanner> createState() => _LeavePlannerState();
}

class _LeavePlannerState extends State<_LeavePlanner> {
  LeavePlanningMode _mode = LeavePlanningMode.exact;
  LeaveKind _type = LeaveKind.annual;
  late int _first = _yearDay(widget.year);
  late int _last = _first + 30 <= leaveDay(lastLeaveDate)
      ? _first + 30
      : leaveDay(lastLeaveDate);
  int? _days = 1;
  String _occasion = '';
  String? _error;
  List<LeavePeriod>? _suggestions;

  void _edit(VoidCallback edit) => setState(() {
    edit();
    _suggestions = null;
    _error = null;
  });

  void _afterThreeMonths() {
    final today = DateTime.now();
    final lastDay = DateTime.utc(today.year, today.month + 4, 0).day;
    final date = DateTime.utc(
      today.year,
      today.month + 3,
      today.day <= lastDay ? today.day : lastDay,
    );
    final limit = leaveDay(lastLeaveDate);
    _edit(() {
      final start = leaveDay(date);
      _first = start <= limit ? start : limit;
      _last = _first + 30 <= limit ? _first + 30 : limit;
    });
  }

  void _search() => setState(() {
    try {
      _suggestions = widget.data.suggest(
        kind: _type,
        mode: _mode,
        firstDay: _first,
        lastDay: _mode == LeavePlanningMode.window ? _last : _first,
        days: _days ?? 0,
      );
      _error = null;
    } on LeaveException catch (error) {
      _error = _message(error.issue);
      _suggestions = null;
    }
  });

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('تخطيط إجازة'),
    scrollable: true,
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _select(
          'طريقة التخطيط',
          _mode,
          LeavePlanningMode.values,
          (mode) => switch (mode) {
            LeavePlanningMode.exact => 'تاريخ محدد',
            LeavePlanningMode.window => 'فترة مستقبلية',
            LeavePlanningMode.occasion => 'مناسبة',
          },
          (value) => _edit(() => _mode = value),
        ),
        _select(
          'نوع الإجازة',
          _type,
          LeaveKind.values,
          _kind,
          (value) => _edit(() => _type = value),
        ),
        TextFormField(
          initialValue: '1',
          decoration: const InputDecoration(labelText: 'عدد الأيام التقويمية'),
          keyboardType: TextInputType.number,
          inputFormatters: numberInputFormatters,
          textDirection: TextDirection.ltr,
          onChanged: (value) => _edit(() => _days = _number(value)),
        ),
        if (_mode == LeavePlanningMode.occasion)
          TextFormField(
            maxLength: 120,
            decoration: const InputDecoration(
              labelText: 'اسم المناسبة (اختياري)',
            ),
            onChanged: (value) => _occasion = value,
          ),
        _dayButton(
          context,
          _mode == LeavePlanningMode.occasion ? 'تاريخ المناسبة' : 'البداية',
          _first,
          (value) => _edit(() {
            _first = value;
            if (_last < _first) _last = _first;
          }),
        ),
        if (_mode == LeavePlanningMode.window) ...[
          _dayButton(
            context,
            'النهاية',
            _last,
            (value) => _edit(() => _last = value),
          ),
          TextButton(
            onPressed: _afterThreeMonths,
            child: const Text('فترة بعد ثلاثة أشهر'),
          ),
        ],
        if (_error != null)
          Text(
            _error!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        if (_suggestions?.isEmpty == true)
          const Text('لا توجد فترة مناسبة ضمن الرصيد والتواريخ المحددة.'),
        for (final period in _suggestions ?? const <LeavePeriod>[])
          ListTile(
            title: Text(
              '${_date(context, period.startDay)} – ${_date(context, period.endDay)}',
            ),
            subtitle: Text(
              'يُخصم ${period.days} يوم من رصيد ${period.chargeYear}\n'
              'راحة متصلة ${widget.data.calendar.continuousBreak(period).days} يوم\n'
              'المباشرة ${_date(context, widget.data.calendar.returnDay(period))}',
            ),
            trailing: const Icon(Icons.add),
            onTap: () {
              final _PlannedLeave plan = (
                period: period,
                kind: _type,
                occasion: _mode == LeavePlanningMode.occasion
                    ? _occasion.trim()
                    : '',
              );
              Navigator.of(context).pop(plan);
            },
          ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('رجوع'),
      ),
      FilledButton(onPressed: _search, child: const Text('عرض الاقتراحات')),
    ],
  );
}
