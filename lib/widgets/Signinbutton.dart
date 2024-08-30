import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

Container custom_button(BuildContext context, Function onTap, String text) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return Colors.black26;
            }
            return Colors.white;
          }),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
      child: Text(
        text,
        style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 13.sp,
            fontFamily: 'mainfont'),
      ),
    ),
  );
}
