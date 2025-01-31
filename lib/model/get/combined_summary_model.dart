class CombinedSummaryModel {
  final List<BankData>? data;
  final double? stoutTotalBalance;
  final double? qadriaTotalBalance;
  final double? stoutQadriaTotal;

  CombinedSummaryModel({
    this.data,
    this.stoutTotalBalance,
    this.qadriaTotalBalance,
    this.stoutQadriaTotal,
  });

  factory CombinedSummaryModel.fromJson(Map<String, dynamic> json) {
    return CombinedSummaryModel(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => BankData.fromJson(e))
          .toList(),
      stoutTotalBalance: json['stout_total_balance']?.toDouble(),
      qadriaTotalBalance: json['qadria_total_balance']?.toDouble(),
      stoutQadriaTotal: json['stout_qadria_total']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.map((e) => e.toJson()).toList(),
      'stout_total_balance': stoutTotalBalance,
      'qadria_total_balance': qadriaTotalBalance,
      'stout_qadria_total': stoutQadriaTotal,
    };
  }
}

class BankData {
  final String? bankAccount;
  final double? openingStout;
  final double? debitStout;
  final double? creditStout;
  final double? closingStout;
  final String? bankAccountQadria;
  final double? openingQadria;
  final double? debitQadria;
  final double? creditQadria;
  final double? closingQadria;

  BankData({
    this.bankAccount,
    this.openingStout,
    this.debitStout,
    this.creditStout,
    this.closingStout,
    this.bankAccountQadria,
    this.openingQadria,
    this.debitQadria,
    this.creditQadria,
    this.closingQadria,
  });

  factory BankData.fromJson(Map<String, dynamic> json) {
    return BankData(
      bankAccount: json['bank_account'] as String?,
      openingStout: json['opening_stout']?.toDouble(),
      debitStout: json['debit_stout']?.toDouble(),
      creditStout: json['credit_stout']?.toDouble(),
      closingStout: json['closing_stout']?.toDouble(),
      bankAccountQadria: json['bank_account_qadria'] as String?,
      openingQadria: json['opening_qadria']?.toDouble(),
      debitQadria: json['debit_qadria']?.toDouble(),
      creditQadria: json['credit_qadria']?.toDouble(),
      closingQadria: json['closing_qadria']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bank_account': bankAccount,
      'opening_stout': openingStout,
      'debit_stout': debitStout,
      'credit_stout': creditStout,
      'closing_stout': closingStout,
      'bank_account_qadria': bankAccountQadria,
      'opening_qadria': openingQadria,
      'debit_qadria': debitQadria,
      'credit_qadria': creditQadria,
      'closing_qadria': closingQadria,
    };
  }
}
