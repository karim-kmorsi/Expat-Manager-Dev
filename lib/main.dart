import 'package:material_ui/material_ui.dart';

import 'data/android_storage.dart';
import 'data/android_appearance.dart';
import 'data/ledger_backup.dart';
import 'finance/ledger.dart';
import 'ui/finance_home.dart';
import 'ui/backup_screen.dart';
import 'ui/app_theme.dart';
import 'ui/localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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

  @override
  void initState() {
    super.initState();
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
        return snapshot.hasData
            ? FinanceHome(
                ledger: snapshot.data!,
                openBackup: widget.openBackup,
                appearance: _appearance,
                onAppearance: _setAppearance,
              )
            : const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    ),
  );
}
