# T-006 tested Android toolchain

Owner disposition is **conditionally accepted** for the isolated probe. Product code and production-readiness approval are separate.

| Component | Verified baseline |
|---|---|
| Host | Ubuntu 24.04.5 LTS x86_64 |
| Flutter | Stable 3.50.0, framework revision `ab2912035e`. Official Linux archive SHA-256 `6ea2d806fd57269ae783e6788e2a81fc26eaad782f1e0d0ff38623bb765ff9f5` |
| Dart / ORM | Bundled Dart 3.14.0, Drift 2.35.4, sqlite3 3.9.1, drift_dev 2.35.3 and build_runner 2.17.1. Pub resolved without dependency overrides |
| Native storage / backup | SQLite3MultipleCiphers 2.6.1 via sqlite3 Native Assets, sodium 4.1.2+1 and libsodium 1.0.22. Both native versions reported by the running probe |
| Android | Platform 36 revision 2, compile/target SDK 36, minimum SDK 24, Build Tools 36.0.0, NDK 28.2.13676358 and Platform Tools 37.0.1 |
| JVM/build | OpenJDK 17.0.21.0.3 scoped to Flutter and Gradle, Gradle Wrapper 9.5.0 and AGP 9.3.1 |

## Product build security update

The product uses Gradle 9.9.1 with the official Wrapper JAR and a pinned SHA-256 for the binary distribution. This version addresses the Gradle advisories affecting the T-006 baseline. The table above records the original probe environment. [Gradle security advisory](https://github.com/gradle/gradle/security/advisories/GHSA-3cfg-jpcr-gfp3)

## Reviewed evidence

The external operator file `T-006-verification.txt` (2026-11-19, SHA-256 `b93312e217d705e44107381789a66477379b1ae5305faea6dc149efa2445e94f`) was checked against the raw probe logs. Release APK SHA-256 `140824c60fb99cab889321ac3c7663f3aff9bf64c9b39845e314a69c4c726cac` matched the local artifact. The evidence identifies the isolated workspace. Probe source, logs, database files and binaries are kept outside this repository.

| Result | Evidence and limit |
|---|---|
| PASS | `flutter doctor -v` approved Flutter and Android and confirmed JDK 17 and accepted SDK licenses. The logs show AGP 9.3.1 resolution and successful release build. Duplicate adb paths and desktop prerequisites were reported. Probe commands used the SDK adb |
| PASS | Pub resolution, Drift generation, Dart analysis and a widget test. The signed release APK had both ABIs. ELF load segments and APK entries passed 16 KB alignment checks |
| PASS | `api35-x64-4k-final` ran x86_64 on API 35 (4096-byte pages). `api36-x64-16k-b` ran x86_64 on API 36 (16384-byte pages). `api36-arm64-16k-a` ran an arm64 process via Native Bridge on the x86_64 API 36 emulator (16384-byte host pages) |
| PASS | Each final run ran offline, reopened encrypted USD/NPR/EGP data and rejected the wrong DB key and platform SQLite. Restored balances matched in a new database with a distinct key. Wrong backup password, modified and truncated ciphertext, failed writes and process termination before and after commit all preserved the expected complete state |
| FAIL, recovered | First device run failed when clearing a read-only MethodChannel byte view. The probe now clears a mutable copy. The rebuilt APK passed all three final runs |
| NOT TESTED | Physical arm64 hardware, native physical 16 KB execution, abrupt power loss, clean-install portability on a physical phone and full M3 recovery, migration and privacy coverage. The probe restored to a separate database in the same installation |

The probe needed the existing Android CLI explicitly selected, a probe-only definition for the 16 KB AVD and a local Flutter JDK setting. These fixes did not require a dependency version change. The product bootstrap should record its own locked build inputs and verification. Review probe code and library notices before any reuse.

MIT applies to Drift, sqlite3 and SQLite3MultipleCiphers. SQLite is in the public domain. sodium uses BSD-3-Clause and libsodium uses ISC. Confirm the complete dependency/license and notice inventory in T-018.

[Flutter Linux release manifest](https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json) · [Flutter 3.50.0 Android defaults](https://github.com/flutter/flutter/blob/3.50.0/packages/flutter_tools/lib/src/android/gradle_utils.dart) · [Drift encryption](https://drift.simonbinder.eu/platforms/encryption/) · [Android 16 KB guidance](https://developer.android.com/guide/practices/page-sizes)
