import 'package:pana_project/models/housingCard.dart';
import 'package:pana_project/models/impressionCard.dart';

class PanaTravelCardModel {
  int? id;
  String? name;
  String? description;
  int? reviewsCount;
  int? reviewsBallAvg;
  List<HousingCardModel>? housings;
  List<ImpressionCardModel>? impressions;

  PanaTravelCardModel(
      {this.id,
      this.name,
      this.description,
      this.reviewsCount,
      this.reviewsBallAvg,
      this.housings,
      this.impressions});

  PanaTravelCardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    reviewsCount = json['reviews_count'];
    reviewsBallAvg = json['reviews_ball_avg'];
    if (json['housings'] != null) {
      housings = <HousingCardModel>[];
      json['housings'].forEach((v) {
        housings!.add(HousingCardModel.fromJson(v));
      });
    }
    if (json['impressions'] != null) {
      impressions = <ImpressionCardModel>[];
      json['impressions'].forEach((v) {
        impressions!.add(ImpressionCardModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['reviews_count'] = reviewsCount;
    data['reviews_ball_avg'] = reviewsBallAvg;
    if (housings != null) {
      data['housings'] = housings!.map((v) => v.toJson()).toList();
    }
    if (impressions != null) {
      data['impressions'] = impressions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
