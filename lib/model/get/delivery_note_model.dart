class DeliveryNote {
  String name;
  String postingDate;
  String status;
  String customer;
  String? customDealer; // Nullable field as custom_dealer can be null
  double grandTotal;

  DeliveryNote({
    required this.name,
    required this.postingDate,
    required this.status,
    required this.customer,
    this.customDealer, // Nullable field, can be null
    required this.grandTotal,
  });

  // Factory constructor for creating a DeliveryNote instance from JSON
  factory DeliveryNote.fromJson(Map<String, dynamic> json) {
    return DeliveryNote(
      name: json['name'] as String,
      postingDate: json['posting_date'] as String,
      status: json['status'] as String,
      customer: json['customer'] as String,
      customDealer: json['custom_dealer'] as String?, // Nullable type
      grandTotal: (json['grand_total'] as num).toDouble(),
    );
  }

  // Method to convert a DeliveryNote instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'posting_date': postingDate,
      'status': status,
      'customer': customer,
      'custom_dealer': customDealer,
      'grand_total': grandTotal,
    };
  }
}
