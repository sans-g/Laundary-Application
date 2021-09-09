import 'package:flutter/material.dart';

class LaundryItem {
  final String itemName;
  int quantity = 0;
  final String imageURL;
  bool isAdded = false;

  LaundryItem(
      {@required this.itemName,
      @required this.quantity,
      @required this.imageURL,
      @required this.isAdded});
}

List<LaundryItem> laundryItemList = [];
