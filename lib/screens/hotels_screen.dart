import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/search_provider.dart';
import '../utils/constants.dart';
import '../widgets/hotel_card.dart';

class HotelsScreen extends StatefulWidget {
  const HotelsScreen({super.key});

  @override
  State<HotelsScreen> createState() => _HotelsScreenState();
}

class _HotelsScreenState extends State<HotelsScreen> {
  final _locationController = TextEditingController();
  DateTime? _checkIn;
  DateTime? _checkOut;
  int _guests = 1;

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkIn = picked;
        } else {
          _checkOut = picked;
        }
      });
    }
  }

  void _search() {
    if (_locationController.text.isEmpty) return;
    if (_checkIn == null || _checkOut == null) return;

    context.read<SearchProvider>().searchHotels(
          location: _locationController.text.trim(),
          checkIn:
              '${_checkIn!.year}-${_checkIn!.month.toString().padLeft(2, '0')}-${_checkIn!.day.toString().padLeft(2, '0')}',
          checkOut:
              '${_checkOut!.year}-${_checkOut!.month.toString().padLeft(2, '0')}-${_checkOut!.day.toString().padLeft(2, '0')}',
          guests: _guests,
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
      appBar: AppBar(title: Text(l10n.searchHotels)),
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
                      controller: _locationController,
                      decoration: InputDecoration(
                        labelText: l10n.to,
                        prefixIcon: const Icon(Icons.location_on),
                        hintText: 'Сочи',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _DateTile(
                            label: l10n.checkIn,
                            value: _formatDate(_checkIn),
                            onTap: () => _selectDate(context, true),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _DateTile(
                            label: l10n.checkOut,
                            value: _formatDate(_checkOut),
                            onTap: () => _selectDate(context, false),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.guests, style: theme.textTheme.bodyMedium),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: _guests > 1
                                  ? () => setState(() => _guests--)
                                  : null,
                            ),
                            Text('$_guests',
                                style: theme.textTheme.titleMedium),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: _guests < 10
                                  ? () => setState(() => _guests++)
                                  : null,
                            ),
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
                        label: Text(l10n.searchHotelsButton),
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
                        ],
                      ),
                    ),
                  );
                }
                if (provider.hotels.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.hotel,
                              size: 64,
                              color: AppColors.accent.withValues(alpha: 0.3)),
                          const SizedBox(height: 16),
                          Text(l10n.bestDeals,
                              style: theme.textTheme.titleLarge),
                        ],
                      ),
                    ),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.bestDeals, style: theme.textTheme.titleLarge),
                    const SizedBox(height: 12),
                    ...provider.hotels.map((h) => HotelCard(hotel: h)),
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
