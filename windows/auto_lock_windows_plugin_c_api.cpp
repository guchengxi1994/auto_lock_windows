#include "include/auto_lock_windows/auto_lock_windows_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "auto_lock_windows_plugin.h"

void AutoLockWindowsPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  auto_lock_windows::AutoLockWindowsPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
