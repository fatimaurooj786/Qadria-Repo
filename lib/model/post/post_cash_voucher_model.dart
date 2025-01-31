import 'dart:convert';

CashVoucherModel cashVoucherModelFromJson(String str) => CashVoucherModel.fromJson(json.decode(str));

String cashVoucherModelToJson(CashVoucherModel data) => json.encode(data.toJson());

class CashVoucherModel {
  int? id;
  String type;
  DateTime date;
  String partyType;
  String party;
  int amount;
  String? attachment; // Make attachment nullable

  CashVoucherModel({
    this.id,
    required this.type,
    required this.date,
    required this.partyType,
    required this.party,
    required this.amount,
    this.attachment, // Make attachment optional
  });

  factory CashVoucherModel.fromJson(Map<String, dynamic> json) => CashVoucherModel(
    id: json["id"],
    type: json["type"],
    date: DateTime.parse(json["date"]),
    partyType: json["party_type"],
    party: json["party"],
    amount: json["amount"],
    attachment: json["attachment"], // Parse attachment from JSON
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "date":
    "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "party_type": partyType,
    "party": party,
    "amount": amount,
    if (attachment != null) "attachment": attachment, // Include attachment if not null
  };
}

