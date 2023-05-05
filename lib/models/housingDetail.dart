import 'package:pana_project/models/breakfasts.dart';
import 'package:pana_project/models/category.dart';
import 'package:pana_project/models/city.dart';
import 'package:pana_project/models/comforts.dart';
import 'package:pana_project/models/images.dart';
import 'package:pana_project/models/languages.dart';
import 'package:pana_project/models/user.dart';
import 'package:pana_project/models/videos.dart';

class HousingDetailModel {
  int? id;
  User? user;
  Category? category;
  City? city;
  int? status;
  String? name;
  String? description;
  int? maxFloor;
  int? star;
  String? contactPerson;
  String? phone;
  String? altPhone;
  int? representManagement;
  String? companyName;
  String? address;
  String? altAddress;
  String? lat;
  String? lng;
  int? distance;
  String? postalCode;
  String? cancelFineDay;
  String? requiredPay;
  int? guestPayCheckIn;
  String? parking;
  String? parkingProperty;
  String? parkingLocation;
  String? parkingBooking;
  int? parkingPrice;
  String? breakfast;
  int? childrenAllowed;
  String? pet;
  int? petCharge;
  int? petPrice;
  String? checkInFrom;
  String? checkInBefore;
  String? checkOutFrom;
  String? checkOutBefore;
  int? posTerminal;
  String? invoiceName;
  String? invoiceCompanyName;
  int? recipientInvoice;
  City? recipientInvoiceCity;
  String? recipientInvoiceAddress;
  String? recipientInvoicePostalCode;
  String? createdAt;
  int? roomCount;
  int? basePriceMin;
  int? reviewsCount;
  String? reviewsBallAvg;
  String? reviewsPriceAvg;
  String? reviewsPurityAvg;
  String? reviewsStaffAvg;
  List<Images>? images;
  List<Videos>? videos;
  List<Comforts>? comforts;
  List<Languages>? languages;
  List<Breakfasts>? breakfasts;
  String? freeDates;

  HousingDetailModel({
    this.id,
    this.user,
    this.category,
    this.city,
    this.status,
    this.name,
    this.description,
    this.maxFloor,
    this.star,
    this.contactPerson,
    this.phone,
    this.altPhone,
    this.representManagement,
    this.companyName,
    this.address,
    this.altAddress,
    this.lat,
    this.lng,
    this.distance,
    this.postalCode,
    this.cancelFineDay,
    this.requiredPay,
    this.guestPayCheckIn,
    this.parking,
    this.parkingProperty,
    this.parkingLocation,
    this.parkingBooking,
    this.parkingPrice,
    this.breakfast,
    this.childrenAllowed,
    this.pet,
    this.petCharge,
    this.petPrice,
    this.checkInFrom,
    this.checkInBefore,
    this.checkOutFrom,
    this.checkOutBefore,
    this.posTerminal,
    this.invoiceName,
    this.invoiceCompanyName,
    this.recipientInvoice,
    this.recipientInvoiceCity,
    this.recipientInvoiceAddress,
    this.recipientInvoicePostalCode,
    this.createdAt,
    this.roomCount,
    this.basePriceMin,
    this.reviewsCount,
    this.reviewsBallAvg,
    this.reviewsPriceAvg,
    this.reviewsPurityAvg,
    this.reviewsStaffAvg,
    this.images,
    this.videos,
    this.comforts,
    this.languages,
    this.breakfasts,
    this.freeDates,
  });

  HousingDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
    city = json['city'] != null ? City.fromJson(json['city']) : null;
    status = json['status'];
    name = json['name'];
    description = json['description'];
    maxFloor = json['max_floor'];
    star = json['star'];
    contactPerson = json['contact_person'];
    phone = json['phone'];
    altPhone = json['alt_phone'];
    representManagement = json['represent_management'];
    companyName = json['company_name'];
    address = json['address'];
    altAddress = json['alt_address'];
    lat = json['lat'];
    lng = json['lng'];
    distance = json['distance'];
    postalCode = json['postal_code'];
    cancelFineDay = json['cancel_fine_day'];
    requiredPay = json['required_pay'];
    guestPayCheckIn = json['guest_pay_check_in'];
    parking = json['parking'];
    parkingProperty = json['parking_property'];
    parkingLocation = json['parking_location'];
    parkingBooking = json['parking_booking'];
    parkingPrice = json['parking_price'];
    breakfast = json['breakfast'];
    childrenAllowed = json['children_allowed'];
    pet = json['pet'];
    petCharge = json['pet_charge'];
    petPrice = json['pet_price'];
    checkInFrom = json['check_in_from'];
    checkInBefore = json['check_in_before'];
    checkOutFrom = json['check_out_from'];
    checkOutBefore = json['check_out_before'];
    posTerminal = json['pos_terminal'];
    invoiceName = json['invoice_name'];
    invoiceCompanyName = json['invoice_company_name'];
    recipientInvoice = json['recipient_invoice'];
    recipientInvoiceCity = json['recipient_invoice_city'] != null
        ? City.fromJson(json['recipient_invoice_city'])
        : null;
    recipientInvoiceAddress = json['recipient_invoice_address'];
    recipientInvoicePostalCode = json['recipient_invoice_postal_code'];
    createdAt = json['created_at'];
    roomCount = json['room_count'];
    basePriceMin = int.parse((json['base_price_min'] ?? 0).toString());
    reviewsCount = json['reviews_count'];
    reviewsBallAvg = json['reviews_ball_avg'].toString();
    reviewsPriceAvg = json['reviews_price_avg'].toString();
    reviewsPurityAvg = json['reviews_purity_avg'].toString();
    reviewsStaffAvg = json['reviews_staff_avg'].toString();
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
    if (json['videos'] != null) {
      videos = <Videos>[];
      json['videos'].forEach((v) {
        videos!.add(Videos.fromJson(v));
      });
    }
    if (json['comforts'] != null) {
      comforts = <Comforts>[];
      json['comforts'].forEach((v) {
        comforts!.add(Comforts.fromJson(v));
      });
    }
    if (json['languages'] != null) {
      languages = <Languages>[];
      json['languages'].forEach((v) {
        languages!.add(Languages.fromJson(v));
      });
    }
    if (json['breakfasts'] != null) {
      breakfasts = <Breakfasts>[];
      json['breakfasts'].forEach((v) {
        breakfasts!.add(Breakfasts.fromJson(v));
      });
    }
    freeDates = json['free_dates'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (city != null) {
      data['city'] = city!.toJson();
    }
    data['status'] = status;
    data['name'] = name;
    data['description'] = description;
    data['max_floor'] = maxFloor;
    data['star'] = star;
    data['contact_person'] = contactPerson;
    data['phone'] = phone;
    data['alt_phone'] = altPhone;
    data['represent_management'] = representManagement;
    data['company_name'] = companyName;
    data['address'] = address;
    data['alt_address'] = altAddress;
    data['lat'] = lat;
    data['lng'] = lng;
    data['distance'] = distance;
    data['postal_code'] = postalCode;
    data['cancel_fine_day'] = cancelFineDay;
    data['required_pay'] = requiredPay;
    data['guest_pay_check_in'] = guestPayCheckIn;
    data['parking'] = parking;
    data['parking_property'] = parkingProperty;
    data['parking_location'] = parkingLocation;
    data['parking_booking'] = parkingBooking;
    data['parking_price'] = parkingPrice;
    data['breakfast'] = breakfast;
    data['children_allowed'] = childrenAllowed;
    data['pet'] = pet;
    data['pet_charge'] = petCharge;
    data['pet_price'] = petPrice;
    data['check_in_from'] = checkInFrom;
    data['check_in_before'] = checkInBefore;
    data['check_out_from'] = checkOutFrom;
    data['check_out_before'] = checkOutBefore;
    data['pos_terminal'] = posTerminal;
    data['invoice_name'] = invoiceName;
    data['invoice_company_name'] = invoiceCompanyName;
    data['recipient_invoice'] = recipientInvoice;
    if (recipientInvoiceCity != null) {
      data['recipient_invoice_city'] = recipientInvoiceCity!.toJson();
    }
    data['recipient_invoice_address'] = recipientInvoiceAddress;
    data['recipient_invoice_postal_code'] = recipientInvoicePostalCode;
    data['created_at'] = createdAt;
    data['room_count'] = roomCount;
    data['base_price_min'] = basePriceMin;
    data['reviews_count'] = reviewsCount;
    data['reviews_ball_avg'] = reviewsBallAvg;
    data['reviews_price_avg'] = reviewsPriceAvg;
    data['reviews_purity_avg'] = reviewsPurityAvg;
    data['reviews_staff_avg'] = reviewsStaffAvg;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    if (videos != null) {
      data['videos'] = videos!.map((v) => v.toJson()).toList();
    }
    if (comforts != null) {
      data['comforts'] = comforts!.map((v) => v.toJson()).toList();
    }
    if (languages != null) {
      data['languages'] = languages!.map((v) => v.toJson()).toList();
    }
    if (breakfasts != null) {
      data['breakfasts'] = breakfasts!.map((v) => v.toJson()).toList();
    }
    data['free_dates'] = freeDates;
    return data;
  }
}
