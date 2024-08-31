import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

String? finalEmail;

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  navigateToHome() async {
    await Future.delayed(const Duration(seconds: 5), () {
      Get.offNamed(
        finalEmail == null || finalEmail == '' ? '/login' : '/home',
      );
    });
  }

  Future getvaildationData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var obtainedEmail = sharedPreferences.getString('email');
    setState(() {
      finalEmail = obtainedEmail;
    });
    log('Email: $finalEmail');
  }

  @override
  void initState() {
    getvaildationData().whenComplete(() => navigateToHome());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDB47E),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Image.asset(
                    "assets/Logo.png",
                    width: 100.w,
                    height: 50.h,
                  ),
                ),
              ],
            ),
          ),
          Text('جميع البيانات مأخودة من موقع كنيسة الانبا تكلا',
              style: TextStyle(
                  color: Colors.black, fontFamily: 'mainfont', fontSize: 9.sp)),
          Text('Developed  By Mina Philip',
              style: TextStyle(
                  color: Colors.black, fontFamily: 'mainfont', fontSize: 9.sp)),
        ],
      ),
    );
  }
}
