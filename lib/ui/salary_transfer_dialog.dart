import 'package:material_ui/material_ui.dart';

import '../finance/ledger.dart';
import '../finance/model.dart';
import '../finance/transfer_quote.dart';
import 'amount.dart';
import 'digits.dart';

String allocationCategoryLabel(AllocationCategory category) =>
    switch (category) {
      AllocationCategory.family => 'تحويلات الأسرة',
      AllocationCategory.living => 'الإيجار والمصروفات',
      AllocationCategory.obligations => 'الالتزامات والديون',
      AllocationCategory.savings => 'المدخرات والاستثمارات',
      AllocationCategory.cash => 'النقدية',
      AllocationCategory.personal => 'المصروفات الشخصية',
    };

Widget allocationCategoryField(
  AllocationCategory? value,
  ValueChanged<AllocationCategory?> onChanged,
) => DropdownButtonFormField<AllocationCategory>(
  initialValue: value,
  isExpanded: true,
  decoration: const InputDecoration(labelText: 'التصنيف'),
  items: [
    for (final category in AllocationCategory.values)
      DropdownMenuItem(
        value: category,
        child: Text(allocationCategoryLabel(category)),
      ),
  ],
  onChanged: onChanged,
);

class SalaryTransferDialog extends StatefulWidget {
  const SalaryTransferDialog({
    required this.available,
    required this.scales,
    required this.lastRates,
    this.item,
    super.key,
  });

  final int available;
  final Map<String, int> scales;
  final Map<String, String> lastRates;
  final SalaryAllocationView? item;

  @override
  State<SalaryTransferDialog> createState() => _SalaryTransferDialogState();
}

class _NeedFields {
  _NeedFields(Map<String, int> scales, [TransferNeed? need])
    : currency = need?.currency ?? usdCurrency,
      category = need?.category ?? AllocationCategory.family,
      label = TextEditingController(text: need?.label),
      amount = TextEditingController(
        text: need == null
            ? null
            : formatMinor(need.minor, scales[need.currency]!),
      );

  String currency;
  AllocationCategory category;
  final TextEditingController label;
  final TextEditingController amount;

  void dispose() {
    label.dispose();
    amount.dispose();
  }
}

class _RouteFields {
  _RouteFields(int scale, String? lastRate, TransferTerms? terms)
    : rate = TextEditingController(text: terms?.rate ?? lastRate),
      previous = terms == null && lastRate != null,
      fixed = TextEditingController(
        text: terms == null || terms.fixedFee == 0
            ? null
            : formatMinor(terms.fixedFee, scale),
      ),
      percent = TextEditingController(
        text: terms == null || terms.feeBps == 0
            ? null
            : formatMinor(terms.feeBps, 2),
      ),
      margin = TextEditingController(
        text: terms == null || terms.marginBps == 0
            ? null
            : formatMinor(terms.marginBps, 2),
      );

  final TextEditingController rate;
  final TextEditingController fixed;
  final TextEditingController percent;
  final TextEditingController margin;
  final forward = TextEditingController();
  bool previous;

  TransferTerms? terms(int scale) {
    final value = latinAmount(rate.text.trim());
    final fixedFee = _optional(fixed, scale);
    final feeBps = _optional(percent, 2);
    final marginBps = _optional(margin, 2);
    if (exchangeRateUnits(value) == null ||
        fixedFee == null ||
        feeBps == null ||
        marginBps == null ||
        fixedFee < 0 ||
        feeBps < 0 ||
        feeBps >= 10000 ||
        marginBps < 0 ||
        marginBps >= 10000) {
      return null;
    }
    return (
      rate: value,
      fixedFee: fixedFee,
      feeBps: feeBps,
      marginBps: marginBps,
    );
  }

  int? _optional(TextEditingController field, int scale) =>
      field.text.trim().isEmpty ? 0 : parseMinor(field.text, scale);

  void dispose() {
    for (final controller in [rate, fixed, percent, margin, forward]) {
      controller.dispose();
    }
  }
}

class _SalaryTransferDialogState extends State<SalaryTransferDialog> {
  late final _needs = [
    for (final need in widget.item?.transfer?.needs ?? <TransferNeed>[])
      _NeedFields(widget.scales, need),
    if (widget.item == null) _NeedFields(widget.scales),
  ];
  late final _routes = {
    for (final currency in transferCurrencies.where(
      (code) => code != usdCurrency,
    ))
      currency: _RouteFields(
        _usdScale,
        widget.lastRates[currency],
        widget.item?.transfer?.terms[currency],
      ),
  };

  int get _usdScale => widget.scales[usdCurrency]!;

  @override
  void dispose() {
    for (final need in _needs) {
      need.dispose();
    }
    for (final route in _routes.values) {
      route.dispose();
    }
    super.dispose();
  }

  TransferPlan? _plan(Set<String> currencies) {
    final needs = <TransferNeed>[];
    final terms = <String, TransferTerms>{};
    for (final need in _needs) {
      final amount = parseMinor(
        need.amount.text,
        widget.scales[need.currency]!,
      );
      if (amount == null || amount <= 0) return null;
      needs.add((
        category: need.category,
        label: need.label.text.trim(),
        currency: need.currency,
        minor: amount,
      ));
    }
    for (final currency in currencies) {
      final route = _routes[currency]!.terms(_usdScale);
      if (route == null) return null;
      terms[currency] = route;
    }
    return TransferPlan(needs: needs, terms: terms);
  }

  void _refresh(String _) => setState(() {});

  void _releaseKeyboard() => FocusManager.instance.primaryFocus?.unfocus();

