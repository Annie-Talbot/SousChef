import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sous_chef/DatabaseHandler.dart';

class Ingredient {
  int id;
  String name;
  int directory;

  Ingredient({required this.id, required this.name, required this.directory});

  Map<String, Object> toMap() {
    return {
      'id':id,
      'name': name,
      'directory': directory,
    };
  }

  Ingredient.fromMap(Map<String, dynamic> res):
        id = res['id'],
        name = res['name'],
        directory = res['directory'];

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
            Navigator.pushNamed(context, "/detail");
          },
        ),
        onDismissed: (DismissDirection direction) async {
          await dbHandler.deleteIngredient(ingredient.id);
        },
      );
    }
  }