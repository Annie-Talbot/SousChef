import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sous_chef/DatabaseHandler.dart';
import 'package:sous_chef/objects/directory.dart';
import '../../destination.dart';

class IngredientListPage extends StatefulWidget {
  const IngredientListPage({ required Key key, required this.destination }) : super(key: key);

  final Destination destination;

  @override
  _IngredientListPageState createState() => _IngredientListPageState();
}

class _IngredientListPageState extends State<IngredientListPage> {

  DatabaseHandler dbHandler = DatabaseHandler();

  @override
  void initState() {
    super.initState();
    print("here");
    dbHandler.open().whenComplete(() => setState(() {}));
    print("how im here");
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
          future: dbHandler.fetchRootDirectories(DirectoryType.ingredient),
          builder: (BuildContext context, AsyncSnapshot<List<Directory>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (BuildContext context, int index) {
                  return DirectoryWidget(
                    dir: snapshot.data![index],
                    dbHandler: dbHandler);
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
                        DirectoryType.ingredient);
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