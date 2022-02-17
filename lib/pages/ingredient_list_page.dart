import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sous_chef/DatabaseHandler.dart';
import 'package:sous_chef/objects/directory.dart';
import '../destination.dart';

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
                  return Dismissible(
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Icon(Icons.delete_forever),
                    ),
                    key: ValueKey<int>(snapshot.data![index].id),
                    onDismissed: (DismissDirection direction) async {
                      setState(() {
                        snapshot.data!.remove(snapshot.data![index]);
                      });
                    },
                    child: Card(
                        child: ListTile(
                          contentPadding: EdgeInsets.all(8.0),
                          title: Text(snapshot.data![index].name),
                        )),
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

}