import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:loader_overlay/loader_overlay.dart';

import 'package:client/Common/common.dart';

class DashboardController extends GetxController {
  final hospitalsList = [].obs;

  @override
  void onReady() {
    super.onReady();
    getHospitalList();
  }

  void getHospitalList() async {
    try {
      Get.context!.loaderOverlay.show();

      final response = await httpPostRequest(
        route: '/api/hospital/list',
        body: {},
        successCode: 200,
      );
      final temp = response["data"];
      if (temp is List) hospitalsList.value = temp;
    } catch (e) {
      developer.log(e.toString());
      showErrorSnackBar(content: e.toString());
    } finally {
      Get.context!.loaderOverlay.hide();
    }
  }

  Future<void> addHospital() async {
    Future<void> insert(String name) async {
      try {
        Get.context!.loaderOverlay.show();
        final Map<String, Map> data = {
          "data": {"name": name}
        };
        await httpPostRequest(route: '/api/hospital/insert', body: data, successCode: 200);
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

      if (changed == true) getHospitalList();
    } catch (e) {
      developer.log(e.toString());
      showErrorSnackBar(content: "Failed to add hospital");
    }
  }
}

class InsertColumn extends StatelessWidget {
  const InsertColumn({super.key, required this.insert});

  final Function(String) insert;

  @override
  Widget build(BuildContext context) {
    final TextEditingController tc = TextEditingController();

    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              color: Theme.of(context).colorScheme.tertiary,
              child: Text(
                "Add hospital",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onTertiary),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Row(
                children: [
                  Expanded(child: Text('Hospital name :')),
                  Expanded(
                    child: TextField(
                      controller: tc,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        // contentPadding: EdgeInsets.all(0),
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: () async {
                    await insert(tc.text);
                    Get.back(result: true);
                  },
                  child: Text(
                    'Add',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.tertiary),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
