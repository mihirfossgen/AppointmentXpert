import 'dart:ui';

import 'package:appointmentxpert/presentation/splash_screen/splash_screen.dart';
import 'package:appointmentxpert/routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_framework/breakpoint.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

import 'core/app_export.dart';
import 'core/utils/initial_bindings.dart';
import 'core/utils/logger.dart';
import 'localization/app_localization.dart';
import 'shared_prefrences_page/shared_prefrence_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefUtils.init();
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

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((value) {
    Logger.init(kReleaseMode ? LogMode.live : LogMode.debug);
    runApp(const MyApp());
    // DevicePreview(
    //   enabled: !kReleaseMode,
    //   builder: (context) => MyApp(), // Wrap your app
    // );
  });
}

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
