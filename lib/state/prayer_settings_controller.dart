import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Prayer time "accuracy" complaints are almost always a mismatch between
/// this app's default calculation convention and the one the user is used
/// to - there is no single universally-correct method, different regions
/// and schools of thought use different (all valid) conventions. This
/// controller lets the user pick their own, persisted across launches.
class PrayerSettingsController extends ChangeNotifier {
  static const _methodKey = 'prayer_calculation_method';
  static const _madhabKey = 'prayer_madhab';

  /// A curated subset of adhan_dart's 23 methods - the ones most commonly
  /// used by mainstream prayer-time apps, to keep the picker usable.
  static const availableMethods = [
    CalculationMethod.muslimWorldLeague,
    CalculationMethod.ummAlQura,
    CalculationMethod.egyptian,
    CalculationMethod.karachi,
    CalculationMethod.northAmerica,
    CalculationMethod.moonsightingCommittee,
    CalculationMethod.singapore,
    CalculationMethod.turkiye,
    CalculationMethod.kuwait,
    CalculationMethod.qatar,
    CalculationMethod.dubai,
  ];

  CalculationMethod _method = CalculationMethod.muslimWorldLeague;
  CalculationMethod get method => _method;

  Madhab _madhab = Madhab.shafi;
  Madhab get madhab => _madhab;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMethod = prefs.getString(_methodKey);
    if (savedMethod != null) {
      _method = availableMethods.firstWhere(
        (m) => m.name == savedMethod,
        orElse: () => CalculationMethod.muslimWorldLeague,
      );
    }
    final savedMadhab = prefs.getString(_madhabKey);
    _madhab = savedMadhab == 'hanafi' ? Madhab.hanafi : Madhab.shafi;
    notifyListeners();
  }

  Future<void> setMethod(CalculationMethod method) async {
    if (_method == method) return;
    _method = method;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_methodKey, method.name);
  }

  Future<void> setMadhab(Madhab madhab) async {
    if (_madhab == madhab) return;
    _madhab = madhab;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_madhabKey, madhab.name);
  }

  CalculationParameters buildParameters() {
    final params = _parametersFor(_method);
    params.madhab = _madhab;
    return params;
  }

  CalculationParameters _parametersFor(CalculationMethod method) {
    return switch (method) {
      CalculationMethod.muslimWorldLeague => CalculationMethodParameters.muslimWorldLeague(),
      CalculationMethod.ummAlQura => CalculationMethodParameters.ummAlQura(),
      CalculationMethod.egyptian => CalculationMethodParameters.egyptian(),
      CalculationMethod.karachi => CalculationMethodParameters.karachi(),
      CalculationMethod.northAmerica => CalculationMethodParameters.northAmerica(),
      CalculationMethod.moonsightingCommittee =>
        CalculationMethodParameters.moonsightingCommittee(),
      CalculationMethod.singapore => CalculationMethodParameters.singapore(),
      CalculationMethod.turkiye => CalculationMethodParameters.turkiye(),
      CalculationMethod.kuwait => CalculationMethodParameters.kuwait(),
      CalculationMethod.qatar => CalculationMethodParameters.qatar(),
      CalculationMethod.dubai => CalculationMethodParameters.dubai(),
      _ => CalculationMethodParameters.muslimWorldLeague(),
    };
  }
}
