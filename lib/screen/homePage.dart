import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laundary_application/model/laundaryItem.dart';
import 'package:laundary_application/widgets/animatedAppBar.dart';
import 'package:laundary_application/widgets/appDrawer.dart';
import 'package:laundary_application/widgets/cartWidget.dart';
import 'package:laundary_application/widgets/gradentContainer.dart';
import 'package:laundary_application/widgets/laundryItems.dart';
import 'package:laundary_application/widgets/weekGoals.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  // ignore: non_constant_identifier_names
  AnimationController _ColorAnimationController;

  // ignore: non_constant_identifier_names
  AnimationController _TextAnimationController;
  Animation _colorTween, _homeTween, _workOutTween, _iconTween, _drawerTween;

  @override
  void initState() {
    _ColorAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    _colorTween = ColorTween(begin: Colors.transparent, end: Colors.white)
        .animate(_ColorAnimationController);
    _iconTween =
        ColorTween(begin: Colors.white, end: Colors.lightBlue.withOpacity(0.5))
            .animate(_ColorAnimationController);
    _drawerTween = ColorTween(begin: Colors.white, end: Colors.black)
        .animate(_ColorAnimationController);
    _homeTween = ColorTween(begin: Colors.white, end: Colors.blue)
        .animate(_ColorAnimationController);
    _workOutTween = ColorTween(begin: Colors.white, end: Colors.black)
        .animate(_ColorAnimationController);
    _TextAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));

    super.initState();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  bool scrollListener(ScrollNotification scrollInfo) {
    bool scroll = false;
    if (scrollInfo.metrics.axis == Axis.vertical) {
      _ColorAnimationController.animateTo(scrollInfo.metrics.pixels / 80);

      _TextAnimationController.animateTo(scrollInfo.metrics.pixels);
      return scroll = true;
    }
    return scroll;
  }



  @override
  Widget build(BuildContext context) {
    int quantity = 0;
    List<LaundryItem> cartItems =
        laundryItemList.where((element) => element.quantity > 0).toList();
    for (int i = 0; i < cartItems.length; i++)
      quantity = quantity + cartItems[i].quantity;
    return Scaffold(
      key: scaffoldKey,
      drawer: AppDrawer(),
      backgroundColor: Color(0xFFEEEEEE),
      body: NotificationListener<ScrollNotification>(
        onNotification: scrollListener,
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              child: Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            GradientContainer(
                              pendingOrders: 1,
                              ongoingOrders: 4,
                              completedOrders: 1,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            LaundryItems(),
                          ],
                        ),
                        WeekGoal(),
                      ],
                    ),
                  ),
                  AnimatedAppBar(
                    drawerTween: _drawerTween,
                    onPressed: () {
                      scaffoldKey.currentState.openDrawer();
                    },
                    colorAnimationController: _ColorAnimationController,
                    colorTween: _colorTween,
                    homeTween: _homeTween,
                    iconTween: _iconTween,
                    workOutTween: _workOutTween,
                  )
                ],
              ),
            ),
            if (cartItems.length > 0)
              Positioned(
                bottom: 10,
                left: 20,
                right: 20,
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.blue[200], Colors.blueAccent[700]],
                          end: Alignment.bottomRight,
                          begin: Alignment.topLeft),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Items:$quantity",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white),
                        ),
                        Row(
                          children: [
                            Stack(
                              children: <Widget>[
                                Center(
                                    child: Icon(
                                  Icons.shopping_cart,
                                  color: Colors.white,
                                )),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 15, top: 12),
                                  child: CircleAvatar(
                                    minRadius: 7,
                                    maxRadius: 7,
                                    backgroundColor: Colors.green,
                                    child: Text(
                                      cartItems.length.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation, anotherAnimation) {
                                      return CartWidget();
                                    },
                                    transitionDuration:
                                        Duration(milliseconds: 600),
                                    transitionsBuilder: (context, animation,
                                        anotherAnimation, child) {
                                      animation = CurvedAnimation(
                                          curve: Curves.bounceIn,
                                          parent: animation);
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
                              child: Text(
                                "View Cart ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
