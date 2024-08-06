import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:client/PatientTable/page.dart';
import 'package:client/PatientTable/controller.dart';
import 'controller.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sync-IoT"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  'Select Hospital',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: controller.addHospital,
                  child: Text('Add Hospital'),
                ),
              ],
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              child: Obx(
                () => Wrap(
                  spacing: 10,
                  runSpacing: 5,
                  children: controller.hospitalsList.value.map((e) => HospitalCard(name: e["name"])).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HospitalCard extends StatelessWidget {
  const HospitalCard({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          Get.to(() => PatientTableScreen(controller: Get.put(PatientTableController(hospital: name))));
        },
        child: SizedBox(
          width: 100,
          height: 40,
          child: Center(
            child: Text(
              name,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
