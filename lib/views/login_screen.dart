import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elkeraza/helper/awesome_snackbar.dart';

import 'package:elkeraza/service/push_notifications.dart';
import 'package:elkeraza/service/topic_maneger.dart';
import 'package:elkeraza/views/Splashview.dart';
import 'package:elkeraza/widgets/Signinbutton.dart';
import 'package:elkeraza/widgets/Textfiled.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

GlobalKey<ScaffoldState> snackkey = GlobalKey<ScaffoldState>();
final TextEditingController passwordTextController = TextEditingController();
final TextEditingController emailTextController = TextEditingController();

class LoginBody extends StatefulWidget {
  LoginBody({Key? key}) : super(key: key);

  @override
  LoginBodyState createState() => LoginBodyState();
}

class LoginBodyState extends State<LoginBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDB47E),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.02, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 50,
                  child: Text(""),
                ),
                Image.asset(
                  'assets/Logo.png',
                  height: 30.h,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.sp),
                  child: Text(
                    'تسجيل الدخول',
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: 'mainfont',
                        color: Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                reusableTextField(
                    "عنوان البريد الالكتروني",
                    Icons.person_outline,
                    false,
                    emailTextController,
                    100,
                    false),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("كلمة المرور", Icons.lock_outline, true,
                    passwordTextController, 100, false),
                const SizedBox(
                  height: 5,
                ),
                const SizedBox(height: 20),
                custom_button(
                  context,
                  () async {
                    final SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    sharedPreferences.setString(
                        'email', emailTextController.text);
                    finalEmail = emailTextController.text;
                    await signIn(context).then((value) {});
                  },
                  'تسجيل الدخول',
                ),
                custom_button(context, () {
                  Get.toNamed('/home');
                }, 'الدخول بدون تسجيل'),
                signUpOption()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("ليس لديك حساب؟ انشئ ",
            style: TextStyle(
                color: Colors.black, fontSize: 10.sp, fontFamily: 'mainfont')),
        GestureDetector(
          onTap: () {
            Get.toNamed('/signup');
          },
          child: Text(
            "حساب جديد",
            style: TextStyle(
                fontFamily: 'mainfont',
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 10.sp),
          ),
        )
      ],
    );
  }
}

signIn(BuildContext context) async {
  String email = emailTextController.text;
  String password = passwordTextController.text;

  if (email.isNotEmpty && password.isNotEmpty) {
    var userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(email).get();

    if (userSnapshot.exists) {
      var user = userSnapshot.data();
      if (user!['password'] == password) {
        log('User signed in successfully');

        await FirebaseFirestore.instance.collection('users').doc(email).set(
            {
              'token': fcmToken,
              'updatedAt': FieldValue
                  .serverTimestamp(), // Optional: Track when the token was last updated
            },
            SetOptions(
                merge:
                    true)); // Use merge to avoid overwriting other fields in the document
        TopicManager.subscribeToTopic("${user['الكنيسه']}");
        TopicManager.subscribeToTopic("${user['الكنيسه']}_${user['الخدمه']}");
        TopicManager.subscribeToTopic("${user['الكنيسه']}");
        log('Token sent to Firestore successfully for user: $email');
        log('${user['الكنيسه']}_${user['الخدمه']}');
        log('${user['الكنيسه']}');
        log(TopicManager.convertToTopicName("${user['الكنيسه']}"));
        log(TopicManager.convertToTopicName(
            "${user['الكنيسه']}_${user['الخدمه']}"));
        passwordTextController.clear();
        emailTextController.clear();
        showSuccessSnackbar(
            context, 'تم تسجيل الدخول', 'تم تسجيل الدخول بنجاح');
        Get.offNamed('/home');
      } else {
        showFailureSnackbar(
            context, 'فشل تسجيل الدخول', 'كلمة المرور غير صحيحة');
      }
    } else {
      showFailureSnackbar(context, 'فشل تسجيل الدخول',
          'البريد الالكتروني غير صحيح او كلمة المرور غير صحيحة');
    }
  } else {
    showFailureSnackbar(context, 'البيانات غير مكتملة',
        'البريد الالكتروني وكلمة المرور مطلوبة');
  }
}
