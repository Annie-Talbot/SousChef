import 'package:flutter/cupertino.dart';
import 'package:sous_chef/pages/error_page.dart';
import 'package:sous_chef/pages/ingredient_list_page.dart';

import '../destination.dart';

class IngredientDestination extends Destination{
  const IngredientDestination(String title, IconData icon) : super(title, icon);

  @override
  Widget Function(BuildContext) routeBuilder(BuildContext context,
      RouteSettings settings) {
    return (context) {
      switch (settings.name) {
        case '/':
          return IngredientListPage(destination: this, key: UniqueKey(),);
        default:
          return ErrorPage(key: UniqueKey());
      }
    };
  }
}