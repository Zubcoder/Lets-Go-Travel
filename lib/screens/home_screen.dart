import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/analytics_service.dart';
import 'ai_planner_screen.dart';
import 'flights_screen.dart';
import 'hotels_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final _screens = const [
    AiPlannerScreen(),
    FlightsScreen(),
    HotelsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: theme.dividerColor, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) {
            const tabNames = ['ai_planner', 'flights', 'hotels', 'settings'];
            AnalyticsService.tabChanged(tabNames[i]);
            setState(() => _currentIndex = i);
          },
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.auto_awesome_outlined),
              activeIcon: const Icon(Icons.auto_awesome),
              label: l10n.aiPlanner,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.flight_outlined),
              activeIcon: const Icon(Icons.flight),
              label: l10n.flights,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.hotel_outlined),
              activeIcon: const Icon(Icons.hotel),
              label: l10n.hotels,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings_outlined),
              activeIcon: const Icon(Icons.settings),
              label: l10n.settings,
            ),
          ],
        ),
      ),
    );
  }
}
