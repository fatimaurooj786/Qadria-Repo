import 'package:flutter/material.dart';

import '../../../../res/colors.dart';
class CustomDropdown extends StatelessWidget {
  final String? value;
  final List<String> options;
  final void Function(String?)? onChanged;

  const CustomDropdown({
    super.key,
    this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: MyColors.color),
        ),
      ),
      child: DropdownButton<String>(
        value: value,
        onChanged: onChanged,
        underline: const SizedBox(),
        icon: const Icon(Icons.arrow_drop_down,color: MyColors.color),
        isExpanded: true,
        items: options.map<DropdownMenuItem<String>>((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
      ),
    );
  }
}
