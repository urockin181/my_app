import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'state/locale_controller.dart';
import 'state/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final localeController = LocaleController();
  final themeController = ThemeController();
  await Future.wait([localeController.load(), themeController.load()]);

  final prefs = await SharedPreferences.getInstance();
  final onboardingComplete = prefs.getBool('onboarding_complete') ?? false;

  runApp(MuslimGuideApp(
    localeController: localeController,
    themeController: themeController,
    showOnboarding: !onboardingComplete,
  ));
}
