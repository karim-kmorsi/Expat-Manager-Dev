# Expat Manager

Expat Manager is an Arabic-first Android app for managing personal expatriate affairs locally and offline. The user defines the rules for personal leave planning and entitlements. The v0.1 technical baseline has conditional feasibility acceptance. Product implementation follows the applicable planning gate and a separate authorization.

- [Requirements](docs/REQUIREMENTS.md) and [decisions](docs/DECISIONS.md)
- [Architecture](docs/ARCHITECTURE.md), [security](docs/SECURITY.md) and [acceptance scenarios](docs/ACCEPTANCE.md)
- [Tested toolchain and T-006 evidence](docs/TOOLCHAIN.md)
- [Roadmap and finance-first plan](planning/ROADMAP.md) and [task references](planning/tasks.csv)

## Financial foundation (T-008)

Use the pinned Android setup in [Toolchain](docs/TOOLCHAIN.md). Run `flutter pub get`, `dart run build_runner build` when the Drift schema changes, and `flutter analyze`. The generated Drift source and dependency lockfile are versioned.

Run `flutter test test` for the ledger tests and `flutter test -d <device> integration_test/android_ledger_test.dart` on a dedicated Android test installation. The device test writes synthetic accounts to that installation. `flutter build apk --release --target-platform=android-arm64,android-x64` produces a local, unsigned release-mode APK.

The first slice provides an Arabic account and journal interface, optional opening balances and same-currency transfers. The ledger also exposes basic linked reversals and corrections for posted movements. Statement reconciliation and its effective-date policy are outside this slice.
