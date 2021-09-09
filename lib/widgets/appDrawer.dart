import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laundary_application/widgets/orderWidget.dart';
import 'package:laundary_application/widgets/settingWidget.dart';
import 'package:laundary_application/widgets/userProfile.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    var userId = FirebaseAuth.instance.currentUser.uid;
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(userId)
                    .snapshots(),
                builder: (context, snapshot) {
                  return snapshot.hasData?Container(
                    height: 170,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(snapshot.data.data()['image_url']),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 100, left: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(
                                    snapshot.data.data()['image_url']),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data.data()['username'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        fontSize: 20),
                                  ),
                                  Text(
                                    snapshot.data.data()['laundryBagNo'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        fontSize: 20),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ):Container();
                }),
            Divider(),
            Container(
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: ListTile(
                title: Text("Orders"),
                onTap: () {
                  Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (context, animation, anotherAnimation) {
                        return OrderWidget();
                      },
                      transitionDuration: Duration(milliseconds: 600),
                      transitionsBuilder:
                          (context, animation, anotherAnimation, child) {
                        animation = CurvedAnimation(
                            curve: Curves.bounceIn, parent: animation);
                        return SlideTransition(
                          position: Tween(
                                  begin: Offset(1.0, 0.0),
                                  end: Offset(0.0, 0.0))
                              .animate(animation),
                          child: ScaleTransition(
                            scale: animation,
                            child: child,
                          ),
                        );
                      }));
                },
                leading: Icon(
                  Icons.assignment,
                  size: 25,
                  color: Colors.black87.withOpacity(0.7),
                ),
              ),
            ),
            Divider(),
            Container(
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: ListTile(
                leading: Icon(
                  Icons.perm_contact_cal_outlined,
                  size: 25,
                  color: Colors.black87.withOpacity(0.7),
                ),
                title: Text("User Profile"),
                onTap: () {
                  Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (context, animation, anotherAnimation) {
                        return ProfileWidget();
                      },
                      transitionDuration: Duration(milliseconds: 600),
                      transitionsBuilder:
                          (context, animation, anotherAnimation, child) {
                        animation = CurvedAnimation(
                            curve: Curves.bounceIn, parent: animation);
                        return SlideTransition(
                          position: Tween(
                              begin: Offset(1.0, 0.0),
                              end: Offset(0.0, 0.0))
                              .animate(animation),
                          child: ScaleTransition(
                            scale: animation,
                            child: child,
                          ),
                        );
                      }));
                },
              ),
            ),
            Divider(),
            Container(
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: ListTile(
                title: Text("Settings"),
                onTap: () {
                  Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (context, animation, anotherAnimation) {
                        return SettingWidget();
                      },
                      transitionDuration: Duration(milliseconds: 600),
                      transitionsBuilder:
                          (context, animation, anotherAnimation, child) {
                        animation = CurvedAnimation(
                            curve: Curves.bounceIn, parent: animation);
                        return SlideTransition(
                          position: Tween(
                              begin: Offset(1.0, 0.0),
                              end: Offset(0.0, 0.0))
                              .animate(animation),
                          child: ScaleTransition(
                            scale: animation,
                            child: child,
                          ),
                        );
                      }));
                },
                leading: Icon(
                  Icons.settings,
                  size: 25,
                  color: Colors.black87.withOpacity(0.7),
                ),
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
