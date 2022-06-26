import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sous_chef/pages/error_page.dart';

import '../destination.dart';
import '../objects/recipe.dart';
import '../pages/recipe/recipe_detail_page.dart';
import '../pages/recipe/recipe_list_page.dart';

class RecipeRoutes {
  static const String list = "/";
  static const String detail = "/detail";
}

class RecipeDestination extends Destination{
  RecipeDestination(String title, IconData icon) : super(title, icon);

  @override
  Widget Function(BuildContext) routeBuilder(BuildContext context,
      RouteSettings settings,
      Function(Recipe recipe, TimeOfDay eatTime) initiateCooking) {
    return (context) {
      switch (settings.name) {
        case RecipeRoutes.list:
          return RecipeListPage(destination: this, key: UniqueKey(), initiateCooking: initiateCooking);
        case RecipeRoutes.detail:
          return RecipeDetailPage(key: UniqueKey(), destination: this);
        default:
          return ErrorPage(key: UniqueKey());
      }
    };
  }
}