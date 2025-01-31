class PurchaseInvoiceDetail {
  final String supplier;
  final DateTime? dueDate;
  final DateTime? date;
  final double totalQty;
  final double grandTotal;
  final List<Item> items;

  PurchaseInvoiceDetail({
    required this.supplier,
    required this.dueDate,
    required this.date,
    required this.totalQty,
    required this.grandTotal,
    required this.items,
  });

  factory PurchaseInvoiceDetail.fromJson(Map<String, dynamic> json) {
    return PurchaseInvoiceDetail(
      supplier: json['supplier'] ?? 'N/A',
      dueDate: json['due_date'] != null && json['due_date'] != ''
          ? DateTime.tryParse(json['due_date'])
          : null,
      date: json['date'] != null && json['date'] != ''
          ? DateTime.tryParse(json['date'])
          : null,
      totalQty: json['total_qty'] ?? 0.0,
      grandTotal: json['grand_total'] ?? 0.0,
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => Item.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'supplier': supplier,
      'due_date': dueDate?.toIso8601String(),
      'date': date?.toIso8601String(),
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
  final double discountAmount;
  final double amount;

  Item({
    required this.itemName,
    required this.qty,
    required this.rate,
    required this.discountAmount,
    required this.amount,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemName: json['item_name'] ?? 'Unknown Item',
      qty: json['qty'] ?? 0.0,
      rate: json['rate'] ?? 0.0,
      discountAmount: json['discount_amount'] ?? 0.0,
      amount: json['amount'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_name': itemName,
      'qty': qty,
      'rate': rate,
      'discount_amount': discountAmount,
      'amount': amount,
    };
  }
}
