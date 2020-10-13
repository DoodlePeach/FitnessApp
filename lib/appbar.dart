import 'package:flutter/material.dart';
import 'settings.dart';

AppBar getAppBar(BuildContext context, Function refreshNutritionBar){
  return AppBar(
    title: Text("Fiverr"),
    actions: [
      IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return SettingsFormWidget();
              },
            )).then((value){
              if(refreshNutritionBar != null)
              {refreshNutritionBar();}
            });
          })
    ],
  );
}