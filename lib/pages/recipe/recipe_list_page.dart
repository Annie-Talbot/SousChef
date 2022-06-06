import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sous_chef/database_handler.dart';
import 'package:sous_chef/objects/recipe.dart';
import '../../destination.dart';
import '../../objects/directory.dart';

class RecipeListPage extends StatefulWidget {
  const RecipeListPage({ required Key key, required this.destination,
    required Function(Recipe recipe) this.initiateCooking}) : super(key: key);

  final Function(Recipe recipe) initiateCooking;
  final Destination destination;

  @override
  _RecipeListPageState createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {

  DatabaseHandler dbHandler = DatabaseHandler();

  @override
  void initState() {
    super.initState();
    dbHandler.open().whenComplete(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.destination.title),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    creteAlertDialog(context);
                  },
                  child: Icon(
                    Icons.add,
                    size: 28.0,
                  ),
                )
            ),
          ]
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          // TODO: Change function name to fetchAll
          future: dbHandler.fetchAllRecipes(DirectoryType.recipe),
          builder: (BuildContext context, AsyncSnapshot<List<Directory>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (BuildContext context, int index) {
                  return DirectoryWidget(
                      dir: snapshot.data![index],
                      dbHandler: dbHandler,
                      initiateCooking: widget.initiateCooking
                  );
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  creteAlertDialog(BuildContext context) {
    TextEditingController ctrl = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Add a root directory"),
            content: TextField(
              controller: ctrl,
            ),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text("Add"),
                onPressed: () {
                  setState(() {
                    dbHandler.addRootDirectory(
                        ctrl.text.toString(),
                        DirectoryType.recipe);
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