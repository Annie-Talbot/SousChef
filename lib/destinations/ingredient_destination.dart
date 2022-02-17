import 'package:flutter/cupertino.dart';
import 'package:sous_chef/objects/ingredient.dart';
import 'package:sous_chef/pages/error_page.dart';
import 'package:sous_chef/pages/ingredient/ingredient_list_page.dart';

import '../destination.dart';
import '../pages/ingredient/ingredient_detail_page.dart';

class IngredientDestination extends Destination{
  const IngredientDestination(String title, IconData icon) : super(title, icon);

  @override
  Widget Function(BuildContext) routeBuilder(BuildContext context,
      RouteSettings settings) {
    return (context) {
      switch (settings.name) {
        case '/':
          return IngredientListPage(destination: this, key: UniqueKey(),);
        case '/detail':
          return IngredientDetailPage(Ingredient(id:1, name:"dave", directory:1), key: UniqueKey(), destination: this);
        default:
          return ErrorPage(key: UniqueKey());
      }
    };
  }
}