import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pana_project/utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImpressionProvider {
  String API_URL = AppConstants.baseUrl;

  Future<dynamic> getImpressionData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${API_URL}api/mobile/impression/?page=1'),
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
      int countryId,
      int adultCount,
      int childCount,
      int babyCount,
      int petCount,
      String startDate,
      String endDate,
      int cityId,
      String searchText) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    String urlParams = 'api/mobile/impression?page=1';

    if (countryId != 0) {
      urlParams += '&country_id=${countryId}';
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
      urlParams += '&date_from=${startDate}&date_to=${endDate}';
    }
    if (cityId != 0) {
      urlParams += '&city_id=$cityId';
    }
    if (searchText != '') {
      urlParams += '&search=${Uri.encodeComponent(searchText)}';
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

    final response = await http.get(
      Uri.parse('${API_URL}api/mobile/impression/session?impression_id=$id'),
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
}