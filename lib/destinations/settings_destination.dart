import 'package:flutter/cupertino.dart';
import 'package:sous_chef/pages/error_page.dart';
import 'package:sous_chef/pages/ingredient/ingredient_list_page.dart';

import '../destination.dart';
import '../pages/settings_page.dart';

class SettingsDestination extends Destination{
  const SettingsDestination(String title, IconData icon) : super(title, icon);

  @override
  Widget Function(BuildContext) routeBuilder(BuildContext context,
      RouteSettings settings) {
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