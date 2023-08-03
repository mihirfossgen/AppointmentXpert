import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initFcm() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCX7puGlnu_F7DeMBA86rNj4tiotpFAtAE",
            authDomain: "healthcare-cpas.firebaseapp.com",
            projectId: "healthcare-cpas",
            storageBucket: "healthcare-cpas.appspot.com",
            messagingSenderId: "231282522270",
            iosClientId:
                "231282522270-qd59ru008i35ht6rnl5o9876p70l4gcq.apps.googleusercontent.com",
            androidClientId:
                "231282522270-odsjhmha7nq1tvjq7mdvogr08posu0b7.apps.googleusercontent.com",
            appId: "1:231282522270:ios:3f6178dc8bbca810b1638f"));
  } else {
    await Firebase.initializeApp();
  }

  DarwinInitializationSettings iosInitializationSettings =
      const DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  var initializationSettingsAndroid =
      const AndroidInitializationSettings("@drawable/mariene_logo");

  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: iosInitializationSettings);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  FirebaseMessaging.onMessage.listen((RemoteMessage? message) async {
    RemoteNotification? notification = message?.notification;
    AndroidNotification? android = message?.notification?.android;
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
            android: AndroidNotificationDetails('channel.id', 'channel.name')),
        payload: json.encode(message?.data),
      );
    }
  });
}
