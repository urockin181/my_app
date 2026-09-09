import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// The app name shown in the title bar and app switcher
  ///
  /// In en, this message translates to:
  /// **'Muslim Guide'**
  String get appTitle;

  /// No description provided for @navChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get navChat;

  /// No description provided for @navPrayerTimes.
  ///
  /// In en, this message translates to:
  /// **'Prayer Times'**
  String get navPrayerTimes;

  /// No description provided for @navQibla.
  ///
  /// In en, this message translates to:
  /// **'Qibla'**
  String get navQibla;

  /// No description provided for @navAthkar.
  ///
  /// In en, this message translates to:
  /// **'Athkar'**
  String get navAthkar;

  /// No description provided for @chatTitle.
  ///
  /// In en, this message translates to:
  /// **'Ask a Question'**
  String get chatTitle;

  /// No description provided for @chatInputHint.
  ///
  /// In en, this message translates to:
  /// **'Ask about Quran or Hadith...'**
  String get chatInputHint;

  /// No description provided for @chatSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get chatSend;

  /// No description provided for @chatDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Answers are drawn from the Quran and Hadith. For important religious rulings, please also consult a qualified scholar.'**
  String get chatDisclaimer;

  /// No description provided for @chatWelcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Assalamu Alaikum! Ask me any question and I will search the Quran and Hadith for an answer.'**
  String get chatWelcomeMessage;

  /// No description provided for @chatNoInformation.
  ///
  /// In en, this message translates to:
  /// **'I could not find information about this in the Quran or Hadith sources available to me. Please consult a qualified scholar.'**
  String get chatNoInformation;

  /// No description provided for @chatSearching.
  ///
  /// In en, this message translates to:
  /// **'Searching the Quran and Hadith...'**
  String get chatSearching;

  /// No description provided for @chatErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while getting an answer. Please try again.'**
  String get chatErrorGeneric;

  /// No description provided for @chatSourceQuran.
  ///
  /// In en, this message translates to:
  /// **'Quran'**
  String get chatSourceQuran;

  /// No description provided for @chatSourceHadith.
  ///
  /// In en, this message translates to:
  /// **'Hadith'**
  String get chatSourceHadith;

  /// No description provided for @chatHadithGradeSahih.
  ///
  /// In en, this message translates to:
  /// **'Authentic (Sahih)'**
  String get chatHadithGradeSahih;

  /// No description provided for @chatHadithGradeHasan.
  ///
  /// In en, this message translates to:
  /// **'Good (Hasan)'**
  String get chatHadithGradeHasan;

  /// No description provided for @chatHadithGradeDaif.
  ///
  /// In en, this message translates to:
  /// **'Weak (Da\'if)'**
  String get chatHadithGradeDaif;

  /// No description provided for @chatHadithGradeUnknown.
  ///
  /// In en, this message translates to:
  /// **'Grade not available'**
  String get chatHadithGradeUnknown;

  /// No description provided for @chatApiKeyMissing.
  ///
  /// In en, this message translates to:
  /// **'The chatbot is not configured yet. Please add a Gemini API key to use this feature.'**
  String get chatApiKeyMissing;

  /// No description provided for @prayerTimesTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer Times'**
  String get prayerTimesTitle;

  /// No description provided for @prayerFajr.
  ///
  /// In en, this message translates to:
  /// **'Fajr'**
  String get prayerFajr;

  /// No description provided for @prayerSunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get prayerSunrise;

  /// No description provided for @prayerDhuhr.
  ///
  /// In en, this message translates to:
  /// **'Dhuhr'**
  String get prayerDhuhr;

  /// No description provided for @prayerAsr.
  ///
  /// In en, this message translates to:
  /// **'Asr'**
  String get prayerAsr;

  /// No description provided for @prayerMaghrib.
  ///
  /// In en, this message translates to:
  /// **'Maghrib'**
  String get prayerMaghrib;

  /// No description provided for @prayerIsha.
  ///
  /// In en, this message translates to:
  /// **'Isha'**
  String get prayerIsha;

  /// No description provided for @prayerNextPrayer.
  ///
  /// In en, this message translates to:
  /// **'Next prayer: {name} at {time}'**
  String prayerNextPrayer(String name, String time);

  /// No description provided for @prayerLocationRequired.
  ///
  /// In en, this message translates to:
  /// **'Location access is needed to calculate accurate prayer times for your area.'**
  String get prayerLocationRequired;

  /// No description provided for @prayerGrantPermission.
  ///
  /// In en, this message translates to:
  /// **'Grant Location Access'**
  String get prayerGrantPermission;

  /// No description provided for @prayerLocationDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission was denied. Prayer times cannot be calculated without your location.'**
  String get prayerLocationDenied;

  /// No description provided for @prayerLocationServiceOff.
  ///
  /// In en, this message translates to:
  /// **'Location services are turned off. Please enable them to get prayer times.'**
  String get prayerLocationServiceOff;

  /// No description provided for @prayerLoading.
  ///
  /// In en, this message translates to:
  /// **'Getting your location...'**
  String get prayerLoading;

  /// No description provided for @prayerRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get prayerRefresh;

  /// No description provided for @qiblaTitle.
  ///
  /// In en, this message translates to:
  /// **'Qibla Direction'**
  String get qiblaTitle;

  /// No description provided for @qiblaInstructions.
  ///
  /// In en, this message translates to:
  /// **'Hold your phone flat and rotate until the arrow points toward the Kaaba.'**
  String get qiblaInstructions;

  /// No description provided for @qiblaCalibrate.
  ///
  /// In en, this message translates to:
  /// **'If the direction seems off, move your phone in a figure-8 motion to calibrate the compass.'**
  String get qiblaCalibrate;

  /// No description provided for @qiblaLocationRequired.
  ///
  /// In en, this message translates to:
  /// **'Location access is needed to determine the Qibla direction from where you are.'**
  String get qiblaLocationRequired;

  /// No description provided for @qiblaNotSupported.
  ///
  /// In en, this message translates to:
  /// **'Your device does not have a compass sensor, so Qibla direction cannot be shown.'**
  String get qiblaNotSupported;

  /// No description provided for @qiblaDegrees.
  ///
  /// In en, this message translates to:
  /// **'{degrees}° from North'**
  String qiblaDegrees(String degrees);

  /// No description provided for @athkarTitle.
  ///
  /// In en, this message translates to:
  /// **'Athkar'**
  String get athkarTitle;

  /// No description provided for @athkarSabah.
  ///
  /// In en, this message translates to:
  /// **'Morning Athkar'**
  String get athkarSabah;

  /// No description provided for @athkarMasaa.
  ///
  /// In en, this message translates to:
  /// **'Evening Athkar'**
  String get athkarMasaa;

  /// No description provided for @athkarCount.
  ///
  /// In en, this message translates to:
  /// **'Count: {count}'**
  String athkarCount(String count);

  /// No description provided for @athkarReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get athkarReset;

  /// No description provided for @athkarCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get athkarCompleted;

  /// No description provided for @athkarLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading Athkar...'**
  String get athkarLoading;

  /// No description provided for @athkarError.
  ///
  /// In en, this message translates to:
  /// **'Could not load Athkar. Please check your internet connection and try again.'**
  String get athkarError;

  /// No description provided for @athkarRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get athkarRetry;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get settingsLanguageArabic;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsTheme;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsPrayerCalculation.
  ///
  /// In en, this message translates to:
  /// **'Prayer Calculation'**
  String get settingsPrayerCalculation;

  /// No description provided for @settingsCalculationMethod.
  ///
  /// In en, this message translates to:
  /// **'Calculation method'**
  String get settingsCalculationMethod;

  /// No description provided for @settingsMadhab.
  ///
  /// In en, this message translates to:
  /// **'Asr calculation (Madhab)'**
  String get settingsMadhab;

  /// No description provided for @settingsMadhabShafi.
  ///
  /// In en, this message translates to:
  /// **'Shafi / Maliki / Hanbali'**
  String get settingsMadhabShafi;

  /// No description provided for @settingsMadhabHanafi.
  ///
  /// In en, this message translates to:
  /// **'Hanafi'**
  String get settingsMadhabHanafi;

  /// No description provided for @onboardingChooseLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get onboardingChooseLanguageTitle;

  /// No description provided for @onboardingChooseLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'اختر لغتك'**
  String get onboardingChooseLanguageSubtitle;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable Location'**
  String get onboardingPermissionTitle;

  /// No description provided for @onboardingPermissionBody.
  ///
  /// In en, this message translates to:
  /// **'Muslim Guide uses your location to show accurate prayer times and point you toward the Qibla. You can change this later in your device settings.'**
  String get onboardingPermissionBody;

  /// No description provided for @onboardingAllowLocation.
  ///
  /// In en, this message translates to:
  /// **'Allow Location Access'**
  String get onboardingAllowLocation;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Not Now'**
  String get onboardingSkip;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingGetStarted;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
