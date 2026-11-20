import 'package:material_ui/material_ui.dart';

import '../finance/model.dart';
import '../leave/model.dart';
import 'date_picker.dart';
import 'digits.dart';

String recordDayLabel(BuildContext context, int day) =>
    MaterialLocalizations.of(context).formatCompactDate(dateOfLeaveDay(day));

class RecordEditor extends StatefulWidget {
  const RecordEditor({
    required this.title,
    required this.body,
    required this.save,
    required this.action,
    this.customError,
    super.key,
  });
  final String title;
  final Widget Function(BuildContext, StateSetter) body;
  final Future<void> Function() save;
  final String action;
  final String? Function(Object)? customError;

  @override
  State<RecordEditor> createState() => RecordEditorState();
}

class RecordEditorState extends State<RecordEditor> {
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
    } catch (error) {
      if (mounted) {
        setState(
          () => _error = widget.customError?.call(error) ?? 'تعذّر حفظ السجل.',
        );
      }
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

Widget recordFields(List<Widget> children) => Column(
  mainAxisSize: MainAxisSize.min,
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    for (final field in children)
      Padding(padding: const EdgeInsets.only(bottom: 10), child: field),
  ],
);

Widget recordNumberField(
  String title,
  String value,
  ValueChanged<String> change,
) => TextFormField(
  initialValue: value,
  decoration: InputDecoration(labelText: title),
  keyboardType: const TextInputType.numberWithOptions(decimal: true),
  inputFormatters: amountInputFormatters,
  textDirection: TextDirection.ltr,
  onChanged: change,
);

Widget recordChoices<T>(
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

Widget recordDateButton(
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
  child: Text('$label ${recordDayLabel(context, date)}'),
);
