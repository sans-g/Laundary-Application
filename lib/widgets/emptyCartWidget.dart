import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

Widget emptyCart() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/upload.png",
          width: 200,
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          "ADD ITEMS TO YOUR BAG",
          style: GoogleFonts.lato(
              fontWeight: FontWeight.w800, fontSize: 20),
        )
      ],
    ),
  );
}
