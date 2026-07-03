import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/constants.dart';
import '../widgets/cross_promo_widget.dart';
import 'onboarding_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Column(
              children: [
                Consumer<LocaleProvider>(
                  builder: (context, localeProv, _) {
                    return ListTile(
                      leading: const Icon(Icons.language),
                      title: Text(l10n.language),
                      trailing: DropdownButton<String>(
                        value: localeProv.locale.languageCode,
                        underline: const SizedBox(),
                        items: const [
                          DropdownMenuItem(
                              value: 'ru', child: Text('Русский')),
                          DropdownMenuItem(
                              value: 'en', child: Text('English')),
                        ],
                        onChanged: (code) {
                          if (code != null) {
                            localeProv.setLocale(Locale(code));
                          }
                        },
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                Consumer<ThemeProvider>(
                  builder: (context, themeProv, _) {
                    return ListTile(
                      leading: const Icon(Icons.dark_mode),
                      title: Text(l10n.theme),
                      trailing: DropdownButton<ThemeMode>(
                        value: themeProv.themeMode,
                        underline: const SizedBox(),
                        items: [
                          DropdownMenuItem(
                            value: ThemeMode.dark,
                            child: Text(l10n.darkTheme),
                          ),
                          DropdownMenuItem(
                            value: ThemeMode.light,
                            child: Text(l10n.lightTheme),
                          ),
                          DropdownMenuItem(
                            value: ThemeMode.system,
                            child: Text(l10n.systemTheme),
                          ),
                        ],
                        onChanged: (mode) {
                          if (mode != null) {
                            themeProv.setThemeMode(mode);
                          }
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: Text(l10n.howToUse),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const OnboardingScreen(isFromSettings: true),
                    ),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.mail_outline),
                  title: Text(l10n.support),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => launchUrl(Uri.parse(
                      'mailto:${AppConstants.supportEmail}?subject=${Uri.encodeComponent("${AppConstants.appName} v${AppConstants.appVersion} — Обратная связь")}')),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.star_outline),
                  title: Text(l10n.rateApp),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => launchUrl(Uri.parse(
                      'https://apps.rustore.ru/app/com.zubcoder.letiumno')),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.shield_outlined),
                  title: Text(l10n.privacyPolicy),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const PrivacyPolicyScreen()),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: Text(l10n.termsOfService),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TermsScreen()),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(l10n.version),
                  trailing: Text(
                    AppConstants.appVersion,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const CrossPromoWidget(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
