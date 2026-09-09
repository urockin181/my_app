import 'dart:async';

import 'package:adhan_dart/adhan_dart.dart' as adhan;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../services/location_service.dart';
import '../../services/prayer_times_service.dart';

enum _ScreenState { loading, needsPermission, serviceDisabled, denied, ready, error }

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  final _locationService = LocationService();
  final _prayerTimesService = PrayerTimesService();

  _ScreenState _state = _ScreenState.loading;
  adhan.PrayerTimes? _prayerTimes;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _load();
    _ticker = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _state = _ScreenState.loading);
    try {
      final result = await _locationService.getCurrentLocation();
      switch (result.outcome) {
        case LocationOutcome.serviceDisabled:
          setState(() => _state = _ScreenState.serviceDisabled);
          return;
        case LocationOutcome.permissionDenied:
          setState(() => _state = _ScreenState.denied);
          return;
        case LocationOutcome.granted:
          final position = result.position!;
          final times = _prayerTimesService.calculateForToday(
            latitude: position.latitude,
            longitude: position.longitude,
          );
          setState(() {
            _prayerTimes = times;
            _state = _ScreenState.ready;
          });
      }
    } catch (_) {
      setState(() => _state = _ScreenState.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    switch (_state) {
      case _ScreenState.loading:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(l10n.prayerLoading),
            ],
          ),
        );
      case _ScreenState.serviceDisabled:
        return _MessageState(
          icon: Icons.location_off,
          message: l10n.prayerLocationServiceOff,
          actionLabel: l10n.prayerRefresh,
          onAction: _load,
        );
      case _ScreenState.denied:
        return _MessageState(
          icon: Icons.location_disabled,
          message: l10n.prayerLocationDenied,
          actionLabel: l10n.prayerGrantPermission,
          onAction: _load,
        );
      case _ScreenState.error:
        return _MessageState(
          icon: Icons.error_outline,
          message: l10n.chatErrorGeneric,
          actionLabel: l10n.prayerRefresh,
          onAction: _load,
        );
      case _ScreenState.needsPermission:
        return _MessageState(
          icon: Icons.location_on_outlined,
          message: l10n.prayerLocationRequired,
          actionLabel: l10n.prayerGrantPermission,
          onAction: _load,
        );
      case _ScreenState.ready:
        return _PrayerTimesList(prayerTimes: _prayerTimes!, onRefresh: _load);
    }
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.icon,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            FilledButton(onPressed: onAction, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}

class _PrayerTimesList extends StatelessWidget {
  const _PrayerTimesList({required this.prayerTimes, required this.onRefresh});

  final adhan.PrayerTimes prayerTimes;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final timeFormat = DateFormat.jm(locale);

    final next = prayerTimes.nextPrayer();
    final nextTime = prayerTimes.timeForPrayer(next);

    final entries = <(String, DateTime)>[
      (l10n.prayerFajr, prayerTimes.fajr),
      (l10n.prayerSunrise, prayerTimes.sunrise),
      (l10n.prayerDhuhr, prayerTimes.dhuhr),
      (l10n.prayerAsr, prayerTimes.asr),
      (l10n.prayerMaghrib, prayerTimes.maghrib),
      (l10n.prayerIsha, prayerTimes.isha),
    ];

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                l10n.prayerNextPrayer(
                  _prayerDisplayName(l10n, next.name),
                  timeFormat.format(nextTime.toLocal()),
                ),
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...entries.map((entry) {
            final (label, time) = entry;
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                title: Text(label),
                trailing: Text(
                  timeFormat.format(time.toLocal()),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  String _prayerDisplayName(AppLocalizations l10n, String name) {
    switch (name) {
      case 'fajr':
      case 'fajrAfter':
        return l10n.prayerFajr;
      case 'sunrise':
        return l10n.prayerSunrise;
      case 'dhuhr':
        return l10n.prayerDhuhr;
      case 'asr':
        return l10n.prayerAsr;
      case 'maghrib':
        return l10n.prayerMaghrib;
      case 'isha':
      case 'ishaBefore':
        return l10n.prayerIsha;
      default:
        return name;
    }
  }
}
