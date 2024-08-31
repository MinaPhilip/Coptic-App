import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../Model/drawer_model.dart';
import 'custom_list_view.dart';

class Custom_Drawer extends StatefulWidget {
  final String nameChurches;
  final String service;
  final String nameUser;
  final String id;
  final String status;
  const Custom_Drawer(
      {super.key,
      required this.nameChurches,
      required this.service,
      required this.nameUser,
      required this.id,
      required this.status});

  @override
  State<Custom_Drawer> createState() => _Custom_DrawerState();
}

List<DrawerModel>? items;

class _Custom_DrawerState extends State<Custom_Drawer> {
  @override
  void initState() {
    if (widget.status == 'مخدوم') {
      items = [
        DrawerModel(
            title: 'دردشة الخدمه',
            iconData: Icons.chat_bubble_outline_outlined,
            pagenavigator: '/Chat',
            arugList: [
              widget.nameChurches,
              widget.service,
              widget.nameUser,
              widget.id,
              widget.status
            ]),
        const DrawerModel(
          title: 'تسجيل الخروج',
          iconData: Icons.logout,
          pagenavigator: '/login',
          arugList: [],
        ),
      ];
    } else {
      items = [
        DrawerModel(
            title: 'دردشة الخدمه',
            iconData: Icons.chat_bubble_outline_outlined,
            pagenavigator: '/Chat',
            arugList: [
              widget.nameChurches,
              widget.service,
              widget.nameUser,
              widget.id,
              widget.status
            ]),
        const DrawerModel(
          title: ' ارسال اشعار للمخدومين',
          iconData: Icons.notifications,
          pagenavigator: '/notification_topic',
          arugList: [],
        ),
        const DrawerModel(
          title: 'تسجيل الخروج',
          iconData: Icons.logout,
          pagenavigator: '/login',
          arugList: [],
        ),
      ];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFDDB47E),
      child: Column(
        children: [
          DrawerHeader(
              child: Image.asset(
            'assets/Logo.png',
            width: 100.w,
            height: 100.h,
          )),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items!.length,
              itemBuilder: (context, index) {
                return CustomListviewItems(
                  drawerModel: items![index],
                );
              })
        ],
      ),
    );
  }
}
