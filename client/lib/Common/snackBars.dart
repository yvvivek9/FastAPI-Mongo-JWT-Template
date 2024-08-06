import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void showSuccessSnackBar({BuildContext? context, required String content}) {
  final snackBar = SnackBar(
    backgroundColor: Colors.green,
    content: Text(
      content,
      style: GoogleFonts.roboto(
        fontSize: 17,
        color: Colors.white,
      ),
    ),
    action: SnackBarAction(
      label: 'Dismiss',
      textColor: Colors.green,
      backgroundColor: Colors.white,
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );

  final currContext = context ?? Get.context!;
  if (!currContext.mounted) return;
  ScaffoldMessenger.of(currContext).clearSnackBars();
  ScaffoldMessenger.of(currContext).showSnackBar(snackBar);
}

void showErrorSnackBar({BuildContext? context, required String content}) {
  final snackBar = SnackBar(
    backgroundColor: Colors.red,
    content: Text(
      content,
      style: GoogleFonts.roboto(
        fontSize: 17,
        color: Colors.white,
      ),
    ),
    action: SnackBarAction(
      label: 'Dismiss',
      textColor: Colors.red,
      backgroundColor: Colors.white,
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );

  final currContext = context ?? Get.context!;
  if (!currContext.mounted) return;
  ScaffoldMessenger.of(currContext).clearSnackBars();
  ScaffoldMessenger.of(currContext).showSnackBar(snackBar);
}
