import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:client/Authentication/Login/page.dart';
import 'controller.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final SignUpController controller = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 80,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          height: 500,
          width: 400,
          child: Column(
            children: [
              Obx(
                () => DropdownMenu(
                  width: 320,
                  controller: controller.userTypeController,
                  requestFocusOnTap: false,
                  hintText: 'Select user type',
                  dropdownMenuEntries: controller.userTypes.value
                      .map((e) => DropdownMenuEntry(
                            value: e["name"],
                            label: e["name"],
                          ))
                      .toList(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: controller.usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: controller.passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: controller.processSignUp,
                child: Text('Sign-Up'),
              ),
              SizedBox(height: 30),
              TextButton(
                onPressed: () {
                  Get.off(() => LoginScreen());
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
