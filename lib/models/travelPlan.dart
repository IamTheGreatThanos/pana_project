import 'package:pana_project/models/city.dart';
import 'package:pana_project/models/housingCard.dart';
import 'package:pana_project/models/impressionCard.dart';

class TravelPlanModel {
  int? id;
  int? type;
  int? status;
  String? name;
  int? tripId;
  City? city;
  HousingCardModel? housing;
  ImpressionCardModel? impression;
  int? private;
  String? dateStart;
  String? dateEnd;
  String? lat;
  String? lng;

  TravelPlanModel({
    this.id,
    this.type,
    this.status,
    this.name,
    this.tripId,
    this.city,
    this.housing,
    this.impression,
    this.private,
    this.dateStart,
    this.dateEnd,
    this.lat,
    this.lng,
  });

  TravelPlanModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    status = json['status'];
    name = json['name'];
    tripId = json['trip_id'];
    city = json['city'] != null ? City.fromJson(json['city']) : null;
    housing = json['housing'] != null
        ? HousingCardModel.fromJson(json['housing'])
        : null;
    impression = json['impression'] != null
        ? ImpressionCardModel.fromJson(json['impression'])
        : null;
    private = json['private'];
    dateStart = json['date_start'];
    dateEnd = json['date_end'];
    lat = json['lat'].toString();
    lng = json['lng'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['status'] = status;
    data['name'] = name;
    data['trip_id'] = tripId;
    if (city != null) {
      data['city'] = city!.toJson();
    }
    if (housing != null) {
      data['housing'] = housing!.toJson();
    }
    if (impression != null) {
      data['impression'] = impression!.toJson();
    }
    data['private'] = private;
    data['date_start'] = dateStart;
    data['date_end'] = dateEnd;
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}
