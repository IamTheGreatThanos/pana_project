import 'package:pana_project/models/housingDetail.dart';
import 'package:pana_project/models/impressionDetail.dart';
import 'package:pana_project/models/transactionHistory.dart';
import 'package:pana_project/models/user.dart';

class ReceiptOrder {
  int? id;
  String? type;
  int? status; // 6 - отменено
  User? user;
  HousingDetailModel? housing;
  ImpressionDetailModel? impression;
  double? totalPrice;
  double? returnPrice;
  double? finePrice;
  String? dateFrom;
  String? dateTo;
  String? paymentAt;
  int? paymentType; // 1 - card, 3 - при заселении
  String? createdAt;
  String? comment;
  int? countPeople;
  String? timeStart;
  String? timeEnd;
  List<RoomNumbers>? roomNumbers;
  Map<dynamic, dynamic>? successPaymentOperation;

  ReceiptOrder({
    this.id,
    this.type,
    this.status,
    this.user,
    this.housing,
    this.impression,
    this.totalPrice,
    this.returnPrice,
    this.finePrice,
    this.dateFrom,
    this.dateTo,
    this.paymentAt,
    this.paymentType,
    this.comment,
    this.countPeople,
    this.timeStart,
    this.timeEnd,
    this.roomNumbers,
    this.successPaymentOperation,
  });

  ReceiptOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    status = json['status'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    housing = json['housing'] != null
        ? new HousingDetailModel.fromJson(json['housing'])
        : null;
    impression = json['impression'] != null
        ? new ImpressionDetailModel.fromJson(json['impression'])
        : null;
    json['total_price'] != null
        ? totalPrice = double.parse(json['total_price'].toString())
        : totalPrice = json['total_price'];
    json['return_price'] != null
        ? returnPrice = double.parse(json['return_price'].toString())
        : returnPrice = json['return_price'];
    json['fine_price'] != null
        ? finePrice = double.parse(json['fine_price'].toString())
        : finePrice = json['fine_price'];
    dateFrom = json['date_from'];
    dateTo = json['date_to'];
    paymentAt = json['payment_at'];
    paymentType = json['payment_type'];
    createdAt = json['created_at'];
    comment = json['comment'];
    countPeople = json['count_people'];
    timeStart = json['time_start'];
    timeEnd = json['time_end'];
    if (json['roomNumbers'] != null) {
      roomNumbers = <RoomNumbers>[];
      json['roomNumbers'].forEach((v) {
        roomNumbers!.add(new RoomNumbers.fromJson(v));
      });
    }
    successPaymentOperation = json['success_payment_operation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['status'] = this.status;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.housing != null) {
      data['housing'] = this.housing!.toJson();
    }
    if (this.impression != null) {
      data['impression'] = this.impression!.toJson();
    }
    data['total_price'] = this.totalPrice;
    data['return_price'] = this.returnPrice;
    data['fine_price'] = this.finePrice;
    data['date_from'] = this.dateFrom;
    data['date_to'] = this.dateTo;
    data['payment_at'] = this.paymentAt;
    data['comment'] = this.comment;
    data['count_people'] = this.countPeople;
    data['time_start'] = this.timeStart;
    data['time_end'] = this.timeEnd;
    if (this.roomNumbers != null) {
      data['roomNumbers'] = this.roomNumbers!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}
