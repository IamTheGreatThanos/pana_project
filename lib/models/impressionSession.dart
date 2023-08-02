class ImpressionSessionModel {
  int? id;
  String? status;
  int? openPrice;
  String? openPriceCurrency;
  int? openEarning;
  int? closedPrice;
  String? closedPriceCurrency;
  int? closedEarning;
  int? inDay;
  int? startDay;
  String? startTime;
  int? endDay;
  String? endTime;
  int? duplicateWeek;
  String? runDate;
  String? runOutDate;
  String? startDateText;
  String? startDate;
  String? endDate;
  int? type;

  ImpressionSessionModel({
    this.id,
    this.status,
    this.openPrice,
    this.openPriceCurrency,
    this.openEarning,
    this.closedPrice,
    this.closedPriceCurrency,
    this.closedEarning,
    this.inDay,
    this.startDay,
    this.startTime,
    this.endDay,
    this.endTime,
    this.duplicateWeek,
    this.runDate,
    this.runOutDate,
    this.startDateText,
    this.startDate,
    this.endDate,
    this.type,
  });

  ImpressionSessionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    openPrice = json['open_price'];
    openPriceCurrency = json['open_price_currency'];
    openEarning = json['open_earning'];
    closedPrice = json['closed_price'];
    closedPriceCurrency = json['closed_price_currency'];
    closedEarning = json['closed_earning'];
    inDay = json['in_day'];
    startDay = json['start_day'];
    startTime = json['start_time'];
    endDay = json['end_day'];
    endTime = json['end_time'];
    duplicateWeek = json['duplicate_week'];
    runDate = json['run_date'];
    runOutDate = json['run_out_date'];
    startDateText = json['start_date_text'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['open_price'] = this.openPrice;
    data['open_price_currency'] = this.openPriceCurrency;
    data['open_earning'] = this.openEarning;
    data['closed_price'] = this.closedPrice;
    data['closed_price_currency'] = this.closedPriceCurrency;
    data['closed_earning'] = this.closedEarning;
    data['in_day'] = this.inDay;
    data['start_day'] = this.startDay;
    data['start_time'] = this.startTime;
    data['end_day'] = this.endDay;
    data['end_time'] = this.endTime;
    data['duplicate_week'] = this.duplicateWeek;
    data['run_date'] = this.runDate;
    data['run_out_date'] = this.runOutDate;
    data['start_date_text'] = this.startDateText;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['type'] = this.type;
    return data;
  }
}
