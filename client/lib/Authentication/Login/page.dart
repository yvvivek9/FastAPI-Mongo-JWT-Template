import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:client/Authentication/SignUp/page.dart';
import 'controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController controller = Get.put(LoginController());

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
                onPressed: controller.handleLogin,
                child: Text('Login'),
              ),
              SizedBox(height: 30),
              TextButton(
                onPressed: () {
                  Get.off(() => SignUpScreen());
                },
                child: Text('Sign-Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
