import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class LocationService {
  LocationService._();

  /// Determine the current position of the device.
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return null.
  static Future<Position?> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('Location services are disabled.');
        return null;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('Location permissions are denied');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('Location permissions are permanently denied.');
        return null;
      }

      // When permissions are granted, get the current position
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 8),
        ),
      );
    } catch (e) {
      debugPrint('Error getting location: $e');
      return null;
    }
  }

  /// Calculate distance between two coordinates in Kilometers (KM)
  static double calculateDistanceInKm({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    final distanceInMeters = Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
    return distanceInMeters / 1000.0;
  }

  /// Cached address so repeated calls are instant
  static Map<String, String>? _cachedAddress;

  /// Reverse geocode coordinates using OpenStreetMap Nominatim
  static Future<Map<String, String>> getAddressFromCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    if (_cachedAddress != null) return _cachedAddress!;

    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude&zoom=14&addressdetails=1',
      );
      final response = await http.get(
        url,
        headers: {'User-Agent': 'HomeFix-FlutterApp/1.0'},
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final address = data['address'] as Map<String, dynamic>?;
        if (address != null) {
          final city = address['city'] ??
              address['town'] ??
              address['city_district'] ??
              address['state_district'] ??
              address['suburb'] ??
              address['county'] ??
              'Nearby';

          final subArea = address['suburb'] ??
              address['neighbourhood'] ??
              address['road'] ??
              address['residential'] ??
              address['state'] ??
              '';

          final state = address['state'] ?? '';

          _cachedAddress = {
            'city': city.toString(),
            'subArea': subArea.toString(),
            'state': state.toString(),
            'full': subArea.isNotEmpty ? '$subArea, $city' : '$city, $state',
          };
          return _cachedAddress!;
        }
      }
    } catch (e) {
      debugPrint('Reverse geocoding error: $e');
    }

    return {
      'city': 'Nearby Area',
      'subArea': 'Current Location',
      'state': '',
      'full': 'Current Location',
    };
  }

  /// Get current device address directly
  static Future<Map<String, String>> getCurrentAddress() async {
    try {
      final pos = await getCurrentPosition();
      if (pos != null) {
        return await getAddressFromCoordinates(
          latitude: pos.latitude,
          longitude: pos.longitude,
        );
      }
    } catch (e) {
      debugPrint('Error getting current address: $e');
    }
    return {
      'city': 'Nearby Area',
      'subArea': 'Current Location',
      'state': '',
      'full': 'Current Location',
    };
  }
}
