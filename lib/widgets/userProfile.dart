import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundary_application/globalWidgets/appBar.dart';
import 'package:shimmer/shimmer.dart';

class ProfileWidget extends StatefulWidget {
  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: appBar(context, "User Profile"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            DocumentSnapshot users = snapshot.data;
            return (snapshot.data == null || users.data() == null)
                ? Shimmer.fromColors(
                    highlightColor: Colors.white,
                    baseColor: Colors.grey[300],
                    child: ShimmerLayout(),
                    period: Duration(milliseconds: 1000),
                  )
                : Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 170,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(
                                  snapshot.data.data()['image_url']),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Center(
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundImage: NetworkImage(
                                      snapshot.data.data()['image_url']),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          users.data()['username'],
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.w800, fontSize: 20),
                        ),
                        Text(
                          user.email,
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.w800, fontSize: 20),
                        ),
                        Text(
                          users.data()['laundryBagNo'],
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.w800, fontSize: 20),
                        ),
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }
}

class ShimmerLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 7.5),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 60,
            ),
            SizedBox(height: 15),
            Container(
              height: 30,
              width: width,
              color: Colors.grey,
            ),
            SizedBox(height: 15),
            Container(
              height: 30,
              width: width,
              color: Colors.grey,
            ),
            SizedBox(height: 15),
            Container(
              height: 60,
              width: width,
              color: Colors.grey,
            ),
            SizedBox(height: 15),
            Container(
              height: 60,
              width: width,
              color: Colors.grey,
            ),
            SizedBox(height: 15),
            Container(
              height: 60,
              width: width,
              color: Colors.grey,
            ),
            SizedBox(height: 15),
            Container(
              height: 60,
              width: width,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
