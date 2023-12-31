import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pana_project/utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImpressionProvider {
  String API_URL = AppConstants.baseUrl;

  Future<dynamic> getImpressionData(int categoryId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    String urlString = '${API_URL}api/mobile/impression/?page=1';

    if (categoryId != 0) {
      urlString += '&category_id=$categoryId';
    }

    final response = await http.get(
      Uri.parse(urlString),
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

  Future<dynamic> getImpressionDetail(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${API_URL}api/mobile/impression/show/$id'),
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

  Future<dynamic> getImpressionFromSearch(
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
    double priceFrom,
    double priceTo,
    List<int> reviewBalls,
    List<int> comforts,
    List<int> languages,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    String urlParams = 'api/mobile/impression?page=1';

    if (categoryId != 0) {
      urlParams += '&topic_id=$categoryId';
    }

    if (countryId != 0) {
      urlParams += '&country_id=$countryId';
    }
    // if (adultCount != 0) {
    //   urlParams += '&max_adult_count=${adultCount}';
    // }
    // if (childCount != 0) {
    //   urlParams += '&max_child_count=${childCount}';
    // }
    // if (babyCount != 0) {
    //   urlParams += '&max_baby_count=${babyCount}';
    // }
    // if (petCount != 0) {
    //   urlParams += '&max_ped_count=$petCount';
    // }
    if (startDate != '') {
      urlParams += '&date_from=$startDate&date_to=$endDate';
    }
    if (cityId != 0) {
      urlParams += '&city_id=$cityId';
    }
    if (searchText != '') {
      urlParams += '&search=${Uri.encodeComponent(searchText)}';
    }

    urlParams += '&price_from=$priceFrom&price_to=$priceTo';

    if (reviewBalls.toString() != '[]') {
      String tempString = '';
      for (var i in reviewBalls) {
        tempString += '$i,';
      }
      urlParams +=
          '&review_balls=${tempString.substring(0, tempString.length - 1)}';
    }
    if (comforts.toString() != '[]') {
      String tempString = '';
      for (var i in comforts) {
        tempString += '$i,';
      }
      urlParams +=
          '&comforts=${tempString.substring(0, tempString.length - 1)}';
    }
    if (languages.toString() != '[]') {
      String tempString = '';
      for (var i in languages) {
        tempString += '$i,';
      }
      urlParams +=
          '&languages=${tempString.substring(0, tempString.length - 1)}';
    }

    print(urlParams);

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

  Future<dynamic> getSessionsInImpression(
      int id, String startDate, String endDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    String url = '${API_URL}api/mobile/impression/session?impression_id=$id';

    if (startDate != '' && endDate != '') {
      url += '&start_date=$startDate&end_date=$endDate';
    }

    final response = await http.get(
      Uri.parse(url),
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

  Future<dynamic> getNearbyImpression(int housingId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${API_URL}api/mobile/impression/nearby/$housingId'),
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

  Future<dynamic> getSimilarImpressions(int impressionId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${API_URL}api/mobile/impression/similar/$impressionId'),
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

  Future<dynamic> getFavoritesImpression() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${API_URL}api/mobile/favorite?page=1&type=impression'),
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

  Future<dynamic> getTextReviewsInImpression(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(
          '${API_URL}api/mobile/review?page=1&type=text_review&impression_id=$id'),
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

  Future<dynamic> getAudioReviewsInImpression(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(
          '${API_URL}api/mobile/review?page=1&type=audio_review&impression_id=$id'),
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
      Uri.parse('${API_URL}api/mobile/reel?impression_id=$id'),
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

  Future<dynamic> impressionPayment(
    int impressionId,
    String dateFrom,
    String dateTo,
    int peopleCount,
    int sessionId,
    int sessionType,
    int paymentCardId,
    String timeFrom,
    String timeTo,
    String comment,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    Map<String, dynamic> bodyObject = {
      "impression_id": impressionId,
      "count_people": peopleCount,
      "adults": 0,
      "children": 0,
      "babies": 0,
      "pets": 0,
      "sessions": [
        {
          'impression_session_id': sessionId,
          'type': sessionType,
        }
      ],
    };

    if (paymentCardId == -2) {
      bodyObject['payment_type'] = 1;
    } else {
      bodyObject['payment_type'] = 1;
      bodyObject["payment_card_id"] = paymentCardId;
    }

    if (dateFrom != '') {
      bodyObject["date_from"] = dateFrom;
      bodyObject["date_to"] = dateTo;
    }

    if (timeFrom != '') {
      bodyObject["time_start"] = timeFrom;
      bodyObject["time_end"] = timeTo;
    }

    if (comment != '') {
      bodyObject["comment"] = comment;
    }

    final response = await http.post(
      Uri.parse('${API_URL}api/mobile/order/impression'),
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

  Future<dynamic> impressionPaymentSend3ds(String md, String paRes) async {
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

  Future<dynamic> getBonusSystem(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${API_URL}api/mobile/bonus-system?impression_id=$id'),
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
}
