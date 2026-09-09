import 'package:flutter/material.dart';
import 'app.dart';
import 'state/locale_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final localeController = LocaleController();
  await localeController.load();
  runApp(MuslimGuideApp(localeController: localeController));
}
