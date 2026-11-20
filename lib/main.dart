import 'package:flutter/foundation.dart'
    show LicenseEntryWithLineBreaks, LicenseRegistry;
import 'package:flutter/services.dart' show rootBundle;
import 'package:material_ui/material_ui.dart';

import 'data/android_appearance.dart';
import 'data/android_storage.dart';
import 'data/ledger_backup.dart';
import 'finance/ledger.dart';
import 'ui/app_theme.dart';
import 'ui/backup_screen.dart';
import 'ui/finance_home.dart';
import 'ui/localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks(
      const ['SQLite3MultipleCiphers'],
      await rootBundle.loadString('assets/licenses/SQLite3MultipleCiphers.txt'),
    );
  });
  final database = openAndroidLedger();
  runApp(
    ExpatManager(
      ledger: database.then(Ledger.new),
      openBackup: () async => androidLedgerBackup(await database),
      initialAppearance: loadAppearance(),
      persistAppearance: saveAppearance,
    ),
  );
}

class ExpatManager extends StatefulWidget {
  const ExpatManager({
    required this.ledger,
    this.openBackup,
    this.initialAppearance,
    this.persistAppearance,
    super.key,
  });

  final Future<Ledger> ledger;
  final Future<LedgerBackup> Function()? openBackup;
  final Future<ThemeMode>? initialAppearance;
  final Future<void> Function(ThemeMode)? persistAppearance;

  @override
  State<ExpatManager> createState() => _ExpatManagerState();
}

class _ExpatManagerState extends State<ExpatManager> {
  ThemeMode _appearance = ThemeMode.system;
  bool _changedAppearance = false;
  bool _startupDelayComplete = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) setState(() => _startupDelayComplete = true);
    });
    widget.initialAppearance?.then((mode) {
      if (mounted && !_changedAppearance) setState(() => _appearance = mode);
    });
  }

  Future<void> _setAppearance(ThemeMode mode) async {
    setState(() {
      _changedAppearance = true;
      _appearance = mode;
    });
    await widget.persistAppearance?.call(mode);
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Expat Manager',
    locale: const Locale('ar'),
    supportedLocales: const [Locale('ar')],
    localizationsDelegates: const [
      LatinArabicLocalizationsDelegate(),
      ...GlobalMaterialLocalizations.delegates,
    ],
    theme: expatTheme(Brightness.light),
    darkTheme: expatTheme(Brightness.dark),
    themeMode: _appearance,
    home: FutureBuilder(
      future: widget.ledger,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'تعذّر فتح البيانات المشفّرة. يمكنك إعادة فتح التطبيق أو الاستعادة من نسخة محفوظة.',
                      ),
                      if (widget.openBackup != null)
                        OutlinedButton(
                          onPressed: () => Navigator.push<void>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const BackupScreen(),
                            ),
                          ),
                          child: const Text('استعادة من نسخة مشفّرة'),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return snapshot.hasData && _startupDelayComplete
            ? FinanceHome(
                ledger: snapshot.data!,
                openBackup: widget.openBackup,
                appearance: _appearance,
                onAppearance: _setAppearance,
              )
            : Scaffold(
                body: SafeArea(
                  child: Stack(
                    children: [
                      const Center(child: CircularProgressIndicator()),
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 28,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Expat Manager v0.1.1',
                              textDirection: TextDirection.ltr,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '© Karim S.K. Morsi 2026',
                              textDirection: TextDirection.ltr,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
      },
    ),
  );
}
