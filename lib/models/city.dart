import 'package:pana_project/models/country.dart';

class City {
  int? id;
  int? countryId;
  String? name;
  Country? country;

  City({this.id, this.countryId, this.name});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryId = json['country_id'];
    name = json['name'];
    country =
        json['country'] != null ? Country.fromJson(json['country']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['country_id'] = countryId;
    data['name'] = name;
    data['country'] = country;
    return data;
  }
}
