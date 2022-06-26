import 'package:flutter/material.dart';
import 'package:sous_chef/theme_manager.dart';
import 'package:provider/provider.dart';
import 'home.dart';

void main() {
  return runApp(ChangeNotifierProvider<ThemeNotifier>(
    create: (_) => new ThemeNotifier(),
    child: MyApp(),
  ));
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, theme, _) => MaterialApp(
        title: "Annie's App",
        theme: theme.getTheme(),
        home: Home(),
      ),
    );
  }
}

// runApp(MaterialApp(
// title: "Annie's Practise App",
// theme: ThemeData(
// fontFamily: 'Exo2',
// colorScheme: ColorScheme.fromSwatch(
// primarySwatch: Colors.teal,
// ),
// brightness: Brightness.light,
// ),
// darkTheme: ThemeData(
// brightness: Brightness.dark,
// ),
// themeMode: ThemeMode.light,
// home: Home(),
// ),
// );