class PurchaseReceiptDetail {
  final String name;
  final String supplier;
  final String date;  // Original date field
  final String postingDate;  // Added postingDate field
  final double totalQty;
  final double grandTotal;
  final List<Item> items;

  PurchaseReceiptDetail({
    required this.name,
    required this.supplier,
    required this.date,
    required this.postingDate,  // Added postingDate to constructor
    required this.totalQty,
    required this.grandTotal,
    required this.items,
  });

  factory PurchaseReceiptDetail.fromJson(Map<String, dynamic> json) {
    return PurchaseReceiptDetail(
      name: json['name'] ?? "N/A",
      supplier: json['supplier'] ?? "N/A",
      date: json['date'] ?? "N/A",  // Original date field
      postingDate: json['posting_date'] ?? "N/A",  // Added postingDate parsing
      totalQty: (json['total_qty'] ?? 0).toDouble(),
      grandTotal: (json['grand_total'] ?? 0).toDouble(),
      items: (json['items'] as List<dynamic>? ?? [])
          .map((item) => Item.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'supplier': supplier,
      'date': date,
      'posting_date': postingDate,  // Added postingDate to toJson
      'total_qty': totalQty,
      'grand_total': grandTotal,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class Item {
  final String itemName;
  final double qty;
  final double rate;
  final double discountPercentage;
  final double discountAmount;

  Item({
    required this.itemName,
    required this.qty,
    required this.rate,
    required this.discountPercentage,
    required this.discountAmount,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemName: json['item_name'] ?? "N/A",
      qty: (json['qty'] ?? 0).toDouble(),
      rate: (json['rate'] ?? 0).toDouble(),
      discountPercentage: (json['discount_percentage'] ?? 0).toDouble(),
      discountAmount: (json['discount_amount'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_name': itemName,
      'qty': qty,
      'rate': rate,
      'discount_percentage': discountPercentage,
      'discount_amount': discountAmount,
    };
  }
}
