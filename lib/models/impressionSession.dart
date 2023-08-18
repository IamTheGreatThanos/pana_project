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
  int? maxCountClosed;
  int? maxCountOpen;
  int? currentPeopleCount;
  int? closedGroupMin;
  int? closedGroupMax;

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
    this.maxCountClosed,
    this.maxCountOpen,
    this.currentPeopleCount,
    this.closedGroupMin,
    this.closedGroupMax,
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
    maxCountClosed = json['closed_groups'];
    maxCountOpen = json['open_groups'];
    currentPeopleCount = int.tryParse(json['count_people'].toString()) ?? 1;
    closedGroupMin = int.tryParse(json['closed_groups_min'].toString()) ?? 1;
    closedGroupMax = int.tryParse(json['closed_groups_max'].toString()) ?? 1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['status'] = status;
    data['open_price'] = openPrice;
    data['open_price_currency'] = openPriceCurrency;
    data['open_earning'] = openEarning;
    data['closed_price'] = closedPrice;
    data['closed_price_currency'] = closedPriceCurrency;
    data['closed_earning'] = closedEarning;
    data['in_day'] = inDay;
    data['start_day'] = startDay;
    data['start_time'] = startTime;
    data['end_day'] = endDay;
    data['end_time'] = endTime;
    data['duplicate_week'] = duplicateWeek;
    data['run_date'] = runDate;
    data['run_out_date'] = runOutDate;
    data['start_date_text'] = startDateText;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['type'] = type;
    data['closed_groups'] = maxCountClosed;
    data['open_groups'] = maxCountOpen;
    data['count_people'] = currentPeopleCount;
    return data;
  }
}
