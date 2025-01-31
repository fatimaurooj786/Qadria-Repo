import 'package:flutter/material.dart';

import '../utils/utils.dart';

class SimpleTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final FocusNode focusNode;
  final FocusNode? currentFocusNode; // Define current focus node
  final FocusNode? nextFocusNode;

  const SimpleTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.focusNode,
    this.currentFocusNode,
    this.nextFocusNode, // Make suffixIcon nullable
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
          ),
          focusNode: focusNode,
          onFieldSubmitted: (value) {
            Utils.fieldFocusChange(context, currentFocusNode!, nextFocusNode!);
          }),
    );
  }
}
