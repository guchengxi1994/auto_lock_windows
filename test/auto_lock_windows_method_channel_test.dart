import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:auto_lock_windows/auto_lock_windows_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelAutoLockWindows platform = MethodChannelAutoLockWindows();
  const MethodChannel channel = MethodChannel('auto_lock_windows');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
