# Personal v0.1 release candidate

## Release notes

- Export an encrypted ledger backup through Android's local document picker. Restore with a password, a preview and explicit confirmation. The app can recover into a separate encrypted vault when the active vault cannot be unlocked.
- The Arabic dashboard groups accounts, remittances, leave, entitlements and gold. The app supports light and dark themes and follows the device appearance by default. The salary calculator dismisses the keyboard when expanding its exchange and fee panels.
- Finance, leave, entitlements and gold retain the existing schema and calculations. The candidate uses ledger schema 9 and APK version 0.1.0 (code 2).

## Privacy and licenses (T-018)

- The production manifest does not request internet or general storage access. Android debug and profile builds allow Flutter's development connection. The picker transfers only the encrypted file through the user's selected local document provider.
- Ledger files, wrapped keys, staging and rollback copies remain under Android's private no-backup directory. Android automatic backup is disabled. The only new preference records the appearance setting. The backup password prompt suppresses screenshots, suggestions and keyboard learning inside the app.
- Reviewed product logging and tracked artifact paths. The app has no telemetry, crash-reporting integration, bank login or cloud-sync service. Backup errors avoid exposing input, passwords and SQL diagnostics.
- Flutter packages and their notices are pinned through `pubspec.lock`. Drift and the Dart SQLite binding use MIT. Flutter, material_ui and intl include BSD notices. sodium includes its BSD notice and libsodium's ISC notice. The pinned native SQLite3MultipleCiphers library uses MIT and its upstream license is bundled and registered in the in-app licenses screen. [SQLite3MultipleCiphers v2.6.1 license](https://github.com/utelle/SQLite3MultipleCiphers/blob/v2.6.1/LICENSE)
- The locally signed candidate uses the existing test certificate for upgrade compatibility. Its key is external to the repository. The project license and a distribution signing policy remain separate decisions.

## Verification and physical acceptance (T-019)

- All 105 local tests pass. Analysis and `git diff --check` pass. Local verification covers existing features, Arabic RTL appearance, keyboard behavior, encrypted restores to empty and populated databases, schemas 1–9, corrupted and unsupported input, and process termination both before and after the restore commit.
- On the isolated Android 15 x86_64 emulator with no default network, verified export and import through the actual document picker, wrong-password rejection, confirmed replacement of synthetic data, recovery into a fresh vault after simulated loss of the wrapped key, and reopening that vault. Reviewed both appearance settings and verified loading the saved mode in a widget test. A release-mode upgrade on the emulator reopened the recovered test account and exposed the backup and licenses screens. The emulator disconnected during the additional cold-restart check of the appearance preference in the release APK.
- The prior REDMAGIC 10 Pro acceptance covers salary allocation at the main baseline. This candidate needs a new physical acceptance pass. Before installing, match the package, version and certificate with the installed app and verify that an in-place upgrade is available. Keep the phone's existing records and avoid app removal or clear-data.
- For the physical pass, verify current finance, leave, entitlements and gold records before and after upgrade. Check Arabic forms, RTL, both appearances, scrolling with the keyboard, and offline operation. Exercise export and a full round-trip with synthetic records in a separate test vault. Test password rejection and interrupted restore in that isolated data set. Native 16 KiB execution requires a device that reports 16384-byte pages.

## Build (T-020)

Use the pinned toolchain and lockfile from the repository. Allow the release command to regenerate its plugin registrant so it excludes the debug integration-test plugin. Build the local candidate with:

```sh
flutter build apk --release --target-platform=android-arm64,android-x64 --build-name=0.1.0 --build-number=2
```

Sign the APK separately with the authorized upgrade-compatible certificate. Verify certificate, APK hash, application ID, version and native library alignment before installing. The candidate is intended for review and testing. Publication and merging require separate approval.

The checked local artifact is `build/personal-v01/Expat-Manager-0.1.0-2-personal.apk`. Its SHA-256 is `d9e691b1478bea0e82b78481468d8f9efb00b61a14c60d91c6a98544af90313a`. It contains ARM64 and x86_64 binaries. ZIP and ELF segment alignment passed 16 KiB checks. The release manifest requests only the AndroidX app-scoped receiver permission. The locally signed artifact matches the certificate recorded for the prior phone APK.

The physical acceptance for this candidate remains pending. T-016 portfolio snapshots, publication and changing the permanent signing policy are outside this implementation.
