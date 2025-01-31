class SalesOrderDetail {
  final PartyBalance partyBalance;
  final Details details;
  final ApprovalRights approvalRights;

  SalesOrderDetail({
    required this.partyBalance,
    required this.details,
    required this.approvalRights,
  });

  factory SalesOrderDetail.fromJson(Map<String, dynamic> json) {
    return SalesOrderDetail(
      partyBalance: PartyBalance.fromJson(json['party_Balance']),
      details: Details.fromJson(json['details']),
      approvalRights: ApprovalRights.fromJson(json['approval_rights']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'party_Balance': partyBalance.toJson(),
      'details': details.toJson(),
      'approval_rights': approvalRights.toJson(),
    };
  }
}

class PartyBalance {
  final String party;
  final double partyBalance;

  PartyBalance({
    required this.party,
    required this.partyBalance,
  });

  factory PartyBalance.fromJson(Map<String, dynamic> json) {
    return PartyBalance(
      party: json['party'],
      partyBalance: (json['party_balance'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'party': party,
      'party_balance': partyBalance,
    };
  }
}

class Details {
  final String name;
  final String customer;
  final String transactionDate;
  final String customDealer;
  final String customApprovalStatus;
  final String deliveryDate;
  final double totalQty;
  final double grandTotal;
  final List<Item> items;

  Details({
    required this.name,
    required this.customer,
    required this.transactionDate,
    required this.customDealer,
    required this.customApprovalStatus,
    required this.deliveryDate,
    required this.totalQty,
    required this.grandTotal,
    required this.items,
  });

  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(
      name: json['name'] ?? 'N/A',
      customer: json['customer'] ?? 'N/A',
      transactionDate: json['transaction_date'] ?? 'N/A',
      customDealer: json['custom_dealer'] ?? 'N/A',
      customApprovalStatus: json['custom_approval_status'] ?? 'N/A',
      deliveryDate: json['delivery_date'] ?? 'N/A',
      totalQty: (json['total_qty'] as num).toDouble(),
      grandTotal: (json['grand_total'] as num).toDouble(),
      items: (json['items'] as List<dynamic>)
          .map((item) => Item.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'customer': customer,
      'transaction_date': transactionDate,
      'custom_dealer': customDealer,
      'custom_approval_status': customApprovalStatus,
      'delivery_date': deliveryDate,
      'total_qty': totalQty,
      'grand_total': grandTotal,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class Item {
  final String itemCode;
  final String itemName;
  final double qty;
  final double rate;
  final double amount;
  final double discountPercentage;
  final double discountAmount;

  Item({
    required this.itemCode,
    required this.itemName,
    required this.qty,
    required this.rate,
    required this.amount,
    required this.discountPercentage,
    required this.discountAmount,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemCode: json['item_code'] ?? 'N/A',
      itemName: json['item_name'] ?? 'N/A',
      qty: (json['qty'] as num).toDouble(),
      rate: (json['rate'] as num).toDouble(),
      amount: (json['amount'] as num).toDouble(),
      discountPercentage: (json['discount_percentage'] as num).toDouble(),
      discountAmount: (json['discount_amount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_code': itemCode,
      'item_name': itemName,
      'qty': qty,
      'rate': rate,
      'amount': amount,
      'discount_percentage': discountPercentage,
      'discount_amount': discountAmount,
    };
  }
}

class ApprovalRights {
  final bool canApprove;

  ApprovalRights({required this.canApprove});

  factory ApprovalRights.fromJson(Map<String, dynamic> json) {
    return ApprovalRights(
      canApprove: json['can_approve'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'can_approve': canApprove,
    };
  }
}
