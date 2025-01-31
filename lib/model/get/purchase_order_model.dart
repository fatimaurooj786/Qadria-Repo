class PurchaseOrder {
  String name;
  String supplier;
  String transactionDate;
  String status;
  double grandTotal;

  PurchaseOrder({
    required this.name,
    required this.supplier,
    required this.transactionDate,
    required this.status,
    required this.grandTotal,
  });

  // Factory constructor for creating a PurchaseOrder instance from JSON
  factory PurchaseOrder.fromJson(Map<String, dynamic> json) {
    return PurchaseOrder(
      name: json['name'] as String,
      supplier: json['supplier'] as String,
      transactionDate: json['transaction_date'] as String,
      status: json['status'] as String,
      grandTotal: (json['grand_total'] as num).toDouble(),
    );
  }

  // Method to convert a PurchaseOrder instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'supplier': supplier,
      'transaction_date': transactionDate,
      'status': status,
      'grand_total': grandTotal,
    };
  }
}
