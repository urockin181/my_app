// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Muslim Guide';

  @override
  String get navChat => 'Chat';

  @override
  String get navPrayerTimes => 'Prayer Times';

  @override
  String get navQibla => 'Qibla';

  @override
  String get navAthkar => 'Athkar';

  @override
  String get chatTitle => 'Ask a Question';

  @override
  String get chatInputHint => 'Ask about Quran or Hadith...';

  @override
  String get chatSend => 'Send';

  @override
  String get chatDisclaimer =>
      'Answers are drawn from the Quran and Hadith. For important religious rulings, please also consult a qualified scholar.';

  @override
  String get chatWelcomeMessage =>
      'Assalamu Alaikum! Ask me any question and I will search the Quran and Hadith for an answer.';

  @override
  String get chatNoInformation =>
      'I could not find information about this in the Quran or Hadith sources available to me. Please consult a qualified scholar.';

  @override
  String get chatSearching => 'Searching the Quran and Hadith...';

  @override
  String get chatErrorGeneric =>
      'Something went wrong while getting an answer. Please try again.';

  @override
  String get chatSourceQuran => 'Quran';

  @override
  String get chatSourceHadith => 'Hadith';

  @override
  String get chatHadithGradeSahih => 'Authentic (Sahih)';

  @override
  String get chatHadithGradeHasan => 'Good (Hasan)';

  @override
  String get chatHadithGradeDaif => 'Weak (Da\'if)';

  @override
  String get chatHadithGradeUnknown => 'Grade not available';

  @override
  String get chatApiKeyMissing =>
      'The chatbot is not configured yet. Please add a Gemini API key to use this feature.';

  @override
  String get prayerTimesTitle => 'Prayer Times';

  @override
  String get prayerFajr => 'Fajr';

  @override
  String get prayerSunrise => 'Sunrise';

  @override
  String get prayerDhuhr => 'Dhuhr';

  @override
  String get prayerAsr => 'Asr';

  @override
  String get prayerMaghrib => 'Maghrib';

  @override
  String get prayerIsha => 'Isha';

  @override
  String prayerNextPrayer(String name, String time) {
    return 'Next prayer: $name at $time';
  }

  @override
  String get prayerLocationRequired =>
      'Location access is needed to calculate accurate prayer times for your area.';

  @override
  String get prayerGrantPermission => 'Grant Location Access';

  @override
  String get prayerLocationDenied =>
      'Location permission was denied. Prayer times cannot be calculated without your location.';

  @override
  String get prayerLocationServiceOff =>
      'Location services are turned off. Please enable them to get prayer times.';

  @override
  String get prayerLoading => 'Getting your location...';

  @override
  String get prayerRefresh => 'Refresh';

  @override
  String get qiblaTitle => 'Qibla Direction';

  @override
  String get qiblaInstructions =>
      'Hold your phone flat and rotate until the arrow points toward the Kaaba.';

  @override
  String get qiblaCalibrate =>
      'If the direction seems off, move your phone in a figure-8 motion to calibrate the compass.';

  @override
  String get qiblaLocationRequired =>
      'Location access is needed to determine the Qibla direction from where you are.';

  @override
  String get qiblaNotSupported =>
      'Your device does not have a compass sensor, so Qibla direction cannot be shown.';

  @override
  String qiblaDegrees(String degrees) {
    return '$degrees° from North';
  }

  @override
  String get athkarTitle => 'Athkar';

  @override
  String get athkarSabah => 'Morning Athkar';

  @override
  String get athkarMasaa => 'Evening Athkar';

  @override
  String athkarCount(String count) {
    return 'Count: $count';
  }

  @override
  String get athkarReset => 'Reset';

  @override
  String get athkarCompleted => 'Completed';

  @override
  String get athkarLoading => 'Loading Athkar...';

  @override
  String get athkarError =>
      'Could not load Athkar. Please check your internet connection and try again.';

  @override
  String get athkarRetry => 'Retry';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageArabic => 'العربية';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsTheme => 'Appearance';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsPrayerCalculation => 'Prayer Calculation';

  @override
  String get settingsCalculationMethod => 'Calculation method';

  @override
  String get settingsMadhab => 'Asr calculation (Madhab)';

  @override
  String get settingsMadhabShafi => 'Shafi / Maliki / Hanbali';

  @override
  String get settingsMadhabHanafi => 'Hanafi';

  @override
  String get onboardingChooseLanguageTitle => 'Choose your language';

  @override
  String get onboardingChooseLanguageSubtitle => 'اختر لغتك';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingPermissionTitle => 'Enable Location';

  @override
  String get onboardingPermissionBody =>
      'Muslim Guide uses your location to show accurate prayer times and point you toward the Qibla. You can change this later in your device settings.';

  @override
  String get onboardingAllowLocation => 'Allow Location Access';

  @override
  String get onboardingSkip => 'Not Now';

  @override
  String get onboardingGetStarted => 'Get Started';
}
