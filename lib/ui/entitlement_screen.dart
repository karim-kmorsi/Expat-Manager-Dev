import 'dart:math';

import 'package:material_ui/material_ui.dart';

import '../data/database.dart';
import '../finance/ledger.dart';
import '../finance/model.dart';
import '../leave/model.dart';
import 'amount.dart';
import 'digits.dart';
import 'record_editor.dart';

part 'entitlement_forms.dart';

typedef _Benefits = ({
  DashainView? bonus,
  AnnualTicket? ticket,
  TravelView? travel,
  List<Currency> currencies,
  List<LedgerAccount> accounts,
  List<LeaveEntry> leaves,
});

int _today() => leaveDay(DateTime.now());

class EntitlementScreen extends StatefulWidget {
  const EntitlementScreen({required this.ledger, super.key});
  final Ledger ledger;

  @override
  State<EntitlementScreen> createState() => _EntitlementScreenState();
}

class _EntitlementScreenState extends State<EntitlementScreen> {
  Ledger get ledger => widget.ledger;
  int _year = DateTime.now().year;
  late Future<_Benefits> _data = _load();

  Future<_Benefits> _load() {
    final year = _year;
    return _read(year);
  }

  Future<_Benefits> _read(int year) async => (
    bonus: await ledger.dashain(year),
    ticket: await ledger.ticket(year),
    travel: await ledger.travelSavings(),
    currencies: await ledger.currencies(),
    accounts: await ledger.accounts(),
    leaves: (await ledger.personalLeave.overview()).entries,
  );

  void _refresh([int? year]) => setState(() {
    if (year != null) _year = year;
    _data = _load();
  });

