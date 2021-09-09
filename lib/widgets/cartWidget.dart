import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:laundary_application/globalWidgets/appBar.dart';
import 'package:laundary_application/model/laundaryItem.dart';
import 'package:laundary_application/widgets/emptyCartWidget.dart';
import 'package:laundary_application/widgets/richText.dart';
import 'package:random_string/random_string.dart';

class CartWidget extends StatefulWidget {
  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  bool isLoading = false;
  List<LaundryItem> cartItems =
      laundryItemList.where((element) => element.quantity > 0).toList();
  User user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    int totalQuantity = 0;
    for (int i = 0; i < cartItems.length; i++) {
      totalQuantity = cartItems[i].quantity + totalQuantity;
    }
    DateTime dateTime = DateTime.now();
    String formattedDate = DateFormat('d MMM yyyy').format(dateTime);
    String formattedTime = DateFormat('kk:mm:ss').add_jm().format(dateTime);
    String formattedDay = DateFormat('EEEEE').format(dateTime);
    return Scaffold(
      appBar: appBar(context, "Review Cart"),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .doc(user.uid)
            .collection("user_orders")
            .snapshots(),
        builder: (context, snapshot) {
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(user.uid)
                  .snapshots(),
              builder: (context, snapshot1) {
                DocumentSnapshot users = snapshot1.data;
                if (snapshot1.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Padding(
                    padding: const EdgeInsets.all(20),
                    child: cartItems.length > 0
                        ? Theme(
                            data: Theme.of(context).copyWith(
                              accentColor: Colors.white12.withOpacity(1),
                            ),
                            child: ListView(
                              children: [
                                Card(
                                  elevation: 3,
                                  child: Container(
                                    height: height * 0.26,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            "Total Cloths: $totalQuantity",
                                            style: GoogleFonts.lato(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 17,
                                            ),
                                          ),
                                          Divider(
                                            color: Colors.black,
                                          ),
                                          CustomText(
                                              title1: "SUBMIT BY",
                                              title2: "Today, 2:00 PM"),
                                          CustomText(
                                              title1: "PICK UP",
                                              title2: "AFTER TWO DAYS"),
                                          Divider(
                                            color: Colors.black,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              if (!isLoading)
                                                MaterialButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      laundryItemList
                                                          .forEach((element) {
                                                        setState(() {
                                                          element.quantity = 0;
                                                        });
                                                        cartItems = [];
                                                      });
                                                    });
                                                  },
                                                  child: Text(
                                                    "EMPTY CART",
                                                    style: GoogleFonts.lato(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.w900),
                                                  ),
                                                ),
                                              MaterialButton(
                                                  onPressed: () async {
                                                    setState(() {
                                                      isLoading = true;
                                                    });

                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('orders')
                                                        .doc(user.uid)
                                                        .collection(
                                                            "user_orders")
                                                        .add({
                                                      'orderNo': (snapshot
                                                              .data
                                                              .docs
                                                              .length *
                                                          35),
                                                      'orderId':
                                                          randomAlphaNumeric(6),
                                                      'User Details': {
                                                        'username': users
                                                            .data()['username'],
                                                        'email': user.email,
                                                        'image_url':
                                                            users.data()[
                                                                'image_url'],
                                                      },
                                                      'Date & Time': {
                                                        'date': formattedDate,
                                                        'time': formattedTime,
                                                        'day': formattedDay,
                                                      },
                                                      'total cloths':
                                                          totalQuantity,
                                                      'Laundry Bag Details':
                                                          cartItems
                                                              .map((e) => {
                                                                    'name': e
                                                                        .itemName,
                                                                    'quantity':
                                                                        e.quantity,
                                                                  })
                                                              .toList(),
                                                      'laundryBagNo':
                                                          users.data()[
                                                              'laundryBagNo'],
                                                      'order_accepted': false,
                                                      'order_processing': false,
                                                      'order_completed': false,
                                                      'order_delivered': false,
                                                    });
                                                    setState(() {
                                                      isLoading = false;
                                                    });
                                                    setState(() {
                                                      laundryItemList
                                                          .forEach((element) {
                                                        setState(() {
                                                          element.quantity = 0;
                                                        });
                                                        cartItems = [];
                                                      });
                                                    });
                                                  },
                                                  child: isLoading
                                                      ? CircularProgressIndicator(
                                                          backgroundColor:
                                                              Colors.blue,
                                                        )
                                                      : Text(
                                                          "CONFIRM ORDER",
                                                          style:
                                                              GoogleFonts.lato(
                                                            fontSize: 14,
                                                            color: Colors
                                                                .lightBlueAccent,
                                                            fontWeight:
                                                                FontWeight.w900,
                                                          ),
                                                        )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Order Summary",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w700),
                                ),
                                Container(
                                  height: height * 0.463,
                                  child: ListView.builder(
                                    itemBuilder: (context, index) {
                                      return Card(
                                        elevation: 3,
                                        child: ListTile(
                                          leading: Image.network(
                                              cartItems[index].imageURL),
                                          title: Text(
                                            cartItems[index].itemName,
                                            style: GoogleFonts.lato(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 19),
                                          ),
                                          subtitle: Text(
                                            "Quantity: ${cartItems[index].quantity}",
                                            style: GoogleFonts.lato(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 17),
                                          ),
                                          trailing: IconButton(
                                              icon: Icon(
                                                FontAwesome.times_circle,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  cartItems[index].quantity = 0;
                                                  cartItems[index].isAdded =
                                                      false;
                                                  cartItems.removeAt(index);
                                                });
                                              }),
                                        ),
                                      );
                                    },
                                    itemCount: cartItems.length,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : emptyCart());
              });
        },
      ),
    );
  }
}


