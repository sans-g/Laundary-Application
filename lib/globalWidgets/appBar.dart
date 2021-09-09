import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget appBar(BuildContext context, String title) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 1,
    leading: IconButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      icon: Icon(
        Icons.arrow_back_ios,
        color: Colors.blue,
      ),
    ),
    title: Text(
      title,
      style: GoogleFonts.lato(color: Colors.black, fontWeight: FontWeight.w800),
    ),
  );
}
