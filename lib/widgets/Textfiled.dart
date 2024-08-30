import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

TextField reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller, int maxLength, bool digitsOnly) {
  return TextField(
    inputFormatters: [
      digitsOnly
          ? FilteringTextInputFormatter.digitsOnly
          : FilteringTextInputFormatter.singleLineFormatter
    ],
    controller: controller,
    obscureText: isPasswordType,
    maxLength: maxLength,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.black,
    style:
        TextStyle(color: Colors.black, fontFamily: 'mainfont', fontSize: 12.sp),
    decoration: InputDecoration(
      counterText: '',
      prefixIcon: Icon(
        icon,
        color: Colors.black,
      ),
      labelText: text,
      labelStyle: TextStyle(
          color: Colors.black, fontFamily: 'mainfont', fontSize: 12.sp),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : digitsOnly
            ? TextInputType.number
            : TextInputType.emailAddress,
  );
}