  Future<void> _edit(
    String title,
    Widget Function(BuildContext, StateSetter) body,
    Future<void> Function() save, {
    String action = 'حفظ',
  }) async {
    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          RecordEditor(title: title, body: body, save: save, action: action),
    );
    if (mounted && saved == true) _refresh();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('الاستحقاقات والادخار')),
    body: SafeArea(
      child: FutureBuilder(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: TextButton(
                onPressed: _refresh,
                child: const Text('تعذّر التحميل. أعد المحاولة.'),
              ),
            );
          }
          final data = snapshot.data;
          if (data == null ||
              snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    tooltip: 'السنة السابقة',
                    icon: const Icon(Icons.chevron_right),
                    onPressed: _year > firstLeaveDate.year
                        ? () => _refresh(_year - 1)
                        : null,
                  ),
                  Expanded(
                    child: Text(
                      'استحقاقات $_year',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    tooltip: 'السنة التالية',
                    icon: const Icon(Icons.chevron_left),
                    onPressed: _year < lastLeaveDate.year
                        ? () => _refresh(_year + 1)
                        : null,
                  ),
                ],
              ),
              _bonus(data),
              _ticket(data),
              _savings(data),
            ],
          );
        },
      ),
    ),
  );

  Widget _bonus(_Benefits data) {
    final view = data.bonus;
    final receipt = view?.receipt;
    final status = receipt != null
        ? 'تم الاستلام'
        : view == null
        ? 'بيانات الاستحقاق غير مكتملة'
        : view.expectedDay <= _today()
        ? 'حلّ الموعد المتوقع'
        : 'بانتظار الموعد المتوقع';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'مكافأة الدساي',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(status),
            if (view != null) ...[
              Text(
                'المتوقع ${_money(data, view.expectedMinor, view.plan.currency)}',
              ),
              Text(
                'موعد الصرف المتوقع ${recordDayLabel(context, view.expectedDay)}',
              ),
            ],
            if (receipt != null) ...[
              Text('الاستلام ${recordDayLabel(context, receipt.day)}'),
              Text(
                _money(
                  data,
                  receipt.minor,
                  _account(data, receipt.accountId).currency,
                ),
              ),
            ],
            if (view != null && receipt == null && data.accounts.isEmpty)
              const Text('أضف حساب استلام من شاشة الحسابات لتأكيد المكافأة.'),
            Wrap(
              spacing: 8,
              children: [
                TextButton(
                  onPressed: () => _editBonusPlan(data),
                  child: const Text('تاريخ الدساي والراتب'),
                ),
                if (view != null && data.accounts.isNotEmpty)
                  FilledButton(
                    onPressed: () => _editBonusReceipt(data, view),
                    child: Text(
                      receipt == null ? 'تأكيد الاستلام' : 'تصحيح الاستلام',
                    ),
                  ),
                if (receipt != null)
                  TextButton(
                    onPressed: () => _reverseBonus(view!),
                    child: const Text('التراجع عن التأكيد'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _ticket(_Benefits data) {
    final ticket = data.ticket;
    final status = ticketStatus(ticket, _year, DateTime.now());
    final received = ticket?.receivedDay;
    final used = ticket?.usedDay;
    final linked = data.leaves
        .where((entry) => entry.id == ticket?.leaveId)
        .firstOrNull;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('تذكرة السفر', style: Theme.of(context).textTheme.titleMedium),
            Text(switch (status) {
              TicketStatus.upcoming => 'لم تبدأ دورة الاستحقاق',
              TicketStatus.due => 'مستحقة',
              TicketStatus.received => 'تم استلامها',
              TicketStatus.used => 'تم استخدامها',
              TicketStatus.expired => 'انتهى الاستحقاق',
            }),
            const Text('رحلة ذهاب وعودة واحدة في السنة، على نفقة جهة العمل.'),
            if (received != null)
              Text('الاستلام ${recordDayLabel(context, received)}'),
            if (used != null)
              Text('الاستخدام ${recordDayLabel(context, used)}'),
            if (linked != null)
              Text('الإجازة ${recordDayLabel(context, linked.startDay)}'),
            Wrap(
              spacing: 8,
              children: [
                if (_year <= DateTime.now().year)
                  FilledButton(
                    onPressed: () => _editTicket(data, false),
                    child: Text(
                      received == null
                          ? 'تأكيد استلام التذكرة'
                          : 'تصحيح بيانات التذكرة',
                    ),
                  ),
                if (received != null && used == null)
                  TextButton(
                    onPressed: () => _editTicket(data, true),
                    child: const Text('تسجيل الاستخدام'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _savings(_Benefits data) {
    final view = data.travel;
    final progress = view?.progress;
    final code = view?.goal.currency;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ادخار الإجازة',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (view == null) const Text('حدّد هدف الادخار وموعده.'),
            if (view != null && progress != null && code != null) ...[
              Text(
                'الهدف ${_money(data, progress.target, code)} · ${recordDayLabel(context, view.goal.targetDay)}',
              ),
              Text('المتاح من الادخار ${_money(data, progress.saved, code)}'),
              Text('المتبقي ${_money(data, progress.remaining, code)}'),
              Text(
                progress.monthly == null
                    ? 'انقضى الموعد المحدد'
                    : 'الاقتراح الشهري ${_money(data, progress.monthly!, code)}',
              ),
              if (progress.pledged > progress.saved)
                const Text(
                  'انخفض رصيد بعض الحسابات. يُحتسب من المساهمات ما يغطيه الرصيد الحالي.',
                ),
              if (view.contributions.isNotEmpty)
                ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: const Text('المساهمات المسجّلة'),
                  children: [
                    for (final item in view.contributions)
                      ListTile(
                        title: Text(
                          latinDigits(_account(data, item.accountId).name),
                        ),
                        onTap: () => _editContribution(data, code, old: item),
                        subtitle: Text(recordDayLabel(context, item.day)),
                        trailing: Text(_money(data, item.minor, code)),
                      ),
                  ],
                ),
            ],
            Wrap(
              spacing: 8,
              children: [
                TextButton(
                  onPressed: () => _editGoal(data),
                  child: Text(view == null ? 'تحديد الهدف' : 'تعديل الهدف'),
                ),
                if (code != null &&
                    data.accounts.any((account) => account.currency == code))
                  FilledButton(
                    onPressed: () => _editContribution(data, code),
                    child: const Text('تسجيل مساهمة'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  LedgerAccount _account(_Benefits data, int id) =>
      data.accounts.firstWhere((account) => account.id == id);

  int _scale(_Benefits data, String code) =>
      data.currencies.firstWhere((currency) => currency.code == code).scale;

  String _money(_Benefits data, int minor, String currency) =>
      '${formatMinor(minor, _scale(data, currency))} $currency';

  int _amount(_Benefits data, String text, String code) {
    final result = parseMinor(text, _scale(data, code));
    if (result == null) throw const LedgerException(LedgerIssue.invalidInput);
    return result;
  }
}
