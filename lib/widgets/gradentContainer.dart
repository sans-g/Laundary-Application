import 'package:flutter/material.dart';

class GradientContainer extends StatelessWidget {
  final int pendingOrders;
  final int ongoingOrders;
  final int completedOrders;

  GradientContainer({
    @required this.completedOrders,
    @required this.ongoingOrders,
    @required this.pendingOrders,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.35,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.blue[200], Colors.blueAccent[700]],
                  end: Alignment.bottomRight,
                  begin: Alignment.topLeft)),
          child: InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        pendingOrders.toString(),
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w900),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "PENDING",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        ongoingOrders.toString(),
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w900),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "ONGOING",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        completedOrders.toString(),
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w900),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "COMPLETED",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 100,
        ),
      ],
    );
  }
}
