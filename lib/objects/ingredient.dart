

class Ingredient {
  int id;
  String name;
  int directory;

  Ingredient({required this.id, required this.name, required this.directory});

  Map<String, Object> toMap() {
    return {
      'id':id,
      'name': name,
      'directory': directory,
    };
  }

  Ingredient.fromMap(Map<String, dynamic> res):
        id = res['id'],
        name = res['name'],
        directory = res['directory'];

}