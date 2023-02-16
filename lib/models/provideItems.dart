class ProvideItems {
  int? id;
  int? impressionId;
  int? provideItemId;
  String? description;
  String? createdAt;
  String? updatedAt;
  ProvideItem? provideItem;

  ProvideItems(
      {this.id,
      this.impressionId,
      this.provideItemId,
      this.description,
      this.createdAt,
      this.updatedAt,
      this.provideItem});

  ProvideItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    impressionId = json['impression_id'];
    provideItemId = json['provide_item_id'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    provideItem = json['provide_item'] != null
        ? ProvideItem.fromJson(json['provide_item'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['impression_id'] = impressionId;
    data['provide_item_id'] = provideItemId;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (provideItem != null) {
      data['provide_item'] = provideItem!.toJson();
    }
    return data;
  }
}

class ProvideItem {
  int? id;
  int? provideId;
  String? name;
  String? createdAt;
  String? updatedAt;

  ProvideItem(
      {this.id, this.provideId, this.name, this.createdAt, this.updatedAt});

  ProvideItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    provideId = json['provide_id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['provide_id'] = provideId;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
