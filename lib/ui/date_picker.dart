import 'package:material_ui/material_ui.dart';

import 'digits.dart';

Future<DateTime?> showAppDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) => showDialog<DateTime>(
  context: context,
  builder: (_) => _AppDatePicker(
    initialDate: DateUtils.dateOnly(initialDate),
    firstDate: DateUtils.dateOnly(firstDate),
    lastDate: DateUtils.dateOnly(lastDate),
  ),
);

class _AppDatePicker extends StatefulWidget {
  const _AppDatePicker({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  @override
  State<_AppDatePicker> createState() => _AppDatePickerState();
}

class _AppDatePickerState extends State<_AppDatePicker> {
  final _form = GlobalKey<FormState>();
  final _input = TextEditingController();
  late DateTime _selected = widget.initialDate;
  bool _manual = false;

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  DateTime? _readInput() => _form.currentState!.validate()
      ? MaterialLocalizations.of(context).parseCompactDate(_input.text)
      : null;

  void _submit() {
    final date = _manual ? _readInput() : _selected;
    if (date != null) Navigator.of(context).pop(date);
  }

  @override
  Widget build(BuildContext context) {
    final strings = MaterialLocalizations.of(context);
    final switchModeLabel = _manual
        ? strings.calendarModeButtonLabel
        : strings.inputDateModeButtonLabel;
    return AlertDialog(
      scrollable: true,
      title: Text(strings.datePickerHelpText),
      contentPadding: const EdgeInsetsDirectional.fromSTEB(12, 8, 12, 0),
      content: SizedBox(
        width: 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: Text(strings.formatFullDate(_selected))),
                IconButton(
                  tooltip: switchModeLabel,
                  icon: Icon(
                    _manual ? Icons.calendar_today : Icons.edit_outlined,
                  ),
                  onPressed: () => setState(() {
                    if (_manual) {
                      _selected = _readInput() ?? _selected;
                    } else {
                      _input.text = strings.formatCompactDate(_selected);
                    }
                    _manual = !_manual;
                  }),
                ),
              ],
            ),
            if (_manual)
              Form(
                key: _form,
                child: TextFormField(
                  controller: _input,
                  keyboardType: TextInputType.datetime,
                  inputFormatters: numberInputFormatters,
                  textDirection: TextDirection.ltr,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: strings.dateInputLabel,
                    hintText: strings.dateHelpText,
                  ),
                  onFieldSubmitted: (_) => _submit(),
                  validator: (value) {
                    final date = strings.parseCompactDate(value);
                    if (date == null) return strings.invalidDateFormatLabel;
                    if (date.isBefore(widget.firstDate) ||
                        date.isAfter(widget.lastDate)) {
                      return strings.dateOutOfRangeLabel;
                    }
                    return null;
                  },
                ),
              )
            else
              SizedBox(
                height: 330,
                child: CalendarDatePicker(
                  initialDate: _selected,
                  firstDate: widget.firstDate,
                  lastDate: widget.lastDate,
                  onDateChanged: (date) => setState(() => _selected = date),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(strings.cancelButtonLabel),
        ),
        FilledButton(onPressed: _submit, child: Text(strings.okButtonLabel)),
      ],
    );
  }
}
