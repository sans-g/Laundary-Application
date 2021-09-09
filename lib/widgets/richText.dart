import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String title1;
  final String title2;

  CustomText({
    @required this.title1,
    @required this.title2,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "$title1: ",
        style: GoogleFonts.lato(fontSize: 13, color: Colors.grey),
        children: <TextSpan>[
          TextSpan(
              text: title2,
              style:
                  TextStyle(fontWeight: FontWeight.w700, color: Colors.black,)),
        ],
      ),
    );
  }
}
