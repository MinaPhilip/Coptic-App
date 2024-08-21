import 'package:flutter/material.dart';

class CategoryModel {
  final String? title;
  final String? image;
  final String? subtitle;
  final Widget widget_CategoryModel;
  CategoryModel(
      {required this.title,
      required this.image,
      required this.subtitle,
      required this.widget_CategoryModel});
}
