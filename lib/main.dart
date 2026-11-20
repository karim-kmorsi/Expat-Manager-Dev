import 'package:material_ui/material_ui.dart';

import 'data/android_storage.dart';
import 'data/ledger_backup.dart';
import 'finance/ledger.dart';
import 'ui/finance_home.dart';
import 'ui/backup_screen.dart';
import 'ui/localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final database = openAndroidLedger();
  runApp(
    ExpatManager(
      ledger: database.then(Ledger.new),
      openBackup: () async => androidLedgerBackup(await database),
    ),
  );
}

class ExpatManager extends StatelessWidget {
  const ExpatManager({required this.ledger, this.openBackup, super.key});

  final Future<Ledger> ledger;
  final Future<LedgerBackup> Function()? openBackup;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Expat Manager',
    locale: const Locale('ar'),
    supportedLocales: const [Locale('ar')],
    localizationsDelegates: const [
      LatinArabicLocalizationsDelegate(),
      ...GlobalMaterialLocalizations.delegates,
    ],
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff1a6653)),
    ),
    home: FutureBuilder(
      future: ledger,
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
                      if (openBackup != null)
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
            ? FinanceHome(ledger: snapshot.data!, openBackup: openBackup)
            : const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    ),
  );
}
