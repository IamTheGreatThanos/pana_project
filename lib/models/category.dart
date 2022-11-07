class Category {
  int? id;
  String? name;
  String? description;
  String? icon;
  String? image;

  Category({this.id, this.name, this.description, this.icon, this.image});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    icon = json['icon'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['icon'] = icon;
    data['image'] = image;
    return data;
  }
}
