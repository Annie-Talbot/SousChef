import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sous_chef/database_handler.dart';
import 'package:sous_chef/destinations/ingredient_destination.dart';

import 'instruction.dart';

class Ingredient {
  int id;
  String name;
  int directory;
  List<Instruction> instructions = [];

  Ingredient({required this.id, required this.name, required this.directory});

  Map<String, Object> toMap() {
    return {
      DatabaseHandler.ingredientsId:id,
      DatabaseHandler.ingredientsName: name,
      DatabaseHandler.ingredientsDirectory: directory,
    };
  }

  void setInstructions(List<Instruction> instructions) {
    this.instructions = instructions;
  }

  List<Instruction> getInstructions() {
    return instructions;
  }

  Ingredient.fromMap(Map<String, dynamic> res):
        id = res[DatabaseHandler.ingredientsId],
        name = res[DatabaseHandler.ingredientsName],
        directory = res[DatabaseHandler.ingredientsDirectory];

  static Map<String, Object> createIngredientInsert({
    required String name,
    required int directory}) {
    return {
      DatabaseHandler.ingredientsName: name,
      DatabaseHandler.ingredientsDirectory: directory,
    };
  }
}

class IngredientWidget extends StatelessWidget {
  const IngredientWidget({
    Key? key,
    required this.ingredient,
    required this.dbHandler
  }) : super(key: key);

  final Ingredient ingredient;
  final DatabaseHandler dbHandler;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Icon(Icons.delete_forever),
      ),
      child: ListTile(
        title: Text(ingredient.name),
        trailing: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.check_box_outline_blank),
          ),
        onTap: () {
          Navigator.pushNamed(
              context,
              IngredientRoutes.detail,
              arguments: IngredientParcel(isExisting: true,
                  dirId: ingredient.directory,
                  ingredient: ingredient));
        },
      ),
      onDismissed: (DismissDirection direction) async {
        await dbHandler.deleteIngredient(ingredient.id);
      },
    );
  }
}

class IngredientParcel {
  bool isExisting;
  Ingredient? ingredient;
  int dirId;

  IngredientParcel({
    required this.isExisting,
    required this.dirId,
    this.ingredient});
}

