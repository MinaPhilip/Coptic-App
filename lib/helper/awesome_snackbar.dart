import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

void showFailureSnackbar(BuildContext context, String title, String message) {
  final snackBar = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: title,
      message: message,
      contentType: ContentType.failure,
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showSuccessSnackbar(BuildContext context, String title, String message) {
  final snackBar = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: title,
      message: message,
      contentType: ContentType.success,
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
