import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundary_application/screen/orderDetails.dart';

class OrderItem extends StatefulWidget {
  final String orderId;
  final String laundryBagNumber;
  final bool orderAccepted;
  final bool orderCompleted;
  final bool orderProcessing;
  final bool orderDelivered;

  OrderItem({
    @required this.orderId,
    @required this.orderAccepted,
    @required this.orderProcessing,
    @required this.laundryBagNumber,
    @required this.orderCompleted,
    @required this.orderDelivered,
  });

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isLoading = false;
    return Card(
      elevation: 3,
      child: FittedBox(
        child: Container(
          width: width,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "ORDER-ID",
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                      ),
                    ),
                    Container(
                      width: width * 0.2,
                      height: 35,
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                        child: Text(
                          widget.orderId,
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  widget.laundryBagNumber,
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                  ),
                ),
                Text(
                  "ORDER PLACED-PLEASE SUBMIT YOUR LAUNDRY BAG TO CONFORM YOUR ORDER...",
                  style: GoogleFonts.lato(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OrderStatus(
                      imageUrl: 'assets/orderPlaced.png',
                      title: 'ACCEPTED',
                      status: widget.orderAccepted,
                    ),
                    OrderStatus(
                      imageUrl: 'assets/processing.png',
                      title: 'PROCESS',
                      status: widget.orderProcessing,
                    ),
                    OrderStatus(
                      imageUrl: 'assets/orderCompleted.png',
                      title: 'COMPLETED',
                      status: widget.orderCompleted,
                    ),
                    OrderStatus(
                      imageUrl: 'assets/deleverd.png',
                      title: 'DELIVERED',
                      status: widget.orderDelivered,
                    ),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (!widget.orderAccepted)
                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) {
                                return AlertDialog(
                                  title: Text("DELETE ORDER"),
                                  content: Text(
                                      "This order will be permanently deleted. You will no longer able to access this order",
                                      style: GoogleFonts.lato()),
                                  actions: [
                                    FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("CANCEL",
                                            style: GoogleFonts.lato())),
                                    FlatButton(
                                      onPressed: () async {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        await FirebaseFirestore.instance
                                            .collection("orders")
                                            .doc(FirebaseAuth
                                                .instance.currentUser.uid)
                                            .collection("user_orders")
                                            .get()
                                            .then((value) {
                                          value.docs.forEach((element) {
                                            if (element.data()['orderId'] ==
                                                widget.orderId)
                                              element.reference.delete();
                                          });
                                        });
                                        setState(() {
                                          isLoading = true;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: isLoading
                                          ? CircularProgressIndicator()
                                          : Text(
                                              "CONFORM",
                                              style: GoogleFonts.lato(),
                                            ),
                                    ),
                                  ],
                                );
                              });
                        },
                        child: Container(
                          width: width * 0.4,
                          height: 40,
                          child: Center(
                              child: Text(
                            "DELETE",
                            style: GoogleFonts.lato(color: Colors.orange),
                          )),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.orange),
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return OrderDetails(
                            orderId: widget.orderId,
                          );
                        }));
                      },
                      child: Container(
                        width: width * 0.4,
                        height: 40,
                        child: Center(
                            child: Text(
                          "VIEW DETAILS",
                          style: GoogleFonts.lato(color: Colors.white),
                        )),
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OrderStatus extends StatelessWidget {
  final String imageUrl;
  final String title;
  final bool status;

  OrderStatus({
    @required this.imageUrl,
    @required this.title,
    @required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: status ? Colors.green : Colors.white,
          child: CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Image.asset(imageUrl),
            ),
          ),
        ),
        Text(
          title,
          style: GoogleFonts.lato(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: status ? Colors.green : Colors.grey,
          ),
        )
      ],
    );
  }
}
