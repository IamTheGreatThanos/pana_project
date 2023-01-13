import 'package:pana_project/models/city.dart';
import 'package:pana_project/models/images.dart';
import 'package:pana_project/models/inventories.dart';
import 'package:pana_project/models/provideItems.dart';
import 'package:pana_project/models/user.dart';

class ImpressionDetailModel {
  int? id;
  User? user;
  City? city;
  int? status;
  String? name;
  String? description;
  String? about;
  MainLanguage? mainLanguage;
  String? duration;
  MeetingPlaceLocationId? meetingPlaceLocationId;
  MeetingPlaceLocationId? venueLocationId;
  int? minAge;
  int? maxAge;
  int? child;
  String? guestInfo;
  String? startTime;
  int? closedGroups;
  int? openGroups;
  String? price;
  int? deadlineGuest;
  int? deadlineFirstGuest;
  int? cancellationPolicy;
  int? identityCards;
  String? phone;
  List<GroupDiscounts>? groupDiscounts;
  List<Inventories>? inventories;
  List<ProvideItems>? provideItems;
  String? reviewsAvgBall;
  int? reviewsCount;
  List<Images>? images;

  ImpressionDetailModel({
    this.id,
    this.user,
    this.city,
    this.status,
    this.name,
    this.description,
    this.about,
    this.mainLanguage,
    this.duration,
    this.meetingPlaceLocationId,
    this.venueLocationId,
    this.minAge,
    this.maxAge,
    this.child,
    this.guestInfo,
    this.startTime,
    this.closedGroups,
    this.openGroups,
    this.price,
    this.deadlineGuest,
    this.deadlineFirstGuest,
    this.cancellationPolicy,
    this.identityCards,
    this.phone,
    this.groupDiscounts,
    this.inventories,
    this.provideItems,
    this.reviewsAvgBall,
    this.reviewsCount,
    this.images,
  });

  ImpressionDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    city = json['city'] != null ? City.fromJson(json['city']) : null;
    status = json['status'];
    name = json['name'];
    description = json['description'];
    about = json['about'];
    mainLanguage = json['main_language'] != null
        ? MainLanguage.fromJson(json['main_language'])
        : null;
    duration = json['duration'];
    meetingPlaceLocationId = json['meeting_place_location_id'] != null
        ? MeetingPlaceLocationId.fromJson(json['meeting_place_location_id'])
        : null;
    venueLocationId = json['venue_location_id'] != null
        ? MeetingPlaceLocationId.fromJson(json['venue_location_id'])
        : null;
    minAge = json['min_age'];
    maxAge = json['max_age'];
    child = json['child'];
    guestInfo = json['guest_info'];
    startTime = json['start_time'];
    closedGroups = json['closed_groups'];
    openGroups = json['open_groups'];
    price = json['price'].toString();
    deadlineGuest = json['deadline_guest'];
    deadlineFirstGuest = json['deadline_first_guest'];
    cancellationPolicy = json['cancellation_policy'];
    identityCards = json['identity_cards'];
    phone = json['phone'];
    if (json['group_discounts'] != null) {
      groupDiscounts = <GroupDiscounts>[];
      json['group_discounts'].forEach((v) {
        groupDiscounts!.add(GroupDiscounts.fromJson(v));
      });
    }
    if (json['inventories'] != null) {
      inventories = <Inventories>[];
      json['inventories'].forEach((v) {
        inventories!.add(Inventories.fromJson(v));
      });
    }
    if (json['provide_items'] != null) {
      provideItems = <ProvideItems>[];
      json['provide_items'].forEach((v) {
        provideItems!.add(ProvideItems.fromJson(v));
      });
    }

    reviewsAvgBall = json['reviews_avg_ball'].toString();
    reviewsCount = json['reviews_count'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (city != null) {
      data['city'] = city!.toJson();
    }
    data['status'] = status;
    data['name'] = name;
    data['description'] = description;
    data['about'] = about;
    if (mainLanguage != null) {
      data['main_language'] = mainLanguage!.toJson();
    }
    data['duration'] = duration;
    if (meetingPlaceLocationId != null) {
      data['meeting_place_location_id'] = meetingPlaceLocationId!.toJson();
    }
    if (venueLocationId != null) {
      data['venue_location_id'] = venueLocationId!.toJson();
    }
    data['min_age'] = minAge;
    data['max_age'] = maxAge;
    data['child'] = child;
    data['guest_info'] = guestInfo;
    data['start_time'] = startTime;
    data['closed_groups'] = closedGroups;
    data['open_groups'] = openGroups;
    data['price'] = price;
    data['deadline_guest'] = deadlineGuest;
    data['deadline_first_guest'] = deadlineFirstGuest;
    data['cancellation_policy'] = cancellationPolicy;
    data['identity_cards'] = identityCards;
    data['phone'] = phone;
    if (groupDiscounts != null) {
      data['group_discounts'] = groupDiscounts!.map((v) => v.toJson()).toList();
    }
    if (inventories != null) {
      data['inventories'] = inventories!.map((v) => v.toJson()).toList();
    }
    if (provideItems != null) {
      data['provide_items'] = provideItems!.map((v) => v.toJson()).toList();
    }
    data['reviews_avg_ball'] = reviewsAvgBall;
    data['reviews_count'] = reviewsCount;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MainLanguage {
  int? id;
  String? name;

  MainLanguage({this.id, this.name});

  MainLanguage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class MeetingPlaceLocationId {
  int? id;
  int? cityId;
  String? address;
  String? home;
  String? number;
  String? building;
  String? index;
  String? description;
  String? lat;
  String? lng;
  String? createdAt;
  String? updatedAt;
  City? city;

  MeetingPlaceLocationId({
    this.id,
    this.cityId,
    this.address,
    this.home,
    this.number,
    this.building,
    this.index,
    this.description,
    this.lat,
    this.lng,
    this.createdAt,
    this.updatedAt,
    this.city,
  });

  MeetingPlaceLocationId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cityId = json['city_id'];
    address = json['address'];
    home = json['home'];
    number = json['number'];
    building = json['building'];
    index = json['index'];
    description = json['description'];
    lat = json['lat'];
    lng = json['lng'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    city = json['city'] != null ? City.fromJson(json['city']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['city_id'] = cityId;
    data['address'] = address;
    data['home'] = home;
    data['number'] = number;
    data['building'] = building;
    data['index'] = index;
    data['description'] = description;
    data['lat'] = lat;
    data['lng'] = lng;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['city'] = city;
    return data;
  }
}

class GroupDiscounts {
  int? id;
  int? impressionId;
  int? minSize;
  int? maxSize;
  int? discount;
  int? price;
  String? priceCurrency;
  int? earning;
  String? earningCurrency;
  String? createdAt;
  String? updatedAt;

  GroupDiscounts(
      {this.id,
      this.impressionId,
      this.minSize,
      this.maxSize,
      this.discount,
      this.price,
      this.priceCurrency,
      this.earning,
      this.earningCurrency,
      this.createdAt,
      this.updatedAt});

  GroupDiscounts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    impressionId = json['impression_id'];
    minSize = json['min_size'];
    maxSize = json['max_size'];
    discount = json['discount'];
    price = json['price'];
    priceCurrency = json['price_currency'];
    earning = json['earning'];
    earningCurrency = json['earning_currency'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['impression_id'] = impressionId;
    data['min_size'] = minSize;
    data['max_size'] = maxSize;
    data['discount'] = discount;
    data['price'] = price;
    data['price_currency'] = priceCurrency;
    data['earning'] = earning;
    data['earning_currency'] = earningCurrency;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
