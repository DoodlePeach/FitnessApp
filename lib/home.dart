import 'package:flutter/material.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'Diet.dart';
import 'foodDatabase.dart';
import 'styles.dart';
import 'form.dart';
import 'databaseQuery.dart';
import 'appbar.dart';
import 'dart:io';

Future<String> _takePicture(bool imageFromGallery) async {
  var imageFile;

  if (imageFromGallery) {
    imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
  } else {
    imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
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

class HomePageWidget extends StatefulWidget {
  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  List<Food> items = [];
  List<Diet> barInfo = [];
  String currentNutritionSelected = "Carb";

  Future<void> refreshList() async {
    // TODO: Provide function to retrieve data from database here. After retrieval, assign it to items.
    List<Food> retrieved = await DatabaseQuery.db.getAllFoods();
    List<Diet> abcd = await DatabaseQuery.db.getDiet();

    if (abcd.length == 0) abcd = await DatabaseQuery.db.newDiet();

    //await DatabaseQuery.db.updateDiet(Diet(10,20,30), 0);

    setState(() {
      items = retrieved;
    });
  }

  Future refreshBarInfo() async{
    List<Diet> info = await DatabaseQuery.db.getDiet();

    setState(() {
      barInfo = info;
    });
  }

  void changeSelectedNutritionType(String type){
    setState(() {
      currentNutritionSelected = type;
    });
  }

  @override
  void initState() {
    super.initState();
    DatabaseQuery.db.database;
    refreshList();
    refreshBarInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, refreshBarInfo),
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

                                  SizedBox(width: 10,),

                                  Text(
                                    currentNutritionSelected,
                                    style: smallElementTextStyle,
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
                              ).then((value) => {refreshList()});
                            },
                          )
                        ],
                      ),
                      Divider(
                        height: 1,
                      ),
                      Expanded(
                          child: FoodListWidget(
                            currentlySelectedNutritionType: currentNutritionSelected,
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
  final List<Food> items;
  final List<Diet> barInfo;
  final Function currentNutritionSelected;

  NutritionBarWidget({Key key, @required this.items, @required this.barInfo, @required this.currentNutritionSelected});

  @override
  _NutritionBarWidgetState createState() => _NutritionBarWidgetState();
}

class _NutritionBarWidgetState extends State<NutritionBarWidget> {
  int totalCarbs = 0, totalFats = 0, totalProteins = 0;

  Widget getNutritionBarWidget(){
    if(widget.barInfo.length == 0){
      return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InkWell(
                onTap: (){
                  setState(() {
                    widget.currentNutritionSelected("Carb");
                  });
                },
                child: NutritionValueBarWidget(
                  name: 'Carbs',
                  current: totalCarbs,
                  total: 0,
                  background: Color(0xFFDE68C2),
                ),
              ),
              InkWell(
                onTap: (){
                  setState(() {
                    widget.currentNutritionSelected("Protein");
                  });
                },
                child: NutritionValueBarWidget(
                  name: 'Protein',
                  current: totalProteins,
                  total: 0,
                  background: Color(0xFFDF9D69),
                ),
              ),
              InkWell(
                onTap: (){
                  setState(() {
                    widget.currentNutritionSelected("Fat");
                  });
                },
                child: NutritionValueBarWidget(
                  name: 'Fat',
                  current: totalFats,
                  total: 0,
                  background: Color(0xFF93DE68),
                ),
              ),
            ],
          ));
    }

    else{
      return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InkWell(
                onTap: (){
                  setState(() {
                    widget.currentNutritionSelected("Carb");
                  });
                },
                child: NutritionValueBarWidget(
                  name: 'Carbs',
                  current: totalCarbs,
                  total: widget.barInfo[0].carb,
                  background: Color(0xFFDE68C2),
                ),
              ),
              InkWell(
                onTap: (){
                  setState(() {
                    widget.currentNutritionSelected("Protein");
                  });
                },
                child: NutritionValueBarWidget(
                  name: 'Protein',
                  current: totalProteins,
                  total: widget.barInfo[0].protein,
                  background: Color(0xFFDF9D69),
                ),
              ),
              InkWell(
                onTap: (){
                  setState(() {
                    widget.currentNutritionSelected("Fat");
                  });
                },
                child: NutritionValueBarWidget(
                  name: 'Fat',
                  current: totalFats,
                  total: widget.barInfo[0].fat,
                  background: Color(0xFF93DE68),
                ),
              ),
            ],
          ));
    }
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
            children: [
              getNutritionBarWidget()
            ],
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
  final List<Food> foodList;
  final Function refreshList;
  final String currentlySelectedNutritionType;

  FoodListWidget(
      {Key key, @required this.foodList, @required this.refreshList, @required this.currentlySelectedNutritionType});

  @override
  Widget build(BuildContext context) {
    List<Food> typeList = [];

    for(int i = 0; i < foodList.length; i++){
      if(foodList[i].type == currentlySelectedNutritionType){
        typeList.add(foodList[i]);
      }
    }

    return ListView.builder(
        itemCount: typeList.length,
        padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
        itemBuilder: (BuildContext context, int index) {
          return FoodListElementWidget(
            item: typeList[index],
            refreshList: refreshList,
          );
        });
  }
}

class FoodListElementWidget extends StatefulWidget {
  final Food item;
  final Function refreshList;

  FoodListElementWidget(
      {Key key, @required this.item, @required this.refreshList});

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

    if(await imageFile.exists()){
      return Image.file(imageFile);
    }

    else{
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
        ).then((value) => {widget.refreshList()});
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
                  setState(()  {
                    widget.item.isAdded = isTrue ? 1 : 0;
                    DatabaseQuery.db.updateFood(
                        Food(
                            widget.item.name,
                            widget.item.type,
                            widget.item.weight,
                            widget.item.protein,
                            widget.item.fat,
                            widget.item.carb,
                            widget.item.image,
                            widget.item.isAdded),
                        false);
                    widget.refreshList();
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
                ))
          ],
        ),
      ),
    );
  }
}
