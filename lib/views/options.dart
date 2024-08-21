import 'package:elkeraza/Data/midnight_prayer.dart';
import 'package:elkeraza/widgets/Box.dart';
import 'package:flutter/material.dart';

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
              json: true,
              title: 'صلاة باكر',
              path: 'assets/Data/elagbia/bakr.json',
            ),
            const Box(
              json: true,
              title: 'صلاة الساعة الثالثة',
              path: 'assets/Data/elagbia/elthaltha.json',
            ),
            const Box(
              json: true,
              title: 'صلاة الساعة السادسة',
              path: 'assets/Data/elagbia/elsadsa.json',
            ),
            const Box(
              json: true,
              title: 'صلاة الساعة التاسعة',
              path: 'assets/Data/elagbia/eltas3a.json',
            ),
            const Box(
              json: true,
              title: 'صلاة الغروب',
              path: 'assets/Data/elagbia/el8rob.json',
            ),
            const Box(
              json: true,
              title: 'صلاة النوم',
              path: 'assets/Data/elagbia/elnom.json',
            ),
            Box(
              json: false,
              title: 'صلاة نصف الليل',
              file: midnightPrayer,
            ),
            const Box(
              json: true,
              title: 'صلاة الستار',
              path: 'assets/Data/elagbia/elsetar.json',
            ),
          ],
        ));
  }
}
