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
  double? totalPrice;
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
    totalPrice = double.parse(json['total_price'].toString());
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
