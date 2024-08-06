import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';
import 'package:client/Common/table.dart';
import 'package:client/Hardware/page.dart';
import 'package:client/Hardware/controller.dart';

class PatientTableScreen extends StatelessWidget {
  const PatientTableScreen({super.key, required this.controller});

  final PatientTableController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sync-IoT : Patient Records - ${controller.hospital}'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        child: Column(
          children: [
            SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: controller.addColumnInTable,
                    child: Text('Add column'),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await Get.to(() => HardwareScreen(controller: Get.put(HardwareController(hardware: controller.hardware, hospital: controller.hospital))));
                      controller.getHardwareData();
                    },
                    child: Text('Manage Hardware'),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: controller.addPatient,
                    child: Text('Add Patient'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.loaded.value == true) {
                  return CustomTable(
                    columns: controller.columns,
                    data: controller.data,
                    onEdit: controller.updatePatient,
                    onDelete: controller.deletePatient,
                  );
                } else {
                  return Container();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
