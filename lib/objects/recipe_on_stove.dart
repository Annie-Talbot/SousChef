

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sous_chef/objects/method_on_stove.dart';

import 'method.dart';
import 'recipe.dart';

class RecipeOnStove {
  String name = "Recipe";
  String ingredients = "Ingredients List";
  TimeOfDay eatTime = TimeOfDay.now();
  List<MethodOnStove> method = [];

  RecipeOnStove(Recipe r, this.eatTime) {
    name = r.name;
    ingredients = r.ingredients;
    int totalTime = 0;
    List<MethodOnStove> tempList = [];
    for (Method m in r.method.reversed) {
      tempList.add(
          MethodOnStove.fromMethod(method: m, eatTime: eatTime, timeTaken: totalTime));
      totalTime += m.duration;
    }
    // Reverse the list
    for (MethodOnStove m in tempList.reversed) {
      method.add(m);
    }
  }

  RecipeOnStove.restore({required this.name, required this.ingredients,
                          required this.method, required this.eatTime});

  Map<String, Object> toMap() {
    List<Map<String, Object>> methodMap = [];
    for (MethodOnStove m in method) {
      methodMap.add(m.toMap());
    }
    // Turn date to string
    String dateString = DateFormat("HH:mm").format(DateTime(2000,
        1, 1, eatTime.hour, eatTime.minute));

    Map<String, Object> map = {
      "name": name,
      "ingredients": ingredients,
      "method": methodMap,
      "eatTime": dateString,
    };
    print(map);
    return map;
  }

  RecipeOnStove.fromMap(Map<String, dynamic> res) {
    List<MethodOnStove> methods = [];
    for (dynamic innerRes in res["method"]) {
      methods.add(MethodOnStove.fromMap(innerRes));
    }
    name = res["name"];
    ingredients = res["ingredients"];
    method = methods;
    
    // Time string is in format "TimeOfDay(HH:MM)"
    // Extracting time values
    eatTime = TimeOfDay.fromDateTime(DateFormat("HH:mm").parse(res["eatTime"]));
  }
}