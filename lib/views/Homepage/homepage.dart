import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:elkeraza/Model/Category_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../Data/prayers/candle_prayer.dart';
import '../../Data/prayers/lqan_prayer.dart';
import '../../Data/prayers/oath_prayers.dart';
import '../../Data/prayers/prostration_prayer.dart';
import '../../Model/coptic_model.dart';
import '../../widgets/Componets_homepage/Category_items.dart';
import '../../widgets/Componets_homepage/drawer.dart';
import '../Splashview/Splashview.dart';

class homepage extends StatefulWidget {
  homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    log(finalEmail.toString());
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot userDoc = await users.doc(finalEmail).get();
      if (userDoc.exists) {
        setState(() {
          userData = userDoc.data() as Map<String, dynamic>?;
        });
      }
    } catch (e) {
      log('Error fetching user data: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    CopticDate copticDate = gregorianToCoptic(now);
    final List<CategoryModel> categories = [
      CategoryModel(
          image: 'assets/alagbia.png',
          title: 'الاجبية',
          subtitle: 'جميع صلوات الاجبيه حتي صلاة النوم',
          widget_CategoryModel: '/options',
          arugList: []),
      CategoryModel(
          image: 'assets/daily.jpg',
          title: 'القراءات اليومية',
          subtitle: 'القراءات الخاصه باليوم حسب التاريخ القبطي',
          widget_CategoryModel: '/day_reading',
          arugList: [formatforreading(now, copticDate)]),
      CategoryModel(
        title: 'صلاة القنديل',
        image: 'assets/candle.jpg',
        subtitle: 'تحتوي علي صلوات القنديل من الاولي الي السابعة',
        widget_CategoryModel: '/prayer',
        arugList: [
          'صلاة القنديل',
          false,
          '',
          candlePrayer,
        ],
      ),
      CategoryModel(
          title: 'صلاة اللقان',
          image: 'assets/lqan.jpg',
          subtitle: 'ثلاث صلوات اللقان اللتي في السنة',
          widget_CategoryModel: '/prayer',
          arugList: [
            'صلاة اللقان',
            false,
            '',
            lqanPrayer,
          ]),
      CategoryModel(
          title: 'صلاة السجده',
          image: 'assets/prostration.jpeg',
          subtitle: 'ثلاث صلوات السجده مع المقدمة ',
          widget_CategoryModel: '/prayer',
          arugList: [
            'صلاة السجده',
            false,
            '',
            prostrationPrayer,
          ]),
      CategoryModel(
          title: 'صلوات القسم',
          image: 'assets/oath.jpg',
          subtitle: 'صلاة تصاحب تقسيم الجسد المقدس في القداس الإلهي ',
          widget_CategoryModel: '/prayer',
          arugList: [
            'صلاة القسم',
            false,
            '',
            oathPrayers,
          ]),
    ];
    return Scaffold(
        key: scaffoldkey,
        drawer: (finalEmail == null || finalEmail!.isEmpty || userData == null)
            ? null
            : Custom_Drawer(
                nameChurches: userData?['الكنيسه'] ?? '',
                service: userData?['الخدمه'] ?? '',
                nameUser: userData?['name'] ?? '',
                id: userData?['id'] ?? '',
                status: userData?['role'] ?? '',
              ),
        backgroundColor: const Color(0xFFDDB47E),
        appBar: AppBar(
            leading:
                (finalEmail == null || finalEmail!.isEmpty || userData == null)
                    ? const SizedBox()
                    : IconButton(
                        onPressed: () {
                          scaffoldkey.currentState!.openDrawer();
                        },
                        icon: const Icon(Icons.menu)),
            backgroundColor: const Color(0xFFDDB47E),
            elevation: 1,
            centerTitle: true,
            title: const Text('المنجلية',
                style: TextStyle(fontSize: 24, fontFamily: 'mainfont'))),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 22),
                    child: CategoryItems(
                      Categories: categories[index],
                    ),
                  );
                },
              ),
            ),
            Row(children: [
              const Text(
                textAlign: TextAlign.start,
                'تاريخ اليوم:  ',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'mainfont'),
              ),
              const SizedBox(height: 8),
              Text(
                DateFormat.yMMMMd('ar').format(now), // Localized date format
                style: const TextStyle(fontSize: 18, fontFamily: 'mainfont'),
              ),
              const SizedBox(height: 16),
            ]),
            Row(
              children: [
                const Text(
                  'التاريخ القبطي:  ',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'mainfont'),
                ),
                const SizedBox(height: 8),
                Text(
                  formatCopticDate(now, copticDate),
                  style: const TextStyle(fontSize: 18, fontFamily: 'mainfont'),
                ),
              ],
            ),
          ],
        ));
  }
}
