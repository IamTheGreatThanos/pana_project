import 'package:pana_project/models/housingDetail.dart';
import 'package:pana_project/models/impressionDetail.dart';
import 'package:pana_project/models/user.dart';

class TransactionHistory {
  int? id;
  String? type;
  int? status;
  User? user;
  HousingDetailModel? housing;
  ImpressionDetailModel? impression;
  int? totalPrice;
  String? dateFrom;
  String? dateTo;
  String? paymentAt;
  String? comment;
  int? countPeople;
  String? timeStart;
  String? timeEnd;
  List<RoomNumbers>? roomNumbers;

  TransactionHistory({
    this.id,
    this.type,
    this.status,
    this.user,
    this.housing,
    this.impression,
    this.totalPrice,
    this.dateFrom,
    this.dateTo,
    this.paymentAt,
    this.comment,
    this.countPeople,
    this.timeStart,
    this.timeEnd,
    this.roomNumbers,
  });

  TransactionHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    status = json['status'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    housing = json['housing'] != null
        ? HousingDetailModel.fromJson(json['housing'])
        : null;
    impression = json['impression'] != null
        ? ImpressionDetailModel.fromJson(json['impression'])
        : null;
    totalPrice = json['total_price'];
    dateFrom = json['date_from'];
    dateTo = json['date_to'];
    paymentAt = json['payment_at'];
    comment = json['comment'];
    countPeople = json['count_people'];
    timeStart = json['time_start'];
    timeEnd = json['time_end'];
    if (json['roomNumbers'] != null) {
      roomNumbers = <RoomNumbers>[];
      json['roomNumbers'].forEach((v) {
        roomNumbers!.add(RoomNumbers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['type'] = type;
    data['status'] = status;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (housing != null) {
      data['housing'] = housing!.toJson();
    }
    if (impression != null) {
      data['impression'] = impression!.toJson();
    }
    data['total_price'] = totalPrice;
    data['date_from'] = dateFrom;
    data['date_to'] = dateTo;
    data['payment_at'] = paymentAt;
    data['comment'] = comment;
    data['count_people'] = countPeople;
    data['time_start'] = timeStart;
    data['time_end'] = timeEnd;
    if (roomNumbers != null) {
      data['roomNumbers'] = roomNumbers!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class RoomNumbers {
  int? id;
  int? housingId;
  String? dateFrom;
  String? dateTo;
  int? orderId;
  int? roomId;
  int? roomNumberId;
  int? count;
  int? price;
  int? totalPrice;
  String? createdAt;
  String? updatedAt;
  String? roomName;

  RoomNumbers({
    this.id,
    this.housingId,
    this.dateFrom,
    this.dateTo,
    this.orderId,
    this.roomId,
    this.roomNumberId,
    this.count,
    this.price,
    this.totalPrice,
    this.createdAt,
    this.updatedAt,
    this.roomName,
  });

  RoomNumbers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    housingId = json['housing_id'];
    dateFrom = json['date_from'];
    dateTo = json['date_to'];
    orderId = json['order_id'];
    roomId = json['room_id'];
    roomNumberId = json['room_number_id'];
    count = json['count'];
    price = json['price'];
    totalPrice = json['total_price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    json['room']['room_name'] != null
        ? roomName = json['room']['room_name']['name']
        : '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['housing_id'] = housingId;
    data['date_from'] = dateFrom;
    data['date_to'] = dateTo;
    data['order_id'] = orderId;
    data['room_id'] = roomId;
    data['room_number_id'] = roomNumberId;
    data['count'] = count;
    data['price'] = price;
    data['total_price'] = totalPrice;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
