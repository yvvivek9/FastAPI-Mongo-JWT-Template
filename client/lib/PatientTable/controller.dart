import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;
import 'package:loader_overlay/loader_overlay.dart';

import 'package:client/Common/common.dart';
import 'widgets.dart';

class PatientTableController extends GetxController {
  PatientTableController({required this.hospital});
  final String hospital;

  final loaded = false.obs;

  List<String> columns = [];
  List<Map<String, String>> data = [];
  List<Map<String, String>> hardware = [];
  List<String> hardwareNames = [];

  @override
  void onReady() {
    super.onReady();
    getTableColumns();
    getHardwareData();
  }

  Future<void> getTableColumns() async {
    try {
      Get.context!.loaderOverlay.show();

      final response = await httpPostRequest(
        route: '/api/patient/columns',
        body: {},
        successCode: 200,
      );
      final List temp = response["data"] as List;
      final List<String> cols = temp.map<String>((col) => col["name"]).toList();
      columns = cols;

      await getPatientData();
    } catch (e) {
      developer.log(e.toString());
      showErrorSnackBar(content: e.toString());
    } finally {
      Get.context!.loaderOverlay.hide();
    }
  }

  Future<void> getPatientData() async {
    try {
      Get.context!.loaderOverlay.show();
      loaded.value = false;

      final response = await httpPostRequest(
        route: '/api/patient/list/hospital',
        body: {
          "hospital": hospital,
        },
        successCode: 200,
      );
      final temp = response["data"] as List;

      final rows = temp.map<Map<String, String>>((row) => Map<String, String>.from(row)).toList();
      data = rows;
    } catch (e) {
      developer.log(e.toString());
      showErrorSnackBar(content: e.toString());
    } finally {
      loaded.value = true;
      Get.context!.loaderOverlay.hide();
    }
  }

  Future<void> getHardwareData() async {
    try {
      Get.context!.loaderOverlay.show();

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

      for (final h in hardware) {
        hardwareNames.add(h["Name"]!);
      }
    } catch (e) {
      developer.log(e.toString());
      showErrorSnackBar(content: e.toString());
    } finally {
      Get.context!.loaderOverlay.hide();
    }
  }

  Future<void> addPatient() async {
    Future<void> add(Map<String, String> patient) async {
      try {
        Get.context!.loaderOverlay.show();
        await httpPostRequest(route: '/api/patient/insert', body: {"data": patient}, successCode: 200);
      } catch (e) {
        developer.log(e.toString());
        showErrorSnackBar(content: e.toString());
      } finally {
        Get.context!.loaderOverlay.hide();
      }
    }

    try {
      Map<String, String> patient = {};
      for (final column in columns) {
        patient[column] = "";
      }
      patient["Hospital"] = hospital;

      final changed = await showDialog<bool>(
        context: Get.context!,
        builder: (ctx) => ModifyPatient(
          action: 'Add',
          hardware: hardwareNames,
          patient: patient,
          modify: add,
        ),
      );

      if (changed == true) getPatientData();
    } catch (e) {
      developer.log(e.toString());
      showErrorSnackBar(content: "Failed to add patient");
    }
  }

  Future<void> updatePatient(String id) async {
    Future<void> update(Map<String, String> updatedPatient) async {
      try {
        Get.context!.loaderOverlay.show();
        await httpPostRequest(route: '/api/patient/update', body: {"id": id, "data": updatedPatient}, successCode: 200);
      } catch (e) {
        developer.log(e.toString());
        showErrorSnackBar(content: e.toString());
      } finally {
        Get.context!.loaderOverlay.hide();
      }
    }

    try {
      Map<String, String> patient = {};
      for (final d in data) {
        if (d["_id"] == id) patient = d;
      }
      patient.remove("_id");
      final changed = await showDialog<bool>(
        context: Get.context!,
        builder: (ctx) => ModifyPatient(
          action: 'Update',
          hardware: hardwareNames,
          patient: patient,
          modify: update,
        ),
      );

      if (changed == true) getPatientData();
    } catch (e) {
      developer.log(e.toString());
      showErrorSnackBar(content: "Failed to update patient");
    }
  }

  Future<void> deletePatient(String id) async {
    try {
      Map<String, String> patient = {};
      for (final d in data) {
        if (d["_id"] == id) patient = d;
      }
      final confirmation = await requestConfirmation(title: "Confirm deletion", content: "Please confirm the deletion of patient named: ${patient["Name"]}");

      if (confirmation) {
        try {
          Get.context!.loaderOverlay.show();
          await httpPostRequest(route: '/api/patient/delete', body: {"id": id}, successCode: 200);
        } catch (e) {
          developer.log(e.toString());
          showErrorSnackBar(content: e.toString());
        } finally {
          Get.context!.loaderOverlay.hide();
          getPatientData();
        }
      }
    } catch (e) {
      developer.log(e.toString());
      showErrorSnackBar(content: "Failed to delete patient");
    }
  }

  Future<void> addColumnInTable() async {
    Future<void> insert(String name) async {
      try {
        Get.context!.loaderOverlay.show();
        await httpPostRequest(route: '/api/patient/column/insert', body: {"name": name}, successCode: 200);
      } catch (e) {
        developer.log(e.toString());
        showErrorSnackBar(content: e.toString());
      } finally {
        Get.context!.loaderOverlay.hide();
      }
    }

    final changed = await showDialog<bool>(
      context: Get.context!,
      builder: (ctx) => InsertColumn(
        insert: insert,
      ),
    );
    if (changed == true) getTableColumns();
  }
}
