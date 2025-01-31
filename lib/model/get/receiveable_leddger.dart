import 'dart:convert';

class LedgerItem {
  String customCustomerContact;
  String customerName;
  String city;
  double openingBalance;
  double totalAmount;
  double discountAmount;
  double totalPReturn;
  double totalPurchase;
  double totalPaid;
  String promise;
  String comments;
  double remaining;

  LedgerItem({
    required this.customCustomerContact,
    required this.customerName,
    required this.city,
    required this.openingBalance,
    required this.totalAmount,
    required this.discountAmount,
    required this.totalPReturn,
    required this.totalPurchase,
    required this.totalPaid,
    required this.promise,
    required this.comments,
    required this.remaining,
  });

  // Factory method to create an instance from JSON
  factory LedgerItem.fromJson(Map<String, dynamic> json) {
    return LedgerItem(
      customCustomerContact: json['custom_customer_contact'] as String,
      customerName: json['customer_name'] as String,
      city: json['city'] as String,
      openingBalance: (json['opening_balance'] as num).toDouble(),
      totalAmount: (json['total_amount'] as num).toDouble(),
      discountAmount: (json['discount_amount'] as num).toDouble(),
      totalPReturn: (json['total_p_return'] as num).toDouble(),
      totalPurchase: (json['total_purchase'] as num).toDouble(),
      totalPaid: (json['total_paid'] as num).toDouble(),
      promise: json['promise'] as String,
      comments: json['comments'] as String? ?? '',
      remaining: (json['remaining'] as num).toDouble(),
    );
  }

  // Method to convert the instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'custom_customer_contact': customCustomerContact,
      'customer_name': customerName,
      'city': city,
      'opening_balance': openingBalance,
      'total_amount': totalAmount,
      'discount_amount': discountAmount,
      'total_p_return': totalPReturn,
      'total_purchase': totalPurchase,
      'total_paid': totalPaid,
      'promise': promise,
      'comments': comments,
      'remaining': remaining,
    };
  }
}
