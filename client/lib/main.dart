import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'package:client/Dashboard/page.dart';
import 'package:client/Authentication/Login/page.dart';

import 'package:client/PatientTable/page.dart';
import 'theme.dart';

bool loggedIn = false;

Future<void> checkLogIn() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("token");
  if (token != null) loggedIn = true;
}

void main() async {
  await checkLogIn();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      child: GetMaterialApp(
        title: 'Flutter Demo',
        theme: themeData,
        home: loggedIn ? DashboardScreen() : LoginScreen(),
        // home: PatientTableScreen(),
      ),
    );
  }
}
