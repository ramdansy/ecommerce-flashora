import 'dart:convert';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'notification_helper.dart';

class FcmHelper {
  static String _serverToken = '';

  Future<void> init() async {
    await FirebaseMessaging.instance.requestPermission();

    //Get FCM Token
    final fcmToken = await FirebaseMessaging.instance.getToken();
    _serverToken = fcmToken!;
    debugPrint('FCM Token: $fcmToken');

    //Handle background message
    FirebaseMessaging.instance.getInitialMessage().then(
      (value) {
        NotificationHelper.payload.value = jsonEncode({
          'title': value?.notification?.title,
          'body': value?.notification?.body,
          'data': value?.data,
        });
      },
    );

    //Handle ontap background message
    FirebaseMessaging.onMessageOpenedApp.listen(
      (event) {
        NotificationHelper.payload.value = jsonEncode({
          'title': event.notification?.title,
          'body': event.notification?.body,
          'data': event.data,
        });
      },
    );

    //Handle ontap foreground message
    FirebaseMessaging.onMessage.listen(
      (event) async {
        RemoteNotification? notification = event.notification;
        AndroidNotification? android = event.notification?.android;

        if (notification != null && android != null && !kIsWeb) {
          await NotificationHelper.flutterLocalNotificationsPlugin.show(
            Random().nextInt(99),
            notification.title,
            notification.body,
            payload: jsonEncode({
              'title': notification.title,
              'body': notification.body,
              'data': event.data,
            }),
            NotificationHelper.notificationDetails,
          );
        }
      },
    );
  }

  static Map<String, dynamic> tryDesoce(data) {
    try {
      return jsonDecode(data);
    } catch (e) {
      return {};
    }
  }

  static Future<void> sendNotification(String title, String body) async {
    try {
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$_serverToken',
        },
        body: jsonEncode({
          "to": "/topics/all",
          "notification": {
            "title": title,
            "body": body,
          },
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('Notification sent successfully.');
      } else {
        debugPrint(
            'Failed to send notification. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error sending notification: $e');
    }
  }
}
