import 'package:geolocator/geolocator.dart';

enum LocationOutcome { granted, serviceDisabled, permissionDenied }

class LocationResult {
  const LocationResult({required this.outcome, this.position});
  final LocationOutcome outcome;
  final Position? position;
}

/// Shared location-permission flow used by both the Prayer Times and
/// Qibla screens.
class LocationService {
  Future<LocationResult> getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return const LocationResult(outcome: LocationOutcome.serviceDisabled);
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return const LocationResult(outcome: LocationOutcome.permissionDenied);
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
    return LocationResult(outcome: LocationOutcome.granted, position: position);
  }
}
