import 'package:fitness_app/FoodProvider.dart';
import 'package:fitness_app/appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'foodDatabase.dart';
import 'styles.dart';
import 'form.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'dart:io';

class FoodListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context),
      body: Consumer<FoodModel>(
        builder: (context, model, child){
          return Container(
            child: Card(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Foods",
                                  style: cardTitleTextStyle,
                                ),
                                SizedBox(
                                  width: 10,
                                )
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return FormWidget();
                              }),
                            );
                          },
                        )
                      ],
                    ),
                    Divider(
                      height: 1,
                    ),
                    Expanded(child: FoodListWidget(foodList: model.items))
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class FoodListWidget extends StatelessWidget {
  final List<Food> foodList;

  FoodListWidget(
      {Key key,
        @required this.foodList});

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
        itemCount: foodList.length,
        padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
        itemBuilder: (BuildContext context, int index) {
          return FoodListElementWidget(
              item: foodList[index]
          );
        });
  }
}

class FoodListElementWidget extends StatefulWidget {
  final Food item;

  FoodListElementWidget(
      {Key key, @required this.item});

  @override
  _FoodListElementWidgetState createState() => _FoodListElementWidgetState();
}

class _FoodListElementWidgetState extends State<FoodListElementWidget> {
  bool convertIntToBool(int isAdded) {
    if (isAdded == 1)
      return true;
    else
      return false;
  }

  Future<Widget> getFoodImage(String path) async {
    File imageFile = File(path);

    if (await imageFile.exists()) {
      return Image.file(imageFile);
    } else {
      return Image.asset("images/dummy.jpg");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return FormWidget(
              item: widget.item,
            );
          }),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
        decoration: widget.item.isAdded == 1 ? listElementGradient : null,
        child: Row(
          children: [
            CircularCheckBox(
                activeColor: Colors.green,
                value: widget.item.isAdded == 1,
                onChanged: (isTrue) {
                  setState(() {
                    widget.item.isAdded = isTrue ? 1 : 0;
                    Provider.of<FoodModel>(context, listen: false).update(
                        Food(
                            widget.item.name,
                            widget.item.type,
                            widget.item.weight,
                            widget.item.protein,
                            widget.item.fat,
                            widget.item.carb,
                            widget.item.image,
                            widget.item.isAdded));
                  });
                }),
            Expanded(
              flex: 2,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                      child: FutureBuilder(
                        future: getFoodImage(widget.item.image),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return snapshot.data;
                          }

                          return Image.asset("images/dummy.jpg");
                        },
                      ))),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.name,
                      style: bigElementTextStyle,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.item.type,
                      style: smallElementTextStyle,
                    )
                  ],
                ),
              ),
              flex: 6,
            ),
            Expanded(
                flex: 1,
                child: Text(
                  widget.item.weight.toString() + "g",
                  style: bigElementTextStyle,
                )),

            Expanded(
              flex: 1,
              child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: (){
                    print("Pressed");
                  },
              )
            )
          ],
        ),
      ),
    );
  }
}
