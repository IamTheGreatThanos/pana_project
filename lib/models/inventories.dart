class Inventories {
  int? id;
  int? impressionId;
  String? name;
  String? createdAt;
  String? updatedAt;

  Inventories(
      {this.id, this.impressionId, this.name, this.createdAt, this.updatedAt});

  Inventories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    impressionId = json['impression_id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['impression_id'] = impressionId;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
