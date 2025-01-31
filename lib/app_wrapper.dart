import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qadria/view/auth/login.dart';
import 'package:qadria/view/bottom_nav/bottom_nav.dart';
import 'package:qadria/view_models/auth/auth_controller.dart';

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());

    return Obx(() {
      return authController.isLoggedIn.value
          ? const BottomNav()
          : const LoginPage();
    });
  }
}