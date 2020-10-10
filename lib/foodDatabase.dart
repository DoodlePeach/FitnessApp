import 'dart:convert';

Food clientFromJson(String str) {
  final jsonData = json.decode(str);
  return Food.fromMap(jsonData);
}

String clientToJson(Food data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Food {
  int protein,fat,carb,weight;
  String name,type;
  int isAdded;


  Food(String name,String type,int weight,int protein,int fat,int carb,int isAdded){
    this.name =name;
    this.type = type;
    this.weight = weight;
    this.protein = protein;
    this.fat= fat;
    this.carb = carb;
    this.isAdded= isAdded;
  }

  factory Food.fromMap(Map<String, dynamic> json) => new Food(
      json["name"],
      json["type"],
      json["weight"],
      json["protein"],
      json["fat"],
      json["carb"],
      json["isAdded"]
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "type":type,
    "weight":weight,
    "protein" : protein,
    "fat": fat,
    "carb":carb,
    "isAdded":isAdded
  };
}