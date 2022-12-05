import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:pana_project/utils/const.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainProvider {
  String API_URL = AppConstants.baseUrl;

  Future<dynamic> getHousingData(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${API_URL}api/mobile/housing?page=1&category_id=$id'),
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
      int countryId,
      int adultCount,
      int childCount,
      int babyCount,
      int petCount,
      String startDate,
      String endDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    String urlParams = 'api/mobile/housing?page=1';

    if (countryId != 0) {
      urlParams += '&country_id=${countryId}';
    }
    if (adultCount != 0) {
      urlParams += '&max_adult_count=${adultCount}';
    }
    if (childCount != 0) {
      urlParams += '&max_child_count=${childCount}';
    }
    if (babyCount != 0) {
      urlParams += '&max_baby_count=${babyCount}';
    }
    if (petCount != 0) {
      urlParams += '&max_ped_count=${petCount}';
    }
    if (startDate != '') {
      urlParams += '&date_from=${startDate}&date_to=${endDate}';
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

  Future<dynamic> addToFavorite(int housing_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('${API_URL}api/mobile/favorite'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': "Bearer $token"
      },
      body: jsonEncode(<String, dynamic>{
        "housing_id": housing_id,
      }),
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

  Future<dynamic> deleteFavorite(int housing_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.delete(
      Uri.parse('${API_URL}api/mobile/favorite/$housing_id'),
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

  Future<dynamic> getFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${API_URL}api/mobile/favorite?page=1'),
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

  Future<dynamic> housingPayment(
    int housingId,
    String dateFrom,
    String dateTo,
    int peopleCount,
    List<int> selectedRoomIds,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    Map<String, dynamic> bodyObject = {
      "housing_id": housingId,
      "count_people": peopleCount,
      "rooms": selectedRoomIds,
    };

    if (dateFrom != '') {
      bodyObject["date_from"] = dateFrom;
      bodyObject["date_to"] = dateTo;
    }

    final response = await http.post(
      Uri.parse('${API_URL}api/mobile/favorite'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': "Bearer $token"
      },
      body: jsonEncode(bodyObject),
    );

    print(jsonDecode(response.body));

    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      result['response_status'] = 'ok';
      return result;
    } else {
      Map<String, dynamic> result = jsonDecode(response.body);
      result['response_status'] = 'error';
      return result;
    }
  }

  Future<dynamic> sendTextReview(
    int housingId,
    String date,
    String review,
    int price,
    int field,
    int purity,
    int staff,
    List<XFile> images,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var uri = Uri.parse('${API_URL}api/mobile/review');
    var request = http.MultipartRequest("POST", uri);
    request.headers['Authorization'] = "Bearer $token";
    request.headers['Accept'] = "application/json";

    request.fields['housing_id'] = housingId.toString();
    request.fields['was_at'] = date;
    request.fields['description'] = review;
    request.fields['price'] = price.toString();
    request.fields['atmosphere'] = field.toString();
    request.fields['purity'] = purity.toString();
    request.fields['staff'] = staff.toString();

    for (XFile item in images) {
      var stream = http.ByteStream(DelegatingStream.typed(item.openRead()));
      var length = await item.length();
      var multipartFile = http.MultipartFile('images', stream, length,
          filename: basename(item.path));
      request.files.add(multipartFile);
    }

    var response = await request.send();
    final responseString = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      Map<String, dynamic> result = {};
      result['data'] = jsonDecode(responseString);
      result['response_status'] = 'ok';
      return result;
    } else {
      Map<String, dynamic> result = {};
      result['data'] = jsonDecode(responseString);
      result['response_status'] = 'error';
      return result;
    }
  }

  Future<dynamic> sendAudioReview(
    int housingId,
    File audio,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var uri = Uri.parse('${API_URL}api/mobile/review');
    var request = http.MultipartRequest("POST", uri);
    request.headers['Authorization'] = "Bearer $token";
    request.headers['Accept'] = "application/json";

    request.fields['housing_id'] = housingId.toString();
    var stream = http.ByteStream(DelegatingStream.typed(audio.openRead()));
    var length = await audio.length();
    var multipartFile = http.MultipartFile('images', stream, length,
        filename: basename(audio.path));
    request.files.add(multipartFile);

    var response = await request.send();
    final responseString = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      Map<String, dynamic> result = {};
      result['data'] = jsonDecode(responseString);
      result['response_status'] = 'ok';
      return result;
    } else {
      Map<String, dynamic> result = {};
      result['data'] = jsonDecode(responseString);
      result['response_status'] = 'error';
      return result;
    }
  }
}
