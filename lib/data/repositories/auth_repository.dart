import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../core/services/supabase_service.dart';
import '../models/user_model.dart';

class AuthRepository {
  AuthRepository();

  /// Fetch profile from Supabase
  Future<UserModel?> getProfile(String userId) async {
    try {
      final response = await SupabaseService.client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response != null) {
        return UserModel.fromJson(response);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting profile: $e');
      return null;
    }
  }

  /// Create or update initial profile
  Future<UserModel> upsertProfile({
    required String id,
    required String phone,
    required String role,
    String? fullName,
    String? avatarUrl,
    bool isProfileCompleted = false,
  }) async {
    final data = {
      'id': id,
      'phone': phone,
      'role': role,
      'full_name': fullName ?? (role == 'customer' ? 'User' : 'Service Worker'),
      'avatar_url': avatarUrl,
      'is_profile_completed': isProfileCompleted,
    };

    final response = await SupabaseService.client
        .from('profiles')
        .upsert(data)
        .select()
        .single();

    return UserModel.fromJson(response);
  }

  /// Process or Upload Avatar
  /// Attempts Supabase Storage upload, falls back to base64 Data URL if bucket is not available.
  Future<String?> processAvatar({
    required String userId,
    required String filePath,
  }) async {
    try {
      final file = File(filePath);
      if (!file.existsSync()) return null;

      final bytes = await file.readAsBytes();
      final fileExt = filePath.split('.').last.toLowerCase();
      final cleanExt = (fileExt == 'png' || fileExt == 'webp') ? fileExt : 'jpeg';
      final fileName = '$userId-${DateTime.now().millisecondsSinceEpoch}.$cleanExt';

      try {
        await SupabaseService.client.storage.from('avatars').uploadBinary(
          fileName,
          bytes,
        );
        final publicUrl = SupabaseService.client.storage.from('avatars').getPublicUrl(fileName);
        if (publicUrl.isNotEmpty) {
          return publicUrl;
        }
      } catch (storageError) {
        debugPrint('Supabase storage not accessible, using Base64 Data URL: $storageError');
      }

      // Base64 Data URL fallback (stored in text column)
      final base64String = base64Encode(bytes);
      return 'data:image/$cleanExt;base64,$base64String';
    } catch (e) {
      debugPrint('Error processing avatar: $e');
      return null;
    }
  }

  /// Update Profile Details (Upsert ensures row exists even if id changed)
  Future<UserModel?> updateProfile({
    required String id,
    String? fullName,
    String? avatarUrl,
    String? phone,
    String? email,
  }) async {
    final Map<String, dynamic> data = {'id': id};
    if (fullName != null && fullName.isNotEmpty) data['full_name'] = fullName;
    if (avatarUrl != null && avatarUrl.isNotEmpty) data['avatar_url'] = avatarUrl;
    if (phone != null && phone.isNotEmpty) data['phone'] = phone;
    if (email != null && email.isNotEmpty) data['email'] = email;

    try {
      final response = await SupabaseService.client
          .from('profiles')
          .upsert(data, onConflict: 'id')
          .select()
          .maybeSingle();

      if (response != null) {
        return UserModel.fromJson(response);
      }
    } catch (e) {
      debugPrint('updateProfile error: $e');
    }
    return getProfile(id);
  }

  /// Update Worker Details (Skills, Experience, City etc.)
  Future<void> saveWorkerDetails({
    required String workerId,
    required List<String> skills,
    required int experienceYears,
    String? fullName,
    String? avatarUrl,
    String? phone,
    String? bio,
    String? city,
    double? hourlyRate,
    double? latitude,
    double? longitude,
  }) async {
    // 1. FIRST make sure the profile exists in profiles table
    try {
      final Map<String, dynamic> profileData = {
        'id': workerId,
        'role': 'worker',
        'is_profile_completed': true,
      };
      if (fullName != null && fullName.isNotEmpty) {
        profileData['full_name'] = fullName;
      }
      if (avatarUrl != null && avatarUrl.isNotEmpty) {
        profileData['avatar_url'] = avatarUrl;
      }
      if (phone != null && phone.isNotEmpty) {
        profileData['phone'] = phone;
      }

      await SupabaseService.client.from('profiles').upsert(
        profileData,
        onConflict: 'id',
      );
    } catch (e) {
      debugPrint('profiles initial upsert warning: $e');
    }

    // 2. THEN insert into worker_details (satisfies foreign key constraint)
    try {
      final Map<String, dynamic> workerData = {
        'worker_id': workerId,
        'skills': skills,
        'experience_years': experienceYears,
        'bio': bio,
        'city': city,
        'hourly_rate': hourlyRate ?? 0,
        'active_plan': 'free',
      };
      if (latitude != null) workerData['latitude'] = latitude;
      if (longitude != null) workerData['longitude'] = longitude;

      await SupabaseService.client.from('worker_details').upsert(workerData);
    } catch (e) {
      debugPrint('worker_details upsert warning: $e');
    }
  }
}
