import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;
import 'package:loader_overlay/loader_overlay.dart';

import 'package:client/Common/common.dart';
import 'widgets.dart';

class HardwareController extends GetxController {
  HardwareController({required this.hardware, required this.hospital});
  String hospital;
  List<Map<String, String>> hardware = [];

  final loaded = true.obs;

  Future<void> getHardwareData() async {
    try {
      Get.context!.loaderOverlay.show();
      loaded.value = false;

      final response = await httpPostRequest(
        route: '/api/hardware/list/hospital',
        body: {
          "hospital": hospital,
        },
        successCode: 200,
      );
      final temp = response["data"] as List;

      final rows = temp.map<Map<String, String>>((row) => Map<String, String>.from(row)).toList();
      hardware = rows;
    } catch (e) {
      developer.log(e.toString());
      showErrorSnackBar(content: e.toString());
    } finally {
      loaded.value = true;
      Get.context!.loaderOverlay.hide();
    }
  }

  Future<void> addHardware() async {
    Future<void> insert(String name) async {
      try {
        Get.context!.loaderOverlay.show();
        final Map<String, Map> data = {
          "data": {"Name": name, "Hospital": hospital}
        };
        await httpPostRequest(route: '/api/hardware/insert', body: data, successCode: 200);
      } catch (e) {
        developer.log(e.toString());
        showErrorSnackBar(content: e.toString());
      } finally {
        Get.context!.loaderOverlay.hide();
      }
    }

    try {
      final changed = await showDialog<bool>(
        context: Get.context!,
        builder: (ctx) => InsertColumn(insert: insert),
      );

      if (changed == true) getHardwareData();
    } catch (e) {
      developer.log(e.toString());
      showErrorSnackBar(content: "Failed to add patient");
    }
  }

  Future<void> editHardware(String id) async {}

  Future<void> deleteHardware(String id) async {
    try {
      Map<String, String> selectedHardware = {};
      for (final h in hardware) {
        if (h["_id"] == id) selectedHardware = h;
      }
      final confirmation =
          await requestConfirmation(title: "Confirm deletion", content: "Please confirm the deletion of hardware named: ${selectedHardware["Name"]}");

      if (confirmation) {
        try {
          Get.context!.loaderOverlay.show();
          await httpPostRequest(route: '/api/hardware/delete', body: {"id": id}, successCode: 200);
          getHardwareData();
        } catch (e) {
          developer.log(e.toString());
          showErrorSnackBar(content: e.toString());
        } finally {
          Get.context!.loaderOverlay.hide();
        }
      }
    } catch (e) {
      developer.log(e.toString());
      showErrorSnackBar(content: "Failed to delete hardware");
    }
  }
}
