import 'package:elkeraza/Model/coptic_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    CopticDate copticDate = gregorianToCoptic(now);

    return Scaffold(
      backgroundColor: const Color(0xFFDDB47E),
      appBar: AppBar(title: Text('التقويم القبطي')),
      body: Padding(
        padding: const EdgeInsets.only(right: 30, left: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'تاريخ اليوم:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              DateFormat.yMMMMd('ar').format(now), // Localized date format
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'التاريخ القبطي:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              formatCopticDate(now, copticDate),
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
