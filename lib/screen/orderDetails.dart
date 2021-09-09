import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundary_application/widgets/orderItemWidget.dart';
import 'package:laundary_application/widgets/richText.dart';

class OrderDetails extends StatefulWidget {
  final String orderId;

  OrderDetails({
    @required this.orderId,
  });

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  var orderDetails;
  TextStyle textStyle =
      GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.w900);
  List<dynamic> laundryBag;

  void initState() {
    FirebaseFirestore.instance
        .collection("orders")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("user_orders")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        if (element.data()['orderId'] == widget.orderId)
          setState(() {
            orderDetails = element.data();
            laundryBag = orderDetails['Laundry Bag Details'];
          });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(orderDetails);
    print(widget.orderId);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Widget _orderStatus(
      String imageUrl,
      String title,
      bool status,
      String successText,
      String pendingText,
    ) {
      return Row(
        children: [
          OrderStatus(
            imageUrl: imageUrl,
            title: title,
            status: status,
          ),
          SizedBox(
            width: 5,
          ),
          Container(
            width: width * 0.7,
            child: status
                ? Text(
                    successText,
                    style: GoogleFonts.lato(),
                  )
                : Text(
                    pendingText,
                    style: GoogleFonts.lato(color: Colors.grey),
                  ),
          )
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          "ORDER DETAILS",
          style: GoogleFonts.lato(color: Colors.black),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: orderDetails != null
          ? Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ORDER-ID: ${orderDetails['orderId']}",
                      style: textStyle,
                    ),
                    Divider(),
                    Text(
                      "USER DETAILS",
                      style: textStyle,
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                            backgroundImage: NetworkImage(
                                orderDetails['User Details']['image_url'])),
                        SizedBox(
                          width: 5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              title1: "NAME",
                              title2: orderDetails['User Details']['username'],
                            ),
                            CustomText(
                              title1: "EMAIL",
                              title2: orderDetails['User Details']['email'],
                            ),
                            CustomText(
                              title1: "Laundry Bag Number",
                              title2: orderDetails['laundryBagNo'],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(),
                    Text(
                      "ORDER DATE & TIME",
                      style: textStyle,
                    ),
                    CustomText(
                      title1: 'DAY',
                      title2: orderDetails['Date & Time']['day'],
                    ),
                    CustomText(
                      title1: "DATE",
                      title2: orderDetails['Date & Time']['date'],
                    ),
                    CustomText(
                      title1: "TIME",
                      title2: orderDetails['Date & Time']['time'],
                    ),
                    Divider(),
                    Text(
                      "LAUNDRY BAG DETAILS",
                      style: textStyle,
                    ),
                    CustomText(
                      title1: "Total Cloths",
                      title2: orderDetails['total cloths'].toString(),
                    ),
                    Container(
                      height: 17.0 * laundryBag.length,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Text("${index + 1}. "),
                              CustomText(
                                  title1: laundryBag[index]['name'],
                                  title2:
                                      laundryBag[index]['quantity'].toString()),
                            ],
                          );
                        },
                        itemCount: laundryBag.length,
                      ),
                    ),
                    Divider(),
                    Text(
                      "ORDER STATUS",
                      style: textStyle,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(),
                        _orderStatus(
                            "assets/orderPlaced.png",
                            'ACCEPTED',
                            orderDetails['order_accepted'],
                            'Your order has been successfully accepted by the laundry team',
                            "Please submit your laundry bag to the laundry office before 2:00 PM"),
                        Divider(),
                        _orderStatus(
                            'assets/processing.png',
                            'PROCESS',
                            orderDetails['order_processing'],
                            'Your laundry bag has been successfully verified by the laundry team.',
                            'Your bag is not verified by the laundry team...'),
                        Divider(),
                        _orderStatus(
                            'assets/orderCompleted.png',
                            'COMPLETED',
                            orderDetails['order_completed'],
                            "Your garments has been successfully washed. Please visit the laundry office to collect your laundry bag.",
                            "Your bag is under progress..."),
                        Divider(),
                        _orderStatus(
                            'assets/deleverd.png',
                            'DELIVERED',
                            orderDetails['order_delivered'],
                            "Your bag has been successfully delivered.",
                            "Pending..."),
                        Divider(),
                      ],
                    )
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
