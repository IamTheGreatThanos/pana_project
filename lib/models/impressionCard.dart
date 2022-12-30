import 'package:pana_project/models/city.dart';
import 'package:pana_project/models/country.dart';
import 'package:pana_project/models/images.dart';
import 'package:pana_project/models/user.dart';
import 'package:pana_project/models/videos.dart';

class ImpressionCardModel {
  int? id;
  User? user;
  City? city;
  Country? country;
  String? name;
  String? duration;
  List<Images>? images;
  List<Videos>? videos;
  String? openPrice;
  bool? inFavorite;
  int? reviewsAvgBall;
  int? reviewsCount;

  ImpressionCardModel({
    this.id,
    this.user,
    this.city,
    this.country,
    this.name,
    this.duration,
    this.images,
    this.videos,
    this.openPrice,
    this.inFavorite,
    this.reviewsAvgBall,
    this.reviewsCount,
  });

  ImpressionCardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    city = json['city'] != null ? City.fromJson(json['city']) : null;
    country =
        json['country'] != null ? Country.fromJson(json['country']) : null;
    name = json['name'];
    duration = json['duration'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
    if (json['videos'] != null) {
      videos = <Videos>[];
      json['videos'].forEach((v) {
        videos!.add(Videos.fromJson(v));
      });
    }
    openPrice = json['open_price'].toString();
    inFavorite = json['in_favorite'];
    reviewsAvgBall = json['reviews_avg_ball'];
    reviewsCount = json['reviews_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (city != null) {
      data['city'] = city!.toJson();
    }
    if (country != null) {
      data['country'] = country!.toJson();
    }
    data['name'] = name;
    data['duration'] = duration;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    if (videos != null) {
      data['videos'] = videos!.map((v) => v.toJson()).toList();
    }
    data['open_price'] = openPrice;
    data['in_favorite'] = inFavorite;
    data['reviews_avg_ball'] = reviewsAvgBall;
    data['reviews_count'] = reviewsCount;
    return data;
  }
}
