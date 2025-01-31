class CashVoucherDetailModel {
  final String name;
  final String type;
  final String date;
  final String partyType;
  final String party;
  final String city;
  final double amount;

  CashVoucherDetailModel({
    required this.name,
    required this.type,
    required this.date,
    required this.partyType,
    required this.party,
    required this.city,
    required this.amount,
  });

  // Factory method to create an instance from JSON with default "N/A" for null string values
  factory CashVoucherDetailModel.fromJson(Map<String, dynamic> json) {
    return CashVoucherDetailModel(
      name: json['name'] ?? "N/A", // Default to "N/A" if null
      type: json['type'] ?? "N/A", // Default to "N/A" if null
      date: json['date'] ?? "N/A", // Default to "N/A" if null
      partyType: json['party_type'] ?? "N/A", // Default to "N/A" if null
      party: json['party'] ?? "N/A", // Default to "N/A" if null
      city: json['city'] ?? "N/A", // Default to "N/A" if null
      amount: (json['amount'] as num?)?.toDouble() ??
          0.0, // Default to 0.0 if null or not a valid number
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'date': date,
      'party_type': partyType,
      'party': party,
      'city': city,
      'amount': amount,
    };
  }
}
