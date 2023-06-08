import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:ffi' as ffi;

import 'auto_lock_windows_platform_interface.dart';

typedef CFunc = ffi.Void Function();
typedef Func = void Function();

typedef CIntFunc = ffi.Int Function();
typedef IntFunc = int Function();

/// An implementation of [AutoLockWindowsPlatform] that uses method channels.
class MethodChannelAutoLockWindows extends AutoLockWindowsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('auto_lock_windows');

  static final ffi.DynamicLibrary _lib =
      ffi.DynamicLibrary.open("auto_lock_windows_plugin.dll");

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<int> getLastInputDuration() async {
    IntFunc func = _lib
        .lookup<ffi.NativeFunction<CIntFunc>>("get_last_input_duration")
        .asFunction();
    final r = func();
    debugPrint("[duration] : $r sec");
    return r;
  }

  @override
  Future lockScreen() async {
    Func func =
        _lib.lookup<ffi.NativeFunction<CFunc>>("lock_screen").asFunction();
    func();
  }

  @override
  Future sleepWindows() async {
    Func func =
        _lib.lookup<ffi.NativeFunction<CFunc>>("sleep_windows").asFunction();
    func();
  }
}
