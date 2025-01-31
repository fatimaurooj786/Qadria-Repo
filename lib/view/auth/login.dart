import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../res/colors.dart';
import '../../res/components/my_button.dart';
import '../../res/components/my_text_field.dart';
import '../../res/constants.dart';
import '../../view_models/auth/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController authController = Get.put(AuthController());

  bool passwordVisible = true;

  void signIn() {
    authController.login();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    //final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: MyColors.scaffoldSColor,
      body: Padding(
        padding: padding,
        child: Obx(
              () => SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: height * 0.15),
                const Icon(Icons.lock, size: 60, color: MyColors.color),
                SizedBox(height: height * 0.15),
                Center(
                  child: MyTextField(
                    controller: authController.emailController.value,
                    hintText: 'Enter your email',
                    obscureText: false,
                    focusNode: authController.emailFocus.value,
                    currentFocusNode: authController.emailFocus.value,
                    nextFocusNode: authController.passwordFocus.value,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                SizedBox(height: height * 0.01),
                MyTextField(
                  controller: authController.passwordController.value,
                  hintText: 'Enter your password',
                  obscureText: passwordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible ? Icons.visibility_off : Icons.visibility,
                      color: MyColors.color,
                    ),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                  focusNode: authController.passwordFocus.value,
                  currentFocusNode: authController.passwordFocus.value,
                ),
                SizedBox(height: height * 0.03),
                MyButton(
                  onTap: signIn,
                  text: 'Login',
                  isLoading: authController.loading.value,

                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
