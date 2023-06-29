class CreditCard {
  int? id;
  int? userId;
  int? isDefault;
  int? status;
  String? number;
  String? month;
  String? year;
  String? cvv;
  String? name;
  String? cryptogram;
  String? token;
  String? createdAt;
  String? updatedAt;
  String? type;

  CreditCard({
    this.id,
    this.userId,
    this.isDefault,
    this.status,
    this.number,
    this.month,
    this.year,
    this.cvv,
    this.name,
    this.cryptogram,
    this.token,
    this.createdAt,
    this.updatedAt,
    this.type,
  });

  CreditCard.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    isDefault = json['default'];
    status = json['status'];
    number = json['number'];
    month = json['month'];
    year = json['year'];
    cvv = json['cvv'];
    name = json['name'];
    cryptogram = json['cryptogram'];
    token = json['token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['user_id'] = userId;
    data['default'] = isDefault;
    data['status'] = status;
    data['number'] = number;
    data['month'] = month;
    data['year'] = year;
    data['cvv'] = cvv;
    data['name'] = name;
    data['cryptogram'] = cryptogram;
    data['token'] = token;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['type'] = type;
    return data;
  }
}
