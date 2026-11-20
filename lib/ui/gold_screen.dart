import 'dart:convert';
import 'dart:math';

import 'package:material_ui/material_ui.dart';

import '../data/database.dart';
import '../finance/ledger.dart';
import '../finance/model.dart';
import '../leave/model.dart';
import 'amount.dart';
import 'digits.dart';
import 'record_editor.dart';

part 'gold_forms.dart';

String _goldKind(GoldKind kind) => switch (kind) {
  GoldKind.bar => 'سبيكة',
  GoldKind.coin => 'جنيه ذهب',
  GoldKind.jewelry => 'مشغولات',
  GoldKind.other => 'أخرى',
};

String _trimDecimal(String text) => text.replaceFirst(RegExp(r'\.?0+$'), '');
String _weight(BigInt mg) => '${_trimDecimal(formatUnits(mg, 3))} جرام';
String _karat(int value) => _trimDecimal(formatMinor(value, 2));

typedef _GoldData = ({
  List<GoldItem> items,
  List<LedgerAccount> accounts,
  Map<String, int> scales,
});

class GoldScreen extends StatefulWidget {
  const GoldScreen({required this.ledger, super.key});
  final Ledger ledger;

  @override
  State<GoldScreen> createState() => _GoldScreenState();
}

class _GoldScreenState extends State<GoldScreen> {
  late Future<_GoldData> _data = _load();
  String? _owner;
  String? _holder;
  int? _purity;

  Future<_GoldData> _load() async => (
    items: await widget.ledger.goldInventory(),
    accounts: await widget.ledger.accounts(),
    scales: {
      for (final currency in await widget.ledger.currencies())
        currency.code: currency.scale,
    },
  );

  void _refresh() {
    final next = _load();
    setState(() {
      _data = next;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('الذهب الفعلي في مصر')),
    body: SafeArea(
      child: FutureBuilder(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: TextButton(
                onPressed: _refresh,
                child: const Text('تعذّر تحميل السجل. أعد المحاولة.'),
              ),
            );
          }
          final data = snapshot.data;
          if (data == null ||
              snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final owners =
              data.items.map((row) => row.piece.owner).toSet().toList()..sort();
          final holders =
              data.items.map((row) => row.piece.custodian).toSet().toList()
                ..sort();
          final purities =
              data.items
                  .map((row) => row.piece.karatHundredths)
                  .toSet()
                  .toList()
                ..sort();
          final owner = owners.contains(_owner) ? _owner : null;
          final holder = holders.contains(_holder) ? _holder : null;
          final purity = purities.contains(_purity) ? _purity : null;
          final filtered = data.items
              .where(
                (row) =>
                    (owner == null || row.piece.owner == owner) &&
                    (holder == null || row.piece.custodian == holder) &&
                    (purity == null || row.piece.karatHundredths == purity),
              )
              .toList();
          final weights = goldWeightByKarat(filtered);
          final total = weights.values.fold(BigInt.zero, (a, b) => a + b);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'وزن القطع الموجودة ${_weight(total)}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (weights.isNotEmpty)
                Wrap(
                  spacing: 8,
                  children: [
                    for (final key in weights.keys.toList()..sort())
                      Chip(
                        label: Text(
                          'عيار ${_karat(key)} · ${_weight(weights[key]!)}',
                        ),
                      ),
                  ],
                ),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: FilledButton.icon(
                  onPressed: () async {
                    final saved = await _editPiece(
                      context,
                      widget.ledger,
                      data.scales,
                    );
                    if (mounted && saved) _refresh();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('إضافة قطعة'),
                ),
              ),
              if (data.items.isNotEmpty)
                ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: const Text('تصفية القطع'),
                  children: [
                    recordFields([
                      _filter(
                        'المالك',
                        owner,
                        owners,
                        latinDigits,
                        (value) => _owner = value,
                      ),
                      _filter(
                        'الحائز',
                        holder,
                        holders,
                        latinDigits,
                        (value) => _holder = value,
                      ),
                      _filter(
                        'العيار',
                        purity,
                        purities,
                        _karat,
                        (value) => _purity = value,
                      ),
                    ]),
                  ],
                ),
              if (filtered.isEmpty)
                const ListTile(title: Text('لا توجد قطع في هذا العرض.')),
              for (final item in [
                ...filtered.where((item) => item.sale == null),
                ...filtered.where((item) => item.sale != null),
              ])
                Card(
                  child: ListTile(
                    key: ValueKey(item.piece.id),
                    title: Text(latinDigits(item.piece.label)),
                    subtitle: Text(
                      '${_goldKind(item.piece.kind)} · عيار ${_karat(item.piece.karatHundredths)} · ${_weight(BigInt.from(item.piece.weightMg))}\n'
                      'المالك ${latinDigits(item.piece.owner)} · الحائز ${latinDigits(item.piece.custodian)}',
                    ),
                    trailing: Text(item.sale == null ? 'موجودة' : 'مباعة'),
                    onTap: () async {
                      await showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        useSafeArea: true,
                        builder: (_) => _GoldPanel(
                          ledger: widget.ledger,
                          id: item.piece.id,
                          data: data,
                        ),
                      );
                      if (mounted) _refresh();
                    },
                  ),
                ),
            ],
          );
        },
      ),
    ),
  );

  Widget _filter<T extends Object>(
    String label,
    T? selected,
    List<T> options,
    String Function(T) name,
    ValueChanged<T?> change,
  ) => recordChoices<T?>(label, selected, [
    const DropdownMenuItem(value: null, child: Text('الكل')),
    for (final value in options)
      DropdownMenuItem(value: value, child: Text(name(value))),
  ], (value) => setState(() => change(value)));
}

