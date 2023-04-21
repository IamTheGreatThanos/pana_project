import 'package:pana_project/models/city.dart';
import 'package:pana_project/models/housingDetail.dart';
import 'package:pana_project/models/travelCard.dart';

class NotificationModel {
  int? id;
  int? type;
  String? typeInfoTestDeveloper;
  String? title;
  String? description;
  String? readAt;
  HousingDetailModel? housing;
  City? city;
  Map<String, dynamic>? impression;
  TravelCardModel? trip;
  Chat? chat;
  int? iconType;

  NotificationModel({
    this.id,
    this.type,
    this.typeInfoTestDeveloper,
    this.title,
    this.description,
    this.readAt,
    this.housing,
    this.city,
    this.impression,
    this.trip,
    this.chat,
    this.iconType,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    typeInfoTestDeveloper = json['type_info_test_developer'];
    title = json['title'];
    description = json['description'];
    readAt = json['read_at'];
    housing = json['housing'] != null
        ? HousingDetailModel.fromJson(json['housing'])
        : null;
    city = json['city'] != null ? City.fromJson(json['city']) : null;
    impression = json['impression'];
    trip = json['trip'] != null ? TravelCardModel.fromJson(json['trip']) : null;
    chat = json['chat'] != null ? Chat.fromJson(json['chat']) : null;
    iconType = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['type'] = type;
    data['type_info_test_developer'] = typeInfoTestDeveloper;
    data['title'] = title;
    data['description'] = description;
    data['read_at'] = readAt;
    data['housing'] = housing;
    data['city'] = city;
    data['impression'] = impression;
    data['trip'] = trip;
    if (chat != null) {
      data['chat'] = chat!.toJson();
    }
    data['icon'] = iconType;
    return data;
  }
}

class Chat {
  int? id;
  int? userId;
  String? createdAt;
  String? updatedAt;

  Chat({this.id, this.userId, this.createdAt, this.updatedAt});

  Chat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
