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

  Future<dynamic> addToFavorite(int id, int type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    Map<String, dynamic> jsonBody = {};

    if (type == 1) {
      jsonBody['housing_id'] = id;
    } else {
      jsonBody['impression_id'] = id;
    }

    final response = await http.post(
      Uri.parse('${API_URL}api/mobile/favorite'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': "Bearer $token"
      },
      body: jsonEncode(jsonBody),
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

  Future<dynamic> deleteFavorite(int id, int type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    Map<String, dynamic> jsonBody = {};

    if (type == 1) {
      jsonBody['housing_id'] = id;
    } else {
      jsonBody['impression_id'] = id;
    }

    final response = await http.post(
      Uri.parse('${API_URL}api/mobile/favorite/delete'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': "Bearer $token"
      },
      body: jsonEncode(jsonBody),
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

  Future<dynamic> sendTextReview(
    int type,
    int id,
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

    if (type == 2) {
      request.fields['housing_id'] = id.toString();
    } else {
      request.fields['impression_id'] = id.toString();
    }

    request.fields['was_at'] = date;
    request.fields['description'] = review;
    request.fields['price'] = price.toString();
    request.fields['atmosphere'] = field.toString();
    request.fields['purity'] = purity.toString();
    request.fields['staff'] = staff.toString();

    List<http.MultipartFile> multipartFiles = [];

    for (int i = 0; i < images.length; i++) {
      var stream =
          http.ByteStream(DelegatingStream.typed(images[i].openRead()));
      var length = await images[i].length();
      var multipartFile = http.MultipartFile('images[$i]', stream, length,
          filename: basename(images[i].path));
      multipartFiles.add(multipartFile);
    }

    request.files.addAll(multipartFiles);

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
    int type,
    int id,
    File audio,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var uri = Uri.parse('${API_URL}api/mobile/review');
    var request = http.MultipartRequest("POST", uri);
    request.headers['Authorization'] = "Bearer $token";
    request.headers['Accept'] = "application/json";

    if (type == 2) {
      request.fields['housing_id'] = id.toString();
    } else {
      request.fields['impression_id'] = id.toString();
    }

    var stream = http.ByteStream(DelegatingStream.typed(audio.openRead()));
    var length = await audio.length();
    var multipartFile = http.MultipartFile('audio', stream, length,
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

  Future<dynamic> getCities(int countryId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${API_URL}api/city?country_id=$countryId'),
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

  Future<dynamic> getReels(String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${API_URL}api/mobile/reel?type=$type'),
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

  Future<dynamic> getReelInfo(int reelId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${API_URL}api/mobile/reel/show/$reelId'),
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

  Future<dynamic> uploadReels(
    String type,
    int id,
    int cityId,
    int categoryId,
    File video,
    File thumbnail,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var uri = Uri.parse('${API_URL}api/mobile/reel');
    var request = http.MultipartRequest("POST", uri);
    request.headers['Authorization'] = "Bearer $token";
    request.headers['Accept'] = "application/json";

    if (type == 'housing') {
      request.fields['housing_id'] = id.toString();
    } else {
      request.fields['impression_id'] = id.toString();
    }
    request.fields['city_id'] = cityId.toString();
    request.fields['category_id'] = categoryId.toString();

    var streamThumbnail =
        http.ByteStream(DelegatingStream.typed(thumbnail.openRead()));
    var lengthThumbnail = await thumbnail.length();
    var multipartFileThumbnail = http.MultipartFile(
        'thumbnail', streamThumbnail, lengthThumbnail,
        filename: basename(thumbnail.path));
    request.files.add(multipartFileThumbnail);

    var stream = http.ByteStream(DelegatingStream.typed(video.openRead()));
    var length = await video.length();
    var multipartFile = http.MultipartFile('video', stream, length,
        filename: basename(video.path));
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

  Future<dynamic> getCards() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${API_URL}api/mobile/payment-card'),
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

  Future<dynamic> createCard(
      String name,
      String number,
      String month,
      String year,
      String cvv,
      int isDefault,
      String cryptogram,
      int type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('${API_URL}api/mobile/payment-card'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': "Bearer $token"
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'number': number,
        'month': month,
        'year': year,
        'cvv': cvv,
        'default': isDefault,
        'cryptogram': cryptogram,
        'type': type,
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

  Future<dynamic> getAutocompleteText(String text) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(
          '${API_URL}api/mobile/global-search/${Uri.encodeComponent(text)}'),
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

  Future<dynamic> requestPaymentPermission() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${API_URL}api/mobile/payment/is-public'),
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

  Future<dynamic> getSelections() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${API_URL}api/mobile/compilation'),
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

  Future<dynamic> getReviewById(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${API_URL}api/mobile/review/show/$id'),
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

  // TODO: Get Comforts (type: 1 - housing, 2 - impression) (levels: 1,2)

  Future<dynamic> getComforts(int type, int level) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(
          '${API_URL}api/comfort?for=${type == 1 ? 'housing' : 'impression'}&level=$level'),
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

  // TODO: Get breakfasts

  Future<dynamic> getBreakfasts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${API_URL}api/breakfast'),
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

  // TODO: Get bed

  Future<dynamic> getBed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${API_URL}api/bed'),
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

  // TODO: Get language

  Future<dynamic> getLanguages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${API_URL}api/language'),
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

  // TODO: Get topics

  Future<dynamic> getTopics() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${API_URL}api/topic'),
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

  // TODO: Get locations

  Future<dynamic> getLocations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${API_URL}api/position'),
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

  // TODO: Request Order Return Prices

  Future<dynamic> requestOrderReturnPrices(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${API_URL}api/mobile/order/refund/price/$id'),
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
