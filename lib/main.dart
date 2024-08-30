import 'package:elkeraza/service/push_notifications.dart';
import 'package:elkeraza/views/AnimatedDropdownPages.dart';
import 'package:elkeraza/views/chat_page.dart';
import 'package:elkeraza/views/homepage.dart';
import 'package:elkeraza/views/login_screen.dart';
import 'package:elkeraza/views/options.dart';
import 'package:elkeraza/views/signup.dart';
import 'package:elkeraza/views/special_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'firebase_options.dart';
import 'service/local_notifications.dart';
import 'views/Splashview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Future.wait([
    PushNotificationsService.init(),
    LocalNotificationService.init(),
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) => GetMaterialApp(
        getPages: [
          GetPage(
              name: '/',
              page: () => const SplashView(),
              transition: Transition.fadeIn),
          GetPage(
              name: '/login',
              page: () => LoginBody(),
              transition: Transition.fadeIn),
          GetPage(
              name: '/home',
              page: () => homepage(),
              transition: Transition.fadeIn),
          GetPage(
              name: '/signup',
              page: () => SignUpScreen(),
              transition: Transition.fadeIn),
          GetPage(
              name: '/prayer',
              page: () => const AnimatedDropdownPages(),
              transition: Transition.fadeIn),
          GetPage(
              name: '/day_reading',
              page: () => const day_reading(),
              transition: Transition.fadeIn),
          GetPage(
              name: '/options',
              page: () => const Options(),
              transition: Transition.fadeIn),
          GetPage(
              name: '/Chat',
              page: () => ChatPage(),
              transition: Transition.fadeIn),
        ],
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ar', 'EG'),
          Locale('en', 'US'),
        ],
        locale: const Locale('ar', 'EG'), // Set the locale to Arabic
        home: const SplashView(),
      ),
    );
  }
}
