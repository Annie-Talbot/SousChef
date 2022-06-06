import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../destination.dart';
import '../objects/recipe.dart';

class EmptyCookPage extends StatefulWidget {
  const EmptyCookPage({ required Key key, required this.destination }) : super(key: key);

  final Destination destination;

  @override
  _EmptyCookPageState createState() => _EmptyCookPageState();
}

class _EmptyCookPageState extends State<EmptyCookPage> {
  bool _cooking = false;
  Recipe? _recipeOnStove;

  updateStove() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("cooking")) {
      prefs.setBool("cooking", false);
    }
    if (prefs.getBool("cooking")! == true) {
      // Cooking is in progress
      // Update cooking variables
      _cooking = true;
      _recipeOnStove = Recipe.fromMap(
          json.decode(prefs.getString("recipe")!)
      );
      setState(() {
        // Reload widgets
      });
    } else {
      // Nothing on the stove
      setState(() {
        _cooking = false;
        _recipeOnStove = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      updateStove();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_cooking) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.destination.title),
          actions: <Widget>[buildRemoveRecipeButton()],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: buildCookingWidget(),
        ),
      );
    } else {
      // Not cooking
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.destination.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: buildNotCookingWidget(),
        ),
      );
    }
  }
  
  Widget buildCookingWidget() {
      return Card(
        margin: EdgeInsets.all(12.0),
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _recipeOnStove!.name,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              Text(_recipeOnStove!.ingredients)
            ],
          ),
        ),
      );
  }

  createConcernDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Are you sure you want to exit cooking?",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            content: Text("All progress will be lost."),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text("Cancel"),
                onPressed: () {
                    Navigator.of(context).pop();
                },
              ),
              MaterialButton(
                elevation: 5.0,
                child: Text("Remove current recipe"),
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setBool("cooking", false);
                  prefs.setString("Recipe", "");
                  updateStove();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }

  buildRemoveRecipeButton() =>
      Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            onTap: () {
              createConcernDialog(context);
            },
            child: Icon(
              Icons.add,
              size: 28.0,
            ),
          )
      );

  buildNotCookingWidget() =>
      Card(
        margin: EdgeInsets.all(12.0),
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Nothing on the stove!",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              Text("Go to the recipes tab to select a recipe to cook.")
            ],
          ),
        ),
      );



}