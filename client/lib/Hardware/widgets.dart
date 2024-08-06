import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                "Add hardware",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onTertiary),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Row(
                children: [
                  Expanded(child: Text('Hardware name :')),
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
