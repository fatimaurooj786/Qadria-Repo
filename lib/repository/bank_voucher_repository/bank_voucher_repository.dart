import 'dart:developer';

import 'package:qadria/model/get/detail_models/cash_voucher_detail_model.dart';

import '../../data/network/network_api_services.dart';
import '../../res/app_url.dart';

class BankVoucherRepo {
  final _apiService = NetworkApiService();

  Future<dynamic> postBankVoucher(
      {required String date,
      required String party,
      required int amount,
      required String attachment}) async {
    final Map<String, dynamic> data = {
      "type": "Receive",
      "date": date,
      "party_type": "Customer",
      "party": party,
      "amount": amount,
      "attachment": attachment
    };
    dynamic response =
        await _apiService.getPostApiResponse(AppUrl.bankVoucher, data);
    return response;
  }

  
}
