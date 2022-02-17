import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sous_chef/DatabaseHandler.dart';
import 'package:sous_chef/objects/directory.dart';
import '../../destination.dart';
import '../../objects/ingredient.dart';

class IngredientDetailPage extends StatefulWidget {
  const IngredientDetailPage(this.ingredient,
      { required Key key,
        required this.destination,
        }) : super(key: key);
  final Ingredient ingredient;
  final Destination destination;

  @override
  _IngredientDetailPageState createState() => _IngredientDetailPageState();
}

class _IngredientDetailPageState extends State<IngredientDetailPage> {

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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.ingredient.name,
              style: Theme.of(context).textTheme.titleLarge
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {  },
        child: Icon(Icons.save_as_outlined),
      ),
    );
  }

}