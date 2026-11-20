part of 'gold_screen.dart';

int _goldToday() => leaveDay(DateTime.now());

String _goldMoney(int minor, String code, Map<String, int> scales) =>
    '${formatMinor(minor, scales[code]!)} $code';

String? _goldError(Object error) {
  if (error is! GoldException) return null;
  return switch (error.issue) {
    GoldIssue.invalid => 'تحقّق من الوزن والعيار والتواريخ والبيانات المطلوبة.',
    GoldIssue.samePerson => 'أدخل مالكًا وحائزًا مختلفين.',
    GoldIssue.missing => 'القطعة غير متاحة.',
    GoldIssue.stale => 'تغيّر السجل. افتح النموذج مجددًا.',
    GoldIssue.sold => 'لا يمكن نقل حيازة قطعة مباعة.',
    GoldIssue.notSold => 'سجّل البيع أولًا.',
  };
}

Future<bool> _goldEditor(
  BuildContext context,
  String title,
  Widget Function(BuildContext, StateSetter) body,
  Future<void> Function() save, {
  String action = 'حفظ',
}) async =>
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => RecordEditor(
        title: title,
        body: body,
        save: save,
        action: action,
        customError: _goldError,
      ),
    ) ==
    true;

Widget _goldText(
  String label,
  String text,
  int limit,
  ValueChanged<String> change,
) => TextFormField(
  initialValue: text,
  maxLength: limit,
  decoration: InputDecoration(labelText: label),
  onChanged: change,
);

int _goldNumber(String value, int scale) =>
    parseMinor(value, scale) ?? (throw const GoldException(GoldIssue.invalid));

class _GoldPriceFields {
  _GoldPriceFields(this.scales, int? minor, this.currency)
    : known = minor != null,
      amount = minor == null ? '' : formatMinor(minor, scales[currency]!);

  final Map<String, int> scales;
  bool known;
  String amount;
  String? currency;

  List<Widget> fields(String label, StateSetter update) => [
    SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text('$label معروف'),
      value: known,
      onChanged: (value) => update(() => known = value),
    ),
    if (known) ...[
      recordChoices('العملة', currency, [
        for (final code in scales.keys)
          DropdownMenuItem(value: code, child: Text(code)),
      ], (value) => update(() => currency = value)),
      recordNumberField(label, amount, (value) => amount = value),
    ],
  ];

  GoldPurchase? get value {
    if (!known) return null;
    final code = currency;
    if (code == null) throw const GoldException(GoldIssue.invalid);
    return (minor: _goldNumber(amount, scales[code]!), currency: code);
  }
}

Future<bool> _editPiece(
  BuildContext context,
  Ledger ledger,
  Map<String, int> scales, {
  GoldPiece? old,
}) {
  final key =
      't015:${DateTime.now().microsecondsSinceEpoch}:${Random.secure().nextInt(1 << 32)}';
  var label = old?.label ?? '';
  var kind = old?.kind ?? GoldKind.bar;
  var weight = old == null ? '' : _trimDecimal(formatMinor(old.weightMg, 3));
  var purity = old == null ? '' : _karat(old.karatHundredths);
  var owner = old?.owner ?? '';
  var holder = old?.custodian ?? '';
  var notes = old?.notes ?? '';
  var purchaseDay = old?.purchaseDay;
  final price = _GoldPriceFields(
    scales,
    old?.purchaseMinor,
    old?.purchaseCurrency,
  );
  return _goldEditor(
    context,
    old == null ? 'إضافة قطعة ذهب' : 'تعديل القطعة',
    (context, update) => recordFields([
      _goldText('اسم القطعة أو وصفها', label, 120, (value) => label = value),
      recordChoices('النوع', kind, [
        for (final type in GoldKind.values)
          DropdownMenuItem(value: type, child: Text(_goldKind(type))),
      ], (value) => update(() => kind = value!)),
      recordNumberField('الوزن بالجرام', weight, (value) => weight = value),
      recordNumberField('العيار', purity, (value) => purity = value),
      _goldText('المالك الفعلي', owner, 100, (value) => owner = value),
      if (old == null)
        _goldText('الحائز', holder, 100, (value) => holder = value),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text('تاريخ الشراء معروف'),
        value: purchaseDay != null,
        onChanged: (value) =>
            update(() => purchaseDay = value ? _goldToday() : null),
      ),
      if (purchaseDay != null)
        recordDateButton(
          context,
          'تاريخ الشراء',
          purchaseDay!,
          (value) => update(() => purchaseDay = value),
          last: _goldToday(),
        ),
      ...price.fields('تكلفة الشراء', update),
      _goldText('ملاحظات (اختياري)', notes, 500, (value) => notes = value),
    ]),
    () async {
      final details = GoldDetails(
        label: label,
        kind: kind,
        weightMg: _goldNumber(weight, 3),
        karatHundredths: _goldNumber(purity, 2),
        owner: owner,
        purchaseDay: purchaseDay,
        purchase: price.value,
        notes: notes,
      );
      if (old == null) {
        await ledger.addGold(
          operationId: key,
          details: details,
          custodian: holder,
        );
      } else {
        await ledger.editGold(old, details);
      }
    },
  );
}

