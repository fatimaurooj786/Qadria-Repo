import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:qadria/res/colors.dart';

class CustomDropDownSearch extends StatefulWidget {
  final String searchLabelText;
  final String labelText;
  final List<String> values;
  final String? selectedItem1;
  final IconData? icon;
  final void Function(String?)? onChanged;

  const CustomDropDownSearch(
      {super.key,
      required this.searchLabelText,
      required this.labelText,
      required this.values,
      this.selectedItem1,
      this.icon = Icons.person,
      this.onChanged});

  @override
  State<CustomDropDownSearch> createState() => _CustomDropDownSearchState();
}

class _CustomDropDownSearchState extends State<CustomDropDownSearch> {
  String? selectedItem2;
  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      key: GlobalKey<DropdownSearchState<String>>(),
      selectedItem: widget.selectedItem1 == null || widget.selectedItem1 == ''
          ? selectedItem2
          : widget.selectedItem1,
      // selectedItem: selectedItem2,
      items: (filter, infiniteScrollProps) =>
          widget.values, // Pre-loaded list of customers
      itemAsString: (String? value) => value ?? '', // Display the selected item
      popupProps: PopupProps.menu(
        showSearchBox: true,
        constraints: const BoxConstraints(maxHeight: 300),
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            labelText: widget.searchLabelText,
            prefixIcon: const Icon(Icons.search),
            border: const OutlineInputBorder(),
          ),
        ),
      ),
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          labelText: widget.labelText,
          border: const OutlineInputBorder(),
          prefixIcon: Icon(widget.icon, color: MyColors.color),
        ),
      ),
      compareFn: (String? value, selectedItem) => value == selectedItem,

      onChanged: (widget.onChanged),
    );
  }
}
