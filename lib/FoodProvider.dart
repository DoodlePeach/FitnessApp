import 'dart:collection';

import 'package:fitness_app/databaseQuery.dart';
import 'package:fitness_app/foodDatabase.dart';
import 'package:flutter/foundation.dart';

class FoodModel extends  ChangeNotifier{
  List<Food> _items = [];
  UnmodifiableListView<Food> get items => UnmodifiableListView(_items);

  FoodModel(){
    refresh();
  }

  void refresh() {
    DatabaseQuery.db.getAllFoods().then((List<Food> value) {
      _items = value;
      notifyListeners();
    });

  }

  void insert(Food item){
    DatabaseQuery.db.newFood(item);
    refresh();
  }

  void update(Food item){
    DatabaseQuery.db.updateFood(item, false);
    refresh();
  }

  void delete(Food item){
    DatabaseQuery.db.deleteFood(item);
    refresh();
  }
}