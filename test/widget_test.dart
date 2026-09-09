import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:my_app/app.dart';
import 'package:my_app/state/locale_controller.dart';
import 'package:my_app/state/theme_controller.dart';

void main() {
  testWidgets('App builds and shows the chat tab by default', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final localeController = LocaleController();
    localeController.setLocale(const Locale('en'));
    final themeController = ThemeController();

    await tester.pumpWidget(MuslimGuideApp(
      localeController: localeController,
      themeController: themeController,
      showOnboarding: false,
    ));
    // Avoid pumpAndSettle here: the initial frame briefly shows an
    // indeterminate CircularProgressIndicator (while prayer settings load
    // from SharedPreferences), and an indeterminate spinner's animation
    // never lets pumpAndSettle finish on its own.
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    expect(find.text('Ask a Question'), findsOneWidget);
  });
}
