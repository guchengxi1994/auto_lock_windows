import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'auto_lock_windows_method_channel.dart';

abstract class AutoLockWindowsPlatform extends PlatformInterface {
  /// Constructs a AutoLockWindowsPlatform.
  AutoLockWindowsPlatform() : super(token: _token);

  static final Object _token = Object();

  static AutoLockWindowsPlatform _instance = MethodChannelAutoLockWindows();

  /// The default instance of [AutoLockWindowsPlatform] to use.
  ///
  /// Defaults to [MethodChannelAutoLockWindows].
  static AutoLockWindowsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AutoLockWindowsPlatform] when
  /// they register themselves.
  static set instance(AutoLockWindowsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future lockScreen();

  Future sleepWindows();

  Future<int> getLastInputDuration();
}
