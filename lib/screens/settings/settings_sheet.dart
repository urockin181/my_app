import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../state/locale_controller.dart';
import '../../state/prayer_settings_controller.dart';
import '../../state/theme_controller.dart';

Future<void> showSettingsSheet(
  BuildContext context, {
  required LocaleController localeController,
  required ThemeController themeController,
  required PrayerSettingsController prayerSettingsController,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => _SettingsSheet(
      localeController: localeController,
      themeController: themeController,
      prayerSettingsController: prayerSettingsController,
    ),
  );
}

class _SettingsSheet extends StatelessWidget {
  const _SettingsSheet({
    required this.localeController,
    required this.themeController,
    required this.prayerSettingsController,
  });

  final LocaleController localeController;
  final ThemeController themeController;
  final PrayerSettingsController prayerSettingsController;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.settingsTitle, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),

            Text(l10n.settingsLanguage, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            ListenableBuilder(
              listenable: localeController,
              builder: (context, _) => SegmentedButton<Locale>(
                segments: [
                  ButtonSegment(value: const Locale('ar'), label: Text(l10n.settingsLanguageArabic)),
                  ButtonSegment(value: const Locale('en'), label: Text(l10n.settingsLanguageEnglish)),
                ],
                selected: {localeController.locale},
                onSelectionChanged: (selection) => localeController.setLocale(selection.first),
              ),
            ),

            const SizedBox(height: 24),
            Text(l10n.settingsTheme, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            ListenableBuilder(
              listenable: themeController,
              builder: (context, _) => SegmentedButton<ThemeMode>(
                segments: [
                  ButtonSegment(value: ThemeMode.light, label: Text(l10n.settingsThemeLight)),
                  ButtonSegment(value: ThemeMode.dark, label: Text(l10n.settingsThemeDark)),
                  ButtonSegment(value: ThemeMode.system, label: Text(l10n.settingsThemeSystem)),
                ],
                selected: {themeController.mode},
                onSelectionChanged: (selection) => themeController.setMode(selection.first),
              ),
            ),

            const SizedBox(height: 24),
            Text(l10n.settingsPrayerCalculation, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            ListenableBuilder(
              listenable: prayerSettingsController,
              builder: (context, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.settingsCalculationMethod, style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 4),
                  DropdownButton<CalculationMethod>(
                    isExpanded: true,
                    value: prayerSettingsController.method,
                    items: [
                      for (final m in PrayerSettingsController.availableMethods)
                        DropdownMenuItem(value: m, child: Text(m.displayName)),
                    ],
                    onChanged: (value) {
                      if (value != null) prayerSettingsController.setMethod(value);
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.settingsMadhab, style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 8),
                  SegmentedButton<Madhab>(
                    segments: [
                      ButtonSegment(value: Madhab.shafi, label: Text(l10n.settingsMadhabShafi)),
                      ButtonSegment(value: Madhab.hanafi, label: Text(l10n.settingsMadhabHanafi)),
                    ],
                    selected: {prayerSettingsController.madhab},
                    onSelectionChanged: (selection) =>
                        prayerSettingsController.setMadhab(selection.first),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
