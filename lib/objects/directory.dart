
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sous_chef/DatabaseHandler.dart';
import 'package:sous_chef/objects/ingredient.dart';

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
      'id':id,
      'name': name,
      'parent': parent,
      'type': type.index
    };
  }

  Directory.fromMap(Map<String, dynamic> map):
        parent = map['parent'],
        id = map['id'],
        name = map['name'],
        type = DirectoryType.values[map['type']];
}

class DirectoryWidget extends StatefulWidget {
  const DirectoryWidget({
    Key? key,
    required this.dir,
    required this.dbHandler
  }) : super(key: key);

  final Directory dir;
  final DatabaseHandler dbHandler;

  @override
  State<DirectoryWidget> createState() => _DirectoryWidgetState();
}

class _DirectoryWidgetState extends State<DirectoryWidget> {
  @override
  Widget build(BuildContext context) {
    //dbHandler.addRawIngredient("Carrots", dir.id);
    return Card(
        child: Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Icon(Icons.delete_forever),
            ),
            child: ExpansionTile(
              controlAffinity: ListTileControlAffinity.leading,
              trailing: IconButton(
                icon: Icon(Icons.drive_file_rename_outline),
                onPressed: () {
                  createRenameDialog(context, widget.dir);
                },
              ),
              title: Text(
                widget.dir.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: widget.dir.children.map(
                      (child) => IngredientWidget(
                          ingredient: child,
                          dbHandler: widget.dbHandler)).toList(),
            ),
            onDismissed: (DismissDirection direction) async {
              await widget.dbHandler.deleteDirectory(widget.dir.id);
            },
        )
      );
  }

  createRenameDialog(BuildContext context, Directory d) {
    TextEditingController ctrl = TextEditingController(text: d.name);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Rename"),
            content: TextField(
              controller: ctrl,
            ),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text("Rename"),
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