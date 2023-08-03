import 'dart:ui';

import 'package:appointmentxpert/core/utils/notifications.dart';
import 'package:appointmentxpert/presentation/splash_screen/splash_screen.dart';
import 'package:appointmentxpert/routes/app_routes.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_framework/breakpoint.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

import 'core/utils/initial_bindings.dart';
import 'core/utils/logger.dart';
import 'localization/app_localization.dart';
import 'shared_prefrences_page/shared_prefrence_page.dart';

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  RemoteNotification? notification = message.notification;
  print('message -- ${message.notification?.title}');
  print('message -- ${message.notification?.body}');
  print('message -- ${message.data}');
}

const _kTestingCrashlytics = true;

Future<void> _initializeFlutterFire() async {
  if (_kTestingCrashlytics) {
    // Force enable crashlytics collection enabled if we're testing it.
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  } else {
    // Else only enable it in non-debug builds.
    // You could additionally extend this to allow users to opt-in.
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(!kDebugMode);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefUtils.init();

  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    } else {
      print(value);
    }
  });

  await initFcm();
  await _initializeFlutterFire();
  const fatalError = true;
  FlutterError.onError = (errorDetails) {
    if (fatalError) {
      // If you want to record a "fatal" exception
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      // ignore: dead_code
    } else {
      // If you want to record a "non-fatal" exception
      FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    }
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    if (fatalError) {
      // If you want to record a "fatal" exception
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      // ignore: dead_code
    } else {
      // If you want to record a "non-fatal" exception
      FirebaseCrashlytics.instance.recordError(error, stack);
    }
    return true;
  };

  // await Firebase.initializeApp(
  //     options: const FirebaseOptions(
  //         apiKey: "AIzaSyCX7puGlnu_F7DeMBA86rNj4tiotpFAtAE",
  //         //authDomain: "xxxx",
  //         projectId: "healthcare-cpas",
  //         storageBucket: "healthcare-cpas.appspot.com",
  //         messagingSenderId: "231282522270",
  //         appId: "1:231282522270:ios:3f6178dc8bbca810b1638f"));
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((value) async {
    Logger.init(kReleaseMode ? LogMode.live : LogMode.debug);
    // AdaptiveLayout.setBreakpoints(
    //   mediumScreenMinWidth: 600,
    //   largeScreenMinWidth: 1200,
    // );
    // runApp(   DevicePreview(
    //   enabled: !kReleaseMode,
    //   builder: (context) => MyApp(), // Wrap your app
    // ));
    /*await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCX7puGlnu_F7DeMBA86rNj4tiotpFAtAE",
            //authDomain: "xxxx",
            projectId: "healthcare-cpas",
            storageBucket: "healthcare-cpas.appspot.com",
            messagingSenderId: "231282522270",
            appId: "1:231282522270:ios:3f6178dc8bbca810b1638f"));*/

    runApp(const MyApp());
    // DevicePreview(
    //   enabled: !kReleaseMode,
    //   builder: (context) => MyApp(), // Wrap your app
    // );
  });
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  importance: Importance.high,
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      theme: ThemeData(
        visualDensity: VisualDensity.standard,
      ),
      translations: AppLocalization(),
      locale: Get.deviceLocale, //for setting localization strings
      fallbackLocale: const Locale('en', 'US'),
      title: 'clinic_app',
      initialBinding: InitialBindings(),
      home: const SplashScreen(),
      initialRoute: AppRoutes.initialRoute,
      scrollBehavior: CustomScrollBehaviour(),
      getPages: AppRoutes.pages,
    );
  }
}

class CustomScrollBehaviour extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
