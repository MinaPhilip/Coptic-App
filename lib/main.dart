import 'package:elkeraza/service/push_notifications.dart';
import 'package:elkeraza/views/Notifications/notification_token_view.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'firebase_options.dart';
import 'service/local_notifications.dart';
import 'views/Chat/chat_page.dart';
import 'views/Homepage/homepage.dart';
import 'views/Login and sign up/login_screen.dart';
import 'views/Login and sign up/signup.dart';
import 'views/Notifications/notification_topic_view.dart';
import 'views/Readings_views/AnimatedDropdownPages.dart';
import 'views/Readings_views/options.dart';
import 'views/Readings_views/special_screen.dart';
import 'views/Splashview/Splashview.dart';

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
              page: () => const SignUpScreen(),
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
          GetPage(
              name: '/notification_topic',
              page: () => NotificationTopicView(),
              transition: Transition.fadeIn),
          GetPage(
              name: '/notification_token',
              page: () => NotificationTokenView(),
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
