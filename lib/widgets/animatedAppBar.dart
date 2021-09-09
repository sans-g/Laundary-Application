import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:laundary_application/model/laundaryItem.dart';

// ignore: must_be_immutable
class AnimatedAppBar extends StatelessWidget {
  AnimationController colorAnimationController;
  Animation colorTween, homeTween, workOutTween, iconTween, drawerTween;
  Function onPressed;

  AnimatedAppBar({
    @required this.colorAnimationController,
    @required this.onPressed,
    @required this.colorTween,
    @required this.homeTween,
    @required this.iconTween,
    @required this.drawerTween,
    @required this.workOutTween,
  });

  @override
  Widget build(BuildContext context) {
    var userId = FirebaseAuth.instance.currentUser.uid;
    int totalQuantity = 0;
    List<LaundryItem> cartItems =
        laundryItemList.where((element) => element.quantity > 0).toList();

    for (int i = 0; i < cartItems.length; i++) {
      totalQuantity = cartItems[i].quantity + totalQuantity;
    }
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(userId)
            .snapshots(),
        builder: (context, snapshot1) {
          return Container(
            height: 80,
            child: AnimatedBuilder(
                animation: colorAnimationController,
                builder: (context, child) => snapshot1.hasData
                    ? AppBar(
                        leading: IconButton(
                          icon: Icon(
                            Icons.dehaze,
                            color: drawerTween.value,
                          ),
                          onPressed: onPressed,
                        ),
                        backgroundColor: colorTween.value,
                        elevation: 0,
                        titleSpacing: 0.0,
                        title: Row(
                          children: <Widget>[
                            Text(
                              "Hello  ",
                              style: TextStyle(
                                  color: homeTween.value,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 1),
                            ),
                            Text(
                              snapshot1.data.data()['username'],
                              style: TextStyle(
                                  color: workOutTween.value,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 1),
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          Icon(
                            Icons.notifications,
                            color: iconTween.value,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(7),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  snapshot1.data.data()['image_url']),
                            ),
                          ),
                        ],
                      )
                    : CircularProgressIndicator()),
          );
        });
  }
}
