import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pana_project/utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HousingProvider {
  String API_URL = AppConstants.baseUrl;

  Future<dynamic> getHousingData(int id, String lat, String lng) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    String uri = '${API_URL}api/mobile/housing?page=1';
    if (lat != '' && lng != '') {
      uri += '&lat=$lat&lng=$lng';
    }

    if (id != 0) {
      uri += '&category_id=$id';
    }

    final response = await http.get(
      Uri.parse(uri),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': "Bearer $token"
      },
    );

    // print(jsonDecode(response.body));

    if (response.statusCode == 200) {
      Map<String, dynamic> result = {};
      result['data'] = jsonDecode(response.body);
      result['response_status'] = 'ok';
      return result;
    } else {
      Map<String, dynamic> result = {};
      result['data'] = jsonDecode(response.body);
      result['response_status'] = 'error';
      return result;
    }
  }

  Future<dynamic> getHousingFromSearch(
    int categoryId,
    int countryId,
    int adultCount,
    int childCount,
    int babyCount,
    int petCount,
    String startDate,
    String endDate,
    int cityId,
    String searchText,
    String lat,
    String lng,
    double priceFrom,
    double priceTo,
    List<int> reviewBalls,
    List<int> stars,
    List<int> comforts,
    List<int> breakfasts,
    List<int> languages,
    List<int> beds,
    int pets,
    int children,
    List<int> locations,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    String urlParams = 'api/mobile/housing?page=1';

    if (categoryId != 0) {
      urlParams += '&category_id=$categoryId';
    }
    if (countryId != 0) {
      urlParams += '&country_id=$countryId';
    }
    if (adultCount != 0) {
      urlParams += '&max_adult_count=$adultCount';
    }
    if (childCount != 0) {
      urlParams += '&max_child_count=$childCount';
    }
    if (babyCount != 0) {
      urlParams += '&max_baby_count=$babyCount';
    }
    if (petCount != 0) {
      urlParams += '&max_ped_count=$petCount';
    }
    if (startDate != '') {
      urlParams += '&date_from=$startDate&date_to=$endDate';
    }
    if (cityId != 0) {
      urlParams += '&city_id=$cityId';
    }
    if (searchText != '') {
      urlParams += '&search=${Uri.encodeComponent(searchText)}';
    }
    if (lat != '' && lng != '') {
      urlParams += '&lat=$lat&lng=$lng';
    }
    urlParams += '&price_from=$priceFrom&price_to=$priceTo';

    if (stars.toString() != '[]') {
      String tempString = '';
      for (var i in stars) {
        tempString += '$i,';
      }
      urlParams += '&stars=$tempString';
    }
    if (reviewBalls.toString() != '[]') {
      String tempString = '';
      for (var i in reviewBalls) {
        tempString += '$i,';
      }
      urlParams += '&review_balls=$tempString';
    }
    if (comforts.toString() != '[]') {
      String tempString = '';
      for (var i in comforts) {
        tempString += '$i,';
      }
      urlParams += '&comforts=$tempString';
    }
    if (breakfasts.toString() != '[]') {
      String tempString = '';
      for (var i in breakfasts) {
        tempString += '$i,';
      }
      urlParams += '&breakfasts=$tempString';
    }
    if (languages.toString() != '[]') {
      String tempString = '';
      for (var i in languages) {
        tempString += '$i,';
      }
      urlParams += '&languages=$tempString';
    }
    if (beds.toString() != '[]') {
      String tempString = '';
      for (var i in beds) {
        tempString += '$i,';
      }
      urlParams += '&beds=$tempString';
    }
    if (pets != 0) {
      urlParams += '&pet=${pets == 2 ? 1 : 0}';
    }
    if (children != 0) {
      urlParams += '&children_allowed=${children == 2 ? 'yes' : 'no'}';
    }
    if (locations.toString() != '[]') {
      String tempString = '';
      for (var i in locations) {
        tempString += '$i,';
      }
      urlParams += '&positions=$tempString';
    }

    print(urlParams);

    final queryParameters = {
      'page': 1,
      'lat': lat,
      'lng': lng,
      'price_from': priceFrom,
      'price_to': priceTo,
      'stars': stars,
      'review_balls': reviewBalls,
      'comforts': comforts,
      'breakfasts': breakfasts,
      'languages': languages,
      'beds': beds,
    };

    final response = await http.get(
      Uri.parse(API_URL + urlParams),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> result = {};
      result['data'] = jsonDecode(response.body);
      result['response_status'] = 'ok';
      return result;
    } else {
      Map<String, dynamic> result = {};
      result['data'] = jsonDecode(response.body);
      result['response_status'] = 'error';
      return result;
    }
  }

  Future<dynamic> getHousingDetail(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${API_URL}api/mobile/housing/show/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> result = {};
      result['data'] = jsonDecode(response.body);
      result['response_status'] = 'ok';
      return result;
    } else {
      Map<String, dynamic> result = {};
      result['data'] = jsonDecode(response.body);
      result['response_status'] = 'error';
      return result;
    }
  }

  Future<dynamic> getFavoritesHousing(String lat, String lng) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    String uri = '${API_URL}api/mobile/favorite?page=1&type=housing';

    if (lat != '' && lng != '') {
      uri += '&lat=$lat&lng=$lng';
    }

    final response = await http.get(
      Uri.parse(uri),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> result = {};
      result['data'] = jsonDecode(response.body);
      result['response_status'] = 'ok';
      return result;
    } else {
      Map<String, dynamic> result = {};
      result['data'] = jsonDecode(response.body);
      result['response_status'] = 'error';
      return result;
    }
  }

  Future<dynamic> getRoomsList(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${API_URL}api/mobile/room?housing_id=$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': "Bearer $token"
      },
    );

    // print(jsonDecode(response.body));

    if (response.statusCode == 200) {
      Map<String, dynamic> result = {};
      result['data'] = jsonDecode(response.body);
      result['response_status'] = 'ok';
      return result;
    } else {
      Map<String, dynamic> result = {};
      result['data'] = jsonDecode(response.body);
      result['response_status'] = 'error';
      return result;
    }
  }

  Future<dynamic> getRoomsListByDate(
      int id, String startDate, String endDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(
          '${API_URL}api/mobile/room?housing_id=$id&date_from=$startDate&date_to=$endDate'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': "Bearer $token"
      },
    );

    print(jsonDecode(response.body));

    if (response.statusCode == 200) {
      Map<String, dynamic> result = {};
      result['data'] = jsonDecode(response.body);
      result['response_status'] = 'ok';
      return result;
    } else {
      Map<String, dynamic> result = {};
      result['data'] = jsonDecode(response.body);
      result['response_status'] = 'error';
      return result;
    }
  }

  Future<dynamic> housingPayment(
    int housingId,
    String dateFrom,
    String dateTo,
    int peopleCount,
    List<Map<String, dynamic>> selectedRooms,
    int paymentCardId,
    String comment,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    Map<String, dynamic> bodyObject = {
      "housing_id": housingId,
      "count_people": peopleCount,
      "rooms": selectedRooms,
    };

    if (paymentCardId == -1) {
      bodyObject['payment_type'] = 3;
    } else if (paymentCardId == -2) {
      bodyObject['payment_type'] = 1;
    } else {
      bodyObject['payment_type'] = 1;
      bodyObject["payment_card_id"] = paymentCardId;
    }

    if (dateFrom != '') {
      bodyObject["date_from"] = dateFrom;
      bodyObject["date_to"] = dateTo;
    }

    if (comment != '') {
      bodyObject["comment"] = comment;
    }

    final response = await http.post(
      Uri.parse('${API_URL}api/mobile/order/housing'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': "Bearer $token"
      },
      body: jsonEncode(bodyObject),
    );

    // print(jsonDecode(response.body));

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> result = {};
      result['data'] = jsonDecode(response.body);
      result['response_status'] = 'ok';
      return result;
    } else {
      Map<String, dynamic> result = {};
      result['data'] = jsonDecode(response.body);
      result['response_status'] = 'error';
      return result;
    }
  }

  Future<dynamic> housingPaymentSend3ds(String md, String paRes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    Map<String, dynamic> bodyObject = {
      "MD": md,
      "PaRes": paRes,
    };

    final response = await http.post(
      Uri.parse('${API_URL}api/mobile/payment/post3ds'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': "Bearer $token"
      },
      body: jsonEncode(bodyObject),
    );

    print(jsonDecode(response.body));

    if (response.statusCode == 200) {
      Map<String, dynamic> result = {};
      result['data'] = jsonDecode(response.body);
      result['response_status'] = 'ok';
      return result;
    } else {
      Map<String, dynamic> result = {};
      result['data'] = jsonDecode(response.body);
      result['response_status'] = 'error';
      return result;
    }
  }

  Future<dynamic> initPaymentData(int orderId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    Map<String, dynamic> bodyObject = {
      "order_id": orderId,
    };

    final response = await http.post(
      Uri.parse('${API_URL}api/mobile/payment/init'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': "Bearer $token"
      },
      body: jsonEncode(bodyObject),
    );

    print(jsonDecode(response.body));

    if (response.statusCode == 200) {
      Map<String, dynamic> result = {};
      result['data'] = jsonDecode(response.body);
      result['response_status'] = 'ok';
      return result;
    } else {
      Map<String, dynamic> result = {};
      result['data'] = jsonDecode(response.body);
      result['response_status'] = 'error';
      return result;
    }
  }

  Future<dynamic> getTextReviewsInHousing(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(
          '${API_URL}api/mobile/review?page=1&type=text_review&housing_id=$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> result = {};
      result['data'] = jsonDecode(response.body);
      result['response_status'] = 'ok';
      return result;
    } else {
      Map<String, dynamic> result = {};
      result['data'] = jsonDecode(response.body);
      result['response_status'] = 'error';
      return result;
    }
  }

  Future<dynamic> cancelOrder(int orderId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    Map<String, dynamic> bodyObject = {"order_id": orderId};

    final response = await http.post(
      Uri.parse('${API_URL}api/mobile/order/refund'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': "Bearer $token"
      },
      body: jsonEncode(bodyObject),
    );

    print(jsonDecode(response.body));

    if (response.statusCode == 200) {
      Map<String, dynamic> result = {};
      result['data'] = jsonDecode(response.body);
      result['response_status'] = 'ok';
      return result;
    } else {
      Map<String, dynamic> result = {};
      result['data'] = jsonDecode(response.body);
      result['response_status'] = 'error';
      return result;
    }
  }

  Future<dynamic> getAudioReviewsInHousing(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(
          '${API_URL}api/mobile/review?page=1&type=audio_review&housing_id=$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> result = {};
      result['data'] = jsonDecode(response.body);
      result['response_status'] = 'ok';
      return result;
    } else {
      Map<String, dynamic> result = {};
      result['data'] = jsonDecode(response.body);
      result['response_status'] = 'error';
      return result;
    }
  }

  Future<dynamic> getReelsById(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${API_URL}api/mobile/reel?housing_id=$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> result = {};
      result['data'] = jsonDecode(response.body);
      result['response_status'] = 'ok';
      return result;
    } else {
      Map<String, dynamic> result = {};
      result['data'] = jsonDecode(response.body);
      result['response_status'] = 'error';
      return result;
    }
  }

  Future<dynamic> getBonusSystem(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${API_URL}api/mobile/bonus-system?housing_id=$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': "Bearer $token"
      },
    );

    print(jsonDecode(response.body));

    if (response.statusCode == 200) {
      Map<String, dynamic> result = {};
      result['data'] = jsonDecode(response.body);
      result['response_status'] = 'ok';
      return result;
    } else {
      Map<String, dynamic> result = {};
      result['data'] = jsonDecode(response.body);
      result['response_status'] = 'error';
      return result;
    }
  }
}