  String _money(String currency, int minor) =>
      '${formatMinor(minor, widget.scales[currency]!)} $currency';

  Widget _number(
    TextEditingController controller,
    String label, {
    ValueChanged<String>? onChanged,
  }) => TextField(
    controller: controller,
    inputFormatters: amountInputFormatters,
    textDirection: TextDirection.ltr,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    decoration: InputDecoration(labelText: label),
    onChanged: onChanged ?? _refresh,
  );

  Widget _need(_NeedFields need) => Column(
    key: ObjectKey(need),
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      allocationCategoryField(need.category, (value) {
        if (value != null) setState(() => need.category = value);
      }),
      TextField(
        controller: need.label,
        maxLength: 100,
        decoration: const InputDecoration(
          labelText: 'الوجهة أو الغرض (اختياري)',
        ),
        onChanged: _refresh,
      ),
      DropdownButtonFormField<String>(
        initialValue: need.currency,
        decoration: const InputDecoration(labelText: 'عملة الاحتياج'),
        items: [
          for (final currency in transferCurrencies)
            DropdownMenuItem(value: currency, child: Text(currency)),
        ],
        onChanged: (value) {
          if (value != null) setState(() => need.currency = value);
        },
      ),
      _number(need.amount, 'المبلغ المطلوب · ${need.currency}'),
      if (_needs.length > 1)
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: TextButton(
            onPressed: () {
              setState(() => _needs.remove(need));
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => need.dispose(),
              );
            },
            child: const Text('حذف الاحتياج'),
          ),
        ),
      const Divider(),
    ],
  );

  Widget _route(String currency) {
    final route = _routes[currency]!;
    final terms = route.terms(_usdScale);
    final principal = parseMinor(route.forward.text, _usdScale);
    int? converted;
    if (terms != null && principal != null && principal >= 0) {
      try {
        converted = TransferCalculator(
          sourceScale: _usdScale,
          destinationScale: widget.scales[currency]!,
          terms: terms,
        ).receivedForPrincipal(principal);
      } on LedgerException {
        // An out-of-range result has no preview.
      }
    }
    return Column(
      key: ValueKey(currency),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _number(
          route.rate,
          'كم $currency لكل 1 USD؟',
          onChanged: (_) {
            setState(() => route.previous = false);
          },
        ),
        if (route.previous)
          const Text('آخر سعر مدخل للتخطيط. السعر تقديري وقد يتغير.'),
        ExpansionTile(
          onExpansionChanged: (_) => _releaseKeyboard(),
          tilePadding: EdgeInsets.zero,
          title: Text('الرسوم والهامش · $currency'),
          subtitle: terms == null
              ? null
              : Text(
                  '${_money(usdCurrency, terms.fixedFee)} · ${formatMinor(terms.feeBps, 2)}% · هامش ${formatMinor(terms.marginBps, 2)}%',
                ),
          children: [
            _number(route.fixed, 'رسوم ثابتة · USD'),
            _number(route.percent, 'نسبة من إجمالي الخصم (%)'),
            _number(route.margin, 'هامش إضافي على السعر (%)'),
            const Text('اترك الهامش فارغًا إذا كان السعر يشمله بالفعل.'),
          ],
        ),
        ExpansionTile(
          onExpansionChanged: (_) => _releaseKeyboard(),
          tilePadding: EdgeInsets.zero,
          title: Text('التحويل من USD إلى $currency'),
          children: [
            _number(route.forward, 'أصل المبلغ المرسل قبل الرسوم · USD'),
            if (converted != null)
              Text('المقابل: ${_money(currency, converted)}'),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencies = {
      for (final need in _needs)
        if (need.currency != usdCurrency) need.currency,
    };
    final plan = _plan(currencies);
    var overflow = false;
    ({Map<String, TransferRoute> routes, int principal, int fee, int debit})?
    quote;
    try {
      quote = plan?.calculate(widget.scales);
    } on LedgerException {
      overflow = true;
    }
    final canSave = quote != null && quote.debit <= widget.available;
    return AlertDialog(
      title: const Text('احسب التحويل المطلوب'),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final need in _needs) _need(need),
              OutlinedButton(
                onPressed: () =>
                    setState(() => _needs.add(_NeedFields(widget.scales))),
                child: const Text('إضافة احتياج'),
              ),
              for (final currency in currencies) _route(currency),
              if (overflow) const Text('تجاوز أحد المبالغ الحد المدعوم.'),
              if (quote != null) ...[
                const Divider(),
                for (final MapEntry(:key, :value) in quote.routes.entries)
                  Text(
                    'الاحتياج ${_money(key, value.received)} · المقابل ${_money(usdCurrency, value.principal)}',
                  ),
                Text(
                  'المقابل بالدولار: ${_money(usdCurrency, quote.principal)}',
                ),
                Text('الرسوم المتوقعة: ${_money(usdCurrency, quote.fee)}'),
                Text('إجمالي المطلوب: ${_money(usdCurrency, quote.debit)}'),
                Text(
                  'المتبقي من الراتب: ${formatUnits(BigInt.from(widget.available) - BigInt.from(quote.debit), _usdScale)} USD',
                ),
                if (!canSave) const Text('المبلغ يتجاوز المتبقي غير الموزّع.'),
              ],
              if (currencies.isNotEmpty &&
                  _needs.any((need) => need.currency == usdCurrency))
                const Text(
                  'احتياجات USD تُحسب مستقلة. التحويل بالعملة المحلية لا يسلّم USD.',
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        FilledButton(
          onPressed: canSave ? () => Navigator.pop(context, plan) : null,
          child: const Text('حفظ التوزيع'),
        ),
      ],
    );
  }
}
