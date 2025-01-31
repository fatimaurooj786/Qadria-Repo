class SalesInvoiceDetail {
  final String name;
  final String customer;
  final String customDealer;
  final String customDealerCity;
  final String transactionDate;
  final String customBiltyNo;
  final String customDriverContact;
  final String customGoodsForwarder;
  final double totalQty;
  final double grandTotal;
  final List<Item> items;
  final String postingDate; // Added posting_date field

  SalesInvoiceDetail({
    required this.name,
    required this.customDealer,
    required this.customDealerCity,
    required this.customer,
    required this.transactionDate,
    required this.customBiltyNo,
    required this.customDriverContact,
    required this.customGoodsForwarder,
    required this.totalQty,
    required this.grandTotal,
    required this.items,
    required this.postingDate, // Include in the constructor
  });

  factory SalesInvoiceDetail.fromJson(Map<String, dynamic> json) {
    return SalesInvoiceDetail(
      name: json['name'] ?? "N/A",
      customDealer: json['custom_dealer'] ?? "N/A",
      customDealerCity: json['custom_dealer_city'] ?? "N/A",
      customer: json['customer'] ?? "N/A",
      transactionDate: json['transaction_date'] ?? "N/A",
      customBiltyNo: json['custom_bilty_no'] ?? "N/A",
      customDriverContact: json['custom_driver_contact'] ?? "N/A",
      customGoodsForwarder: json['custom_goods_forwarder'] ?? "N/A",
      totalQty: (json['total_qty'] ?? 0).toDouble(),
      grandTotal: (json['grand_total'] ?? 0).toDouble(),
      items: (json['items'] as List<dynamic>? ?? [])
          .map((item) => Item.fromJson(item))
          .toList(),
      postingDate: json['posting_date'] ?? "N/A", // Handle posting_date field
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'custom_dealer': customDealer,
      'custom_dealer_city': customDealerCity,
      'customer': customer,
      'transaction_date': transactionDate,
      'custom_bilty_no': customBiltyNo,
      'custom_driver_contact': customDriverContact,
      'custom_goods_forwarder': customGoodsForwarder,
      'total_qty': totalQty,
      'grand_total': grandTotal,
      'items': items.map((item) => item.toJson()).toList(),
      'posting_date': postingDate, // Include posting_date in toJson
    };
  }
}

class Item {
  final String itemName;
  final double qty;
  final double rate;
  final double amount;
  final double discountPercentage;
  final double discountAmount;

  Item({
    required this.itemName,
    required this.qty,
    required this.rate,
    required this.amount,
    required this.discountPercentage,
    required this.discountAmount,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemName: json['item_name'] ?? "N/A",
      qty: (json['qty'] ?? 0).toDouble(),
      rate: (json['rate'] ?? 0).toDouble(),
      amount: (json['amount'] ?? 0).toDouble(),
      discountPercentage: (json['discount_percentage'] ?? 0).toDouble(),
      discountAmount: (json['discount_amount'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_name': itemName,
      'qty': qty,
      'rate': rate,
      'amount': amount,
      'discount_percentage': discountPercentage,
      'discount_amount': discountAmount,
    };
  }
}
