import 'package:pana_project/models/beds.dart';
import 'package:pana_project/models/comforts.dart';
import 'package:pana_project/models/images.dart';
import 'package:pana_project/models/roomType.dart';

class RoomCardModel {
  int? id;
  RoomName? roomName;
  int? housingId;
  RoomType? roomType;
  int? status;
  int? size;
  String? description;
  int? basePrice;
  int? smoking;
  int? disabledPeople;
  int? countCopy;
  int? maxPeople;
  int? maxAdultCount;
  int? maxChildCount;
  int? maxBabyCount;
  int? maxPedCount;
  List<Images>? images;
  List<Beds>? beds;
  List<Comforts>? comforts;

  RoomCardModel(
      {this.id,
      this.roomName,
      this.housingId,
      this.roomType,
      this.status,
      this.size,
      this.description,
      this.basePrice,
      this.smoking,
      this.disabledPeople,
      this.countCopy,
      this.maxPeople,
      this.maxAdultCount,
      this.maxChildCount,
      this.maxBabyCount,
      this.maxPedCount,
      this.images,
      this.beds,
      this.comforts});

  RoomCardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roomName = json['roomName'] != null
        ? new RoomName.fromJson(json['roomName'])
        : null;
    housingId = json['housing_id'];
    roomType =
        json['roomType'] != null ? RoomType.fromJson(json['roomType']) : null;
    status = json['status'];
    size = json['size'];
    description = json['description'];
    basePrice = json['base_price'];
    smoking = json['smoking'];
    disabledPeople = json['disabled_people'];
    countCopy = json['count_copy'];
    maxPeople = json['max_people'];
    maxAdultCount = json['max_adult_count'];
    maxChildCount = json['max_child_count'];
    maxBabyCount = json['max_baby_count'];
    maxPedCount = json['max_ped_count'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
    if (json['beds'] != null) {
      beds = <Beds>[];
      json['beds'].forEach((v) {
        beds!.add(Beds.fromJson(v));
      });
    }
    if (json['comforts'] != null) {
      comforts = <Comforts>[];
      json['comforts'].forEach((v) {
        comforts!.add(Comforts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (this.roomName != null) {
      data['roomName'] = this.roomName!.toJson();
    }
    data['housing_id'] = housingId;
    if (roomType != null) {
      data['roomType'] = roomType!.toJson();
    }
    data['status'] = status;
    data['size'] = size;
    data['description'] = description;
    data['base_price'] = basePrice;
    data['smoking'] = smoking;
    data['disabled_people'] = disabledPeople;
    data['count_copy'] = countCopy;
    data['max_people'] = maxPeople;
    data['max_adult_count'] = maxAdultCount;
    data['max_child_count'] = maxChildCount;
    data['max_baby_count'] = maxBabyCount;
    data['max_ped_count'] = maxPedCount;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    if (beds != null) {
      data['beds'] = beds!.map((v) => v.toJson()).toList();
    }
    if (comforts != null) {
      data['comforts'] = comforts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RoomName {
  int? id;
  int? roomTypeId;
  String? name;
  RoomType? roomType;

  RoomName({this.id, this.roomTypeId, this.name, this.roomType});

  RoomName.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roomTypeId = json['room_type_id'];
    name = json['name'];
    roomType = json['room_type'] != null
        ? new RoomType.fromJson(json['room_type'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['room_type_id'] = this.roomTypeId;
    data['name'] = this.name;
    if (this.roomType != null) {
      data['room_type'] = this.roomType!.toJson();
    }
    return data;
  }
}
