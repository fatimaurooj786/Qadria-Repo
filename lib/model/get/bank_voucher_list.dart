//import 'package:qadria/model/get/cash_voucher_list.dart'; // Ensure this import is correct

class BankVoucherListModel {
  final String name;
  final String type;
  final String partyType;
  final String party;
  final double amount;
  final double total;
  final String date; // New field from the API response
  final List<CashEntry> cashEntries; // Bank entries (cash_entries)

  BankVoucherListModel({
    required this.name,
    required this.type,
    required this.partyType,
    required this.party,
    required this.amount,
    required this.total,
    required this.date,
    required this.cashEntries,
  });

  // Factory method to create a BankVoucherListModel from a JSON map
  factory BankVoucherListModel.fromJson(Map<String, dynamic> json) {
    var cashEntriesJson = json['cash_entries'] as List? ?? []; // Getting the cash_entries list from JSON
    List<CashEntry> cashEntries = cashEntriesJson
        .map((entry) => CashEntry.fromJson(entry))
        .toList();

    return BankVoucherListModel(
      name: json['name'] ?? 'N/A', // Defaulting to 'N/A' if the value is null
      type: json['type'] ?? 'N/A',
      partyType: json['party_type'] ?? 'N/A',
      party: json['party'] ?? 'N/A',
      amount: (json['amount'] as num).toDouble(), // Convert amount to double
      total: (json['total'] as num).toDouble(), // Convert total to double
      date: json['date'] ?? 'N/A', // Default 'N/A' if date is missing
      cashEntries: cashEntries, // List of CashEntry objects
    );
  }

  // Method to convert a BankVoucherListModel object to JSON map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'party_type': partyType,
      'party': party,
      'amount': amount,
      'total': total,
      'date': date,
      'cash_entries': cashEntries.map((entry) => entry.toJson()).toList(), // Convert cashEntries list to JSON
    };
  }
}

// CashEntry class to model individual bank entries (originally CashEntry)
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
      account: json['account'] ?? 'N/A', // Defaulting to 'N/A' if account is missing
      amount: (json['amount'] as num).toDouble(), // Converting amount to double
      details: json['details'] ?? 'N/A', // Default to 'N/A' if details are missing
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
