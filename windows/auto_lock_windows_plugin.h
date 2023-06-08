#ifndef FLUTTER_PLUGIN_AUTO_LOCK_WINDOWS_PLUGIN_H_
#define FLUTTER_PLUGIN_AUTO_LOCK_WINDOWS_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace auto_lock_windows {

class AutoLockWindowsPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  AutoLockWindowsPlugin();

  virtual ~AutoLockWindowsPlugin();

  // Disallow copy and assign.
  AutoLockWindowsPlugin(const AutoLockWindowsPlugin&) = delete;
  AutoLockWindowsPlugin& operator=(const AutoLockWindowsPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace auto_lock_windows

#endif  // FLUTTER_PLUGIN_AUTO_LOCK_WINDOWS_PLUGIN_H_
