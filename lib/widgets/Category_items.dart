import 'package:elkeraza/Model/Category_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CategoryItems extends StatelessWidget {
  const CategoryItems({super.key, required this.Categories});
  final CategoryModel Categories;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Categories.widget_CategoryModel,
            arguments: Categories.arugList);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Container(
              margin: const EdgeInsets.only(left: 15, right: 15),
              height: 150,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                Categories.image ?? '',
                fit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            Categories.title ?? '',
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
                fontFamily: 'mainfont'),
          ),
          Text(
            maxLines: 2,
            Categories.subtitle ?? '',
            style: TextStyle(
                color: Colors.black54, fontSize: 11.sp, fontFamily: 'mainfont'),
          )
        ],
      ),
    );
  }
}
