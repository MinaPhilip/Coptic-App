import 'package:elkeraza/Data/candle_prayer.dart';
import 'package:elkeraza/Data/lqan_prayer.dart';
import 'package:elkeraza/Data/oath_prayers.dart';
import 'package:elkeraza/Data/prostration_prayer.dart';
import 'package:elkeraza/Model/Category_model.dart';
import 'package:elkeraza/views/AnimatedDropdownPages.dart';
import 'package:elkeraza/views/options.dart';
import 'package:elkeraza/views/special_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Model/coptic_model.dart';
import '../widgets/Category_items.dart';

class homepage extends StatefulWidget {
  homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
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
          widget_CategoryModel: const Options()),
      CategoryModel(
          image: 'assets/daily.jpg',
          title: 'القراءات اليومية',
          subtitle: 'القراءات الخاصه باليوم حسب التاريخ القبطي',
          widget_CategoryModel: day_reading(
            date: formatforreading(now, copticDate),
          )),
      CategoryModel(
          title: 'صلاة القنديل',
          image: 'assets/candle.jpg',
          subtitle: 'تحتوي علي صلوات القنديل من الاولي الي السابعة',
          widget_CategoryModel: AnimatedDropdownPages(
            title: 'صلاة القنديل',
            json: false,
            file: candlePrayer,
          )),
      CategoryModel(
          title: 'صلاة اللقان',
          image: 'assets/lqan.jpg',
          subtitle: 'ثلاث صلوات اللقان اللتي في السنة',
          widget_CategoryModel: AnimatedDropdownPages(
            title: 'صلاة اللقان',
            json: false,
            file: lqanPrayer,
          )),
      CategoryModel(
          title: 'صلاة السجده',
          image: 'assets/prostration.jpeg',
          subtitle: 'ثلاث صلوات السجده مع المقدمة ',
          widget_CategoryModel: AnimatedDropdownPages(
            title: 'صلاة سجده',
            json: false,
            file: prostrationPrayer,
          )),
      CategoryModel(
          title: 'صلوات القسم',
          image: 'assets/oath.jpg',
          subtitle: 'صلاة تصاحب تقسيم الجسد المقدس في القداس الإلهي ',
          widget_CategoryModel: AnimatedDropdownPages(
            title: 'صلوات القسم',
            json: false,
            file: oathPrayers,
          ))
    ];
    return Scaffold(
        backgroundColor: const Color(0xFFDDB47E),
        appBar: AppBar(
            backgroundColor: const Color(0xFFDDB47E),
            elevation: 1,
            automaticallyImplyLeading: false,
            title: const Center(
              child: Text('المنجلية',
                  style: TextStyle(fontSize: 24, fontFamily: 'mainfont')),
            )),
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
