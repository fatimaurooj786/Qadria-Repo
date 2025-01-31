class CashVoucherListModel {
  final String name;
  final String type;
  final String partyType;
  final String party;
  final double amount;
  final double total;
  final String date; // New field from the API response
  final List<CashEntry> cashEntries; // New field for cash entries

  CashVoucherListModel({
    required this.name,
    required this.type,
    required this.partyType,
    required this.party,
    required this.amount,
    required this.total,
    required this.date,
    required this.cashEntries,
  });

  // Factory method to create a CashVoucherList from a JSON map
  factory CashVoucherListModel.fromJson(Map<String, dynamic> json) {
    var cashEntriesJson = json['cash_entries'] as List? ?? [];
    List<CashEntry> cashEntries = cashEntriesJson
        .map((entry) => CashEntry.fromJson(entry))
        .toList();

    return CashVoucherListModel(
      name: json['name'] ?? 'N/A',
      type: json['type'] ?? 'N/A',
      partyType: json['party_type'] ?? 'N/A',
      party: json['party'] ?? 'N/A',
      amount: (json['amount'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      date: json['date'] ?? 'N/A',
      cashEntries: cashEntries,
    );
  }

  // Method to convert a CashVoucherList object to JSON map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'party_type': partyType,
      'party': party,
      'amount': amount,
      'total': total,
      'date': date,
      'cash_entries': cashEntries.map((entry) => entry.toJson()).toList(),
    };
  }
}

// CashEntry class to model individual cash entries
class CashEntry {
  final String account;
  final double amount;
  final String details;

  CashEntry({
    required this.account,
    required this.amount,
    required this.details,
  });

  // Factory method to create a CashEntry from a JSON map
  factory CashEntry.fromJson(Map<String, dynamic> json) {
    return CashEntry(
      account: json['account'] ?? 'N/A',
      amount: (json['amount'] as num).toDouble(),
      details: json['details'] ?? 'N/A',
    );
  }

  // Method to convert a CashEntry object to JSON map
  Map<String, dynamic> toJson() {
    return {
      'account': account,
      'amount': amount,
      'details': details,
    };
  }
}
