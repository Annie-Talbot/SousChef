import 'package:flutter/cupertino.dart';
import 'package:sous_chef/pages/error_page.dart';
import 'package:sous_chef/pages/ingredient/ingredient_list_page.dart';

import '../destination.dart';
import '../objects/recipe.dart';
import '../pages/settings_page.dart';

class SettingsDestination extends Destination{
  SettingsDestination(String title, IconData icon) : super(title, icon);

  @override
  Widget Function(BuildContext) routeBuilder(BuildContext context,
      RouteSettings settings, Function(Recipe recipe) initiateCooking) {
    return (context) {
      switch (settings.name) {
        case '/':
          return SettingsPage(destination: this, key: UniqueKey(),);
        default:
          return ErrorPage(key: UniqueKey());
      }
    };
  }
}