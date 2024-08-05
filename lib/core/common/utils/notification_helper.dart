import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  /// Futter local notification  plugin
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  ///Notification payload
  static ValueNotifier<String> payload = ValueNotifier('');

  /// Set payload
  void setPayload(String newPayload) {
    payload.value = newPayload;
  }

  /// Inisialisasikan settingan channel notifikasi untuk android
  static AndroidNotificationDetails androidNotificationDetails =
      const AndroidNotificationDetails(
    'local_notification',
    'Local Notification',
    channelDescription: 'Local Notification Demo',
    importance: Importance.max,
    priority: Priority.high,
    icon: '@mipmap/ic_launcher',
    playSound: true,
    enableVibration: true,
  );

  /// Inisialisasikan settingan channel notifikasi untuk iOS
  static DarwinNotificationDetails iosNotificationDetails =
      const DarwinNotificationDetails(
    threadIdentifier: 'local_notification',
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  /// Notifications Details untuk multi platform
  static NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
    iOS: iosNotificationDetails,
  );

  Future<void> initLocalNotifications() async {
    /// config for android
    const AndroidInitializationSettings initSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    //config for ios
    const initSettingsIos = DarwinInitializationSettings();

    // init settings
    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIos,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint('Tap on notification payload: ${details.payload}');
        setPayload(details.payload ?? '');
      },
    );

    /// Request permission untuk ansroid >13
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    /// Request permission untuk ios
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
}
