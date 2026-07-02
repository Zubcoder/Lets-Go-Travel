import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/search_provider.dart';
import '../utils/constants.dart';
import '../widgets/flight_card.dart';

class FlightsScreen extends StatefulWidget {
  const FlightsScreen({super.key});

  @override
  State<FlightsScreen> createState() => _FlightsScreenState();
}

class _FlightsScreenState extends State<FlightsScreen> {
  final _originController = TextEditingController();
  final _destController = TextEditingController();
  DateTime? _departDate;
  DateTime? _returnDate;
  bool _isOneWay = false;
  int _passengers = 1;

  @override
  void dispose() {
    _originController.dispose();
    _destController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isDeparture) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isDeparture) {
          _departDate = picked;
        } else {
          _returnDate = picked;
        }
      });
    }
  }

  void _search() {
    if (_originController.text.isEmpty || _destController.text.isEmpty) return;
    if (_departDate == null) return;

    context.read<SearchProvider>().searchFlights(
          origin: _originController.text.trim(),
          destination: _destController.text.trim(),
          departDate:
              '${_departDate!.year}-${_departDate!.month.toString().padLeft(2, '0')}-${_departDate!.day.toString().padLeft(2, '0')}',
          returnDate: _isOneWay || _returnDate == null
              ? null
              : '${_returnDate!.year}-${_returnDate!.month.toString().padLeft(2, '0')}-${_returnDate!.day.toString().padLeft(2, '0')}',
          passengers: _passengers,
        );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '—';
    return '${date.day}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.searchFlights)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _originController,
                      decoration: InputDecoration(
                        labelText: l10n.from,
                        prefixIcon: const Icon(Icons.flight_takeoff),
                        hintText: 'MOW',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _destController,
                      decoration: InputDecoration(
                        labelText: l10n.to,
                        prefixIcon: const Icon(Icons.flight_land),
                        hintText: 'AER',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _DateTile(
                            label: l10n.departureDate,
                            value: _formatDate(_departDate),
                            onTap: () => _selectDate(context, true),
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (!_isOneWay)
                          Expanded(
                            child: _DateTile(
                              label: l10n.returnDate,
                              value: _formatDate(_returnDate),
                              onTap: () => _selectDate(context, false),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Switch(
                                value: _isOneWay,
                                onChanged: (v) =>
                                    setState(() => _isOneWay = v),
                                activeTrackColor: AppColors.primary,
                              ),
                              Flexible(
                                child: Text(
                                  l10n.oneWay,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: _passengers > 1
                                  ? () =>
                                      setState(() => _passengers--)
                                  : null,
                            ),
                            Text('$_passengers',
                                style: theme.textTheme.titleMedium),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: _passengers < 9
                                  ? () =>
                                      setState(() => _passengers++)
                                  : null,
                            ),
                            Icon(Icons.person,
                                color: AppColors.textSecondary, size: 20),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _search,
                        icon: const Icon(Icons.search),
                        label: Text(l10n.searchButton),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Consumer<SearchProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (provider.error != null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(Icons.error_outline,
                              size: 48, color: AppColors.error),
                          const SizedBox(height: 8),
                          Text(l10n.error,
                              style: theme.textTheme.titleMedium),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: _search,
                            child: Text(l10n.retry),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                if (provider.flights.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.flight,
                              size: 64,
                              color: AppColors.primary.withValues(alpha: 0.3)),
                          const SizedBox(height: 16),
                          Text(
                            l10n.cheapestFlights,
                            style: theme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.popularDirections,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.cheapestFlights,
                        style: theme.textTheme.titleLarge),
                    const SizedBox(height: 12),
                    ...provider.flights
                        .map((f) => FlightCard(flight: f)),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DateTile extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _DateTile({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: theme.inputDecorationTheme.fillColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: theme.textTheme.bodySmall),
            const SizedBox(height: 4),
            Text(value, style: theme.textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
