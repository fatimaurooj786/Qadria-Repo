import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:qadria/res/utils/size_box_extension.dart';

import '../../../../res/colors.dart';

class MenuButton extends StatefulWidget {
  final VoidCallback onTap;
  final String? imagePath; // Nullable for optional images
  final IconData? icon; // Nullable for optional icons
  final String buttonText;

  const MenuButton({
    super.key,
    required this.onTap,
    this.imagePath,
    this.icon,
    required this.buttonText,
  });

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Smooth rounded edges
        ),
        elevation: 6, // Elevated effect for a 3D appearance
        shadowColor: MyColors.shadowColor.withOpacity(0.5), // Custom shadow
        child: Container(
          padding: const EdgeInsets.all(15), // Adjust padding as needed
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: MyColors.shadowColor.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(5, 5), // Offset for a more 3D effect
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Conditional Rendering: Icon or Image
              if (widget.icon != null)
                Icon(
                  widget.icon,
                  size: 50,
                  color: MyColors.color, // Adjust color as needed
                )
              else if (widget.imagePath != null)
                Image.asset(
                  widget.imagePath!,
                  width: 50,
                  height: 50,
                ),
              10.kH, // Adjust spacing between image/icon and text
              // Text
              AutoSizeText(
                widget.buttonText,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
