import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'main.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // initializing notifications for android
    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('app_icon');

    // initializing notifications for IOS
    IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings(
            requestSoundPermission: true,
            requestBadgePermission: true,
            requestAlertPermission: true,
            onDidReceiveLocalNotification:
                (int id, String title, String body, String payload) async {});

    InitializationSettings initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void createNotification() async {
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('door_unlock', 'door_unlock',
        'Channel for door unlocked notification',
        icon: 'app_icon',
        sound: RawResourceAndroidNotificationSound('a_long_cold_string'));
    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails(
        sound: 'a_long_cold_string.m4r',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails,

    );

    await flutterLocalNotificationsPlugin.show(0, 'Door is Unlocked', 'The door was unlocked after loosing connection. Lock', notificationDetails);
  }
}
