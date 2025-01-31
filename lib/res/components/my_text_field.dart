import 'package:flutter/material.dart';
import '../colors.dart';
import '../utils/utils.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Widget? suffixIcon;
  final FocusNode focusNode;
  final FocusNode? currentFocusNode;
  final FocusNode? nextFocusNode;
  final TextInputType? keyboardType;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.suffixIcon,
    required this.focusNode,
    this.currentFocusNode,
    this.nextFocusNode,
    this.keyboardType
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          isDense: true,
          contentPadding: const EdgeInsets.all(15),
          fillColor: Colors.grey.shade50,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: MyColors.color),
          ),
          suffixIcon: suffixIcon,
        ),
        focusNode: focusNode,
        keyboardType: keyboardType,
        onFieldSubmitted: (value) {
          Utils.fieldFocusChange(context, currentFocusNode!, nextFocusNode!);
        });
  }
}
