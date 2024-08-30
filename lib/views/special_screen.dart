import 'package:elkeraza/Data/data_daily.dart';
import 'package:elkeraza/Model/coptic_model.dart';
import 'package:elkeraza/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class day_reading extends StatefulWidget {
  const day_reading({super.key});

  @override
  State<day_reading> createState() => _day_readingState();
}

class _day_readingState extends State<day_reading> {
  double? _selectedValue1 = 24.00;
  String? _selectedValue2 = 'اسود';
  List<dynamic> arugment = Get.arguments;
  // Variable to hold the AppBar title
  late String appBarTitle;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    CopticDate copticDate = gregorianToCoptic(now);
    appBarTitle = Date_without_weekday(copticDate);
  }

  @override
  Widget build(BuildContext context) {
    String datewithnospece = arugment[0].replaceAll(' ', '');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFDDB47E),
        actions: [
          IconButton(
            alignment: Alignment.topLeft,
            onPressed: () {
              showSettingsDialog(
                context,
                _selectedValue1!,
                _selectedValue2!,
                (double newFontSize, String newTextColor) {
                  setState(() {
                    _selectedValue1 = newFontSize;
                    _selectedValue2 = newTextColor;
                  });
                },
              );
            },
            icon: const Icon(Icons.settings),
          ),
          IconButton(
            alignment: Alignment.topLeft,
            onPressed: () async {
              DateTime now = DateTime.now();
              CopticDate copticDate = gregorianToCoptic(now);
              CopticDate? newDate =
                  await showCopticDatePickerDialog(context, copticDate);
              if (newDate != null) {
                setState(() {
                  // Update the date and title, then trigger UI update
                  arugment[0] = formatforreading(DateTime.now(), newDate);
                  appBarTitle = Date_without_weekday(newDate);
                });
              }
            },
            icon: const Icon(Icons.calendar_today),
          ),
        ],
        title: Text(
          appBarTitle,
          style: TextStyle(
              color: const Color.fromARGB(255, 120, 8, 0),
              fontSize: 20.sp,
              fontFamily: 'mainfont'),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpeg'),
            fit: BoxFit.cover, // You can change the fit as needed
          ),
        ),
        child: ListView(
          children: dataList
              .where(
                  (data) => data['date'].replaceAll(' ', '') == datewithnospece)
              .map((data) {
            return Container(
              color: Colors.white24,
              child: Text(
                data['data'],
                style: TextStyle(
                    fontFamily: 'mainfont',
                    fontSize: _selectedValue1,
                    fontWeight: FontWeight.bold,
                    color:
                        _selectedValue2 == 'ابيض' ? Colors.white : Colors.black,
                    height: 2.0),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
