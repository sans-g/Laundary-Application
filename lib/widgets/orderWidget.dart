import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundary_application/globalWidgets/appBar.dart';
import 'package:laundary_application/widgets/noOrder.dart';
import 'package:laundary_application/widgets/orderItemWidget.dart';

class OrderWidget extends StatefulWidget {
  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .doc(FirebaseAuth.instance.currentUser.uid)
            .collection("user_orders")
            .orderBy("orderNo", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          return Scaffold(
              appBar: appBar(context, "Orders Summary"),
              body: snapshot.hasData
                  ? snapshot.data.docs.length >= 1
                      ? Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              FittedBox(
                                child: Container(
                                  height: 35,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      FittedBox(
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              onGoingOrder = true;
                                              completedOrder = false;
                                            });
                                          },
                                          child: Container(
                                            child: Center(
                                              child: Text(
                                                "ONGOING ORDER",
                                                style: GoogleFonts.lato(
                                                    color: onGoingOrder ==
                                                                true &&
                                                            completedOrder ==
                                                                false
                                                        ? Colors.white
                                                        : Colors.grey,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            height: 40,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.45,
                                            decoration: BoxDecoration(
                                                color: onGoingOrder == true &&
                                                        completedOrder == false
                                                    ? Colors.lightBlue
                                                    : null,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                          ),
                                        ),
                                      ),
                                      FittedBox(
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              onGoingOrder = false;
                                              completedOrder = true;
                                            });
                                          },
                                          child: Container(
                                            child: Center(
                                              child: Text(
                                                "COMPLETED ORDERS",
                                                style: GoogleFonts.lato(
                                                    color: onGoingOrder ==
                                                                false &&
                                                            completedOrder ==
                                                                true
                                                        ? Colors.white
                                                        : Colors.grey,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            height: 40,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.45,
                                            decoration: BoxDecoration(
                                                color: onGoingOrder == false &&
                                                        completedOrder == true
                                                    ? Colors.lightBlue
                                                    : null,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SingleChildScrollView(
                                child: Container(
                                  height: height * 0.65,
                                  child: ListView.builder(
                                    itemCount: snapshot.data.docs.length,
                                    itemBuilder: (context, index) {
                                      var orderDetails =
                                          snapshot.data.docs[index].data();
                                      print(orderDetails['orderNo']);
                                      if (completedOrder ==
                                          orderDetails['order_delivered']) {
                                        return OrderItem(
                                          orderId: orderDetails['orderId'],
                                          laundryBagNumber:
                                              orderDetails['laundryBagNo'],
                                          orderAccepted:
                                              orderDetails['order_accepted'],
                                          orderProcessing:
                                              orderDetails['order_processing'],
                                          orderCompleted:
                                              orderDetails['order_completed'],
                                          orderDelivered:
                                              orderDetails['order_delivered'],
                                        );
                                      } else
                                        return SizedBox();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : NoOrder()
                  : NoOrder());
        });
  }
}

bool onGoingOrder = true, completedOrder = false;
