import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';
import 'package:client/Common/table.dart';

class HardwareScreen extends StatelessWidget {
  const HardwareScreen({super.key, required this.controller});

  final HardwareController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sync-IoT : Hardware - ${controller.hospital}'),
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
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: controller.addHardware,
                    child: Text('Add Hardware'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.loaded.value) {
                  return CustomTable(
                    columns: ["Name"],
                    data: controller.hardware,
                    onEdit: controller.editHardware,
                    onDelete: controller.deleteHardware,
                  );
                } else {
                  return Container();
                }
              }),
            )
          ],
        ),
      ),
    );
  }
}
