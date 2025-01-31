class DeliveryNoteDetail {
  final String name;
  final String customer;
  final String customDealer;
  final String customDealerCity;
  final double totalQty;
  final double grandTotal;
  final List<Item> items;

  DeliveryNoteDetail({
    required this.name,
    required this.customer,
    required this.customDealer,
    required this.customDealerCity,
    required this.totalQty,
    required this.grandTotal,
    required this.items,
  });

  factory DeliveryNoteDetail.fromJson(Map<String, dynamic> json) {
    return DeliveryNoteDetail(
      name: json['name'] ?? "N/A",
      customer: json['customer'] ?? "N/A",
      customDealer: json['custom_dealer'] ?? "N/A",
      customDealerCity: json['custom_dealer_city'] ?? "N/A",
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
      'customer': customer,
      'custom_dealer': customDealer,
      'custom_dealer_city': customDealerCity,
      'total_qty': totalQty,
      'grand_total': grandTotal,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class Item {
  final String itemName;
  final String uom;
  final double qty;
  final double rate;
  final double amount;
  final double discountPercentage;
  final double discountAmount;

  Item({
    required this.itemName,
    required this.uom,
    required this.qty,
    required this.rate,
    required this.amount,
    required this.discountPercentage,
    required this.discountAmount,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemName: json['item_name'] ?? "N/A",
      uom: json['uom'] ?? "N/A",
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
      'uom': uom,
      'qty': qty,
      'rate': rate,
      'amount': amount,
      'discount_percentage': discountPercentage,
      'discount_amount': discountAmount,
    };
  }
}
