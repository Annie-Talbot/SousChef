import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sous_chef/objects/recipe_on_stove.dart';

import 'destination.dart';
import 'objects/recipe.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  void setIndex(int newIndex) {
      _currentIndex = newIndex;
  }
  Future<void> initiateCooking(Recipe recipe, TimeOfDay eatTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("cooking", true);
    prefs.setString("recipe", json.encode(RecipeOnStove(recipe, eatTime).toMap()));
    setState(() {
      setIndex(2);
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey("cooking")) {
        prefs.setBool("cooking", false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: allDestinations.map<Widget>((Destination destination) {
          return DestinationView(destination: destination, key: UniqueKey(), initiateCooking: initiateCooking,);
        }).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: allDestinations.map((Destination destination) {
          return BottomNavigationBarItem(
              icon: Icon(destination.icon),
              label: destination.title
          );
        }).toList(),
      ),
    );
  }
}
