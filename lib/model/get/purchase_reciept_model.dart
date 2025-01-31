class PurchaseReceipt {
  String name;
  String supplier;
  String postingDate;
  String status;
  double grandTotal;

  PurchaseReceipt({
    required this.name,
    required this.supplier,
    required this.postingDate,
    required this.status,
    required this.grandTotal,
  });

  // Factory constructor for creating a PurchaseReceipt instance from JSON
  factory PurchaseReceipt.fromJson(Map<String, dynamic> json) {
    return PurchaseReceipt(
      name: json['name'] as String,
      supplier: json['supplier'] as String,
      postingDate: json['posting_date'] as String,
      status: json['status'] as String,
      grandTotal: (json['grand_total'] as num).toDouble(),
    );
  }

  // Method to convert a PurchaseReceipt instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'supplier': supplier,
      'posting_date': postingDate,
      'status': status,
      'grand_total': grandTotal,
    };
  }
}
