import 'package:intl/intl.dart';

final NumberFormat currencyFormatter = NumberFormat.currency(
  locale: 'en_PK',
  symbol: 'Rs ', // Currency symbol
  decimalDigits: 2, // Number of decimal places
);
