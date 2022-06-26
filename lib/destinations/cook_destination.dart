import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sous_chef/pages/error_page.dart';
import 'package:sous_chef/pages/ingredient/ingredient_list_page.dart';

import '../destination.dart';
import '../objects/recipe.dart';
import '../pages/empty_cook_page.dart';

class CookRoutes {
  static const String main = "/";
}


class CookDestination extends Destination{
  CookDestination(String title, IconData icon) : super(title, icon);

  @override
  Widget Function(BuildContext) routeBuilder(BuildContext context,
      RouteSettings settings,
      Function(Recipe recipe, TimeOfDay eatTime) initiateCooking) {
    return (context) {
      switch (settings.name) {
        case CookRoutes.main:
          return EmptyCookPage(destination: this, key: UniqueKey(),);
        default:
          return ErrorPage(key: UniqueKey());
      }
    };
  }
}