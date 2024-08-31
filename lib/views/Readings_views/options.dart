import 'package:flutter/material.dart';
import '../../Data/prayers/midnight_prayer.dart';
import '../../widgets/Componets_reading/box.dart';

class Options extends StatefulWidget {
  const Options({super.key});
  @override
  State<Options> createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  @override
  void dispose() {
    // Cancel or ignore ongoing asynchronous operations
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFDDB47E),
        appBar: AppBar(
          backgroundColor: const Color(0xFFDDB47E),
          title: const Text('الصلوات',
              style: TextStyle(color: Colors.black, fontFamily: 'mainfont')),
        ),
        body: ListView(
          children: [
            const Box(
              title: 'صلاة باكر',
              json: true,
              path: 'assets/Data/elagbia/bakr.json',
            ),
            const Box(
              title: 'صلاة الساعة الثالثة',
              json: true,
              path: 'assets/Data/elagbia/elthaltha.json',
            ),
            const Box(
              title: 'صلاة الساعة السادسة',
              json: true,
              path: 'assets/Data/elagbia/elsadsa.json',
            ),
            const Box(
              title: 'صلاة الساعة التاسعة',
              json: true,
              path: 'assets/Data/elagbia/eltas3a.json',
            ),
            const Box(
              title: 'صلاة الغروب',
              json: true,
              path: 'assets/Data/elagbia/el8rob.json',
            ),
            const Box(
              title: 'صلاة النوم',
              json: true,
              path: 'assets/Data/elagbia/elnom.json',
            ),
            Box(
              title: 'صلاة نصف الليل',
              json: false,
              path: '',
              file: midnightPrayer,
            ),
            const Box(
              title: 'صلاة الستار',
              json: true,
              path: 'assets/Data/elagbia/elsetar.json',
            ),
          ],
        ));
  }
}
