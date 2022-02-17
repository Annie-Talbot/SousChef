import 'package:flutter/cupertino.dart';
import 'package:sous_chef/pages/error_page.dart';
import 'package:sous_chef/pages/ingredient/ingredient_list_page.dart';

import '../destination.dart';
import '../pages/empty_cook_page.dart';

class CookDestination extends Destination{
  const CookDestination(String title, IconData icon) : super(title, icon);

  @override
  Widget Function(BuildContext) routeBuilder(BuildContext context,
      RouteSettings settings) {
    return (context) {
      switch (settings.name) {
        case '/':
          return EmptyCookPage(destination: this, key: UniqueKey(),);
        default:
          return ErrorPage(key: UniqueKey());
      }
    };
  }
}