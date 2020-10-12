import 'dart:convert';

class Diet{
  int protein,fat,carb;

  Diet(int protein,int fat,int carb){
    this.protein = protein;
    this.fat= fat;
    this.carb = carb;
  }

  factory Diet.fromMap(Map<String, dynamic> json) => new Diet(
      json["protein"],
      json["fat"],
      json["carb"]
  );

  Map<String, dynamic> toMap() => {
    "protein" : protein,
    "fat": fat,
    "carb":carb,
  };
}