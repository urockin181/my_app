import 'package:adhan_dart/adhan_dart.dart';

/// Calculates the day's prayer times locally on-device from GPS
/// coordinates - no network call or API key needed.
class PrayerTimesService {
  PrayerTimes calculateForToday({
    required double latitude,
    required double longitude,
  }) {
    final coordinates = Coordinates(latitude, longitude);
    final params = CalculationMethodParameters.muslimWorldLeague();
    return PrayerTimes(
      coordinates: coordinates,
      date: DateTime.now(),
      calculationParameters: params,
      precision: true,
    );
  }
}
