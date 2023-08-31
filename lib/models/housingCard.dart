import 'package:pana_project/models/category.dart';
import 'package:pana_project/models/city.dart';
import 'package:pana_project/models/country.dart';
import 'package:pana_project/models/images.dart';
import 'package:pana_project/models/user.dart';
import 'package:pana_project/models/videos.dart';

class HousingCardModel {
  int? id;
  String? name;
  City? city;
  Country? country;
  List<Images>? images;
  List<Videos>? videos;
  bool? inFavorite;
  double? reviewsAvgBall;
  int? reviewsCount;
  int? distance;
  User? user;
  int? basePriceMin;
  Category? category;
  String? dateFrom;
  String? dateTo;
  int? star;

  HousingCardModel({
    this.id,
    this.name,
    this.city,
    this.country,
    this.images,
    this.videos,
    this.inFavorite,
    this.reviewsAvgBall,
    this.reviewsCount,
    this.distance,
    this.user,
    this.basePriceMin,
    this.category,
    this.dateFrom,
    this.dateTo,
    this.star,
  });

  HousingCardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    city = json['city'] != null ? City.fromJson(json['city']) : null;
    country =
        json['country'] != null ? Country.fromJson(json['country']) : null;
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
    inFavorite = json['in_favorite'];
    reviewsAvgBall = double.tryParse(json['reviews_ball_avg'].toString()) ?? 0;
    reviewsCount = json['reviews_count'];
    distance = json['distance'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    basePriceMin = int.parse((json['base_price_min'] ?? 0).toString());
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
    dateFrom = json['date_from'];
    dateTo = json['date_to'];
    star = json['star'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    if (city != null) {
      data['city'] = city!.toJson();
    }
    if (country != null) {
      data['country'] = country!.toJson();
    }
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    data['in_favorite'] = inFavorite;
    data['reviews_avg_ball'] = reviewsAvgBall;
    data['reviews_count'] = reviewsCount;
    data['distance'] = distance;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['base_price_min'] = basePriceMin;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    data['date_from'] = dateFrom;
    data['date_to'] = dateTo;
    return data;
  }
}
