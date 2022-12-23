import 'package:pana_project/models/city.dart';
import 'package:pana_project/models/country.dart';
import 'package:pana_project/models/images.dart';
import 'package:pana_project/models/videos.dart';

class HousingCardModel {
  int? id;
  City? city;
  Country? country;
  List<Images>? images;
  List<Videos>? videos;
  bool? inFavorite;
  int? reviewsAvgBall;
  int? distance;

  HousingCardModel(
      {this.id,
      this.city,
      this.country,
      this.images,
      this.videos,
      this.inFavorite,
      this.reviewsAvgBall,
      this.distance});

  HousingCardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
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
    reviewsAvgBall = json['reviews_avg_ball'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.city != null) {
      data['city'] = this.city!.toJson();
    }
    if (this.country != null) {
      data['country'] = this.country!.toJson();
    }
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    data['in_favorite'] = this.inFavorite;
    data['reviews_avg_ball'] = this.reviewsAvgBall;
    data['distance'] = this.distance;
    return data;
  }
}
