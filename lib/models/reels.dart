import 'package:pana_project/models/category.dart';
import 'package:pana_project/models/city.dart';
import 'package:pana_project/models/housingDetail.dart';
import 'package:pana_project/models/impressionDetail.dart';
import 'package:pana_project/models/user.dart';

class Reels {
  int? id;
  int? status;
  User? user;
  City? city;
  HousingDetailModel? housing;
  ImpressionDetailModel? impression;
  Category? category;
  String? video;
  String? thumbnail;
  int? showCount;

  Reels(
      {this.id,
      this.status,
      this.user,
      this.city,
      this.housing,
      this.impression,
      this.category,
      this.video,
      this.thumbnail,
      this.showCount});

  Reels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    city = json['city'] != null ? City.fromJson(json['city']) : null;
    housing = json['housing'] != null
        ? HousingDetailModel.fromJson(json['housing'])
        : null;
    impression = json['impression'] != null
        ? ImpressionDetailModel.fromJson(json['impression'])
        : null;
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
    video = json['video'];
    thumbnail = json['thumbnail'];
    showCount = json['show_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (city != null) {
      data['city'] = city!.toJson();
    }
    if (housing != null) {
      data['housing'] = housing!.toJson();
    }
    data['impression'] = impression;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    data['video'] = video;
    data['thumbnail'] = thumbnail;
    data['show_count'] = showCount;
    return data;
  }
}
