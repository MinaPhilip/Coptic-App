import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'HomePage.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  void gettohomepage() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => homepage()));
    });
  }

  void initState() {
    super.initState();
    gettohomepage();
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
