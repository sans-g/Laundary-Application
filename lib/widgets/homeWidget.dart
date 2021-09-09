import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundary_application/model/laundaryItem.dart';
import 'package:laundary_application/widgets/laundryItemWidget.dart';
import 'package:shimmer/shimmer.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    var userId = FirebaseAuth.instance.currentUser.uid;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .snapshots(),
      builder: (context, snapshot1) {
        if (snapshot1.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection("laundryItems").snapshots(),
          builder: (context, snapshot2) {
            return Scaffold(
              appBar: (snapshot1.hasData)
                  ? AppBar(
                      backgroundColor: Colors.white,
                      elevation: 1,
                      leading: Shimmer.fromColors(
                        highlightColor: Colors.white,
                        baseColor: Colors.grey[300],
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.grey,
                          ),
                        ),
                        period: Duration(milliseconds: 1000),
                      ),
                      title: Shimmer.fromColors(
                        highlightColor: Colors.white,
                        baseColor: Colors.grey[300],
                        child: Container(
                          color: Colors.grey,
                          width: 200,
                          height: 30,
                        ),
                        period: Duration(milliseconds: 1000),
                      ),
                    )
                  : AppBar(
                      backgroundColor: Colors.white,
                      elevation: 1,
                      actions: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            MaterialIcons.notifications_none,
                            color: Colors.black,
                          ),
                        )
                      ],
                      leading: Padding(
                          padding: const EdgeInsets.all(5),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                                snapshot1.data.data()['image_url']),
                          )),
                      title: Text(
                        "Hello ${snapshot1.data.data()['username']}",
                        style: GoogleFonts.lato(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
              body: !snapshot2.hasData
                  ? GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          highlightColor: Colors.white,
                          baseColor: Colors.grey[300],
                          child: Container(
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.grey,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  height: 20,
                                  width: 150,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  height: 30,
                                  width: 80,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                          period: Duration(milliseconds: 1000),
                        );
                      },
                    )
                  : Padding(
                      padding: const EdgeInsets.all(20),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          accentColor: Colors.white12.withOpacity(1),
                        ),
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemCount: snapshot2.data.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot laundryItems =
                                snapshot2.data.docs[index];
                            if (laundryItemList.length + 1 <=
                                snapshot2.data.docs.length) {
                              laundryItemList.add(
                                LaundryItem(
                                    isAdded: false,
                                    imageURL: laundryItems.data()['imageURL'],
                                    itemName: laundryItems.data()['name'],
                                    quantity: 0),
                              );
                            }
                            return LaundryItemWidget(
                                name: laundryItems.data()['name'],
                                imageURL: laundryItems.data()['imageURL'],
                                index: index,
                                height: height);
                          },
                        ),
                      ),
                    ),
            );
          },
        );
      },
    );
  }
}
