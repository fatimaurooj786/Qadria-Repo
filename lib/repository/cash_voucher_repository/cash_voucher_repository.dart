import 'dart:developer';

import 'package:qadria/model/get/detail_models/cash_voucher_detail_model.dart';

import '../../data/network/network_api_services.dart';
import '../../res/app_url.dart';

class CashVoucherRepo {
  final _apiService = NetworkApiService();

  Future<dynamic> postCashVoucher(
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
        await _apiService.getPostApiResponse(AppUrl.cashVoucher, data);
    return response;
  }

  Future<CashVoucherDetailModel?> getCashVoucherDetail(String name) async {
    try {
      final Map<String, dynamic> queryParams = {
        'fields': '["type","date","party_type","party","city","amount"]',
        'filters': '[["docstatus", "=", 1]]',
      };
      dynamic response = await _apiService.getGetApiResponse(
          '${AppUrl.cashVoucher}/$name', queryParams);

      return CashVoucherDetailModel.fromJson(response['data']);
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
