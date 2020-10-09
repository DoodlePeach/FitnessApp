import 'package:flutter/material.dart';

class FoodItem {
  String name, type;
  int weight, protein, fat, carb;
  bool isAdded;

  FoodItem(
      {@required this.name,
      @required this.type,
      @required this.weight,
      @required this.isAdded,
      @required this.carb,
      @required this.fat,
      @required this.protein});
}
