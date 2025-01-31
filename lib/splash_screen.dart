import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pretty_animated_text/pretty_animated_text.dart';
import 'package:qadria/res/my_images.dart';
import 'app_wrapper.dart'; // Import your AppWrapper file here

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller and animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Animation duration
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();

    // Navigate to the AppWrapper screen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Get.off(() => const AppWrapper()); // Navigates to AppWrapper
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blue, // Customize background color
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              MyImages.logo, // Your splash logo
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),
            const ScaleText(
              text: 'Qadria Enterprises',
              duration: Duration(milliseconds: 260),
              type: AnimationType.letter,
              textStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
