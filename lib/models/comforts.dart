class Comforts {
  int? id;
  String? name;
  int? level;
  Map<String, dynamic>? parent;

  Comforts({this.id, this.name, this.level, this.parent});

  Comforts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    level = json['level'];
    parent = json['parent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['level'] = level;
    data['parent'] = parent;
    return data;
  }
}
