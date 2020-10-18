import 'package:fitness_app/FoodListPage.dart';
import 'package:flutter/material.dart';
import 'Diet.dart';
import 'DietProvider.dart';
import 'foodDatabase.dart';
import 'styles.dart';
import 'databaseQuery.dart';
import 'appbar.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class HomePageWidget extends StatefulWidget {
  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  List<Food> items = [];
  List<Diet> barInfo = [];
  String currentNutritionSelected = "Carb";

  Future refreshBarInfo() async {
    List<Diet> info = await DatabaseQuery.db.getDiet();

    setState(() {
      barInfo = info;
    });
  }

  void changeSelectedNutritionType(String type) {
    setState(() {
      currentNutritionSelected = type;
    });
  }

  @override
  void initState() {
    super.initState();
    DatabaseQuery.db.database;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context),
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
                  NutritionBarWidget(
                    items: items,
                    barInfo: barInfo,
                    currentNutritionSelected: changeSelectedNutritionType,
                  ),
                ],
              ),
            ),
            Expanded(
              child: FoodInDietWidget()
            )
          ],
        ),
      ),
    );
  }
}

class NutritionBarWidget extends StatefulWidget {
  final List<Food> items;
  final List<Diet> barInfo;
  final Function currentNutritionSelected;

  NutritionBarWidget(
      {Key key,
      @required this.items,
      @required this.barInfo,
      @required this.currentNutritionSelected});

  @override
  _NutritionBarWidgetState createState() => _NutritionBarWidgetState();
}

class _NutritionBarWidgetState extends State<NutritionBarWidget> {
  int totalCarbs = 0, totalFats = 0, totalProteins = 0;

  Consumer<DietModel> getNutritionBarWidget() {
    return Consumer<DietModel>(
      builder: (context, dietModel, child) {
        return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      widget.currentNutritionSelected("Carb");
                    });
                  },
                  child: NutritionValueBarWidget(
                    name: 'Carbs',
                    current: totalCarbs,
                    total: dietModel.carb,
                    background: Color(0xFFDE68C2),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      widget.currentNutritionSelected("Protein");
                    });
                  },
                  child: NutritionValueBarWidget(
                    name: 'Protein',
                    current: totalProteins,
                    total: dietModel.protein,
                    background: Color(0xFFDF9D69),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      widget.currentNutritionSelected("Fat");
                    });
                  },
                  child: NutritionValueBarWidget(
                    name: 'Fat',
                    current: totalFats,
                    total: dietModel.fat,
                    background: Color(0xFF93DE68),
                  ),
                ),
              ],
            ));
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    totalFats = totalProteins = totalCarbs = 0;

    for (int i = 0; i < widget.items.length; i++) {
      if (widget.items[i].isAdded == 1) {
        totalCarbs += widget.items[i].carb;
        totalProteins += widget.items[i].protein;
        totalFats += widget.items[i].fat;
      }
    }
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [getNutritionBarWidget()],
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

class FoodInDietWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                            "Foods in your diet",
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
                      Navigator.push(context, MaterialPageRoute(
                          builder: (BuildContext context) {
                            return FoodListPage();
                          }

                      ));
                    },
                  )
                ],
              ),
              Divider(
                height: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
