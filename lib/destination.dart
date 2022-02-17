import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'destinations/cook_destination.dart';
import 'destinations/friends_destination.dart';
import 'destinations/recipe_destination.dart';
import 'destinations/settings_destination.dart';
import 'pages/error_page.dart';
import 'destinations/ingredient_destination.dart';
import 'icons.dart';

class Destination {
  const Destination(this.title, this.icon);

  final String title;
  final IconData icon;

  Widget Function(BuildContext) routeBuilder(BuildContext context,
      RouteSettings settings) {
    return (context) {
          return ErrorPage(key: UniqueKey());
    };
  }
}

class DestinationView extends StatefulWidget {
  const DestinationView({ required Key key, required this.destination }) : super(key: key);

  final Destination destination;

  @override
  _DestinationViewState createState() => _DestinationViewState();
}

class _DestinationViewState extends State<DestinationView> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: widget.destination.routeBuilder(context, settings),
        );
      },
    );
  }
}


const List<Destination> allDestinations = <Destination>[
  RecipeDestination('Recipes', Icons.receipt),
  IngredientDestination('Ingredients', Icons.local_pizza_outlined),
  CookDestination('Cook', Icons.local_dining_outlined),
  FriendsDestination('Friends', Icons.person),
  SettingsDestination('Settings', Icons.settings)
];