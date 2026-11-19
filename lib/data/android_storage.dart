import 'dart:io';

import 'package:flutter/services.dart';

import 'database.dart';

const _storage = MethodChannel('com.karimkmorsi.expat_manager/storage');

Future<LedgerDatabase> openAndroidLedger() async {
  final storage = await _storage.invokeMapMethod<String, Object>('openLedger');
  if (storage case {'path': final String path, 'key': final Uint8List key}) {
    // Platform channel byte lists are not guaranteed to be writable.
    return LedgerDatabase.open(File(path), Uint8List.fromList(key));
  }
  throw const StorageLocked();
}