class _GoldPanel extends StatefulWidget {
  const _GoldPanel({
    required this.ledger,
    required this.id,
    required this.data,
  });
  final Ledger ledger;
  final int id;
  final _GoldData data;

  @override
  State<_GoldPanel> createState() => _GoldPanelState();
}

class _GoldPanelState extends State<_GoldPanel> {
  late Future<GoldRecord> _record = widget.ledger.goldRecord(widget.id);
  void _refresh() {
    final next = widget.ledger.goldRecord(widget.id);
    setState(() {
      _record = next;
    });
  }

  Future<void> _run(Future<bool> action) async {
    final saved = await action;
    if (mounted && saved) _refresh();
  }

  @override
  Widget build(BuildContext context) => FractionallySizedBox(
    heightFactor: .86,
    child: FutureBuilder(
      future: _record,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: TextButton(
              onPressed: _refresh,
              child: const Text('تعذّر تحميل القطعة. أعد المحاولة.'),
            ),
          );
        }
        final record = snapshot.data;
        if (record == null ||
            snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return _panel(record);
      },
    ),
  );

  Widget _panel(GoldRecord record) {
    final piece = record.item.piece;
    final sale = record.item.sale;
    final receipt = record.receipt;
    final data = widget.data;
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                latinDigits(piece.label),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            IconButton(
              tooltip: 'إغلاق',
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        Text(sale == null ? 'موجودة' : 'مباعة'),
        Text(
          '${_goldKind(piece.kind)} · ${_weight(BigInt.from(piece.weightMg))} · عيار ${_karat(piece.karatHundredths)}',
        ),
        Text('المالك ${latinDigits(piece.owner)}'),
        Text(
          '${sale == null ? 'الحائز' : 'آخر حائز'} ${latinDigits(piece.custodian)}',
        ),
        Text(
          piece.purchaseDay == null
              ? 'تاريخ الشراء غير معروف'
              : 'الشراء ${recordDayLabel(context, piece.purchaseDay!)}',
        ),
        Text(
          piece.purchaseMinor == null
              ? 'تكلفة الشراء غير معروفة'
              : 'التكلفة ${_goldMoney(piece.purchaseMinor!, piece.purchaseCurrency!, data.scales)}',
        ),
        if (piece.notes != null) Text(latinDigits(piece.notes!)),
        if (sale != null) ...[
          const Divider(),
          Text('البيع ${recordDayLabel(context, sale.saleDay)}'),
          Text(
            sale.priceMinor == null
                ? 'ثمن البيع غير معروف'
                : 'ثمن البيع ${_goldMoney(sale.priceMinor!, sale.priceCurrency!, data.scales)}',
          ),
          if (receipt == null)
            const Text('لم يؤكّد استلام الثمن')
          else ...[
            Text('الاستلام ${recordDayLabel(context, receipt.day)}'),
            Text(
              _goldMoney(
                receipt.minor,
                data.accounts
                    .firstWhere((account) => account.id == receipt.accountId)
                    .currency,
                data.scales,
              ),
            ),
          ],
        ],
        Wrap(
          spacing: 8,
          children: [
            TextButton(
              onPressed: () => _run(
                _editPiece(context, widget.ledger, data.scales, old: piece),
              ),
              child: const Text('تعديل القطعة'),
            ),
            if (sale == null)
              TextButton(
                onPressed: () =>
                    _run(_editCustody(context, widget.ledger, piece)),
                child: const Text('نقل الحيازة'),
              ),
            TextButton(
              onPressed: () => _run(
                _editSale(context, widget.ledger, data.scales, record.item),
              ),
              child: Text(sale == null ? 'تسجيل البيع' : 'تصحيح بيانات البيع'),
            ),
            if (sale != null && data.accounts.isNotEmpty)
              FilledButton(
                onPressed: () =>
                    _run(_editReceipt(context, widget.ledger, data, record)),
                child: Text(
                  receipt == null ? 'تأكيد استلام الثمن' : 'تصحيح الاستلام',
                ),
              ),
            if (receipt != null)
              TextButton(
                onPressed: () =>
                    _run(_undoReceipt(context, widget.ledger, sale!)),
                child: const Text('التراجع عن الاستلام'),
              ),
          ],
        ),
        if (sale != null && receipt == null && data.accounts.isEmpty)
          const Text('أضف حسابًا لتأكيد استلام الثمن.'),
        const Divider(),
        Text('سجل العمليات', style: Theme.of(context).textTheme.titleMedium),
        for (final event in record.events) _history(event),
      ],
    );
  }

  Widget _history(GoldEvent event) {
    final label = switch (event.kind) {
      GoldEventKind.added => 'إضافة قطعة',
      GoldEventKind.edited => 'تعديل البيانات',
      GoldEventKind.moved => 'نقل الحيازة',
      GoldEventKind.sold => 'تسجيل البيع',
      GoldEventKind.saleEdited => 'تصحيح بيانات البيع',
      GoldEventKind.received => 'تأكيد استلام الثمن',
      GoldEventKind.receiptCorrected => 'تصحيح الاستلام',
      GoldEventKind.receiptReversed => 'التراجع عن الاستلام',
    };
    final changes = jsonDecode(event.changes) as Map<String, dynamic>;
    String value(String key, Object? input) {
      if (input == null) return 'غير معروف';
      return switch (key) {
        'purchaseDay' || 'saleDay' => recordDayLabel(context, input as int),
        'weight' => _weight(BigInt.from(input as int)),
        'karat' => _karat(input as int),
        'kind' => _goldKind(GoldKind.values.byName(input as String)),
        'purchase' || 'salePrice' => _goldMoney(
          (input as List)[0] as int,
          input[1] as String,
          widget.data.scales,
        ),
        _ => latinDigits(input.toString()),
      };
    }

    const labels = {
      'label': 'الوصف',
      'kind': 'النوع',
      'weight': 'الوزن',
      'karat': 'العيار',
      'owner': 'المالك',
      'custodian': 'الحائز',
      'purchaseDay': 'تاريخ الشراء',
      'purchase': 'تكلفة الشراء',
      'notes': 'الملاحظات',
      'saleDay': 'تاريخ البيع',
      'salePrice': 'ثمن البيع',
    };
    return ListTile(
      title: Text(label),
      subtitle: Text(
        [
          recordDayLabel(
            context,
            leaveDay(DateTime.fromMicrosecondsSinceEpoch(event.recordedMicros)),
          ),
          for (final entry in changes.entries)
            if (entry.value case [final before, final after])
              '${labels[entry.key]} · ${value(entry.key, before)} ← ${value(entry.key, after)}',
          if (event.journalId != null) 'القيد ${event.journalId}',
        ].join('\n'),
      ),
    );
  }
}
