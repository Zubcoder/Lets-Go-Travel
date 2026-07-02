import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations.dart';
import '../models/flight.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class FlightCard extends StatelessWidget {
  final Flight flight;

  const FlightCard({super.key, required this.flight});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (flight.link.isNotEmpty) {
            launchUrl(Uri.parse(flight.link));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        flight.origin,
                        style: theme.textTheme.titleLarge,
                      ),
                      Text(flight.originCity,
                          style: theme.textTheme.bodySmall),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.flight,
                          color: AppColors.primary, size: 28),
                      Text(
                        flight.transfers == 0
                            ? l10n.direct
                            : l10n.withStops(flight.transfers),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        flight.destination,
                        style: theme.textTheme.titleLarge,
                      ),
                      Text(flight.destinationCity,
                          style: theme.textTheme.bodySmall),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(flight.airline,
                          style: theme.textTheme.bodyMedium),
                      const SizedBox(width: 8),
                      Text(flight.flightNumber,
                          style: theme.textTheme.bodySmall),
                    ],
                  ),
                  Text(
                    AppHelpers.formatPrice(flight.price),
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
