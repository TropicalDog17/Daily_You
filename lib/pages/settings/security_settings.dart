import 'package:daily_you/config_provider.dart';
import 'package:daily_you/device_info_service.dart';
import 'package:daily_you/widgets/auth_popup.dart';
import 'package:daily_you/widgets/settings_icon_action.dart';
import 'package:daily_you/widgets/settings_page_shell.dart';
import 'package:daily_you/widgets/settings_section.dart';
import 'package:daily_you/widgets/settings_toggle.dart';
import 'package:flutter/material.dart';
import 'package:daily_you/l10n/generated/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

class SecuritySettings extends StatefulWidget {
  const SecuritySettings({super.key});

  @override
  State<SecuritySettings> createState() => SecuritySettingsPageState();
}

class SecuritySettingsPageState extends State<SecuritySettings> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final configProvider = Provider.of<ConfigProvider>(context);
    final LocalAuthentication auth = LocalAuthentication();
    final l10n = AppLocalizations.of(context)!;

    return SettingsPageShell(
      title: l10n.settingsSecurityTitle,
      child: ListView(
        children: [
          SettingsSection(
            children: [
              SettingsToggle(
                title: l10n.settingsSecurityRequirePassword,
                settingsKey: ConfigKey.requirePassword,
                onChanged: (value) async {
                  if (!configProvider.get(ConfigKey.requirePassword)) {
                    bool setPassword = false;
                    await showDialog(
                      context: context,
                      builder: (context) => AuthPopup(
                        mode: AuthPopupMode.setPassword,
                        title: l10n.settingsSecuritySetPassword,
                        showBiometrics: false,
                        dismissable: true,
                        onSuccess: () {
                          setPassword = true;
                        },
                      ),
                    );
                    await configProvider.set(
                      ConfigKey.requirePassword,
                      setPassword,
                    );
                  } else {
                    await showDialog(
                      context: context,
                      builder: (context) => AuthPopup(
                        mode: AuthPopupMode.unlock,
                        title: l10n.settingsSecurityEnterPassword,
                        showBiometrics: false,
                        dismissable: true,
                        onSuccess: () {
                          configProvider.set(ConfigKey.requirePassword, false);
                        },
                      ),
                    );
                  }
                },
              ),
              if (configProvider.get(ConfigKey.requirePassword))
                SettingsIconAction(
                  title: l10n.settingsSecurityChangePassword,
                  icon: const Icon(Icons.edit_rounded),
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) => AuthPopup(
                        mode: AuthPopupMode.changePassword,
                        title: l10n.settingsSecurityChangePassword,
                        showBiometrics: false,
                        dismissable: true,
                        onSuccess: () {},
                      ),
                    );
                  },
                ),
              if (configProvider.get(ConfigKey.requirePassword) &&
                  (DeviceInfoService().supportsBiometrics ?? false))
                SettingsToggle(
                  title: l10n.settingsSecurityBiometricUnlock,
                  settingsKey: ConfigKey.biometricUnlock,
                  onChanged: (value) async {
                    await showDialog(
                      context: context,
                      builder: (context) => AuthPopup(
                        mode: AuthPopupMode.unlock,
                        title: l10n.settingsSecurityEnterPassword,
                        showBiometrics: false,
                        dismissable: true,
                        onSuccess: () async {
                          var success = true;
                          if (value == true) {
                            try {
                              final didAuthenticate = await auth.authenticate(
                                options: const AuthenticationOptions(
                                  stickyAuth: false,
                                  biometricOnly: true,
                                ),
                                localizedReason: l10n.unlockAppPrompt,
                              );
                              success = didAuthenticate;
                            } on PlatformException {
                              success = false;
                            }
                          }

                          if (success) {
                            configProvider.set(
                              ConfigKey.biometricUnlock,
                              value,
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