Future<bool> _editCustody(
  BuildContext context,
  Ledger ledger,
  GoldPiece piece,
) {
  var name = '';
  return _goldEditor(
    context,
    'نقل الحيازة',
    (_, _) => recordFields([
      Text('الحائز الحالي ${latinDigits(piece.custodian)}'),
      _goldText('الحائز الجديد', name, 100, (value) => name = value),
    ]),
    () => ledger.moveGold(piece, name),
  );
}

Future<bool> _editSale(
  BuildContext context,
  Ledger ledger,
  Map<String, int> scales,
  GoldItem item,
) {
  final old = item.sale;
  var day = old?.saleDay ?? _goldToday();
  final price = _GoldPriceFields(scales, old?.priceMinor, old?.priceCurrency);
  return _goldEditor(
    context,
    old == null ? 'تسجيل البيع' : 'تصحيح بيانات البيع',
    (context, update) => recordFields([
      const Text('يمكن تأكيد استلام الثمن بشكل مستقل بعد تسجيل البيع.'),
      recordDateButton(
        context,
        'تاريخ البيع',
        day,
        (value) => update(() => day = value),
        first: item.piece.purchaseDay,
        last: _goldToday(),
      ),
      ...price.fields('ثمن البيع', update),
    ]),
    () => ledger.saveGoldSale(
      pieceId: item.piece.id,
      expected: old,
      saleDay: day,
      price: price.value,
    ),
  );
}

Future<bool> _editReceipt(
  BuildContext context,
  Ledger ledger,
  _GoldData data,
  GoldRecord record,
) {
  final sale = record.item.sale!;
  final old = record.receipt;
  int? id = old?.accountId;
  String? code() => id == null
      ? null
      : data.accounts.firstWhere((account) => account.id == id).currency;
  var amount = old == null ? '' : formatMinor(old.minor, data.scales[code()]!);
  var day = old?.day ?? _goldToday();
  var reason = '';
  return _goldEditor(
    context,
    old == null ? 'تأكيد استلام ثمن البيع' : 'تصحيح استلام الثمن',
    (context, update) => recordFields([
      recordChoices('حساب الاستلام', id, [
        for (final account in data.accounts)
          DropdownMenuItem(
            value: account.id,
            child: Text('${latinDigits(account.name)} · ${account.currency}'),
          ),
      ], (value) => update(() => id = value)),
      recordNumberField(
        code() == null ? 'المبلغ المستلم' : 'المبلغ المستلم · ${code()}',
        amount,
        (value) => amount = value,
      ),
      recordDateButton(
        context,
        'تاريخ الاستلام',
        day,
        (value) => update(() => day = value),
        last: _goldToday(),
      ),
      if (old != null)
        _goldText('سبب التصحيح', reason, 500, (value) => reason = value),
    ]),
    () async {
      if (id == null) throw const GoldException(GoldIssue.invalid);
      await ledger.confirmGoldReceipt(
        pieceId: sale.pieceId,
        expectedRevision: sale.receiptRevision,
        receipt: (
          accountId: id!,
          day: day,
          minor: _goldNumber(amount, data.scales[code()]!),
        ),
        reason: reason,
      );
    },
    action: 'تأكيد',
  );
}

Future<bool> _undoReceipt(BuildContext context, Ledger ledger, GoldSale sale) {
  var reason = '';
  return _goldEditor(
    context,
    'التراجع عن تأكيد الاستلام',
    (_, _) => _goldText('سبب التراجع', reason, 500, (value) => reason = value),
    () => ledger.confirmGoldReceipt(
      pieceId: sale.pieceId,
      expectedRevision: sale.receiptRevision,
      receipt: null,
      reason: reason,
    ),
    action: 'تأكيد التراجع',
  );
}
