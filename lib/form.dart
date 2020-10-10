import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'foodDatabase.dart';
import 'food_item.dart';
import 'databaseQuery.dart';


bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.parse(s, (e) => null) != null;
}

class FormWidget extends StatefulWidget {
  final Food item;

  FormWidget({Key key, this.item});

  @override
  FormWidgetState createState() {
    return FormWidgetState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class FormWidgetState extends State<FormWidget> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  String name, type;
  int weight, protein, carb, fat;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        title: Text("Fiverr"),
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Name"),

                            // Add TextFormFields and RaisedButton here.
                            TextFormField(
                              // The validator receives the text that the user has entered.
                              decoration: const InputDecoration(
                                hintText: 'Enter the food\'s name',
                              ),
                              enabled: widget.item == null ? true : false,
                              initialValue: widget.item == null ? "" : widget.item.name,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter some text';
                                }

                                name = value;
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Type"),

                            // Add TextFormFields and RaisedButton here.
                            TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'Enter the type of the item',
                              ),
                              initialValue: widget.item == null ? "" : widget.item.type,
                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                type = value;
                                return null;
                              },
                            ),

                          ],
                        ),
                      ),


                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Weight"),

                            // Add TextFormFields and RaisedButton here.
                            TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'Enter the item\'s weight',
                              ),

                              initialValue: widget.item == null
                                  ? 1.toString()
                                  : widget.item.weight.toString(),

                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                if (!isNumeric(value) ||
                                    int.parse(value) < 1 ||
                                    value.isEmpty) {
                                  return 'Invalid number';
                                }
                                weight = int.parse(value);
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Fat"),

                            // Add TextFormFields and RaisedButton here.
                            TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'Enter the fats in the item.',
                              ),

                              initialValue: widget.item == null
                                  ? 1.toString()
                                  : widget.item.fat.toString(),

                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                if (!isNumeric(value) ||
                                    int.parse(value) < 1 ||
                                    value.isEmpty) {
                                  return 'Invalid number';
                                }
                                fat = int.parse(value);
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Carbs"),

                            // Add TextFormFields and RaisedButton here.
                            TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'Enter the carbs of the item.',
                              ),

                              initialValue: widget.item == null
                                  ? 1.toString()
                                  : widget.item.carb.toString(),

                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                if (!isNumeric(value) ||
                                    int.parse(value) < 1 ||
                                    value.isEmpty) {
                                  return 'Invalid number';
                                }
                                carb = int.parse(value);
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Protein"),

                            // Add TextFormFields and RaisedButton here.
                            TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'Enter the proteins in the item',
                              ),

                              initialValue: widget.item == null
                                  ? 1.toString()
                                  : widget.item.protein.toString(),

                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                if (!isNumeric(value) ||
                                    int.parse(value) < 1 ||
                                    value.isEmpty) {
                                  return 'Invalid number';
                                }
                                protein = int.parse(value);
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),

                      Row(children: [
                        Expanded(
                          child: RaisedButton(
                              color: Colors.green,
                              onPressed: () {
                                // Validate returns true if the form is valid, otherwise false.
                                if (_formKey.currentState.validate()) {
                                  // If the form is valid, display a snackbar. In the real world,
                                  // you'd often call a server or save the information in a database.

                                 FoodItem itemDatabse = FoodItem(name: name, weight: weight, carb: carb, fat: fat, protein: protein, type: type, isAdded: false);

                                  if(widget.item == null){
                                    databaseQuery.db.newFood(new Food (name,type,weight,protein,fat,carb,0));
                                  }
                                  else{
                                    databaseQuery.db.updateFood(new Food (name,type,weight,protein,fat,carb,widget.item.isAdded));
                                  }
                                }
                              },
                              child: widget.item == null
                                  ? Text(
                                      'Add',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  : Text("Update",
                                      style: TextStyle(color: Colors.white))),
                        ),
                      ]
                      )
                    ]
                )
            ),
            Row(
              children: [
                Expanded(
                  child: RaisedButton(

                    color: Colors.red,
                    child: Text("Delete", style: TextStyle(color: Colors.white),),
                    onPressed: () {
                      // TODO: DELETE item with data specified in widget.item.
                      databaseQuery.db.deleteFood(widget.item.name);
                      print("Red shiny");
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
