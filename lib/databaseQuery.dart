import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'foodDatabase.dart';

class DatabaseQuery {
  DatabaseQuery._();
  static final DatabaseQuery db = DatabaseQuery._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    return openDatabase(join(await getDatabasesPath(), "TestDB.db"), version: 1,
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE Food ("
              "name TEXT PRIMARY KEY,"
              "type TEXT,"
              "weight int,"
              "fat int,"
              "protein int,"
              "carb int,"
              "isAdded int"
             ")");
        });
  }

  newFood(Food newClient) async {
    final db = await database;
    try{
      var res = await db.insert("Food", newClient.toMap());
      Fluttertoast.showToast(msg: "Added");
     }
    on DatabaseException {
      Fluttertoast.showToast(msg: "Already Exists in your Diet");
    }
  }

  getAllFoods() async {
    final db = await database;
    var res = await db.query("Food");
    List<Food> list =
    res.isNotEmpty ? res.map((c) => Food.fromMap(c)).toList() : [];
    return list;
  }

  updateFood(Food newClient) async {
    final db = await database;
    try{
      var res = await db.update("Food", newClient.toMap(),
          where: "name = ?", whereArgs: [newClient.name]);
      Fluttertoast.showToast(msg: "Updated Successfully");
    }   on DatabaseException {
      Fluttertoast.showToast(msg: "Not Updated");
    }

  }

  deleteFood(String name) async {
    final db = await database;
    try{
      db.delete("Food", where: "name = ?", whereArgs: [name]);
      Fluttertoast.showToast(msg: "Deleted Successfuly");
    }   on DatabaseException {
      Fluttertoast.showToast(msg: "Not Deleted");
    }


  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from Food");
  }
}
