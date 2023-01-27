class Topic {
  int? id;
  String? name;
  int? parentId;
  int? level;
  int? laravelThroughKey;

  Topic(
      {this.id, this.name, this.parentId, this.level, this.laravelThroughKey});

  Topic.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    parentId = json['parent_id'];
    level = json['level'];
    laravelThroughKey = json['laravel_through_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['parent_id'] = this.parentId;
    data['level'] = this.level;
    data['laravel_through_key'] = this.laravelThroughKey;
    return data;
  }
}
