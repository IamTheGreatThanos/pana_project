import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pana_project/utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider {
  String API_URL = AppConstants.baseUrl;

  Future<dynamic> login(String phone, String countryCode) async {
    final response = await http.post(
      Uri.parse('${API_URL}api/mobile/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        "phone": phone,
        "phone_code": countryCode,
      }),
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

  Future<dynamic> loginVerify(String code) async {
    final response = await http.post(
      Uri.parse('${API_URL}api/mobile/auth/login/verify'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        "code": code,
      }),
    );

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

  Future<dynamic> registerVerify(String code) async {
    final response = await http.post(
      Uri.parse('${API_URL}api/mobile/auth/register/verify'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        "code": code,
      }),
    );

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

  Future<dynamic> register(
    String phone,
    String countryCode,
    String name,
    String surname,
    String email,
  ) async {
    final response = await http.post(
      Uri.parse('${API_URL}api/mobile/auth/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        "phone": phone,
        "phone_code": countryCode,
        "name": name,
        "surname": surname,
        "email": email,
      }),
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

  Future<dynamic> updateProfileOnRegister(
      String gender, String birthday) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('${API_URL}api/mobile/user/update'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': "Bearer $token"
      },
      body: jsonEncode(<String, dynamic>{
        "gender": gender,
        "birth_date": birthday,
      }),
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
}
