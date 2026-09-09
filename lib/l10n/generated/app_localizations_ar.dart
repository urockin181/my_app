// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'دليل المسلم';

  @override
  String get navChat => 'المحادثة';

  @override
  String get navPrayerTimes => 'مواقيت الصلاة';

  @override
  String get navQibla => 'القبلة';

  @override
  String get navAthkar => 'الأذكار';

  @override
  String get chatTitle => 'اطرح سؤالاً';

  @override
  String get chatInputHint => 'اسأل عن القرآن أو الحديث...';

  @override
  String get chatSend => 'إرسال';

  @override
  String get chatDisclaimer =>
      'الإجابات مستقاة من القرآن الكريم والحديث الشريف. للمسائل الشرعية المهمة، يرجى الرجوع أيضاً إلى أهل العلم.';

  @override
  String get chatWelcomeMessage =>
      'السلام عليكم! اطرح أي سؤال وسأبحث لك في القرآن الكريم والحديث الشريف عن إجابة.';

  @override
  String get chatNoInformation =>
      'لم أجد معلومات حول هذا في مصادر القرآن والحديث المتاحة لدي. يرجى الرجوع إلى أهل العلم.';

  @override
  String get chatSearching => 'جارٍ البحث في القرآن والحديث...';

  @override
  String get chatErrorGeneric =>
      'حدث خطأ أثناء الحصول على الإجابة. يرجى المحاولة مرة أخرى.';

  @override
  String get chatSourceQuran => 'القرآن الكريم';

  @override
  String get chatSourceHadith => 'الحديث';

  @override
  String get chatHadithGradeSahih => 'صحيح';

  @override
  String get chatHadithGradeHasan => 'حسن';

  @override
  String get chatHadithGradeDaif => 'ضعيف';

  @override
  String get chatHadithGradeUnknown => 'الدرجة غير متوفرة';

  @override
  String get chatApiKeyMissing =>
      'لم يتم إعداد المحادثة الذكية بعد. يرجى إضافة مفتاح Gemini API لاستخدام هذه الميزة.';

  @override
  String get prayerTimesTitle => 'مواقيت الصلاة';

  @override
  String get prayerFajr => 'الفجر';

  @override
  String get prayerSunrise => 'الشروق';

  @override
  String get prayerDhuhr => 'الظهر';

  @override
  String get prayerAsr => 'العصر';

  @override
  String get prayerMaghrib => 'المغرب';

  @override
  String get prayerIsha => 'العشاء';

  @override
  String prayerNextPrayer(String name, String time) {
    return 'الصلاة القادمة: $name في $time';
  }

  @override
  String get prayerLocationRequired =>
      'يلزم الوصول إلى الموقع لحساب مواقيت الصلاة بدقة لمنطقتك.';

  @override
  String get prayerGrantPermission => 'منح إذن الموقع';

  @override
  String get prayerLocationDenied =>
      'تم رفض إذن الموقع. لا يمكن حساب مواقيت الصلاة بدون تحديد موقعك.';

  @override
  String get prayerLocationServiceOff =>
      'خدمة الموقع غير مُفعّلة. يرجى تفعيلها للحصول على مواقيت الصلاة.';

  @override
  String get prayerLoading => 'جارٍ تحديد موقعك...';

  @override
  String get prayerRefresh => 'تحديث';

  @override
  String get qiblaTitle => 'اتجاه القبلة';

  @override
  String get qiblaInstructions =>
      'أمسك هاتفك بشكل مستوٍ وقم بتدويره حتى يشير السهم نحو الكعبة المشرفة.';

  @override
  String get qiblaCalibrate =>
      'إذا بدا الاتجاه غير دقيق، حرّك هاتفك على شكل رقم 8 لمعايرة البوصلة.';

  @override
  String get qiblaLocationRequired =>
      'يلزم الوصول إلى الموقع لتحديد اتجاه القبلة من مكانك.';

  @override
  String get qiblaNotSupported =>
      'جهازك لا يحتوي على حساس بوصلة، لذا لا يمكن عرض اتجاه القبلة.';

  @override
  String qiblaDegrees(String degrees) {
    return '$degrees° من الشمال';
  }

  @override
  String get athkarTitle => 'الأذكار';

  @override
  String get athkarSabah => 'أذكار الصباح';

  @override
  String get athkarMasaa => 'أذكار المساء';

  @override
  String athkarCount(String count) {
    return 'العدد: $count';
  }

  @override
  String get athkarReset => 'إعادة تعيين';

  @override
  String get athkarCompleted => 'تم الإكمال';

  @override
  String get athkarLoading => 'جارٍ تحميل الأذكار...';

  @override
  String get athkarError =>
      'تعذّر تحميل الأذكار. يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى.';

  @override
  String get athkarRetry => 'إعادة المحاولة';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get settingsLanguageArabic => 'العربية';

  @override
  String get settingsLanguageEnglish => 'English';
}
