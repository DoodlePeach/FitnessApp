import 'package:flutter/material.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'styles.dart';
import 'food_item.dart';
import 'form.dart';

FoodItem item =
    FoodItem(name: "Apple", type: "Fruit", weight: 12, isAdded: false, protein: 5, carb: 5, fat: 5);


class HomePageWidget extends StatefulWidget {
  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  List<FoodItem> items = [
    item,
    item,
    item,
    item,
    item,
    item,
    item,
    item,
    item,
    item
  ];

  void refreshList(){
    // TODO: Provide function to retrieve data from database here. After retrieval, assign it to items.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fiverr"),
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                    child: Text(
                      "Nutrition Totals",
                      style: cardTitleTextStyle,
                    ),
                  ),
                  Divider(),
                  NutritionBarWidget(items: items,),
                ],
              ),
            ),
            Expanded(
              child: Card(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                            child: Text(
                              "Foods",
                              style: cardTitleTextStyle,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return FormWidget();
                                }),).then((value) => {
                                  refreshList()
                              });
                            },
                          )
                        ],
                      ),
                      Divider(
                        height: 1,
                      ),
                      Expanded(
                          child: FoodListWidget(
                            foodList: items,
                            refreshList: refreshList,
                          ))
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


class NutritionBarWidget extends StatefulWidget {
  final List<FoodItem> items;

  NutritionBarWidget({Key key, @required this.items});

  @override
  _NutritionBarWidgetState createState() => _NutritionBarWidgetState();
}

class _NutritionBarWidgetState extends State<NutritionBarWidget> {
  int totalCarbs = 0, totalFats = 0, totalProteins = 0;

  @override
  Widget build(BuildContext context) {
    for(int i = 0; i < widget.items.length; i++) {
      print(widget.items[i]);

      totalCarbs += widget.items[i].carb;
      totalProteins += widget.items[i].protein;
      totalFats += widget.items[i].fat;
    }

      return Container(
        child: Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NutritionValueBarWidget(
            name: 'Carbs',
            current: totalCarbs,
            total: 44,
            background: Color(0xFFDE68C2),
          ),
          NutritionValueBarWidget(
            name: 'Protein',
            current: totalProteins,
            total: 20,
            background: Color(0xFFDF9D69),
          ),
          NutritionValueBarWidget(
            name: 'Fat',
            current: totalFats,
            total: 30,
            background: Color(0xFF93DE68),
          ),
        ],
      ),
    ));
  }
}

class NutritionValueBarWidget extends StatelessWidget {
  final String name;
  final int total, current;
  final Color background;

  NutritionValueBarWidget(
      {Key key,
      @required this.name,
      @required this.total,
      @required this.current,
      @required this.background});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      color: background,
      child: Row(
        children: [
          Text(
            name,
            style: foodBarTextStyle,
          ),
          Text(
            current.toString() + "/" + total.toString(),
            style: foodBarTextStyle,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }
}

class FoodListWidget extends StatelessWidget {
  final List<FoodItem> foodList;
  final Function refreshList;

  FoodListWidget({Key key, @required this.foodList, @required this.refreshList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: foodList.length,
        padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
        itemBuilder: (BuildContext context, int index) {
          return FoodListElementWidget(item: foodList[index], refreshList: refreshList,);
        });
  }
}

class FoodListElementWidget extends StatefulWidget {
  final FoodItem item;
  final Function refreshList;
  FoodListElementWidget({Key key, @required this.item, @required this.refreshList});

  @override
  _FoodListElementWidgetState createState() => _FoodListElementWidgetState();
}

class _FoodListElementWidgetState extends State<FoodListElementWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context,
          MaterialPageRoute(builder: (context) {
            return FormWidget(item: widget.item,);
          }),).then((value) => {
            widget.refreshList()
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
        decoration: widget.item.isAdded ? listElementGradient : null,
        child: Row(
          children: [
            CircularCheckBox(
                activeColor: Colors.green,
                value: widget.item.isAdded,
                onChanged: (isTrue) {
                  setState(() {
                    widget.item.isAdded = isTrue;
                  });
                }),
            Expanded(
              flex: 2,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                      child:
                          Image.asset('images/dummy.jpg', fit: BoxFit.contain))),
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
                ))
          ],
        ),
      ),
    );
  }
}
