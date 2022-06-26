import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sous_chef/storage_manager.dart';

class ThemeNotifier with ChangeNotifier {
  static const darkGreen = Color(0xff354f52);
  static const mediumGreen = Color(0xff52796f);
  static const lightGreen = Color(0xff84a98c);
  static const veryLightGreen = Color(0xffcad2c5);
  static const white = Colors.white;
  static const error = Color(0xffb34747);

  final darkTheme = ThemeData(
    brightness: Brightness.dark,
    cardTheme: CardTheme(
      margin: EdgeInsets.all(12.0),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) return white;
          return darkGreen;
        }),
        backgroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) return mediumGreen;
          return veryLightGreen;
        }),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) return mediumGreen;
          return darkGreen;
        }),
      ),
    ),
    primaryColor: lightGreen,
    primaryColorLight: lightGreen,
    bottomAppBarColor: lightGreen,
    focusColor: veryLightGreen,
    highlightColor: veryLightGreen,
    unselectedWidgetColor: lightGreen,
    hintColor: veryLightGreen,
    errorColor: error,
    toggleableActiveColor: lightGreen,
    appBarTheme: const AppBarTheme(
      backgroundColor: lightGreen,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: lightGreen,
        unselectedItemColor: white,
        selectedItemColor: darkGreen,
        type: BottomNavigationBarType.fixed,
        unselectedIconTheme: IconThemeData(
          color: white,
        )
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 24.0,
      backgroundColor: veryLightGreen,
      foregroundColor: darkGreen,
    ),
    dividerTheme: const DividerThemeData(
      color: veryLightGreen,
      thickness: 2.0,
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        color: lightGreen,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        fontSize: 18.0,
      ),
    ),
    listTileTheme: const ListTileThemeData(
      selectedColor: darkGreen,
      style: ListTileStyle.drawer,
      selectedTileColor: darkGreen,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(),),
    ),
  );

  final lightTheme = ThemeData(
    brightness: Brightness.light,
    cardTheme: CardTheme(
      margin: EdgeInsets.all(12.0),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) return white;
          return veryLightGreen;
        }),
        backgroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) return mediumGreen;
          return darkGreen;
        }),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) return mediumGreen;
          return darkGreen;
        }),
      ),
    ),
    primaryColor: lightGreen,
    primaryColorLight: lightGreen,
    appBarTheme: const AppBarTheme(
      backgroundColor: lightGreen,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: lightGreen,
      unselectedItemColor: white,
      selectedItemColor: darkGreen,
      type: BottomNavigationBarType.fixed,
      unselectedIconTheme: IconThemeData(
        color: white,
      )
    ),
    focusColor: veryLightGreen,
    highlightColor: veryLightGreen,
    unselectedWidgetColor: lightGreen,
    hintColor: veryLightGreen,
    errorColor: error,
    toggleableActiveColor: lightGreen,
    dividerTheme: const DividerThemeData(
      color: darkGreen,
      thickness: 2.0,
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        color: darkGreen,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        fontSize: 18.0,
      ),
    ),
    listTileTheme: const ListTileThemeData(
      selectedColor: darkGreen,
      style: ListTileStyle.drawer,
      selectedTileColor: darkGreen,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(),),
    ),
  );

  late ThemeData _themeData;

  ThemeData getTheme() => _themeData;

  ThemeNotifier() {
    StorageManager.readData('themeMode').then((value) {
      print('value read from storage: ' + value.toString());
      var themeMode = value ?? 'light';
      if (themeMode == 'light') {
        _themeData = lightTheme;
      } else {
        print('setting dark theme');
        _themeData = darkTheme;
      }
      notifyListeners();
    });
  }

  void setDarkMode() async {
    _themeData = darkTheme;
    StorageManager.saveData('themeMode', 'dark');
    notifyListeners();
  }

  void setLightMode() async {
    _themeData = lightTheme;
    StorageManager.saveData('themeMode', 'light');
    notifyListeners();
  }

  Future<bool> inDarkMode() async {
    StorageManager.readData('themeMode').then((value) {
      print('value read from storage: ' + value.toString());
      var themeMode = value ?? 'light';
      if (themeMode == 'light') {
        return false;
      } else {
        print('setting dark theme');
        return true;
      }
    });
    return false;
  }

}