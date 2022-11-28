import 'package:pana_project/models/user.dart';

class TravelCardModel {
  int? id;
  String? name;
  int? status;
  User? user;
  int? usersCount;
  int? routeCount;
  String? bgImage;
  String? dateEnd;
  String? dateStart;

  TravelCardModel(
      {this.id,
      this.name,
      this.status,
      this.user,
      this.usersCount,
      this.routeCount,
      this.bgImage,
      this.dateEnd,
      this.dateStart});

  TravelCardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    usersCount = json['users_count'];
    routeCount = json['route_count'];
    bgImage = json['bg_image'];
    dateEnd = json['date_end'];
    dateStart = json['date_start'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['users_count'] = this.usersCount;
    data['route_count'] = this.routeCount;
    data['bg_image'] = this.bgImage;
    data['date_end'] = this.dateEnd;
    data['date_start'] = this.dateStart;
    return data;
  }
}
