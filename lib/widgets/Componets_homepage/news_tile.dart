import 'package:elkeraza/Model/Artical_model.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Newstile extends StatelessWidget {
  const Newstile({super.key, required this.artical});
  final Artical artical;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return artical.widget_artical;
        }));
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Container(
              margin: const EdgeInsets.only(left: 15, right: 15),
              height: 150,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                artical.image ?? '',
                fit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            artical.title ?? '',
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
                fontFamily: 'mainfont'),
          ),
          Text(
            maxLines: 2,
            artical.subtitle ?? '',
            style: TextStyle(
                color: Colors.black54, fontSize: 11.sp, fontFamily: 'mainfont'),
          )
        ],
      ),
    );
  }
}
