import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sous_chef/objects/ingredient.dart';
import 'package:sous_chef/pages/error_page.dart';
import 'package:sous_chef/pages/ingredient/ingredient_list_page.dart';

import '../destination.dart';
import '../objects/recipe.dart';
import '../pages/ingredient/ingredient_detail_page.dart';

class IngredientRoutes {
  static const String list = "/";
  static const String detail = "/detail";
}

class IngredientDestination extends Destination{
  IngredientDestination(String title, IconData icon) : super(title, icon);

  @override
  Widget Function(BuildContext) routeBuilder(BuildContext context,
      RouteSettings settings,
      Function(Recipe recipe, TimeOfDay eatTime) initiateCooking) {
    return (context) {
      switch (settings.name) {
        case IngredientRoutes.list:
          return IngredientListPage(destination: this, key: UniqueKey(), initiateCooking: initiateCooking);
        case IngredientRoutes.detail:
          return IngredientDetailPage(key: UniqueKey(), destination: this);
        default:
          return ErrorPage(key: UniqueKey());
      }
    };
  }
}