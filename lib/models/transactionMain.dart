class TransactionMain {
  double? totalPriceSum;
  double? housingTotalPriceSum;
  double? impressionTotalPriceSum;
  List<Month>? month;

  TransactionMain({
    this.totalPriceSum,
    this.housingTotalPriceSum,
    this.impressionTotalPriceSum,
    this.month,
  });

  TransactionMain.fromJson(Map<String, dynamic> json) {
    totalPriceSum = double.parse(json['total_price_sum'].toString());
    housingTotalPriceSum =
        double.parse(json['housing_total_price_sum'].toString());
    impressionTotalPriceSum =
        double.parse(json['impression_total_price_sum'].toString());
    if (json['month'] != null) {
      month = <Month>[];
      json['month'].forEach((v) {
        month!.add(Month.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_price_sum'] = totalPriceSum;
    data['housing_total_price_sum'] = housingTotalPriceSum;
    data['impression_total_price_sum'] = impressionTotalPriceSum;
    if (month != null) {
      data['month'] = month!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Month {
  String? name;
  int? year;
  double? housingPrice;
  double? impressionPrice;

  Month({this.name, this.year, this.housingPrice, this.impressionPrice});

  Month.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    year = json['year'];
    housingPrice = double.parse(json['housing_price'].toString());
    impressionPrice = double.parse(json['impression_price'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['year'] = year;
    data['housing_price'] = housingPrice;
    data['impression_price'] = impressionPrice;
    return data;
  }
}
