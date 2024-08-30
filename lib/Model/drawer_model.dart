import 'package:flutter/material.dart';

class DrawerModel {
  final String title;
  final IconData iconData;
  final String pagenavigator;
  final List arugList;
  const DrawerModel(
      {required this.title,
      required this.iconData,
      required this.pagenavigator,
      required this.arugList});
}
