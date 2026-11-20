import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../data/android_storage.dart';
import '../data/backup_envelope.dart';
import '../data/ledger_backup.dart';

class BackupScreen extends StatefulWidget {
  const BackupScreen({this.openBackup, super.key});

  final Future<LedgerBackup> Function()? openBackup;

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  bool _busy = false;
  bool _locked = false;
  String? _message;

  Future<void> _run(Future<void> Function() work) async {
    if (_busy || _locked) return;
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      await work();
    } on BackupException catch (error) {
      if (!mounted) return;
      if (error.issue == BackupIssue.recoveryPending) {
        _locked = true;
      }
      _message = switch (error.issue) {
        BackupIssue.unsupported => 'إصدار النسخة الاحتياطية غير مدعوم.',
        BackupIssue.invalidPassword => 'أدخل كلمة مرور صالحة.',
        BackupIssue.invalidData =>
          'تعذّر التحقق من النسخة أو استعادتها. تحقق من الملف وكلمة المرور.',
        BackupIssue.tooLarge => 'الحد الأقصى للنسخة الاحتياطية 16 MB.',
        BackupIssue.recoveryPending => 'أغلق التطبيق وافتحه للتحقق من اكتمال الاستعادة. بقيت نسخة الرجوع محفوظة.',
      };
    } on PlatformException catch (error) {
      _message = error.code == 'BACKUP_TOO_LARGE'
          ? 'الحد الأقصى للنسخة الاحتياطية 16 MB.'
          : 'تعذّر الوصول إلى الملف المختار.';
    } catch (_) {
      _message = 'تعذّرت العملية. تحقق من مساحة التخزين وحاول مرة أخرى.';
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<Uint8List?> _password({required bool exporting}) async {
    if (!mounted) return null;
    await protectBackupPassword(true);
    try {
      if (!mounted) return null;
      return await showDialog<Uint8List>(
        context: context,
        builder: (_) => _PasswordDialog(exporting: exporting),
      );
    } finally {
      await protectBackupPassword(false);
    }
  }

  Future<void> _export() => _run(() async {
    final backup = await widget.openBackup!();
    final password = await _password(exporting: true);
    if (password == null) return;
    final bytes = await backup.export(password);
    if (await saveBackupDocument(bytes)) {
      _message = 'حُفظت النسخة الاحتياطية المشفّرة.';
    }
  });

  Future<void> _import() => _run(() async {
    final file = await chooseBackupDocument();
    if (file == null || !mounted) return;
    final backup = await widget.openBackup?.call();
    final password = await _password(exporting: false);
    if (password == null) return;
    final isRecovery = backup == null;
    final prepared = isRecovery
        ? await prepareAndroidRecovery(file, password)
        : await backup.prepare(file, password);
    try {
      if (!mounted) return;
      final preview = prepared.preview;
      final approve = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            isRecovery
                ? 'استعادة البيانات في مساحة مشفّرة جديدة؟'
                : 'استبدال البيانات الحالية؟',
          ),
          content: Text(
            'الحسابات: ${preview.accounts}\n'
            'القيود: ${preview.movements}\n'
            'الإجازات: ${preview.leaveEntries}\n'
            'قطع الذهب: ${preview.goldPieces}\n\n'
            '${isRecovery ? 'ستبقى الملفات القديمة محفوظة، وسيستخدم التطبيق البيانات المستعادة بعد إعادة تشغيله.' : 'ستحل بيانات النسخة محل البيانات الحالية.'}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                isRecovery ? 'استعادة في مساحة جديدة' : 'استعادة واستبدال',
              ),
            ),
          ],
        ),
      );
      if (approve != true) return;
      if (isRecovery) {
        await recoverAndroidLedger(prepared);
        _locked = true;
        _message = 'تمت الاستعادة. أغلق التطبيق وافتحه لعرض البيانات.';
      } else {
        await backup.restore(prepared);
        if (mounted) Navigator.pop(context, true);
      }
    } finally {
      prepared.discard();
    }
  });

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_busy && !_locked,
    child: Scaffold(
      appBar: AppBar(title: const Text('النسخ الاحتياطي')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'احفظ كلمة المرور في مكان آمن. ستحتاجها عند استعادة النسخة.',
            ),
            const SizedBox(height: 16),
            if (widget.openBackup != null)
              FilledButton.icon(
                onPressed: _busy || _locked ? null : _export,
                icon: const Icon(Icons.save_alt),
                label: const Text('تصدير نسخة مشفّرة'),
              ),
            OutlinedButton.icon(
              onPressed: _busy || _locked ? null : _import,
              icon: const Icon(Icons.upload_file_outlined),
              label: const Text('استعادة من ملف'),
            ),
            if (_busy) const LinearProgressIndicator(),
            if (_message case final message?) Text(message),
          ],
        ),
      ),
    ),
  );
}

class _PasswordDialog extends StatefulWidget {
  const _PasswordDialog({required this.exporting});

  final bool exporting;

  @override
  State<_PasswordDialog> createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<_PasswordDialog> {
  final _form = GlobalKey<FormState>();
  final _first = TextEditingController();
  final _repeat = TextEditingController();

  @override
  void dispose() {
    _first.clear();
    _repeat.clear();
    _first.dispose();
    _repeat.dispose();
    super.dispose();
  }

  Widget _field(
    TextEditingController controller,
    String label,
    String? Function(String?) validate,
  ) => TextFormField(
    controller: controller,
    decoration: InputDecoration(labelText: label),
    obscureText: true,
    enableSuggestions: false,
    autocorrect: false,
    enableIMEPersonalizedLearning: false,
    keyboardType: TextInputType.visiblePassword,
    validator: validate,
  );

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('كلمة مرور النسخة الاحتياطية'),
    content: Form(
      key: _form,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _field(_first, 'كلمة المرور', (value) {
              final password = value ?? '';
              if (password.isEmpty || utf8.encode(password).length > 1024) {
                return 'أدخل كلمة مرور صالحة.';
              }
              return widget.exporting && password.runes.length < 12
                  ? 'استخدم 12 حرفًا على الأقل.'
                  : null;
            }),
            if (widget.exporting)
              _field(
                _repeat,
                'تأكيد كلمة المرور',
                (value) =>
                    value == _first.text ? null : 'كلمتا المرور غير متطابقتين.',
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
          if (_form.currentState!.validate()) {
            Navigator.pop(context, utf8.encode(_first.text));
          }
        },
        child: const Text('متابعة'),
      ),
    ],
  );
}
