import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:loader_overlay/loader_overlay.dart';

import 'package:client/Common/common.dart';
import 'package:client/Authentication/Login/page.dart';

class SignUpController extends GetxController {
  final userTypes = [].obs;

  final TextEditingController userTypeController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void onReady() {
    super.onReady();
    getUserTypes();
  }

  void processSignUp() async {
    try {
      Get.context!.loaderOverlay.show();

      final response = await httpPostRequest(
        route: '/api/auth/register',
        body: {
          'userType': userTypeController.text,
          'username': usernameController.text,
          'password': passwordController.text,
        },
        successCode: 201,
      );
      Get.off(() => LoginScreen());
      showSuccessSnackBar(content: 'Sign-up complete, please login');
    } catch (e) {
      developer.log(e.toString());
      showErrorSnackBar(content: e.toString());
    } finally {
      Get.context!.loaderOverlay.hide();
    }
  }

  void getUserTypes() async {
    try {
      Get.context!.loaderOverlay.show();

      final response = await httpPostRequest(
        route: '/api/auth/listUserTypes',
        body: {},
        successCode: 200,
      );
      final temp = response["data"];
      if (temp is List) userTypes.value = temp;
    } catch (e) {
      developer.log(e.toString());
      showErrorSnackBar(content: e.toString());
    } finally {
      Get.context!.loaderOverlay.hide();
    }
  }
}
