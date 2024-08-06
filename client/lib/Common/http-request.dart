import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:client/Authentication/Login/page.dart';

const String domain = "";

Future<Map> httpPostRequest({
  required String route,
  required Map<String, dynamic> body,
  required int successCode,
}) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final response = await http.post(
      Uri.parse(domain + route),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token ?? '',
      },
      body: jsonEncode(body),
    );

    final decodedResponse = jsonDecode(response.body) as Map;
    if (response.statusCode == successCode) {
      return decodedResponse;
    } else if (response.statusCode == 401) {
      developer.log("JWT token invalid");
      Get.offAll(() => LoginScreen());
      throw Exception("Session timed out, please re-login");
    } else if (response.statusCode == 403) {
      developer.log("Access denied");
      Get.offAll(() => LoginScreen());
      throw Exception("User role invalid, access denied");
    } else {
      throw Exception(decodedResponse["message"]);
    }
  } catch (e) {
    rethrow;
  }
}
