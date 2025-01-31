class SaleOrder {
  String name;
  String customDealer;
  String customDealerCity;
  String customer;
  String transactionDate;
  double grandTotal;

  SaleOrder({
    required this.name,
    required this.customDealer,
    required this.customDealerCity,
    required this.customer,
    required this.transactionDate,
    required this.grandTotal,
  });

  // Factory constructor for creating a SaleOrder instance from JSON
  factory SaleOrder.fromJson(Map<String, dynamic> json) {
    return SaleOrder(
      name: json['name'] ?? 'N/A',
      customDealer: json['custom_dealer'] ?? 'N/A',
      customDealerCity: json['custom_dealer_city'] ?? 'N/A',
      customer: json['customer'] ?? 'N/A',
      transactionDate: json['transaction_date'] ?? 'N/A',
      grandTotal: (json['grand_total'] as num).toDouble(),
    );
  }

  // Method to convert a SaleOrder instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'custom_dealer': customDealer,
      'custom_dealer_city': customDealerCity,
      'customer': customer,
      'transaction_date': transactionDate,
      'grand_total': grandTotal,
    };
  }
}
