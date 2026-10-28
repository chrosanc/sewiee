import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:sewiee/data/services/user_service.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final UserService _userService = UserService();

  static Future<void> init() async {
    // Request permission
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission for notifications');
      
      // Get token
      String? token = await _messaging.getToken();
      if (token != null) {
        debugPrint('FCM Token: $token');
        await _saveTokenToUser(token);
      }

      // Listen to token refresh
      _messaging.onTokenRefresh.listen((newToken) {
        _saveTokenToUser(newToken);
      });

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('Got a message whilst in the foreground!');
        debugPrint('Message data: ${message.data}');

        if (message.notification != null) {
          debugPrint('Message also contained a notification: ${message.notification}');
        }
      });
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }

  static Future<void> _saveTokenToUser(String token) async {
    try {
      final user = await _userService.getCurrentUser();
      if (user != null) {
        await _userService.updateFcmToken(user.uid, token);
      }
    } catch (e) {
      debugPrint('Failed to save FCM token: $e');
    }
  }
}
