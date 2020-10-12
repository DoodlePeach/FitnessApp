import 'package:flutter/material.dart';
import 'styles.dart';
import 'appbar.dart';

class SettingsFormWidget extends StatefulWidget {
  @override
  _SettingsFormWidgetState createState() => _SettingsFormWidgetState();
}

class _SettingsFormWidgetState extends State<SettingsFormWidget> {
  int protien, carb, fat;
  final _formKey = GlobalKey<FormState>();

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(5),
          child: Card(
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Settings",
                        style: cardTitleTextStyle,
                      ),

                      Text(
                        "You can set the maximum limit text here",
                        style: smallElementTextStyle,
                      )
                    ],
                  ),
                ),
                Divider(),
                Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 5),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Carbs"),
                                          TextFormField(
                                            // The validator receives the text that the user has entered.
                                            decoration: const InputDecoration(
                                              hintText:
                                                  'Enter the upper limits of the carbs allowed.',
                                            ),
                                            initialValue: 1.toString(),
                                            validator: (value) {
                                              if (isNumeric(value)) {
                                                return 'Please enter a valid number';
                                              }

                                              carb = double.parse(value)
                                                  .round()
                                                  .toInt();
                                              return null;
                                            },
                                          ),
                                        ])),
                                Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 5),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Protein"),
                                          TextFormField(
                                            // The validator receives the text that the user has entered.
                                            decoration: const InputDecoration(
                                              hintText:
                                                  'Enter the upper limits of the carbs allowed.',
                                            ),
                                            initialValue: 1.toString(),
                                            validator: (value) {
                                              if (isNumeric(value)) {
                                                return 'Please enter a valid number';
                                              }

                                              protien = double.parse(value)
                                                  .round()
                                                  .toInt();
                                              return null;
                                            },
                                          ),
                                        ])),
                                Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 5),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Fat"),
                                          TextFormField(
                                            // The validator receives the text that the user has entered.
                                            decoration: const InputDecoration(
                                              hintText:
                                                  'Enter the upper limits of the carbs allowed.',
                                            ),
                                            initialValue: 1.toString(),
                                            validator: (value) {
                                              if (isNumeric(value)) {
                                                return 'Please enter a valid number';
                                              }

                                              fat = double.parse(value)
                                                  .round()
                                                  .toInt();
                                              return null;
                                            },
                                          ),
                                        ])),
                                Row(children: [
                                  Expanded(
                                    child: RaisedButton(
                                        color: Colors.green,
                                        onPressed: () {
                                          // Validate returns true if the form is valid, otherwise false.
                                          if (_formKey.currentState
                                              .validate()) {
                                            // If the form is valid, display a snackbar. In the real world,
                                            // you'd often call a server or save the information in a database.

                                            // FoodItem itemDatabse = FoodItem(name: name, weight: weight, carb: carb, fat: fat, protein: protein, type: type, isAdded: false);

                                            // TODO: Update values of protien, carb, and fat here.
                                          }
                                        },
                                        child: Text("Update",
                                            style: TextStyle(
                                                color: Colors.white))),
                                  ),
                                ])
                              ],
                            ),
                          ),
                        ]))
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
