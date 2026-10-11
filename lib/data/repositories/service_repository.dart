import 'package:flutter/foundation.dart';
import '../../core/services/supabase_service.dart';
import '../../core/services/location_service.dart';

class ServiceRepository {
  ServiceRepository();

  /// Fetch all services from Supabase
  Future<List<Map<String, dynamic>>> fetchServices() async {
    try {
      final response = await SupabaseService.client
          .from('services')
          .select()
          .order('title', ascending: true);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching services: $e');
      return [];
    }
  }

  /// Fetch registered workers from Supabase profiles + worker_details
  /// Filters by category and optional maxRadiusKm (defaults to 20 km if user coordinates are provided)
  Future<List<Map<String, dynamic>>> fetchWorkers({
    String? category,
    double? userLatitude,
    double? userLongitude,
    double maxRadiusKm = 20.0,
  }) async {
    try {
      final response = await SupabaseService.client
          .from('profiles')
          .select('id, full_name, avatar_url, phone, worker_details(*)')
          .eq('role', 'worker');

      final List<Map<String, dynamic>> results = [];
      final cleanFilter = (category != null && category.trim().isNotEmpty && category.trim().toLowerCase() != 'all' && category.trim().toLowerCase() != 'workers')
          ? category.trim().toLowerCase()
          : null;

      for (final item in response) {
        dynamic rawDetails = item['worker_details'];
        Map<String, dynamic>? details;
        if (rawDetails is Map<String, dynamic>) {
          details = rawDetails;
        } else if (rawDetails is List && rawDetails.isNotEmpty) {
          details = rawDetails.first as Map<String, dynamic>?;
        }

        String skills = 'Service Professional';
        List<String> rawSkillsList = [];
        if (details != null && details['skills'] != null) {
          if (details['skills'] is List) {
            rawSkillsList = (details['skills'] as List).map((s) => s.toString().toLowerCase()).toList();
            skills = (details['skills'] as List).join(', ');
          } else {
            final sStr = details['skills'].toString();
            rawSkillsList = [sStr.toLowerCase()];
            skills = sStr;
          }
        }

        // Strict category filtering
        if (cleanFilter != null) {
          final skillsText = skills.toLowerCase();
          final hasMatch = rawSkillsList.any((s) => s.contains(cleanFilter) || cleanFilter.contains(s)) ||
              skillsText.contains(cleanFilter);
          if (!hasMatch) {
            continue; // Skip worker if skills don't match requested category
          }
        }

        // Location & 20 km Radius filtering
        double? distanceKm;
        final workerLat = (details?['latitude'] as num?)?.toDouble();
        final workerLng = (details?['longitude'] as num?)?.toDouble();

        if (userLatitude != null && userLongitude != null && workerLat != null && workerLng != null) {
          distanceKm = LocationService.calculateDistanceInKm(
            startLatitude: userLatitude,
            startLongitude: userLongitude,
            endLatitude: workerLat,
            endLongitude: workerLng,
          );

          // Strictly filter only within maxRadiusKm (20 km)
          if (distanceKm > maxRadiusKm) {
            continue;
          }
        }

        results.add({
          'id': item['id'],
          'name': item['full_name'] ?? 'HomeFix Worker',
          'phone': item['phone'] ?? '',
          'avatar': item['avatar_url'] ?? 'https://i.pravatar.cc/150?img=11',
          'skills': skills,
          'experience': details != null ? '${details['experience_years'] ?? 1}+ Years' : 'Verified',
          'city': (details?['city'] != null && details!['city'].toString().trim().isNotEmpty)
              ? details['city']
              : 'Nearby Area',
          'price': '₹${details?['hourly_rate'] ?? 299}',
          'rating': '5.0',
          'reviews': '1',
          'distanceKm': distanceKm != null ? '${distanceKm.toStringAsFixed(1)} km' : null,
          'latitude': workerLat,
          'longitude': workerLng,
        });
      }
      return results;
    } catch (e) {
      debugPrint('Error fetching workers: $e');
      return [];
    }
  }
}
