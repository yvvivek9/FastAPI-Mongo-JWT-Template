import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'dart:developer' as developer;

import 'package:client/Common/common.dart';
import 'package:client/Dashboard/page.dart';

class LoginController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void handleLogin() async {
    try {
      Get.context!.loaderOverlay.show();

      final response = await httpPostRequest(
        route: '/api/auth/login',
        body: {
          'username': usernameController.text,
          'password': passwordController.text,
        },
        successCode: 202,
      );

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', response["token"]!);
      Get.off(() => DashboardScreen());

    } catch (e) {
      developer.log(e.toString());
      showErrorSnackBar(content: e.toString());

    } finally {
      Get.context!.loaderOverlay.hide();
    }
  }
}
