import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations.dart';
import '../utils/constants.dart';

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

  static const _cityIata = <String, String>{
    'москва': 'MOW', 'санкт-петербург': 'LED', 'питер': 'LED',
    'сочи': 'AER', 'адлер': 'AER', 'казань': 'KZN',
    'калининград': 'KGD', 'минводы': 'MRV', 'минеральные воды': 'MRV',
    'новосибирск': 'OVB', 'екатеринбург': 'SVX', 'красноярск': 'KJA',
    'владивосток': 'VVO', 'иркутск': 'IKT', 'уфа': 'UFA',
    'самара': 'KUF', 'пермь': 'PEE', 'махачкала': 'MCX',
    'анталья': 'AYT', 'анталия': 'AYT', 'стамбул': 'IST',
    'дубай': 'DXB', 'тбилиси': 'TBS', 'ереван': 'EVN',
    'баку': 'GYD', 'бангкок': 'BKK', 'пхукет': 'HKT', 'бали': 'DPS',
    'париж': 'PAR', 'рим': 'ROM', 'барселона': 'BCN',
    'прага': 'PRG', 'хургада': 'HRG',
  };

  String _resolveIata(String city) {
    final clean = city.trim().toLowerCase();
    return _cityIata[clean] ?? city.trim().toUpperCase();
  }

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

    final originIata = _resolveIata(_originController.text);
    final destIata = _resolveIata(_destController.text);
    final departStr = '${_departDate!.day.toString().padLeft(2, '0')}${_departDate!.month.toString().padLeft(2, '0')}';

    var searchPath = '$originIata$departStr$destIata';
    if (!_isOneWay && _returnDate != null) {
      final returnStr = '${_returnDate!.day.toString().padLeft(2, '0')}${_returnDate!.month.toString().padLeft(2, '0')}';
      searchPath += '$returnStr';
    }
    searchPath += '$_passengers';

    final url = 'https://www.aviasales.ru/search/$searchPath?marker=${AppConstants.marker}';
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
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.flight,
                        size: 64,
                        color: AppColors.primary.withValues(alpha: 0.3)),
                    const SizedBox(height: 16),
                    Text('Поиск откроет Aviasales\nс актуальными ценами',
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
