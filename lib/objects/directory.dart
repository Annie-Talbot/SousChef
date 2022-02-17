
enum DirectoryType {
  ingredient,
  recipe,
}


class Directory {
  int id;
  String name;
  int parent = -1;
  DirectoryType type;

  Directory(this.parent, {required this.id,
                          required this.name,
                          required this.type});

  Map<String, Object> toMap() {
    return {
      'id':id,
      'name': name,
      'parent': parent,
      'type': type.index
    };
  }

  Directory.fromMap(Map<String, dynamic> map):
        parent = map['parent'],
        id = map['id'],
        name = map['name'],
        type = DirectoryType.values[map['type']];
}