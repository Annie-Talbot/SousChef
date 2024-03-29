import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sous_chef/database_handler.dart';
import 'package:sous_chef/destination.dart';
import 'package:sous_chef/destinations/cook_destination.dart';
import 'package:sous_chef/destinations/ingredient_destination.dart';
import 'package:sous_chef/destinations/recipe_destination.dart';
import 'package:sous_chef/pages/empty_cook_page.dart';

import 'instruction.dart';
import 'method.dart';

class Recipe {
  int id;
  String name;
  int directory;
  String ingredients;
  List<Method> method = [];

  Recipe({
    required this.id,
    required this.name,
    required this.directory,
    required this.ingredients}
    );

  Map<String, Object> toMap() {
    return {
      DatabaseHandler.recipeId: id,
      DatabaseHandler.recipeName: name,
      DatabaseHandler.recipeIngredients: ingredients,
      DatabaseHandler.recipeDirectory: directory,
    };
  }

  void setMethod(List<Method> method) {
    this.method = method;
  }

  List<Method> getMethod() {
    return method;
  }

  Recipe.fromMap(Map<String, dynamic> res):
        id = res[DatabaseHandler.recipeId],
        name = res[DatabaseHandler.recipeName],
        ingredients = res[DatabaseHandler.recipeIngredients],
        directory = res[DatabaseHandler.recipeDirectory];

  static Map<String, Object> createRecipeInsert({
    required String name,
    required String ingredients,
    required int directory}) {
    return {
      DatabaseHandler.recipeName: name,
      DatabaseHandler.recipeIngredients: ingredients,
      DatabaseHandler.recipeDirectory: directory,
    };
  }
}

class RecipeWidget extends StatelessWidget {
  const RecipeWidget({
    Key? key,
    required this.recipe,
    required this.dbHandler,
    required this.initiateCooking,
  }) : super(key: key);

  final Recipe recipe;
  final DatabaseHandler dbHandler;
  final Function(Recipe recipe, TimeOfDay eatTime) initiateCooking;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: const Icon(Icons.delete_forever),
      ),
      child: ListTile(
        title: Text(recipe.name),
        trailing: ElevatedButton.icon(
          onPressed: () async {
            TimeOfDay? eatTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
              helpText: "What time would you like to eat?",
              confirmText: "Let's cook!",
              cancelText: "Cancel",
            );
            if (eatTime != null) {
              await initiateCooking(recipe, eatTime);
            }
            },
          icon: const Icon(Icons.local_dining_outlined),
          label: const Text("Cook!"),
        ),
        onTap: () {
          Navigator.pushNamed(
              context,
              RecipeRoutes.detail,
              arguments: RecipeParcel(isExisting: true,
                  dirId: recipe.directory,
                  recipe: recipe));
        },
      ),
      onDismissed: (DismissDirection direction) async {
        await dbHandler.deleteRecipe(recipe.id);
      },
    );
  }

}

class RecipeParcel {
  bool isExisting;
  Recipe? recipe;
  int dirId;

  RecipeParcel({
    required this.isExisting,
    required this.dirId,
    this.recipe});
}

