class AppStartupOverrides {
  bool skipDeviceInfoInit = false;
  bool skipNotificationInit = false;
  bool skipQuickActions = false;

  void reset() {
    skipDeviceInfoInit = false;
    skipNotificationInit = false;
    skipQuickActions = false;
  }
}

final appStartupOverrides = AppStartupOverrides();
