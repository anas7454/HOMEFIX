import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'supabase_service.dart';
import 'storage_service.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
  } catch (_) {}
  debugPrint('[FCM] Handling background message: ${message.messageId} | ${message.notification?.title}');
}

class NotificationService extends GetxService {
  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
    'homefix_local_channel',
    'HomeFix Notifications',
    description: 'Notifications for bookings, plans and service updates',
    importance: Importance.high,
  );

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  FirebaseMessaging? _fcm;
  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  Future<NotificationService> init() async {
    // 1. Initialize Flutter Local Notifications
    const androidSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint('[Notification] User tapped local notification: ${response.payload}');
      },
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);

    // 2. Initialize Firebase Messaging
    await _initFirebaseMessaging();

    return this;
  }

  Future<void> _initFirebaseMessaging() async {
    try {
      // Ensure Firebase Core is initialized
      try {
        await Firebase.initializeApp();
      } catch (e) {
        debugPrint('[Firebase] initializeApp: $e');
      }

      _fcm = FirebaseMessaging.instance;

      // Register background handler
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Request notification permissions
      await requestPermission();

      // Get FCM device token
      try {
        _fcmToken = await _fcm?.getToken();
        debugPrint('====================================');
        debugPrint('[FCM] Device Token: $_fcmToken');
        debugPrint('====================================');
        if (_fcmToken != null) {
          await syncTokenWithBackend(_fcmToken!);
        }
      } catch (err) {
        debugPrint('[FCM] Error fetching token: $err');
      }

      // Listen for token refreshes
      _fcm?.onTokenRefresh.listen((newToken) async {
        _fcmToken = newToken;
        debugPrint('[FCM] Token refreshed: $newToken');
        await syncTokenWithBackend(newToken);
      });

      // Foreground message listener: show rich local notification
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('[FCM] Foreground message received: ${message.notification?.title}');
        final title = message.notification?.title ?? message.data['title'] ?? 'HomeFix Alert';
        final body = message.notification?.body ?? message.data['body'] ?? '';
        final payload = message.data['payload'] ?? message.data['type'];

        showNotification(
          title: title,
          body: body,
          payload: payload,
        );
      });

      // App opened from background notification tap
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('[FCM] App opened from background notification: ${message.data}');
      });

      // Check initial message if app was terminated
      final initialMessage = await _fcm?.getInitialMessage();
      if (initialMessage != null) {
        debugPrint('[FCM] App launched from terminated state via notification: ${initialMessage.data}');
      }
    } catch (e) {
      debugPrint('[FCM] Setup error: $e');
    }
  }

  /// Request permissions for both Android & iOS
  Future<void> requestPermission() async {
    // Local notifications permission
    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    // FCM permission
    try {
      final settings = await _fcm?.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      debugPrint('[FCM] User granted permission: ${settings?.authorizationStatus}');
    } catch (e) {
      debugPrint('[FCM] Permission request error: $e');
    }
  }

  /// Synchronize FCM device token with Supabase and Local Storage
  Future<void> syncTokenWithBackend([String? token]) async {
    final effectiveToken = token ?? _fcmToken;
    if (effectiveToken == null || effectiveToken.isEmpty) return;

    try {
      if (Get.isRegistered<StorageService>()) {
        await Get.find<StorageService>().write('fcm_token', effectiveToken);
      }

      final currentUser = SupabaseService.client.auth.currentUser;
      if (currentUser != null) {
        final userId = currentUser.id;
        // Try updating profiles
        try {
          await SupabaseService.client
              .from('profiles')
              .update({'fcm_token': effectiveToken})
              .eq('id', userId);
        } catch (_) {}

        // Try updating worker_details
        try {
          await SupabaseService.client
              .from('worker_details')
              .update({'fcm_token': effectiveToken})
              .eq('worker_id', userId);
        } catch (_) {}
      }
    } catch (e) {
      debugPrint('[FCM] Error syncing token with backend: $e');
    }
  }

  /// Show instant local notification
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'homefix_local_channel',
      'HomeFix Notifications',
      channelDescription: 'Notifications for bookings, plans and service updates',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/launcher_icon',
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }
}
