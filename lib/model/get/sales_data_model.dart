import 'dart:convert';

class SalesData {
  String month;
  String monthName;
  double totalSales;

  // Constructor
  SalesData({
    required this.month,
    required this.monthName,
    required this.totalSales,
  });

  // Factory method to create an instance from JSON
  factory SalesData.fromJson(Map<String, dynamic> json) {
    return SalesData(
      month: json['Month'],
      monthName: json['Month Name'],
      totalSales: json['Total Sales'].toDouble(),
    );
  }

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'Month': month,
      'Month Name': monthName,
      'Total Sales': totalSales,
    };
  }
}
