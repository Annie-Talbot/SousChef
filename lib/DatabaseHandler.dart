import 'package:logger/logger.dart';
import 'package:sous_chef/objects/directory.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {
  final logger = Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 5,
        lineLength: 50,
        colors: true,
        printEmojis: false,
        printTime: true,
        noBoxingByDefault: true,
      )
  );
  static const String dbName = "sous_chef.db";

  static const String ingredientsTable = "ingredients";
  static const String ingredientsId = "id";
  static const String ingredientsName = "name";
  static const String ingredientsDirectory = "directory";

  static const String directoriesTable = "directories";
  static const String directoriesId = "id";
  static const String directoriesName = "name";
  static const String directoriesType = "type";
  static const String directoriesParent = "parent";

  late Database db;
  DatabaseHandler();

  Future open() async {
    String path = await getDatabasesPath();
    db = await openDatabase(
      join(path, dbName),
      version: 1,
      onCreate: _onCreate,
      onConfigure: _onConfigure
    );
  }

  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE $directoriesTable("
          "$directoriesId INTEGER PRIMARY KEY AUTOINCREMENT, "
          "$directoriesName TEXT NOT NULL, "
          "$directoriesType INTEGER NOT NULL, "
          "$directoriesParent INTEGER "
          "REFERENCES directories(id) ON DELETE CASCADE"
          ")",
    );
    await db.execute(
      "CREATE TABLE $ingredientsTable("
          "$ingredientsId INTEGER PRIMARY KEY AUTOINCREMENT, "
          "$ingredientsName TEXT NOT NULL, "
          "$ingredientsDirectory INTEGER NOT NULL, "
          "FOREIGN KEY ($ingredientsDirectory) REFERENCES $directoriesTable($directoriesId) "
          "ON DELETE CASCADE"
          ")",
    );
    // Insert the root directory
    await db.rawInsert('INSERT INTO $directoriesTable '
        '("$directoriesId", "$directoriesName", "$directoriesType") '
        'VALUES(-1, "Directory 1", ${DirectoryType.ingredient.index})');

    // TODO: Remove manual directory inserts
    await db.rawInsert('INSERT INTO $directoriesTable '
        '("$directoriesName", "$directoriesType", "$directoriesParent") '
        'VALUES("Directory 1", ${DirectoryType.ingredient.index}, -1)');
    await db.rawInsert('INSERT INTO $directoriesTable '
        '("$directoriesName", "$directoriesType", "$directoriesParent") '
        'VALUES("Directory 2", ${DirectoryType.ingredient.index}, -1)');
  }

  Future<int> insertDirectory(List<Directory> dirs) async {
    int result = 0;
    for (Directory d in dirs) {
      result = await db.insert(directoriesTable, d.toMap());
    }
    return result;
  }

  Future<List<Directory>> fetchRootDirectories(DirectoryType type) async {
    logger.d("Fetch init");
    final List<Map<String, Object?>> queryResult = await db.query(
      directoriesTable,
      where: "$directoriesParent = ? AND $directoriesType = ?",
      whereArgs: [-1, DirectoryType.ingredient.index],
    );
    logger.d("Fetch complete. Data: $queryResult");
    return queryResult.map((d) => Directory.fromMap(d)).toList();
  }
}