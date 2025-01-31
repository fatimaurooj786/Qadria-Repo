import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:qadria/view/bottom_nav/activity_summary/activity_summary_screen.dart';
import 'package:qadria/view/bottom_nav/combined_activity_summary/combined_activity_summary_screen.dart';
import 'package:qadria/view/bottom_nav/profile/profile.dart';
import '../../res/colors.dart';
import 'home/home.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  var currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirmation'),
            content: const Text('Are you sure you want to close the app?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                  SystemNavigator.pop();
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          children: const [
            // Home Screen
            Home(),
            ActivitySummaryScreen(),
            CombinedActivitySummaryScreen(),
            // Profile Screen
            Profile(),
          ],
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
        bottomNavigationBar: SalomonBottomBar(
          selectedItemColor: MyColors.color,
          unselectedItemColor: MyColors.color,
          currentIndex: currentIndex,
          onTap: (i) {
            setState(() {
              currentIndex = i;
              _pageController.animateToPage(
                i,
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
              );
            });
          },
          items: [
            /// Home
            SalomonBottomBarItem(
              icon: const Icon(Icons.home_outlined),
              title: const Text("Home", style: TextStyle(fontSize: 10)),
            ),

            /// Activity Summary
            SalomonBottomBarItem(
                icon: const Icon(Icons.assignment_outlined),
                title: const Text("Activity Summary",
                    style: TextStyle(fontSize: 10))),

            //Combined Activity Summary
            SalomonBottomBarItem(
              icon: const Icon(Icons.assignment_outlined),
              title: const Text("Combined Activity",
                  style: TextStyle(fontSize: 10)),
            ),

            /// Likes
            SalomonBottomBarItem(
              icon: const Icon(Icons.person_2_outlined),
              title: const Text("Profile", style: TextStyle(fontSize: 10)),
            ),
          ],
        ),
      ),
    );
  }
}
