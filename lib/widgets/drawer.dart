import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../Model/drawer_model.dart';
import 'custom_list_view.dart';

class Custom_Drawer extends StatelessWidget {
  final String nameChurches;
  final String service;
  final String nameUser;
  final String id;
  const Custom_Drawer(
      {super.key,
      required this.nameChurches,
      required this.service,
      required this.nameUser,
      required this.id});

  @override
  Widget build(BuildContext context) {
    List<DrawerModel> items = [
      DrawerModel(
          title: 'دردشة الخدمه',
          iconData: Icons.chat_bubble_outline_outlined,
          pagenavigator: '/Chat',
          arugList: [nameChurches, service, nameUser, id]),
      const DrawerModel(
        title: 'تسجيل الخروج',
        iconData: Icons.logout,
        pagenavigator: '/login',
        arugList: [],
      ),
    ];

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
              itemCount: items.length,
              itemBuilder: (context, index) {
                return CustomListviewItems(
                  drawerModel: items[index],
                );
              })
        ],
      ),
    );
  }
}
