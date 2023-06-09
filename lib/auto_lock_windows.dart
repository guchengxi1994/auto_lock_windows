import 'auto_lock_windows_platform_interface.dart';

class AutoLockWindows {
  Future<String?> getPlatformVersion() {
    return AutoLockWindowsPlatform.instance.getPlatformVersion();
  }

  Future lockScreen() async {
    return AutoLockWindowsPlatform.instance.lockScreen();
  }

  Future sleepWindows() async {
    return AutoLockWindowsPlatform.instance.sleepWindows();
  }

  Future<int> getDuration() async {
    return AutoLockWindowsPlatform.instance.getLastInputDuration();
  }

  Future playSound() async {
    return AutoLockWindowsPlatform.instance.playSound();
  }
}
