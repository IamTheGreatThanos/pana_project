class HousingCardModel {
  int? id;
  City? city;
  Country? country;
  List<Images>? images;
  bool? inFavorite;
  int? reviewsAvgBall;
  int? distance;

  HousingCardModel(
      {this.id,
      this.city,
      this.country,
      this.images,
      this.inFavorite,
      this.reviewsAvgBall,
      this.distance});

  HousingCardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    city = json['city'] != null ? new City.fromJson(json['city']) : null;
    country =
        json['country'] != null ? new Country.fromJson(json['country']) : null;
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
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

class City {
  int? id;
  int? countryId;
  String? name;

  City({this.id, this.countryId, this.name});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryId = json['country_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['country_id'] = this.countryId;
    data['name'] = this.name;
    return data;
  }
}

class Country {
  int? id;
  String? name;
  Null? phoneCode;

  Country({this.id, this.name, this.phoneCode});

  Country.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phoneCode = json['phone_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone_code'] = this.phoneCode;
    return data;
  }
}

class Images {
  int? id;
  int? housingId;
  String? path;
  Null? position;

  Images({this.id, this.housingId, this.path, this.position});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    housingId = json['housing_id'];
    path = json['path'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['housing_id'] = this.housingId;
    data['path'] = this.path;
    data['position'] = this.position;
    return data;
  }
}
