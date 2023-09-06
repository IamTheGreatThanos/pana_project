class ImpressionSessionInOrderModel {
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

  ImpressionSessionInOrderModel({
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

  ImpressionSessionInOrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['impression_session']['status'];
    openPrice = json['impression_session']['open_price'];
    openPriceCurrency = json['impression_session']['open_price_currency'];
    openEarning = json['impression_session']['open_earning'];
    closedPrice = json['impression_session']['closed_price'];
    closedPriceCurrency = json['impression_session']['closed_price_currency'];
    closedEarning = json['impression_session']['closed_earning'];
    inDay = json['impression_session']['in_day'];
    startDay = json['impression_session']['start_day'];
    startTime = json['impression_session']['start_time'];
    endDay = json['impression_session']['end_day'];
    endTime = json['impression_session']['end_time'];
    duplicateWeek = json['impression_session']['duplicate_week'];
    runDate = json['impression_session']['run_date'];
    runOutDate = json['impression_session']['run_out_date'];
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
}
