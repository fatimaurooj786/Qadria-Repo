class PurchaseInvoice {
  String name;
  String supplier;
  String postingDate;
  String status;
  double grandTotal;

  PurchaseInvoice({
    required this.name,
    required this.supplier,
    required this.postingDate,
    required this.status,
    required this.grandTotal,
  });

  // Factory constructor for creating a PurchaseInvoice instance from JSON
  factory PurchaseInvoice.fromJson(Map<String, dynamic> json) {
    return PurchaseInvoice(
      name: json['name'] as String,
      supplier: json['supplier'] as String,
      postingDate: json['posting_date'] as String,
      status: json['status'] as String,
      grandTotal: (json['grand_total'] as num).toDouble(),
    );
  }

  // Method to convert a PurchaseInvoice instance to JSON
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
