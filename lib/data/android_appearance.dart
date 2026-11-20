import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

const _appearance = MethodChannel('com.karimkmorsi.expat_manager/appearance');

Future<ThemeMode> loadAppearance() async {
  try {
    return switch (await _appearance.invokeMethod<String>('read')) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  } on PlatformException {
    return ThemeMode.system;
  }
}

Future<void> saveAppearance(ThemeMode mode) =>
    _appearance.invokeMethod<void>('write', mode.name);
