
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sous_chef/database_handler.dart';
import 'package:sous_chef/destinations/ingredient_destination.dart';
import 'package:sous_chef/objects/ingredient.dart';
import 'package:sous_chef/objects/recipe.dart';

import '../destinations/recipe_destination.dart';
import '../theme_manager.dart';

enum DirectoryType {
  ingredient,
  recipe,
}


class Directory {
  int id;
  String name;
  int parent = -1;
  DirectoryType type;
  List children = [];

  Directory(this.parent, {required this.id,
                          required this.name,
                          required this.type});

  void addChildren(List children) {
    this.children.addAll(children);
  }

  Map<String, Object> toMap() {
    return {
      DatabaseHandler.directoriesId:id,
      DatabaseHandler.directoriesName: name,
      DatabaseHandler.directoriesParent: parent,
      DatabaseHandler.directoriesType: type.index
    };
  }

  Directory.fromMap(Map<String, dynamic> map):
        parent = map[DatabaseHandler.directoriesParent],
        id = map[DatabaseHandler.directoriesId],
        name = map[DatabaseHandler.directoriesName],
        type = DirectoryType.values[map[DatabaseHandler.directoriesType]];
}

class DirectoryWidget extends StatefulWidget {
  const DirectoryWidget({
    Key? key,
    required this.dir,
    required this.dbHandler,
    required this.initiateCooking,
  }) : super(key: key);

  final Directory dir;
  final DatabaseHandler dbHandler;
  final Function(Recipe recipe, TimeOfDay eatTime) initiateCooking;

  @override
  State<DirectoryWidget> createState() => _DirectoryWidgetState();
}

class _DirectoryWidgetState extends State<DirectoryWidget> {
  @override
  Widget build(BuildContext context) {
    //widget.dbHandler.addRawIngredient("Carrots", widget.dir.id);
    return Card(
        child: Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            background: Container(
              color: ThemeNotifier.error,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: const Icon(Icons.delete_forever),
            ),
            child: ExpansionTile(
              iconColor: ThemeNotifier.mediumGreen,
              textColor: ThemeNotifier.mediumGreen,
              controlAffinity: ListTileControlAffinity.leading,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    alignment: Alignment.centerRight,
                    icon: const Icon(Icons.drive_file_rename_outline),
                    onPressed: () {
                      createRenameDialog(context, widget.dir);
                    },
                  ),
                  IconButton(
                    alignment: Alignment.centerRight,
                    icon: Icon(Icons.add),
                    onPressed: () {
                      if (widget.dir.type == DirectoryType.ingredient ) {
                        Navigator.of(context).pushNamed(
                            IngredientRoutes.detail,
                            arguments: IngredientParcel(
                              isExisting: false,
                              dirId: widget.dir.id,
                            )
                        );
                      } else {
                        Navigator.of(context).pushNamed(
                            RecipeRoutes.detail,
                            arguments: RecipeParcel(
                              isExisting: false,
                              dirId: widget.dir.id,
                            )
                        );
                      }
                    },
                  ),
                ],
              ),
              title: Text(
                widget.dir.name,
              ),
              children: createChildList(context, widget.dir),
            ),
            onDismissed: (DismissDirection direction) async {
              await widget.dbHandler.deleteDirectory(widget.dir.id);
            },
        )
      );
  }

  createChildList(BuildContext context, Directory d) {
    if (d.type == DirectoryType.ingredient) {
      return d.children.map(
              (child) => IngredientWidget(
              ingredient: child,
              dbHandler: widget.dbHandler)).toList();
    } else {
      return d.children.map(
              (child) => RecipeWidget(
              recipe: child,
              dbHandler: widget.dbHandler,
              initiateCooking: widget.initiateCooking)).toList();
    }
  }

  createRenameDialog(BuildContext context, Directory d) {
    TextEditingController ctrl = TextEditingController(text: d.name);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Rename"),
            content: TextField(
              controller: ctrl,
            ),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: const Text("Rename"),
                onPressed: () {
                  setState(() {
                    d.name = ctrl.text.toString();
                    widget.dbHandler.updateDirectory(d);
                    Navigator.of(context).pop();
                  });
                },
              )
            ],
          );
        }
    );
  }
}