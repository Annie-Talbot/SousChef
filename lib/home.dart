import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Future<void> initiateCooking(Recipe recipe) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("cooking", true);
    prefs.setString("recipe", json.encode(recipe.toMap()));
    setState(() {
      setIndex(2);
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey("cooking")) {
        if (prefs.getBool("cooking") == true) {
          initiateCooking(
              Recipe.fromMap(json.decode(prefs.getString("recipe")!))
          );
        }
      } else {
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
              backgroundColor: Theme.of(context).colorScheme.primary,
              label: destination.title
          );
        }).toList(),
      ),
    );
  }
}
