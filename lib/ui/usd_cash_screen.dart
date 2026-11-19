import 'package:material_ui/material_ui.dart';

import '../data/database.dart';
import '../finance/ledger.dart';
import '../finance/model.dart';
import 'amount.dart';
import 'expense_screen.dart';

class UsdCashScreen extends StatefulWidget {
  const UsdCashScreen({
    required this.ledger,
    required this.newOperationId,
    super.key,
  });

  final Ledger ledger;
  final String Function() newOperationId;

  @override
  State<UsdCashScreen> createState() => _UsdCashScreenState();
}

class _UsdCashScreenState extends State<UsdCashScreen> {
  Ledger get ledger => widget.ledger;
  late Future<UsdCashOverview> _data = ledger.usdCashOverview(DateTime.now());
  bool _busy = false;

  void _refresh() {
    setState(() {
      _data = ledger.usdCashOverview(DateTime.now());
    });
  }

  Future<void> _save(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(_errorLabel(error))));
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
        _refresh();
      }
    }
  }

  Future<void> _add(UsdCashOverview data) => _save(() async {
    final input = await _prompt('إضافة نقد', banks: data.bankAccounts);
    if (input == null) return;
    final id = widget.newOperationId();
    final date = DateTime.now();
    if (input.source == 0) {
      await ledger.receiveExternalUsdCash(
        operationId: id,
        minor: input.minor,
        effectiveAt: date,
      );
    } else {
      await ledger.withdrawUsdCash(
        operationId: id,
        bankId: input.source!,
        minor: input.minor,
        effectiveAt: date,
      );
    }
  });

  Future<void> _use() => _save(() async {
    final input = await _prompt('استخدام نقد', note: true);
    if (input != null && mounted) {
      final id = widget.newOperationId();
      final date = DateTime.now();
      await saveWithExpenseReview(context, (acknowledged) async {
        await ledger.useUsdCash(
          operationId: id,
          minor: input.minor,
          effectiveAt: date,
          note: input.note,
          acknowledged: acknowledged,
        );
      });
    }
  });

  Future<void> _opening(LedgerAccount wallet) => _save(() async {
    final input = await _prompt('تسجيل رصيد افتتاحي', allowZero: true);
    if (input != null) {
      await ledger.recordOpening(
        operationId: widget.newOperationId(),
        accountId: wallet.id,
        minor: input.minor,
        effectiveAt: DateTime.now(),
      );
    }
  });

  Future<void> _settle(UsdCashOverview data) => _save(() async {
    final input = await _prompt(
      'تسوية الرصيد',
      allowZero: true,
      label: 'النقد الذي عددته فعليًا',
    );
    if (input == null || !mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد تسوية الرصيد'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _amountRow('الرصيد المسجّل', BigInt.from(data.minor)),
            _amountRow('الرصيد المعدود', BigInt.from(input.minor)),
            _amountRow(
              'فرق التسوية',
              BigInt.from(input.minor) - BigInt.from(data.minor),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('تأكيد التسوية'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ledger.confirmUsdCashBalance(
        operationId: widget.newOperationId(),
        priorMinor: data.minor,
        countedMinor: input.minor,
        effectiveAt: DateTime.now(),
      );
    }
  });

  Future<void> _limit(int current) => _save(() async {
    final input = await _prompt(
      'حد السحب البنكي الشهري',
      initial: current,
      allowZero: true,
    );
    if (input != null) await ledger.setUsdWithdrawalLimit(input.minor);
  });

  Future<void> _correct(CashMovement movement) => _save(() async {
    final input = await _prompt(
      'تصحيح مبلغ الحركة',
      label: 'المبلغ الصحيح',
      initial: movement.minor.abs(),
    );
    if (input != null && mounted) {
      final reversal = widget.newOperationId();
      final replacement = widget.newOperationId();
      await saveWithExpenseReview(context, (acknowledged) async {
        await ledger.correctUsdCashAmount(
          reversalOperationId: reversal,
          replacementOperationId: replacement,
          entryId: movement.entryId,
          minor: input.minor,
          acknowledged: acknowledged,
        );
      });
    }
  });

  Future<_CashInput?> _prompt(
    String title, {
    String label = 'المبلغ بالدولار',
    int? initial,
    bool allowZero = false,
    bool note = false,
    List<LedgerAccount>? banks,
  }) => showDialog<_CashInput>(
    context: context,
    builder: (_) => _CashDialog(
      title: title,
      label: label,
      initial: initial,
      allowZero: allowZero,
      banks: banks,
      note: note,
    ),
  );

  @override
  Widget build(BuildContext context) => FutureBuilder(
    future: _data,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(
          child: TextButton(
            onPressed: _refresh,
            child: const Text('تعذّر تحميل النقد. أعد المحاولة'),
          ),
        );
      }
      final data = snapshot.data;
      if (data == null) return const Center(child: CircularProgressIndicator());
      final wallet = data.account;
      if (wallet == null) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (data.cashAccounts.isEmpty)
              FilledButton(
                onPressed: _busy ? null : () => _save(ledger.setupUsdCash),
                child: const Text('تهيئة حساب النقد بالدولار'),
              )
            else ...[
              const ListTile(
                title: Text('اختر حساب النقد بالدولار لهذه الشاشة'),
              ),
              for (final account in data.cashAccounts)
                ListTile(
                  title: Text(account.name),
                  onTap: _busy
                      ? null
                      : () => _save(
                          () => ledger.setupUsdCash(
                            existingAccountId: account.id,
                          ),
                        ),
                ),
            ],
          ],
        );
      }
      final overLimit =
          data.withdrawnMinor > BigInt.from(data.withdrawalLimitMinor);
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _amountRow('الرصيد النقدي', BigInt.from(data.minor)),
          if (!data.balanceKnown)
            const Text('صافي الحركات المسجلة · الرصيد الفعلي غير معلوم'),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              FilledButton(
                onPressed: _busy ? null : () => _add(data),
                child: const Text('إضافة نقد'),
              ),
              FilledButton.tonal(
                onPressed: _busy ? null : _use,
                child: const Text('استخدام نقد'),
              ),
              OutlinedButton(
                onPressed: _busy ? null : () => _settle(data),
                child: const Text('تسوية الرصيد'),
              ),
              if (data.canRecordOpening)
                TextButton(
                  onPressed: _busy ? null : () => _opening(wallet),
                  child: const Text('رصيد افتتاحي'),
                ),
            ],
          ),
          const Divider(),
          _amountRow(
            'هدف الادخار الشخصي الشهري (اختياري)',
            BigInt.from(usdMonthlySavingsGoalMinor),
          ),
          _amountRow('السحب البنكي هذا الشهر', data.withdrawnMinor),
          _amountRow(
            'حد السحب البنكي الشهري',
            BigInt.from(data.withdrawalLimitMinor),
          ),
          if (overLimit)
            Text(
              'تحذير: تجاوزت السحوبات البنكية حد هذا الشهر.',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton(
              onPressed: _busy ? null : () => _limit(data.withdrawalLimitMinor),
              child: const Text('تعديل حد السحب'),
            ),
          ),
          const Divider(),
          Text('آخر الحركات', style: Theme.of(context).textTheme.titleMedium),
          if (data.movements.isEmpty)
            const ListTile(title: Text('لا توجد حركات نقدية.')),
          for (final movement in data.movements) _history(context, movement),
        ],
      );
    },
  );

  Widget _history(BuildContext context, CashMovement movement) {
    final title = switch (movement.kind) {
      CashMovementKind.opening => 'رصيد افتتاحي',
      CashMovementKind.bankWithdrawal => 'سحب من البنك',
      CashMovementKind.externalIncome => 'دخل نقدي خارجي',
      CashMovementKind.expense =>
        movement.note == null ? 'مصروف نقدي غير مصنف' : 'مصروف نقدي',
      CashMovementKind.settlement => 'تسوية رصيد مؤكّدة',
      CashMovementKind.reversal => 'عكس القيد ${movement.reversalOf}',
      CashMovementKind.other => 'حركة نقدية',
    };
    final canCorrect =
        !movement.reversed &&
        {
          CashMovementKind.bankWithdrawal,
          CashMovementKind.externalIncome,
          CashMovementKind.expense,
        }.contains(movement.kind);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(movement.reversed ? '$title · معكوس' : title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            MaterialLocalizations.of(context)
                .formatShortDate(movement.effectiveAt),
          ),
          if (movement.correctionOf != null)
            Text('تصحيح للقيد ${movement.correctionOf}'),
          if (movement.countedMinor != null)
            _amountRow('الرصيد المعدود', BigInt.from(movement.countedMinor!)),
          if (movement.note != null) Text(movement.note!),
        ],
      ),
      trailing: _usd(BigInt.from(movement.minor)),
      onTap: canCorrect && !_busy ? () => _correct(movement) : null,
    );
  }
}

