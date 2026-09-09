import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../state/locale_controller.dart';
import 'athkar/athkar_screen.dart';
import 'chat/chat_screen.dart';
import 'prayer_times/prayer_times_screen.dart';
import 'qibla/qibla_screen.dart';

/// Root scaffold: one shared app bar + bottom navigation across the app's
/// four main sections. The chatbot is the first tab, i.e. the app's home.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.localeController});

  final LocaleController localeController;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  // Only the tabs the user has actually opened are built. This matters
  // because Prayer Times and Qibla request location permission and Athkar
  // makes a network call as soon as their screen initializes - none of
  // that should happen at app launch just because IndexedStack would
  // otherwise build every tab up front.
  final _visited = <int>{0};

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final titles = [
      l10n.chatTitle,
      l10n.prayerTimesTitle,
      l10n.qiblaTitle,
      l10n.athkarTitle,
    ];

    final screens = const [
      ChatScreen(),
      PrayerTimesScreen(),
      QiblaScreen(),
      AthkarScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_index]),
        actions: [
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language),
            tooltip: l10n.settingsLanguage,
            onSelected: widget.localeController.setLocale,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: const Locale('ar'),
                child: Text(l10n.settingsLanguageArabic),
              ),
              PopupMenuItem(
                value: const Locale('en'),
                child: Text(l10n.settingsLanguageEnglish),
              ),
            ],
          ),
        ],
      ),
      body: IndexedStack(
        index: _index,
        children: [
          for (var i = 0; i < screens.length; i++)
            if (_visited.contains(i)) screens[i] else const SizedBox.shrink(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() {
          _index = i;
          _visited.add(i);
        }),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.chat_bubble_outline),
            selectedIcon: const Icon(Icons.chat_bubble),
            label: l10n.navChat,
          ),
          NavigationDestination(
            icon: const Icon(Icons.access_time_outlined),
            selectedIcon: const Icon(Icons.access_time_filled),
            label: l10n.navPrayerTimes,
          ),
          NavigationDestination(
            icon: const Icon(Icons.explore_outlined),
            selectedIcon: const Icon(Icons.explore),
            label: l10n.navQibla,
          ),
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: const Icon(Icons.menu_book),
            label: l10n.navAthkar,
          ),
        ],
      ),
    );
  }
}
