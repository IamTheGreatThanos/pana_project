class BonusItems {
  int? id;
  int? userBonusId;
  int? bonusSystemItemId;
  int? used;
  String? price;
  int? day;
  int? countOrder;
  BonusSystemItem? bonusSystemItem;

  BonusItems(
      {this.id,
      this.userBonusId,
      this.bonusSystemItemId,
      this.used,
      this.price,
      this.day,
      this.countOrder,
      this.bonusSystemItem});

  BonusItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userBonusId = json['user_bonus_id'];
    bonusSystemItemId = json['bonus_system_item_id'];
    used = json['used'];
    price = json['price'];
    day = json['day'];
    countOrder = json['count_order'];
    bonusSystemItem = json['bonus_system_item'] != null
        ? new BonusSystemItem.fromJson(json['bonus_system_item'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_bonus_id'] = this.userBonusId;
    data['bonus_system_item_id'] = this.bonusSystemItemId;
    data['used'] = this.used;
    data['price'] = this.price;
    data['day'] = this.day;
    data['count_order'] = this.countOrder;
    if (this.bonusSystemItem != null) {
      data['bonus_system_item'] = this.bonusSystemItem!.toJson();
    }
    return data;
  }
}

class BonusSystemItem {
  int? id;
  int? bonusSystemId;
  String? image;
  String? description;
  int? level;
  String? price;
  int? day;
  int? countOrder;

  BonusSystemItem(
      {this.id,
      this.bonusSystemId,
      this.image,
      this.description,
      this.level,
      this.price,
      this.day,
      this.countOrder});

  BonusSystemItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bonusSystemId = json['bonus_system_id'];
    image = json['image'];
    description = json['description'];
    level = json['level'];
    price = json['price'];
    day = json['day'];
    countOrder = json['count_order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['bonus_system_id'] = this.bonusSystemId;
    data['image'] = this.image;
    data['description'] = this.description;
    data['level'] = this.level;
    data['price'] = this.price;
    data['day'] = this.day;
    data['count_order'] = this.countOrder;
    return data;
  }
}
