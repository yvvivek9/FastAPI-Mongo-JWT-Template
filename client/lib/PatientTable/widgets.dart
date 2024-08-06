import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ModifyPatient extends StatelessWidget {
  const ModifyPatient({super.key, required this.patient, required this.modify, required this.action, required this.hardware});

  final String action;
  final List<String> hardware;
  final Map<String, String> patient;
  final Function(Map<String, String>) modify;

  List<Widget> textColumns() {
    List<String> params = patient.keys.toList();
    params.remove("_id");
    params.remove("Hospital");
    List<Widget> columns = [];

    for (final param in params) {
      final tc = TextEditingController();
      tc.text = patient[param] ?? "";
      if (param == "Hardware") {
        columns.add(
          Row(
            children: [
              Expanded(child: Text('Hardware :')),
              Expanded(
                child: DropdownMenu(
                  width: 200,
                  initialSelection: patient["Hardware"] == "" ? null : patient["Hardware"],
                  requestFocusOnTap: false,
                  onSelected: (h) {
                    if (h != null) {
                      patient["Hardware"] = h;
                    }
                  },
                  dropdownMenuEntries: hardware.map((e) => DropdownMenuEntry(value: e, label: e)).toList(),
                  textStyle: TextStyle(
                    fontSize: 15,
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        );
      } else if (param == "Gender") {
        columns.add(
          Row(
            children: [
              Expanded(child: Text('Gender :')),
              Expanded(
                child: DropdownMenu(
                  width: 200,
                  initialSelection: patient["Gender"] == "" ? null : patient["Gender"],
                  requestFocusOnTap: false,
                  onSelected: (h) {
                    if (h != null) {
                      patient["Gender"] = h;
                    }
                  },
                  dropdownMenuEntries: ['Male', 'Female'].map((e) => DropdownMenuEntry(value: e, label: e)).toList(),
                  textStyle: TextStyle(
                    fontSize: 15,
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        columns.add(
          Row(
            children: [
              Expanded(child: Text('$param :')),
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
                  onChanged: (change) {
                    patient[param] = change;
                  },
                ),
              ),
            ],
          ),
        );
      }
      columns.add(SizedBox(height: 20));
    }

    return columns;
  }

  @override
  Widget build(BuildContext context) {
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
                "$action Patient",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onTertiary),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: textColumns(),
              ),
            ),
            Center(
              child: SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: () async {
                    await modify(patient);
                    Get.back(result: true);
                  },
                  child: Text(
                    action,
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
                "Add column",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onTertiary),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Row(
                children: [
                  Expanded(child: Text('Column name :')),
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
