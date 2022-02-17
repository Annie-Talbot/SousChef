import 'package:flutter/cupertino.dart';
import 'package:sous_chef/pages/error_page.dart';

import '../destination.dart';
import '../pages/recipe_list_page.dart';

class RecipeDestination extends Destination{
  const RecipeDestination(String title, IconData icon) : super(title, icon);

  @override
  Widget Function(BuildContext) routeBuilder(BuildContext context,
      RouteSettings settings) {
    return (context) {
      switch (settings.name) {
        case '/':
          return RecipeListPage(destination: this, key: UniqueKey(),);
        default:
          return ErrorPage(key: UniqueKey());
      }
    };
  }
}