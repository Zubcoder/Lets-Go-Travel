import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';
import '../services/ai_service.dart';
import '../services/analytics_service.dart';
import '../utils/constants.dart';

class AiPlannerScreen extends StatefulWidget {
  const AiPlannerScreen({super.key});

  @override
  State<AiPlannerScreen> createState() => _AiPlannerScreenState();
}

class _AiPlannerScreenState extends State<AiPlannerScreen> {
  final _queryController = TextEditingController();
  final AiService _aiService = AiService();
  String? _result;
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  Future<void> _planTrip() async {
    if (_queryController.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _result = null;
    });

    AnalyticsService.aiPlannerUsed();

    try {
      final locale = context.read<LocaleProvider>().locale.languageCode;
      final result = await _aiService.planTrip(
        query: _queryController.text.trim(),
        locale: locale,
      );
      setState(() => _result = result);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.aiPlannerTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.auto_awesome,
                              color: AppColors.primary),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.aiPlannerTitle,
                                style: theme.textTheme.titleLarge,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Умный помощник в путешествии',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.accent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _queryController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: l10n.aiPlannerHint,
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.aiPlannerExample,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _planTrip,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.textPrimary,
                                ),
                              )
                            : const Icon(Icons.auto_awesome),
                        label: Text(
                            _isLoading ? l10n.generating : l10n.planTrip),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_error != null)
              Card(
                color: AppColors.error.withValues(alpha: 0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.error),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n.error,
                          style: const TextStyle(color: AppColors.error),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (_result != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: MarkdownBody(
                    data: _result!,
                    styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                      p: theme.textTheme.bodyLarge,
                      h1: theme.textTheme.headlineMedium,
                      h2: theme.textTheme.titleLarge,
                      h3: theme.textTheme.titleMedium,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
