

import 'package:sous_chef/database_handler.dart';

class Method {
  int id;
  String description;
  int duration;
  int recipe;
  int orderKey;

  Method({
    required this.id,
    required this.description,
    required this.duration,
    required this.recipe,
    required this.orderKey
  });

  Map<String, Object> toMap() {
    return {
      DatabaseHandler.methodId: id,
      DatabaseHandler.methodDesc: description,
      DatabaseHandler.methodDuration: duration,
      DatabaseHandler.methodRecipe: recipe,
      DatabaseHandler.methodOrderKey: orderKey
    };
  }

  Method.fromMap(Map<String, dynamic> res):
        id = res[DatabaseHandler.methodId],
        description = res[DatabaseHandler.methodDesc],
        duration = res[DatabaseHandler.methodDuration],
        recipe = res[DatabaseHandler.methodRecipe],
        orderKey = res[DatabaseHandler.methodOrderKey];

  static Map<String, Object> createMethodInsert({
    required String description,
    required int duration,
    required int recipe,
    required int orderKey}) {
    return {
      DatabaseHandler.methodDesc: description,
      DatabaseHandler.methodDuration: duration,
      DatabaseHandler.methodRecipe: recipe,
      DatabaseHandler.methodOrderKey: orderKey
    };
  }
}