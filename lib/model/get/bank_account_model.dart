// To parse this JSON data, do
//
//     final bankAccountModel = bankAccountModelFromJson(jsonString);

import 'dart:convert';

BankAccountModel bankAccountModelFromJson(String str) => BankAccountModel.fromJson(json.decode(str));

String bankAccountModelToJson(BankAccountModel data) => json.encode(data.toJson());

class BankAccountModel {
  String name;
  String account;

  BankAccountModel({
    required this.name,
    required this.account,
  });

  factory BankAccountModel.fromJson(Map<String, dynamic> json) => BankAccountModel(
    name: json["name"],
    account: json["account"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "account": account,
  };
}
