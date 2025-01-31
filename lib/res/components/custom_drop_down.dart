// import 'package:flutter/material.dart';
//
// typedef DropDownSelection = Function(dynamic selected);
//
// Widget getDropDownItem(dynamic item) {
//   return Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           item == null ? "None" : item.getNameForDropDown(),
//         ),
//         item == null
//             ? const SizedBox.shrink()
//             : Opacity(
//           opacity: 0.5,
//           child: Text(
//             item.getId(),
//             style: const TextStyle(
//                 color: Colors.black,
//                 fontSize: 12),
//           ),
//         )
//       ],
//     ),
//   );
// }
//
// getDropDownView(BuildContext context, List<dynamic> list, dynamic selected,
//     {required DropDownSelection onSelection, bool readOnly = false}) {
//   return DropdownSearch<dynamic>(
//     enabled: true,
//     items: list,
//     dropdownDecoratorProps: const DropDownDecoratorProps(
//       dropdownSearchDecoration: InputDecoration(
//         labelText: "",
//         hintText: "",
//       ),
//     ),
//     compareFn: (value, s) => false,
//     itemAsString: (value) {
//       return value.getNameForDropDown();
//     },
//     dropdownBuilder: (context, selectedItem) {
//       return getDropDownItem(selectedItem);
//     },
//     popupProps: PopupProps.menu(
//       showSearchBox: true,
//       itemBuilder: (context, item, isSelected) {
//         return getDropDownItem(item);
//       },
//       disabledItemFn: (dynamic s) => false,
//     ),
//     onChanged: (dynamic idName) {
//       onSelection(idName);
//     },
//     selectedItem: selected,
//   );
// }