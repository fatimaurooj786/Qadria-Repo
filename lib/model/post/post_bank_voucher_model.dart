import 'dart:convert';

BankVoucherModel bankVoucherModelFromJson(String str) => BankVoucherModel.fromJson(json.decode(str));

String bankVoucherModelToJson(BankVoucherModel data) => json.encode(data.toJson());

class BankVoucherModel {
  int? id;
  String type;
  String? attachment;
  DateTime date;
  String partyType;
  String party;
  String companyBank;
  String companyAccountCoa;
  String bankName;
  String city;
  String chequeNo;
  DateTime chequeDate;
  int amount;

  BankVoucherModel({
    this.id,
    required this.type,
    required this.date,
    this.attachment, // Make attachment nullable
    required this.partyType,
    required this.party,
    required this.companyBank,
    required this.companyAccountCoa,
    required this.bankName,
    required this.city,
    required this.chequeNo,
    required this.chequeDate,
    required this.amount,
  });

  factory BankVoucherModel.fromJson(Map<String, dynamic> json) => BankVoucherModel(
    id: json["id"],
    type: json["type"],
    date: DateTime.parse(json["date"]),
    attachment: json['attachment'], // Accept null value
    partyType: json["party_type"],
    party: json["party"],
    companyBank: json["company_bank"],
    companyAccountCoa: json["company_account_coa"],
    bankName: json["bank_name"],
    city: json["city"],
    chequeNo: json["cheque_no"],
    chequeDate: DateTime.parse(json["cheque_date"]),
    amount: json["amount"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "attachment": attachment, // Include attachment in JSON if not null
    "party_type": partyType,
    "party": party,
    "company_bank": companyBank,
    "company_account_coa": companyAccountCoa,
    "bank_name": bankName,
    "city": city,
    "cheque_no": chequeNo,
    "cheque_date": "${chequeDate.year.toString().padLeft(4, '0')}-${chequeDate.month.toString().padLeft(2, '0')}-${chequeDate.day.toString().padLeft(2, '0')}",
    "amount": amount,
  };
}
