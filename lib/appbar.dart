import 'package:flutter/material.dart';
import 'settings.dart';

AppBar getAppBar(BuildContext context){
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
            ));
          })
    ],
  );
}