typedef _CashInput = ({int minor, int? source, String? note});

class _CashDialog extends StatefulWidget {
  const _CashDialog({
    required this.title,
    required this.label,
    this.initial,
    required this.allowZero,
    this.banks,
    required this.note,
  });

  final String title;
  final String label;
  final int? initial;
  final bool allowZero;
  final List<LedgerAccount>? banks;
  final bool note;

  @override
  State<_CashDialog> createState() => _CashDialogState();
}

class _CashDialogState extends State<_CashDialog> {
  final _form = GlobalKey<FormState>();
  late final _amount = TextEditingController(
    text: widget.initial == null ? null : formatMinor(widget.initial!, 2),
  );
  final _note = TextEditingController();
  late int? _source = widget.banks?.firstOrNull?.id;

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.title),
    content: Form(
      key: _form,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.banks case final banks?)
              DropdownButtonFormField<int>(
                initialValue: _source,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'مصدر النقد'),
                items: [
                  for (final bank in banks)
                    DropdownMenuItem(
                      value: bank.id,
                      child: Text('سحب من البنك · ${bank.name}'),
                    ),
                  const DropdownMenuItem(
                    value: 0,
                    child: Text('دخل نقدي خارجي'),
                  ),
                ],
                onChanged: (id) => _source = id,
                validator: (value) => value == null ? 'اختر مصدر النقد' : null,
              ),
            TextFormField(
              controller: _amount,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(labelText: widget.label),
              validator: (value) {
                final minor = parseMinor(value ?? '', 2);
                return minor == null ||
                        minor < 0 ||
                        (!widget.allowZero && minor == 0)
                    ? 'أدخل مبلغًا صالحًا'
                    : null;
              },
            ),
            if (widget.note)
              TextFormField(
                controller: _note,
                maxLength: 500,
                decoration: const InputDecoration(labelText: 'الغرض (اختياري)'),
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
        onPressed: () {
          if (!_form.currentState!.validate()) return;
          final _CashInput input = (
            minor: parseMinor(_amount.text, 2)!,
            source: _source,
            note: _note.text,
          );
          Navigator.pop(context, input);
        },
        child: Text(widget.title == 'تسوية الرصيد' ? 'مراجعة التسوية' : 'حفظ'),
      ),
    ],
  );
}

