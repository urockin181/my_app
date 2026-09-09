import 'package:adhan_dart/adhan_dart.dart';

/// Calculates the day's prayer times locally on-device from GPS
/// coordinates - no network call or API key needed.
class PrayerTimesService {
  PrayerTimes calculateForToday({
    required double latitude,
    required double longitude,
    required CalculationParameters calculationParameters,
  }) {
    final coordinates = Coordinates(latitude, longitude);
    return PrayerTimes(
      coordinates: coordinates,
      date: DateTime.now(),
      calculationParameters: calculationParameters,
      precision: true,
    );
  }
}
