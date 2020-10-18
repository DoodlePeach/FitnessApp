import 'package:fitness_app/Diet.dart';
import 'package:fitness_app/databaseQuery.dart';
import 'package:flutter/foundation.dart';

class DietModel extends ChangeNotifier{
  int _carb = 0, _protein = 0, _fat = 0;

  int get carb => _carb;
  int get fat => _fat;
  int get protein => _protein;

  DietModel(){
    _fetch();
  }

  void update(Diet newDiet){
    DatabaseQuery.db.updateDiet(newDiet).then((value){
      _fetch();
    });
  }

  void _fetch(){
    DatabaseQuery.db.getDiet().then((List<Diet> fetched){
      if(fetched.length > 0){
        _carb = fetched[0].carb;
        _protein = fetched[0].protein;
        _fat = fetched[0].fat;

        notifyListeners();
      }

      else{
        DatabaseQuery.db.newDiet();
      }
    });
  }
}