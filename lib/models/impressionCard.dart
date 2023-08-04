import 'package:pana_project/models/category.dart';
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
  String? price;
  bool? inFavorite;
  double? reviewsAvgBall;
  int? reviewsCount;
  Category? category;
  String? dateFrom;
  String? dateTo;

  ImpressionCardModel({
    this.id,
    this.user,
    this.city,
    this.country,
    this.name,
    this.duration,
    this.images,
    this.videos,
    this.price,
    this.inFavorite,
    this.reviewsAvgBall,
    this.reviewsCount,
    this.category,
    this.dateFrom,
    this.dateTo,
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
    price = json['price'].toString();
    inFavorite = json['in_favorite'];
    reviewsAvgBall = double.tryParse(json['reviews_avg_ball'].toString()) ?? 0;
    reviewsCount = json['reviews_count'];
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
    dateFrom = json['date_from'];
    dateTo = json['date_to'];
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
    data['price'] = price;
    data['in_favorite'] = inFavorite;
    data['reviews_avg_ball'] = reviewsAvgBall;
    data['reviews_count'] = reviewsCount;
    data['date_from'] = dateFrom;
    data['date_to'] = dateTo;

    return data;
  }
}
