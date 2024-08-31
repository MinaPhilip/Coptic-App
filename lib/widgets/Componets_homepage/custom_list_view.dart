import 'package:elkeraza/service/topic_maneger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../Model/drawer_model.dart';
import '../../views/Splashview/Splashview.dart';

class CustomListviewItems extends StatefulWidget {
  const CustomListviewItems({super.key, required this.drawerModel});
  final DrawerModel drawerModel;

  @override
  State<CustomListviewItems> createState() => _CustomListviewItemsState();
}

class _CustomListviewItemsState extends State<CustomListviewItems> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        if (widget.drawerModel.pagenavigator == '/login') {
          TopicManager.unsubscribeFromAllTopics();
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          await sharedPreferences.clear().then((value) {
            finalEmail = null;
            Get.offNamed('/login');
          });
        } else if (widget.drawerModel.pagenavigator == '/Chat') {
          Get.toNamed('/Chat', arguments: widget.drawerModel.arugList);
        } else if (widget.drawerModel.pagenavigator == '/notification_topic') {
          Get.toNamed('/notification_topic');
        } else {
          Get.toNamed('/notification_token');
        }
      },
      leading: Icon(
        widget.drawerModel.iconData,
        color: Colors.black,
      ),
      title: Text(
        widget.drawerModel.title,
        style: TextStyle(
            fontFamily: 'mainfont', fontSize: 10.sp, color: Colors.black),
      ),
    );
  }
}
