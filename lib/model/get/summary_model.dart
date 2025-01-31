class SummaryModel {
  Data? data;

  SummaryModel({this.data});

  // Factory method to create a SummaryModel from JSON
  factory SummaryModel.fromJson(Map<String, dynamic> json) {
    return SummaryModel(
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }

  // Convert SummaryModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
    };
  }
}

class Data {
  List<RawData>? rawData;
  List<Total>? totals;
  List<Balance>? openingBalance;
  List<Balance>? closingBalance;

  Data({
    this.rawData,
    this.totals,
    this.openingBalance,
    this.closingBalance,
  });

  // Factory method to create a Data from JSON
  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      rawData: json['raw_data'] != null
          ? List<RawData>.from(json['raw_data'].map((x) => RawData.fromJson(x)))
          : null,
      totals: json['totals'] != null
          ? List<Total>.from(json['totals'].map((x) => Total.fromJson(x)))
          : null,
      openingBalance: json['opening_balance'] != null
          ? List<Balance>.from(
              json['opening_balance'].map((x) => Balance.fromJson(x)))
          : null,
      closingBalance: json['closing_balance'] != null
          ? List<Balance>.from(
              json['closing_balance'].map((x) => Balance.fromJson(x)))
          : null,
    );
  }

  // Convert Data to JSON
  Map<String, dynamic> toJson() {
    return {
      'raw_data': rawData?.map((x) => x.toJson()).toList(),
      'totals': totals?.map((x) => x.toJson()).toList(),
      'opening_balance': openingBalance?.map((x) => x.toJson()).toList(),
      'closing_balance': closingBalance?.map((x) => x.toJson()).toList(),
    };
  }
}

class RawData {
  List<String>? bankAccount;
  double? opening;
  double? debit;
  double? credit;
  double? openingEn;
  double? closing;
  String nickname;

  RawData({
    this.bankAccount,
    this.opening,
    this.debit,
    this.credit,
    this.openingEn,
    this.closing,
    this.nickname = '',
  });

  // Factory method to create a RawData from JSON
  factory RawData.fromJson(Map<String, dynamic> json) {
    return RawData(
      bankAccount: json['bank_account'] != null
          ? List<String>.from(json['bank_account'])
          : null,
      opening: json['opening']?.toDouble(),
      debit: json['debit']?.toDouble(),
      credit: json['credit']?.toDouble(),
      openingEn: json['opening_en']?.toDouble(),
      closing: json['closing']?.toDouble(),
      nickname: json['nick_name'] ?? '',
    );
  }

  // Convert RawData to JSON
  Map<String, dynamic> toJson() {
    return {
      'bank_account': bankAccount,
      'opening': opening,
      'debit': debit,
      'credit': credit,
      'opening_en': openingEn,
      'closing': closing,
      'nick_name': nickname,
    };
  }
}

class Total {
  String? label;
  double? value;

  Total({this.label, this.value});

  // Factory method to create a Total from JSON
  factory Total.fromJson(Map<String, dynamic> json) {
    return Total(
      label: json['label'],
      value: json['value']?.toDouble(),
    );
  }

  // Convert Total to JSON
  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'value': value,
    };
  }
}

class Balance {
  String? label;
  double? value;

  Balance({this.label, this.value});

  // Factory method to create a Balance from JSON
  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
      label: json['label'],
      value: json['value']?.toDouble(),
    );
  }

  // Convert Balance to JSON
  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'value': value,
    };
  }
}
