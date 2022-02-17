import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../destination.dart';

class RecipeListPage extends StatefulWidget {
  const RecipeListPage({ required Key key, required this.destination }) : super(key: key);

  final Destination destination;

  @override
  _RecipeListPageState createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.destination.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
            child: Text("I am the ${widget.destination.title} display.")
        ),
      ),
    );
  }
}