import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:laundary_application/model/laundaryItem.dart';
import 'laundryItemWidget.dart';

class LaundryItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    return StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection("laundryItems").snapshots(),
        builder: (context, snapshot2) {
          return snapshot2.hasData
              ? Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "PLACE YOUR ORDER",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic),
                      ),
                      Container(
                        height: snapshot2.data.docs.length * 120.0,
                        child: ListView.builder(
                          itemCount: snapshot2.data.docs.length,
                          physics: NeverScrollableScrollPhysics(),
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
                    ],
                  ),
                )
              : CircularProgressIndicator();
        });
  }
}
