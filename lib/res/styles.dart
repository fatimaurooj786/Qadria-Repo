import 'package:flutter/material.dart';

import 'colors.dart';

TextStyle headerStyle = const TextStyle(
    fontSize: 16, color: MyColors.color, fontWeight: FontWeight.bold);

TextStyle quantityStyle = const TextStyle(
    color: MyColors.color, fontWeight: FontWeight.bold, fontSize: 16);

TextStyle itemNameStyle = const TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 12,
);

TextStyle itemPriceStyle = const TextStyle(
  fontWeight: FontWeight.w500,
);

TextStyle inStockStyle = const TextStyle(
  color: MyColors.color,
  fontSize: 13,
);

TextStyle cartPriceStyle = itemPriceStyle.copyWith(color: MyColors.color);
