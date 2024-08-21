import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../views/AnimatedDropdownPages.dart';

class Box extends StatefulWidget {
  const Box(
      {super.key,
      this.path,
      required this.title,
      required this.json,
      this.file});
  final String? path;
  final String title;
  final bool json;
  final List<dynamic>? file;

  @override
  State<Box> createState() => _BoxState();
}

class _BoxState extends State<Box> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return AnimatedDropdownPages(
            json: widget.json,
            path: widget.path,
            title: widget.title,
            file: widget.file,
          );
        }));
      },
      child: Container(
        margin: const EdgeInsets.all(15),
        height: 50,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(widget.title,
              style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'mainfont',
                  fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }
}
