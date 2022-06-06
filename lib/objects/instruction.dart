

import 'package:sous_chef/database_handler.dart';

class Instruction {
  int id;
  String description;
  int duration;
  int ingredient;
  int orderKey;

  Instruction({
    required this.id,
    required this.description,
    required this.duration,
    required this.ingredient,
    required this.orderKey
  });

  Map<String, Object> toMap() {
    return {
      DatabaseHandler.instructionsId: id,
      DatabaseHandler.instructionsDesc: description,
      DatabaseHandler.instructionsDuration: duration,
      DatabaseHandler.instructionsIngredient: ingredient,
      DatabaseHandler.instructionsOrderKey: orderKey
    };
  }

  Instruction.fromMap(Map<String, dynamic> res):
        id = res[DatabaseHandler.instructionsId],
        description = res[DatabaseHandler.instructionsDesc],
        duration = res[DatabaseHandler.instructionsDuration],
        ingredient = res[DatabaseHandler.instructionsIngredient],
        orderKey = res[DatabaseHandler.instructionsOrderKey];

  static Map<String, Object> createInstructionInsert({
    required String description,
    required int duration,
    required int ingredient,
    required int orderKey}) {
      return {
        DatabaseHandler.instructionsDesc: description,
        DatabaseHandler.instructionsDuration: duration,
        DatabaseHandler.instructionsIngredient: ingredient,
        DatabaseHandler.instructionsOrderKey: orderKey
      };
  }
}