import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'foodDatabase.dart';
import 'databaseQuery.dart';
import 'styles.dart';

final double weightMaxValue = 1000;
final double weightMinValue = 1;

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return int.tryParse(s) != null;
}

Future<String> _takePicture(bool imageFromGallery) async {
  var imageFile;

  if(imageFromGallery){
    imageFile = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );
  }
  else {
    imageFile = await ImagePicker.pickImage(source: ImageSource.camera,
      maxWidth: 600,
    );
  }

  if (imageFile == null) {
    return "";
  }
  final appDir = await getApplicationDocumentsDirectory();
  final fileName = basename(imageFile.path);
  final savedImage = await imageFile.copy('${appDir.path}/$fileName');
  return savedImage.toString();
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
  final _formKey = GlobalKey<FormState>();
  // These are the fields that are going to be inserted into the database.
  String name, type;
  int protein, carb, fat;
  // This is inserted as an int, it is declared here as a double for
  // compatibility with sliders.
  double weight = 1;
  // isSliderTurnedOn is controlled by the a switch, when it is on then the
  // slider is shown for input in weight field, else a textfield is used.
  // isWeightDirty determines whether if the initial value of the text field of
  // weight has 1 or whatever value was set in the slider in case the user
  // switches to slider and then back to text field. isWeightDirty is turned on
  // as soon as the slider is changed
  bool isSliderTurnedOn = true, isWeightDirty = false;

  // This function returns the appropriate UI for weight field
  // based on whether isSliderTurnedOn is set to true or false.
  Widget getWeightInputWidget(){
    if(isSliderTurnedOn){
      return Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Weight"),
                  Switch(value: isSliderTurnedOn, onChanged: (bool value){
                    setState(() {
                      isSliderTurnedOn = value;
                    });
                  },)
                ],
              ),

              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    color: Colors.green,
                    child: Text(weight.round().toString() + "g", style: TextStyle(color: Colors.white),)
                ),
              ),
              Slider(
                min: weightMinValue,
                max: weightMaxValue,
                value: weight,
                label: weight.round().toString(),
                onChanged: (value){
                  setState(() {
                    weight = value;
                    isWeightDirty = true;
                  });
                },
              ),
            ],
          ),
        );
    }

    else{
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Weight"),
                Switch(value: isSliderTurnedOn, onChanged: (bool value){
                  setState(() {
                    isSliderTurnedOn = value;
                  });
                },)
              ],
            ),

            // Add TextFormFields and RaisedButton here.
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter the item\'s weight',
              ),

              initialValue: widget.item != null && isWeightDirty
                  ? weight.round().toInt().toString()
                  : widget.item.weight.toString(),

              // The validator receives the text that the user has entered.
              validator: (value) {
                if (!isNumeric(value) ||
                    int.parse(value) < 1 ||
                    value.isEmpty) {
                  return 'Invalid number';
                }

                isWeightDirty = true;
                weight = double.parse(value);
                return null;
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: getAppBar(context),
      body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(5),
            child: Card(
              child: Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                     Padding(
                       padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text("Add Item", style: cardTitleTextStyle,),
                           IconButton(icon: Icon(Icons.camera_alt), onPressed: (){},)
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


                              getWeightInputWidget(),

                            Container(
                              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text("Weight"),
                                    ],
                                  ),

                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                        color: Colors.green,
                                        child: Text(weight.round().toString() + "g", style: TextStyle(color: Colors.white),)
                                    ),
                                  ),
                                  Slider(
                                    min: weightMinValue,
                                    max: weightMaxValue,
                                    value: weight,
                                    label: weight.round().toString(),
                                    onChanged: (value){
                                      setState(() {
                                        weight = value;
                                      });
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
                                    onPressed: ()  async {
                                      // Validate returns true if the form is valid, otherwise false.
                                      if (_formKey.currentState.validate()) {
                                        // If the form is valid, display a snackbar. In the real world,
                                        // you'd often call a server or save the information in a database.

                                        // FoodItem itemDatabse = FoodItem(name: name, weight: weight, carb: carb, fat: fat, protein: protein, type: type, isAdded: false);
                                        String imagePath;

                                        if(widget.item == null){
                                          imagePath = await _takePicture(false);
                                          DatabaseQuery.db.newFood(new Food (name,type,weight.toInt() ,protein,fat,carb,imagePath,0));
                                        }
                                        else{

                                          imagePath = await _takePicture(false);
                                          DatabaseQuery.db.updateFood(new Food (name,type, weight.toInt(),protein,fat,carb,imagePath,widget.item.isAdded),true);
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
                            DatabaseQuery.db.deleteFood(widget.item.name);
                            Navigator.pop(context);
                          },
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
