import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoOrder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/demo1.png",
              width: 400,
            ),
            Text(
              "No orders",
              style:
              GoogleFonts.lato(fontWeight: FontWeight.w800, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
