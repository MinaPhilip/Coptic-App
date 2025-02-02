import 'package:flutter/material.dart';
import 'package:elkeraza/Model/coptic_model.dart';

Future<void> showSettingsDialog(
  BuildContext context,
  double selectedValue1,
  String selectedValue2,
  Function(double, String) onSettingsChanged,
) async {
  await showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          "الاعدادات",
          style: TextStyle(fontFamily: 'mainfont'),
        ),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'حجم الخط',
                  style: TextStyle(fontFamily: 'mainfont'),
                ),
                DropdownButton<double>(
                  value: selectedValue1,
                  onChanged: (double? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedValue1 = newValue;
                      });
                    }
                  },
                  items: <double>[12, 24, 36, 48, 60]
                      .map<DropdownMenuItem<double>>((double value) {
                    return DropdownMenuItem<double>(
                      value: value,
                      child: Text(
                        value.toString(),
                        style: const TextStyle(fontFamily: 'mainfont'),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                const Text(
                  'لون الخط',
                  style: TextStyle(fontFamily: 'mainfont'),
                ),
                DropdownButton<String>(
                  value: selectedValue2,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedValue2 = newValue;
                      });
                    }
                  },
                  items: <String>['اسود', 'ابيض']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(fontFamily: 'mainfont'),
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          },
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              "Close",
              style: TextStyle(fontFamily: 'mainfont', color: Colors.black),
            ),
            onPressed: () {
              // Pass the updated values back to the parent widget
              onSettingsChanged(selectedValue1, selectedValue2);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<CopticDate?> showCopticDatePickerDialog(
    BuildContext context, CopticDate initialDate) async {
  int selectedDay = initialDate.day;
  int selectedMonth = initialDate.month;
  int selectedYear = initialDate.year;

  return showDialog<CopticDate>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('اختار التاريخ القبطي'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<int>(
                  value: selectedDay,
                  items: List.generate(
                          selectedMonth == 13
                              ? (selectedYear % 4 == 3 ? 6 : 5)
                              : 30,
                          (index) => index + 1)
                      .map((day) => DropdownMenuItem<int>(
                            value: day,
                            child: Text(day.toString()),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedDay = value;
                      });
                    }
                  },
                ),
                DropdownButton<int>(
                  value: selectedMonth,
                  items: List.generate(13, (index) => index + 1)
                      .map((month) => DropdownMenuItem<int>(
                            value: month,
                            child: Text(copticMonths[month - 1]),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedMonth = value;
                        selectedDay = 1; // Reset day when month changes
                      });
                    }
                  },
                ),
                DropdownButton<int>(
                  value: selectedYear,
                  items: List.generate(
                          50, (index) => index + initialDate.year - 25)
                      .map((year) => DropdownMenuItem<int>(
                            value: year,
                            child: Text(year.toString()),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedYear = value;
                        if (selectedMonth == 13) {
                          selectedDay =
                              1; // Reset day when year changes if month is نسئ
                        }
                      });
                    }
                  },
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pop(); // Close the dialog without returning a date
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              CopticDate newDate = CopticDate(
                day: selectedDay,
                month: selectedMonth,
                year: selectedYear,
                monthName: copticMonths[selectedMonth - 1],
                weekday: arabicWeekdays[DateTime.now().weekday % 7],
              );
              Navigator.of(context).pop(newDate);
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
