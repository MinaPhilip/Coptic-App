class CopticDate {
  final int day;
  final int month;
  final int year;
  final String monthName;
  final String weekday;

  CopticDate(
      {required this.day,
      required this.month,
      required this.year,
      required this.monthName,
      required this.weekday});
}

List<String> copticMonths = [
  'توت',
  'بابه',
  'هاتور',
  'كيهك',
  'طوبه',
  'أمشير',
  'برمهات',
  'برموده',
  'بشنس',
  'بؤونه',
  'أبيب',
  'مسري',
  'نسئ'
];

List<String> arabicWeekdays = [
  'الأحد',
  'الإثنين',
  'الثلاثاء',
  'الأربعاء',
  'الخميس',
  'الجمعة',
  'السبت'
];

CopticDate gregorianToCoptic(DateTime date) {
  int year = date.year;

  int copticYear = year - 283;
  DateTime copticNewYear = DateTime(year, 9, 11);

  if (year % 4 == 3) {
    copticNewYear = DateTime(year, 9, 12);
  }

  int daysSinceCopticNewYear = date.difference(copticNewYear).inDays;

  if (daysSinceCopticNewYear < 0) {
    copticYear -= 1;
    copticNewYear = DateTime(year - 1, 9, 11);

    if ((year - 1) % 4 == 3) {
      copticNewYear = DateTime(year - 1, 9, 12);
    }

    daysSinceCopticNewYear = date.difference(copticNewYear).inDays;
  }

  int copticMonthIndex = daysSinceCopticNewYear ~/ 30;
  int copticDay = (daysSinceCopticNewYear % 30) + 1;
  String copticMonthName = copticMonths[copticMonthIndex];
  String weekday = arabicWeekdays[date.weekday % 7];

  return CopticDate(
      day: copticDay,
      month: copticMonthIndex + 1,
      year: copticYear,
      monthName: copticMonthName,
      weekday: weekday);
}

String formatCopticDate(DateTime date, CopticDate copticDate) {
  String weekday = arabicWeekdays[date.weekday % 7];
  return '$weekday ${copticDate.day} ${copticDate.monthName} ${copticDate.year}';
}

String formatforreading(DateTime date, CopticDate copticDate) {
  return '${copticDate.monthName}${copticDate.day} ';
}

String Date_without_weekday(CopticDate copticDate) {
  return '${copticDate.day} ${copticDate.monthName} ${copticDate.year}';
}
