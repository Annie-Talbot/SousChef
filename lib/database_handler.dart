import 'package:flutter/src/widgets/editable_text.dart';
import 'package:logger/logger.dart';
import 'package:sous_chef/objects/directory.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'objects/ingredient.dart';
import 'objects/instruction.dart';
import 'objects/method.dart';
import 'objects/recipe.dart';

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

  static const String instructionsTable = "instructions";
  static const String instructionsId = "id";
  static const String instructionsDesc = "description";
  static const String instructionsDuration = "duration";
  static const String instructionsOrderKey = "order_key";
  static const String instructionsIngredient = "ingredient";

  static const String recipeTable = "recipes";
  static const String recipeId = "id";
  static const String recipeName = "name";
  static const String recipeIngredients = "ingredients";
  static const String recipeDirectory = "directory";

  static const String methodTable = "methods";
  static const String methodId = "id";
  static const String methodDesc = "description";
  static const String methodDuration = "duration";
  static const String methodOrderKey = "order_key";
  static const String methodRecipe = "recipe";

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
    // Insert the root directory
    await db.rawInsert('INSERT INTO $directoriesTable '
        '("$directoriesId", "$directoriesName", "$directoriesType") '
        'VALUES(-1, "Directory 1", ${DirectoryType.ingredient.index})');

    await db.execute(
      "CREATE TABLE $ingredientsTable("
          "$ingredientsId INTEGER PRIMARY KEY AUTOINCREMENT, "
          "$ingredientsName TEXT NOT NULL, "
          "$ingredientsDirectory INTEGER NOT NULL, "
          "FOREIGN KEY ($ingredientsDirectory) REFERENCES $directoriesTable($directoriesId) "
          "ON DELETE CASCADE"
          ")",
    );

    await db.execute("CREATE TABLE $instructionsTable("
        "$instructionsId INTEGER PRIMARY KEY AUTOINCREMENT, "
        "$instructionsDesc TEXT NOT NULL, "
        "$instructionsDuration INTEGER NOT NULL, "
        "$instructionsOrderKey INTEGER NOT NULL, "
        "$instructionsIngredient INTEGER NOT NULL, "
        "FOREIGN KEY ($instructionsIngredient) REFERENCES $ingredientsTable($ingredientsId) "
        "ON DELETE CASCADE"
        ")",
    );

    await db.execute("CREATE TABLE $recipeTable("
          "$recipeId INTEGER PRIMARY KEY AUTOINCREMENT, "
          "$recipeName TEXT NOT NULL, "
          "$recipeIngredients TEXT, "
          "$recipeDirectory INTEGER NOT NULL, "
          "FOREIGN KEY ($recipeDirectory) REFERENCES $directoriesTable($directoriesId) "
          "ON DELETE CASCADE"
          ")",
    );

    await db.execute("CREATE TABLE $methodTable("
        "$methodId INTEGER PRIMARY KEY AUTOINCREMENT, "
        "$methodDesc TEXT NOT NULL, "
        "$methodDuration INTEGER NOT NULL, "
        "$methodOrderKey INTEGER NOT NULL, "
        "$methodRecipe INTEGER NOT NULL, "
        "FOREIGN KEY ($methodRecipe) REFERENCES $recipeTable($recipeId) "
        "ON DELETE CASCADE"
        ")",
    );

  }

  Future<int> insertDirectory(List<Directory> dirs) async {
    int result = 0;
    for (Directory d in dirs) {
      result = await db.insert(directoriesTable, d.toMap());
    }
    return result;
  }

  Future<List<Directory>> fetchAllIngredients(DirectoryType type) async {
    List<Directory> rootDirs = await fetchRootDirectories(type);
    for (Directory d in rootDirs) {
      // Fetch children
      d.addChildren(await fetchChildIngredients(d.id));
    }
    return rootDirs;
  }

  Future<List<Directory>> fetchRootDirectories(DirectoryType type) async {
    logger.d("Fetch root directories init");
    final List<Map<String, Object?>> queryResult = await db.query(
      directoriesTable,
      where: "$directoriesParent = ? AND $directoriesType = ?",
      whereArgs: [-1, type.index],
    );
    List<Directory> dirs = queryResult.map((d) => Directory.fromMap(d)).toList();
    logger.d("Fetch complete. Data: $queryResult");
    return dirs;
  }

  Future<List<Ingredient>> fetchChildIngredients(int directory) async {
    logger.d("Fetch init");
    final List<Map<String, Object?>> queryResult = await db.query(
      ingredientsTable,
      where: "$ingredientsDirectory = ?",
      whereArgs: [directory],
    );
    logger.d("Fetch complete. Data: $queryResult");
    List<Ingredient> ingredients = queryResult.map((i) => Ingredient.fromMap(i)).toList();
    for (Ingredient i in ingredients) {
      i.setInstructions(await fetchInstructions(i.id));
    }
    return ingredients;
  }

  Future<int> addRootDirectory(String name, DirectoryType type) async {
    return await db.rawInsert('INSERT INTO $directoriesTable '
        '("$directoriesName", "$directoriesParent", "$directoriesType") '
        'VALUES(?, ?, ?)', [name, -1, type.index]);
  }

  Future<int> updateDirectory(Directory d) async {
    return await db.update(
        directoriesTable,
        d.toMap(),
        where: "$directoriesId = ?",
        whereArgs: [d.id]);
  }

  Future<int> deleteDirectory(int directoryId) async {
    return await db.delete(
      directoriesTable,
      where: "$directoriesId = ?",
      whereArgs: [directoryId]
    );
  }

  // Ingredient actions
  Future<int> insertIngredient(Map<String, Object> ingredient,
      List<List<String>> instructions) async {
    int ingredientId = await db.insert(ingredientsTable, ingredient);
    addInstructions(instructions, ingredientId);
    return ingredientId;
  }

  Future<int> updateIngredient(Ingredient i,
      List<List<String>> instructions) async {
    await db.update(
      ingredientsTable,
      i.toMap(),
      where: "$ingredientsId = ?",
      whereArgs: [i.id],
    );
    // Remove all previously stored instructions for this ingredient
    removeInstructionsForIngredient(i);
    // Add the new instructions
    addInstructions(instructions, i.id);
    return i.id;
  }

  Future<int> deleteIngredient(int ingredientId) async {
    // TODO: Remove instructions when ingredient is deleted
    return await db.delete(
        ingredientsTable,
        where: "$ingredientsId = ?",
        whereArgs: [ingredientId]
    );
  }

  // Instruction actions
  Future<int> insertInstruction(Map<String, Object> instruction) async {
    return await db.insert(instructionsTable, instruction);
  }

  Future<int> removeInstructionsForIngredient(Ingredient ingredient) async {
    return await db.delete(
        instructionsTable,
        where: "$instructionsIngredient = ?",
        whereArgs: [ingredient.id]
    );
  }

  Future<int> addInstruction(String description, String duration,
      int index, int id) async {
    return await db.rawInsert('INSERT INTO $instructionsTable '
        '("$instructionsDesc", "$instructionsDuration", '
        '"$instructionsOrderKey", "$instructionsIngredient") '
        'VALUES(?, ?, ?, ?)', [description, duration, index, id]);
  }

  void addInstructions(List<List<String>> rawInstructions,
      int ingredientId) {
    for (int i = 0; i < rawInstructions.length; i++) {
      addInstruction(rawInstructions[i][0], rawInstructions[i][1],
          i, ingredientId);
    }
  }

  Future<List<Instruction>> fetchInstructions(int ingredientId) async {
    final List<Map<String, Object?>> queryResult = await db.query(
      instructionsTable,
      where: "$instructionsIngredient = ?",
      whereArgs: [ingredientId],
    );
    // TODO: Return instructions in the correct order.
    return queryResult.map((i) => Instruction.fromMap(i)).toList();
  }

  // Recipe Actions
  Future<List<Directory>> fetchAllRecipes(DirectoryType type) async {
    List<Directory> rootDirs = await fetchRootDirectories(type);
    for (Directory d in rootDirs) {
      // Fetch children
      d.addChildren(await fetchChildRecipes(d.id));
    }
    return rootDirs;
  }

  Future<List<Recipe>> fetchChildRecipes(int directory) async {
    logger.d("Fetch init");
    final List<Map<String, Object?>> queryResult = await db.query(
      recipeTable,
      where: "$recipeDirectory = ?",
      whereArgs: [directory],
    );
    logger.d("Fetch complete. Data: $queryResult");
    List<Recipe> recipes = queryResult.map((i) => Recipe.fromMap(i)).toList();
    for (Recipe r in recipes) {
      r.setMethod(await fetchMethod(r.id));
    }
    return recipes;
  }

  Future<int> deleteRecipe(int id) async {
    return await db.delete(
        recipeTable,
        where: "$recipeId = ?",
        whereArgs: [id]
    );
  }

  Future<int> insertRecipe(Map<String, Object> recipe,
      List<List<String>> method) async {
    int recipeId = await db.insert(recipeTable, recipe);
    addMethods(method, recipeId);
    return recipeId;
  }

  Future<int> updateRecipe(Recipe r,
      List<List<String>> methods) async {
    await db.update(
      recipeTable,
      r.toMap(),
      where: "$recipeId = ?",
      whereArgs: [r.id],
    );
    // Remove all previously stored instructions for this ingredient
    removeMethodForRecipe(r);
    // Add the new instructions
    addMethods(methods, r.id);
    return r.id;
  }

  // Method Actions
  Future<int> addMethod(String description, String duration,
      int index, int id) async {
    return await db.rawInsert('INSERT INTO $methodTable '
        '("$methodDesc", "$methodDuration", '
        '"$methodOrderKey", "$methodRecipe") '
        'VALUES(?, ?, ?, ?)', [description, duration, index, id]);
  }

  void addMethods(List<List<String>> rawMethods,
      int ingredientId) {
    for (int i = 0; i < rawMethods.length; i++) {
      addMethod(rawMethods[i][0], rawMethods[i][1],
          i, ingredientId);
    }
  }

  Future<List<Method>> fetchMethod(int recipeID) async {
    final List<Map<String, Object?>> queryResult = await db.query(
      methodTable,
      where: "$methodRecipe = ?",
      whereArgs: [recipeID],
    );
    // TODO: Return method in the correct order.
    return queryResult.map((m) => Method.fromMap(m)).toList();
  }

  Future<int> removeMethodForRecipe(Recipe recipe) async {
    return await db.delete(
        methodTable,
        where: "$methodRecipe = ?",
        whereArgs: [recipe.id]
    );
  }
}