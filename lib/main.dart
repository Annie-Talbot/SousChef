import 'package:flutter/material.dart';

import 'home.dart';

void main() {
  runApp(MaterialApp(
    title: "Annie's Practise App",
    theme: ThemeData(
      fontFamily: 'Exo2',
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.teal,
      ),
      brightness: Brightness.light,
    ),
    darkTheme: ThemeData(
      brightness: Brightness.dark,
    ),
    themeMode: ThemeMode.light,
    home: Home(),
  ),
  );
}