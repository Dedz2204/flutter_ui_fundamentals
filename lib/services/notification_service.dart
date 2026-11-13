import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../app_keys.dart';
import '../firebase_options.dart';

// Praktik 10: Background Handler.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  debugPrint('[BACKGROUND] Notification received');
  debugPrint('[BACKGROUND] title: ${message.notification?.title}');
  debugPrint('[BACKGROUND] body: ${message.notification?.body}');
  debugPrint('[BACKGROUND] data: ${message.data}');
}

class NotificationService {
  NotificationService._();

  static final NotificationService instance =
      NotificationService._();

  final FirebaseMessaging _messaging =
      FirebaseMessaging.instance;

  StreamSubscription<RemoteMessage>? _foregroundSubscription;

  // Praktik 8: Meminta izin notifikasi.
  Future<AuthorizationStatus> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint(
      'Notification permission: '
      '${settings.authorizationStatus.name}',
    );

    return settings.authorizationStatus;
  }

  // Memeriksa status izin notifikasi.
  Future<AuthorizationStatus> getPermissionStatus() async {
    final settings =
        await _messaging.getNotificationSettings();

    return settings.authorizationStatus;
  }

  // Praktik 9: Mendaftarkan perangkat ke FCM.
  Future<void> registerDevice() async {
    await _messaging.register();
  }

  // Mendengarkan FCM Token.
  void listenTokenRefresh(void Function(String token) onRefresh) {
    _messaging.onRegistered.listen((token) {
      debugPrint('FCM Token: $token');
      onRefresh(token);
    });
  }

  // Praktik 10: Inisialisasi notification listener.
  Future<AuthorizationStatus> init() async {
    final status = await requestPermission();

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await _foregroundSubscription?.cancel();

    // FOREGROUND: Aplikasi sedang terbuka.
    _foregroundSubscription =
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('[FOREGROUND] Notification received');
      debugPrint('title: ${message.notification?.title}');
      debugPrint('body: ${message.notification?.body}');
      debugPrint('data: ${message.data}');

      final title =
          message.notification?.title ?? 'Notifikasi';

      final body =
          message.notification?.body ?? '';

      // Menampilkan SnackBar.
      final messenger = messengerKey.currentState;

      if (messenger != null) {
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                '$title\n$body',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              backgroundColor: Colors.blue,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 8),
              margin: const EdgeInsets.all(16),
            ),
          );

        debugPrint('SnackBar berhasil dipanggil');
      } else {
        debugPrint(
          'ERROR: ScaffoldMessenger belum tersedia',
        );
      }
    });

    debugPrint('Notification listener berhasil diinisialisasi');

    return status;
  }

  // Membersihkan listener foreground.
  Future<void> dispose() async {
    await _foregroundSubscription?.cancel();
    _foregroundSubscription = null;
  }
}