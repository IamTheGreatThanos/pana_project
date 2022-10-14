class HousingDetailModel {
  int? id;
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
  String? postalCode;
  String? cancelFineDay;
  String? requiredPay;
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
  List<Images>? images;

  HousingDetailModel({
    this.id,
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
    this.postalCode,
    this.cancelFineDay,
    this.requiredPay,
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
    this.images,
  });

  HousingDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    city = json['city'] != null ? new City.fromJson(json['city']) : null;
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
    postalCode = json['postal_code'];
    cancelFineDay = json['cancel_fine_day'];
    requiredPay = json['required_pay'];
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
        ? new City.fromJson(json['recipient_invoice_city'])
        : null;
    recipientInvoiceAddress = json['recipient_invoice_address'];
    recipientInvoicePostalCode = json['recipient_invoice_postal_code'];
    createdAt = json['created_at'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.city != null) {
      data['city'] = this.city!.toJson();
    }
    data['status'] = this.status;
    data['name'] = this.name;
    data['description'] = this.description;
    data['max_floor'] = this.maxFloor;
    data['star'] = this.star;
    data['contact_person'] = this.contactPerson;
    data['phone'] = this.phone;
    data['alt_phone'] = this.altPhone;
    data['represent_management'] = this.representManagement;
    data['company_name'] = this.companyName;
    data['address'] = this.address;
    data['alt_address'] = this.altAddress;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['postal_code'] = this.postalCode;
    data['cancel_fine_day'] = this.cancelFineDay;
    data['required_pay'] = this.requiredPay;
    data['parking'] = this.parking;
    data['parking_property'] = this.parkingProperty;
    data['parking_location'] = this.parkingLocation;
    data['parking_booking'] = this.parkingBooking;
    data['parking_price'] = this.parkingPrice;
    data['breakfast'] = this.breakfast;
    data['children_allowed'] = this.childrenAllowed;
    data['pet'] = this.pet;
    data['pet_charge'] = this.petCharge;
    data['pet_price'] = this.petPrice;
    data['check_in_from'] = this.checkInFrom;
    data['check_in_before'] = this.checkInBefore;
    data['check_out_from'] = this.checkOutFrom;
    data['check_out_before'] = this.checkOutBefore;
    data['pos_terminal'] = this.posTerminal;
    data['invoice_name'] = this.invoiceName;
    data['invoice_company_name'] = this.invoiceCompanyName;
    data['recipient_invoice'] = this.recipientInvoice;
    if (this.recipientInvoiceCity != null) {
      data['recipient_invoice_city'] = this.recipientInvoiceCity!.toJson();
    }
    data['recipient_invoice_address'] = this.recipientInvoiceAddress;
    data['recipient_invoice_postal_code'] = this.recipientInvoicePostalCode;
    data['created_at'] = this.createdAt;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Category {
  int? id;
  String? name;
  String? description;
  String? icon;
  String? image;

  Category({this.id, this.name, this.description, this.icon, this.image});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    icon = json['icon'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['icon'] = this.icon;
    data['image'] = this.image;
    return data;
  }
}

class City {
  int? id;
  int? countryId;
  String? name;

  City({this.id, this.countryId, this.name});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryId = json['country_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['country_id'] = this.countryId;
    data['name'] = this.name;
    return data;
  }
}

class Images {
  int? id;
  int? housingId;
  String? path;
  Null? position;

  Images({this.id, this.housingId, this.path, this.position});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    housingId = json['housing_id'];
    path = json['path'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['housing_id'] = this.housingId;
    data['path'] = this.path;
    data['position'] = this.position;
    return data;
  }
}
