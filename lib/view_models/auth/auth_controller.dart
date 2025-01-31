import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../repository/auth_repository/auth_repository.dart';
import '../../res/utils/utils.dart';
import '../../view/bottom_nav/bottom_nav.dart';

class AuthController extends GetxController {
  final _api = AuthRepo();

  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  final emailFocus = FocusNode().obs;
  final passwordFocus = FocusNode().obs;

  RxBool loading = false.obs;
  RxBool isLoggedIn = false.obs;
  RxString name = "".obs;
  RxString email2 = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadLoginStatus();
  }

  void loadLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLoggedIn.value = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn.value) {
      name.value = prefs.getString('name') ?? '';
      email2.value = prefs.getString('email') ?? '';
    }
  }

  void login() {
    final String email = emailController.value.text;
    final String password = passwordController.value.text;
    loading.value = true;
    _api.loginAPi(email: email, password: password).then((response) {
      loading.value = false;
      isLoggedIn.value = true;
      var fullName = response.data['full_name'];
      name.value = fullName;
      email2.value = email;
      Get.offAll(() => const BottomNav());
      Utils.successSnackBar('Successfully Logged In');
      saveUserDetails(
        email: email,
        isLoggedIn: isLoggedIn.value,
        name: name.value,
      );
    }).catchError((error) {
      loading.value = false;
      Utils.errorSnackBar(error.toString());
      log(error.toString());
    });
  }

  Future<void> logout() async {
    loading.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('name');
    await prefs.remove('email');
    isLoggedIn.value = false;
    name.value = '';
    email2.value = '';
    loading.value = false;

    // Clear and reset the text controllers
    emailController.value.clear();
    passwordController.value.clear();

    // Un focus the fields
    // emailFocus.value.unfocus();
    // passwordFocus.value.unfocus();

    // Create new instances of the TextEditingControllers and FocusNodes to reset them
    emailController.value = TextEditingController();
    passwordController.value = TextEditingController();
    emailFocus.value = FocusNode();
    passwordFocus.value = FocusNode();
  }

  Future<void> saveUserDetails({
    required String email,
    required String name,
    required bool isLoggedIn,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    log('Saving user details using SharedPreferences:');
    await prefs.setString('email', email);
    await prefs.setString('name', name);
    await prefs.setBool('isLoggedIn', isLoggedIn);
    log("$email Email");
    log("$name Name");
    log('User details saved using SharedPreferences.');
  }
}
