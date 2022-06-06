import 'package:flutter/cupertino.dart';
import 'package:sous_chef/pages/error_page.dart';
import 'package:sous_chef/pages/ingredient/ingredient_list_page.dart';

import '../destination.dart';
import '../objects/recipe.dart';
import '../pages/friends_page.dart';

class FriendsDestination extends Destination{
  FriendsDestination(String title, IconData icon) : super(title, icon);

  @override
  Widget Function(BuildContext) routeBuilder(BuildContext context,
      RouteSettings settings, Function(Recipe recipe) initiateCooking) {
    return (context) {
      switch (settings.name) {
        case '/':
          return FriendsPage(destination: this, key: UniqueKey(),);
        default:
          return ErrorPage(key: UniqueKey());
      }
    };
  }
}