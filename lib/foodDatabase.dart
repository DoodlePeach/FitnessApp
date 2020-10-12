import 'dart:convert';


class Food {
  int protein,fat,carb,weight;
  String name,type;
  int isAdded;
  String image;


  Food(String name,String type,int weight,int protein,int fat,int carb,String image,int isAdded){
    this.name =name;
    this.type = type;
    this.weight = weight;
    this.protein = protein;
    this.fat= fat;
    this.carb = carb;
    this.image = image;
    this.isAdded= isAdded;
  }

  factory Food.fromMap(Map<String, dynamic> json) => new Food(
      json["name"],
      json["type"],
      json["weight"],
      json["protein"],
      json["fat"],
      json["carb"],
      json["image"],
      json["isAdded"]
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "type":type,
    "weight":weight,
    "protein" : protein,
    "fat": fat,
    "carb":carb,
    "image":image,
    "isAdded":isAdded
  };
}