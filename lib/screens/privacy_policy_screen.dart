import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final sections = [
      (l10n.privacySection1Title, l10n.privacySection1Body),
      (l10n.privacySection2Title, l10n.privacySection2Body),
      (l10n.privacySection3Title, l10n.privacySection3Body),
      (l10n.privacySection4Title, l10n.privacySection4Body),
      (l10n.privacySection5Title, l10n.privacySection5Body),
      (l10n.privacySection6Title, l10n.privacySection6Body),
      (l10n.privacySection7Title, l10n.privacySection7Body),
      (l10n.privacySection8Title, l10n.privacySection8Body),
      (l10n.privacySection9Title, l10n.privacySection9Body),
      (l10n.privacySection10Title, l10n.privacySection10Body),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.privacyPolicyTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.privacyLastUpdated,
              style: theme.textTheme.bodySmall
                  ?.copyWith(fontStyle: FontStyle.italic)),
          const SizedBox(height: 16),
          for (final (title, body) in sections) ...[
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(body, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}
