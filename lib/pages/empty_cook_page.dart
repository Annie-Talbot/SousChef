import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sous_chef/objects/recipe_on_stove.dart';
import '../destination.dart';
import '../objects/method_on_stove.dart';
import '../objects/recipe.dart';

class EmptyCookPage extends StatefulWidget {
  const EmptyCookPage({ required Key key, required this.destination }) : super(key: key);

  final Destination destination;

  @override
  _EmptyCookPageState createState() => _EmptyCookPageState();
}

class _EmptyCookPageState extends State<EmptyCookPage> {
  bool _cooking = false;
  RecipeOnStove? _recipeOnStove;

  updateStove() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("cooking")) {
      prefs.setBool("cooking", false);
    }
    if (prefs.getBool("cooking")! == true) {
      // Cooking is in progress
      // Update cooking variables
      _cooking = true;
      _recipeOnStove = RecipeOnStove.fromMap(
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
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildTitleWidget(),
            Divider(),
            buildSubheadingWidget("Ingredients"),
            Text(
              _recipeOnStove!.ingredients,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Divider(),
            buildSubheadingWidget("Method"),
            Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: createMethodWidgets()
            ),
          ]
        ),
      );
  }

  createConcernDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Are you sure you want to exit cooking?",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            content: const Text("All progress will be lost."),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: const Text("Cancel"),
                onPressed: () {
                    Navigator.of(context).pop();
                },
              ),
              MaterialButton(
                elevation: 5.0,
                child: const Text("Remove current recipe"),
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
              Icons.cancel_outlined,
              size: 28.0,
            ),
          )
      );

  buildNotCookingWidget() =>
      Card(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Nothing's on the stove!",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const Text("Go to the recipes tab to select a recipe to cook.")
            ],
          ),
        ),
      );

  List<Widget> createMethodWidgets() {
    List<Widget> methods = [];
    for (MethodOnStove m in _recipeOnStove!.method) {
      methods.add(MethodOnStoveWidget(method: m));
    }
    return methods;
  }



  Widget buildTitleWidget() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 2.0),
    child: Text(
      _recipeOnStove!.name,
      style: Theme.of(context).textTheme.titleLarge,
    ),
  );

  Widget buildSubheadingWidget(String headingText) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 2.0),
    child: Text(
      headingText,
      style: Theme.of(context).textTheme.headlineMedium,
    ),
  );

}