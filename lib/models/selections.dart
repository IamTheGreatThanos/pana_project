import 'package:pana_project/models/housingCard.dart';
import 'package:pana_project/models/impressionCard.dart';

class Selections {
  int? id;
  String? title;
  String? description;
  // Null? image;
  String? createdAt;
  String? updatedAt;
  List<SelectionItems>? items;

  Selections(
      {this.id,
      this.title,
      this.description,
      // this.image,
      this.createdAt,
      this.updatedAt,
      this.items});

  Selections.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    // image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['items'] != null) {
      items = <SelectionItems>[];
      json['items'].forEach((v) {
        items!.add(new SelectionItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    // data['image'] = this.image;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SelectionItems {
  int? id;
  int? compilationId;
  int? housingId;
  int? impressionId;
  String? type;
  String? description;
  HousingCardModel? housing;
  ImpressionCardModel? impression;

  SelectionItems(
      {this.id,
      this.compilationId,
      this.housingId,
      this.impressionId,
      this.type,
      this.description,
      this.housing,
      this.impression});

  SelectionItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    compilationId = json['compilation_id'];
    housingId = json['housing_id'];
    impressionId = json['impression_id'];
    type = json['type'];
    description = json['description'];
    housing = json['housing'] != null
        ? HousingCardModel.fromJson(json['housing'])
        : null;
    impression = json['impression'] != null
        ? ImpressionCardModel.fromJson(json['impression'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['compilation_id'] = compilationId;
    data['housing_id'] = housingId;
    data['impression_id'] = impressionId;
    data['type'] = type;
    data['description'] = description;
    if (housing != null) {
      data['housing'] = housing!.toJson();
    }
    if (impression != null) {
      data['impression'] = impression!.toJson();
    }
    return data;
  }
}
