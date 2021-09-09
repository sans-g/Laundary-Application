import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundary_application/model/laundaryItem.dart';

class LaundryItemWidget extends StatefulWidget {
  final double height;
  final String imageURL;
  final String name;
  final int index;

  LaundryItemWidget({
    @required this.name,
    @required this.imageURL,
    @required this.index,
    @required this.height,
  });

  @override
  _LaundryItemWidgetState createState() => _LaundryItemWidgetState();
}

class _LaundryItemWidgetState extends State<LaundryItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.network(
                  widget.imageURL,
                  height: 60,
                ),
                Text(
                  widget.name,
                  style: GoogleFonts.lato(
                      fontWeight: FontWeight.w800, fontSize: 20),
                ),
              ],
            ),
            (laundryItemList[widget.index].isAdded &&
                    laundryItemList[widget.index].quantity > 0)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(
                          FontAwesome.minus_circle,
                          color: Colors.red,
                          size: 30,
                        ),
                        onPressed: () {
                          setState(() {
                            laundryItemList[widget.index].quantity--;
                            if (laundryItemList[widget.index].quantity == 0) {
                              laundryItemList[widget.index].isAdded = false;
                            }
                          });
                        },
                      ),
                      Text(
                        "${laundryItemList[widget.index].quantity}",
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          FontAwesome.plus_circle,
                          color: Colors.green,
                          size: 30,
                        ),
                        onPressed: () {
                          setState(() {
                            laundryItemList[widget.index].quantity++;
                          });
                        },
                      ),
                    ],
                  )
                : RaisedButton(
                    onPressed: () {
                      setState(() {
                        laundryItemList[widget.index].isAdded = true;
                        laundryItemList[widget.index].quantity++;
                      });
                    },
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      " ADD ",
                      style: GoogleFonts.lato(
                          color: Colors.white, fontWeight: FontWeight.w800),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
