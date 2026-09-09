import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/generated/app_localizations.dart';
import 'screens/home_shell.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'state/locale_controller.dart';
import 'state/prayer_settings_controller.dart';
import 'state/theme_controller.dart';
import 'theme/app_theme.dart';

class MuslimGuideApp extends StatefulWidget {
  const MuslimGuideApp({
    super.key,
    required this.localeController,
    required this.themeController,
    required this.showOnboarding,
  });

  final LocaleController localeController;
  final ThemeController themeController;
  final bool showOnboarding;

  @override
  State<MuslimGuideApp> createState() => _MuslimGuideAppState();
}

class _MuslimGuideAppState extends State<MuslimGuideApp> {
  late bool _showOnboarding = widget.showOnboarding;
  final _prayerSettingsController = PrayerSettingsController();
  bool _prayerSettingsLoaded = false;

  @override
  void initState() {
    super.initState();
    _prayerSettingsController.load().then((_) {
      if (mounted) setState(() => _prayerSettingsLoaded = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([widget.localeController, widget.themeController]),
      builder: (context, _) {
        return MaterialApp(
          onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: widget.themeController.mode,
          locale: widget.localeController.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: !_prayerSettingsLoaded
              ? const _SplashScreen()
              : _showOnboarding
                  ? OnboardingScreen(
                      localeController: widget.localeController,
                      onComplete: () => setState(() => _showOnboarding = false),
                    )
                  : HomeShell(
                      localeController: widget.localeController,
                      themeController: widget.themeController,
                      prayerSettingsController: _prayerSettingsController,
                    ),
        );
      },
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
