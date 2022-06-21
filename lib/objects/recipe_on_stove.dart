

import 'package:flutter/cupertino.dart';
import 'package:sous_chef/objects/method_on_stove.dart';

import 'method.dart';
import 'recipe.dart';

class RecipeOnStove {
  String name = "Recipe";
  String ingredients = "Ingredients List";
  List<MethodOnStove> method = [];

  RecipeOnStove(Recipe r) {
    name = r.name;
    ingredients = r.ingredients;
    int counter = 0;
    for (Method m in r.method) {
      int startTime = 19 + counter;
      method.add(
          MethodOnStove(method: m, done: false, startTime: startTime));
      counter ++;
    }
  }

  RecipeOnStove.restore({required this.name, required this.ingredients,
                          required this.method});

  Map<String, Object> toMap() {
    List<Map<String, Object>> methodMap = [];
    for (MethodOnStove m in method) {
      methodMap.add(m.toMap());
    }
    return {
      "name": name,
      "ingredients": ingredients,
      "method": methodMap
    };
  }

  RecipeOnStove.fromMap(Map<String, dynamic> res) {
    List<MethodOnStove> methods = [];
    for (dynamic innerRes in res["method"]) {
      methods.add(MethodOnStove.fromMap(innerRes));
    }
    name = res["name"];
    ingredients = res["ingredients"];
    method = methods;
  }
}