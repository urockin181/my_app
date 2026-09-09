import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_app/app.dart';
import 'package:my_app/state/locale_controller.dart';

void main() {
  testWidgets('App builds and shows the chat tab by default', (WidgetTester tester) async {
    final localeController = LocaleController();
    localeController.setLocale(const Locale('en'));

    await tester.pumpWidget(MuslimGuideApp(localeController: localeController));
    await tester.pumpAndSettle();

    expect(find.text('Ask a Question'), findsOneWidget);
  });
}
