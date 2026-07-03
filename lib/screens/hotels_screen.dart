import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations.dart';
import '../utils/constants.dart';

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

  static const _cityEn = <String, String>{
    'москва': 'Moscow', 'сочи': 'Sochi', 'санкт-петербург': 'Saint-Petersburg',
    'казань': 'Kazan', 'калининград': 'Kaliningrad', 'анталья': 'Antalya',
    'анталия': 'Antalya', 'стамбул': 'Istanbul', 'дубай': 'Dubai',
    'тбилиси': 'Tbilisi', 'париж': 'Paris', 'рим': 'Rome',
    'барселона': 'Barcelona', 'прага': 'Prague', 'бали': 'Bali',
    'пхукет': 'Phuket', 'хургада': 'Hurghada', 'ереван': 'Yerevan',
    'баку': 'Baku', 'бангкок': 'Bangkok', 'минводы': 'Mineralnye-Vody',
  };

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

    final city = _locationController.text.trim();
    final cityEn = _cityEn[city.toLowerCase()] ?? city;
    final checkIn = '${_checkIn!.year}-${_checkIn!.month.toString().padLeft(2, '0')}-${_checkIn!.day.toString().padLeft(2, '0')}';
    final checkOut = '${_checkOut!.year}-${_checkOut!.month.toString().padLeft(2, '0')}-${_checkOut!.day.toString().padLeft(2, '0')}';

    final url = 'https://search.hotellook.com/hotels'
        '?destination=${Uri.encodeComponent(cityEn)}'
        '&checkIn=$checkIn&checkOut=$checkOut'
        '&adults=$_guests&marker=${AppConstants.marker}';

    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
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
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.hotel,
                        size: 64,
                        color: AppColors.accent.withValues(alpha: 0.3)),
                    const SizedBox(height: 16),
                    Text('Поиск откроет Hotellook\nс актуальными ценами',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(
                            color: AppColors.textSecondary)),
                  ],
                ),
              ),
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
