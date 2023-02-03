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
  int? colorNumber;

  TravelCardModel({
    this.id,
    this.name,
    this.status,
    this.user,
    this.usersCount,
    this.routeCount,
    this.bgImage,
    this.dateEnd,
    this.dateStart,
    this.colorNumber,
  });

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
    colorNumber = json['color_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['status'] = status;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['users_count'] = usersCount;
    data['route_count'] = routeCount;
    data['bg_image'] = bgImage;
    data['date_end'] = dateEnd;
    data['date_start'] = dateStart;
    data['color_number'] = colorNumber;
    return data;
  }
}
