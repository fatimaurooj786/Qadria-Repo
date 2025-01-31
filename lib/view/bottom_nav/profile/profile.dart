import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../res/colors.dart';
import '../../../res/constants.dart';
import '../../../res/utils/utils.dart';
import '../../../view_models/auth/auth_controller.dart';
import '../../auth/login.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());

    return Scaffold(
      backgroundColor: MyColors.scaffoldSColor,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() {
              return ProfileInfoCard(
                title: 'Full Name',
                content: authController.name.value,
              );
            }),
            space2,
            Obx(() {
              return ProfileInfoCard(
                title: 'Email',
                content: authController.email2.value,
              );
            }),
            const SizedBox(
              height: 40,
              child: Center(
                child: Text("v1.0.0"),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Show confirmation dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirm Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            authController.logout().then((value) {
                              Get.offAll(() => const LoginPage());
                            }).onError((error, stackTrace) {
                              Utils.errorSnackBar(error.toString());
                            });
                          },
                          child: const Text('Logout'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileInfoCard extends StatelessWidget {
  final String title;
  final String content;

  const ProfileInfoCard({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
