import 'package:material_ui/material_ui.dart';

import 'data/android_storage.dart';
import 'finance/ledger.dart';
import 'ui/finance_home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ExpatManager(ledger: openAndroidLedger().then(Ledger.new)));
}

class ExpatManager extends StatelessWidget {
  const ExpatManager({required this.ledger, super.key});

  final Future<Ledger> ledger;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Expat Manager',
    locale: const Locale('ar'),
    supportedLocales: const [Locale('ar')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff1a6653)),
    ),
    home: FutureBuilder(
      future: ledger,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Scaffold(
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'تعذّر فتح البيانات المشفّرة. أعد فتح التطبيق للمحاولة مجددًا.',
                  ),
                ),
              ),
            ),
          );
        }
        return snapshot.hasData
            ? FinanceHome(ledger: snapshot.data!)
            : const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    ),
  );
}
