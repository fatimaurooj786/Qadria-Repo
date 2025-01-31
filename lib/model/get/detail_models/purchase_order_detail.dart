class PurchaseOrderDetail {
  final String name;
  final String supplier;
  final DateTime? date;
  final double totalQty;
  final double grandTotal;
  final String setWarehouse;
  final List<Item> items;
  final String transactionDate;  // Added the transactionDate field

  PurchaseOrderDetail({
    required this.name,
    required this.supplier,
    required this.date,
    required this.totalQty,
    required this.grandTotal,
    required this.setWarehouse,
    required this.items,
    required this.transactionDate,  // Include in constructor
  });

  factory PurchaseOrderDetail.fromJson(Map<String, dynamic> json) {
    return PurchaseOrderDetail(
      name: json['name'] ?? "N/A",
      supplier: json['supplier'] ?? "N/A",
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      totalQty: json['total_qty'] ?? 0.0,
      grandTotal: json['grand_total'] ?? 0.0,
      setWarehouse: json['set_warehouse'] ?? "N/A",
      items:
          (json['items'] as List).map((item) => Item.fromJson(item)).toList(),
      transactionDate: json['transaction_date'] ?? "N/A",  // Parsing transactionDate
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'supplier': supplier,
      'date': date?.toIso8601String(),
      'total_qty': totalQty,
      'grand_total': grandTotal,
      'set_warehouse': setWarehouse,
      'items': items.map((item) => item.toJson()).toList(),
      'transaction_date': transactionDate,  // Adding transactionDate to JSON
    };
  }
}

class Item {
  final String itemName;
  final double qty;
  final double rate;
  final DateTime? scheduleDate;
  final String uom;
  final double amount;
  final double discountPercentage;
  final double discountAmount;

  Item({
    required this.itemName,
    required this.qty,
    required this.rate,
    required this.scheduleDate,
    required this.uom,
    required this.amount,
    required this.discountPercentage,
    required this.discountAmount,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemName: json['item_name'] ?? "N/A",
      qty: json['qty'] ?? 0.0,
      rate: json['rate'] ?? 0.0,
      scheduleDate: json['schedule_date'] != null
          ? DateTime.parse(json['schedule_date'])
          : null,
      uom: json['uom'] ?? "N/A",
      amount: json['amount'] ?? 0.0,
      discountPercentage: json['discount_percentage'] ?? 0.0,
      discountAmount: json['discount_amount'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_name': itemName,
      'qty': qty,
      'rate': rate,
      'schedule_date': scheduleDate?.toIso8601String(),
      'uom': uom,
      'amount': amount,
      'discount_percentage': discountPercentage,
      'discount_amount': discountAmount,
    };
  }
}
