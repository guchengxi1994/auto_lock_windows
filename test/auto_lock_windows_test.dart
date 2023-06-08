import 'package:flutter_test/flutter_test.dart';
import 'package:auto_lock_windows/auto_lock_windows.dart';
import 'package:auto_lock_windows/auto_lock_windows_platform_interface.dart';
import 'package:auto_lock_windows/auto_lock_windows_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAutoLockWindowsPlatform
    with MockPlatformInterfaceMixin
    implements AutoLockWindowsPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future lockScreen() {
    // TODO: implement lockScreen
    throw UnimplementedError();
  }

  @override
  Future sleepWindows() {
    // TODO: implement sleepWindows
    throw UnimplementedError();
  }

  @override
  Future<int> getLastInputDuration() {
    // TODO: implement getLastInputDuration
    throw UnimplementedError();
  }
}

void main() {
  final AutoLockWindowsPlatform initialPlatform =
      AutoLockWindowsPlatform.instance;

  test('$MethodChannelAutoLockWindows is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAutoLockWindows>());
  });

  test('getPlatformVersion', () async {
    AutoLockWindows autoLockWindowsPlugin = AutoLockWindows();
    MockAutoLockWindowsPlatform fakePlatform = MockAutoLockWindowsPlatform();
    AutoLockWindowsPlatform.instance = fakePlatform;

    expect(await autoLockWindowsPlugin.getPlatformVersion(), '42');
  });
}
