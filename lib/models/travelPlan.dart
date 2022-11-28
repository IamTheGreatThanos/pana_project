import 'package:pana_project/models/city.dart';
import 'package:pana_project/models/housingDetail.dart';

class TravelPlanModel {
  int? id;
  int? type;
  int? status;
  String? name;
  int? tripId;
  City? city;
  HousingDetailModel? housing;
  int? private;
  String? dateStart;
  String? dateEnd;

  TravelPlanModel(
      {this.id,
      this.type,
      this.status,
      this.name,
      this.tripId,
      this.city,
      this.housing,
      this.private,
      this.dateStart,
      this.dateEnd});

  TravelPlanModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    status = json['status'];
    name = json['name'];
    tripId = json['trip_id'];
    city = json['city'] != null ? City.fromJson(json['city']) : null;
    housing = json['housing'] != null
        ? HousingDetailModel.fromJson(json['housing'])
        : null;
    private = json['private'];
    dateStart = json['date_start'];
    dateEnd = json['date_end'];
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
    data['private'] = private;
    data['date_start'] = dateStart;
    data['date_end'] = dateEnd;
    return data;
  }
}
