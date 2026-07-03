import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final sections = [
      (l10n.termsSection1Title, l10n.termsSection1Body),
      (l10n.termsSection2Title, l10n.termsSection2Body),
      (l10n.termsSection3Title, l10n.termsSection3Body),
      (l10n.termsSection4Title, l10n.termsSection4Body),
      (l10n.termsSection5Title, l10n.termsSection5Body),
      (l10n.termsSection6Title, l10n.termsSection6Body),
      (l10n.termsSection7Title, l10n.termsSection7Body),
      (l10n.termsSection8Title, l10n.termsSection8Body),
      (l10n.termsSection9Title, l10n.termsSection9Body),
      (l10n.termsSection10Title, l10n.termsSection10Body),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.termsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.termsLastUpdated,
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