Widget _amountRow(String label, BigInt minor) => Padding(
  padding: const EdgeInsets.symmetric(vertical: 5),
  child: Row(
    children: [
      Expanded(child: Text(label)),
      _usd(minor),
    ],
  ),
);

Widget _usd(BigInt minor) {
  final digits = minor.abs().toString().padLeft(3, '0');
  final separator = digits.length - 2;
  final amount =
      "${minor.isNegative ? '-' : ''}${digits.substring(0, separator)}.${digits.substring(separator)}";
  return Text('$amount USD', textDirection: TextDirection.ltr);
}

String _errorLabel(Object error) => switch (error) {
  CashException(:final issue) => switch (issue) {
    CashIssue.walletRequired => 'اختر حساب النقد بالدولار أولًا.',
    CashIssue.walletAlreadySelected ||
    CashIssue.duplicateCashAccount => 'حساب النقد بالدولار محدد بالفعل.',
    CashIssue.invalidAmount => 'أدخل مبلغًا صالحًا.',
    CashIssue.insufficientCash => 'المبلغ يتجاوز الرصيد النقدي المسجّل.',
    CashIssue.openingAfterSettlement => 'الرصيد محدّد بتسوية سابقة.',
    CashIssue.staleBalance => 'تغيّر الرصيد المسجّل. راجع التسوية مجددًا.',
    CashIssue.uncorrectableMovement => 'هذه الحركة غير مؤهلة لتصحيح المبلغ.',
  },
  ExpenseOverlap() =>
    'تتداخل الحركة مع إجمالي مسجّل لهذا الحساب. صحّح الإجمالي أو ألغِه أولًا.',
  LedgerException() when error.issue == LedgerIssue.alreadyReversed =>
    'الحركة معكوسة بالفعل.',
  LedgerException() when error.issue == LedgerIssue.duplicateConflict =>
    'تعارض مع عملية مسجّلة.',
  LedgerException() when error.issue == LedgerIssue.overflow =>
    'تجاوز المبلغ الحد المدعوم.',
  _ => 'تعذّر حفظ الحركة.',
};
