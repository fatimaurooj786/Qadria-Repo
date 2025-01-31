import 'dart:convert';
import 'package:qadria/model/get/cash_voucher_list.dart';
import 'package:qadria/view/bottom_nav/home/cash_voucher/cash_voucher_list.dart';
import '../../data/network/network_api_services.dart';
import '../../res/app_url.dart';

class CashVoucherListRepo {
  final _apiService = NetworkApiService();

  Future<List<CashVoucherListModel>> getCashVouchers({
    int? limitStart = 20,
    int? limit = 20,
    String? selectedPartyType,
    String? selectedParty,
    String? date,
  }) async {
    final Map<String, dynamic> queryParams = {
      'fields': '["name", "type", "party_type", "party", "amount", "total", "date", "cash_entries"]',
      'filters': '[["docstatus", "=", 1]]',
      'order_by': 'creation desc',
    };

    // Default filters for docstatus = 1 (you already have this part)
    List<List<dynamic>> filters = [
      ["docstatus", "=", 1]
    ];

    // Add the party filter if provided
    if (selectedPartyType != null && selectedParty != null) {
      filters.add(["party", "=", selectedParty]);
    }

    // Add the date filter if provided
    if (date != null) {
      filters.add(["date", "=", date]);
    }

    // Apply pagination limits if no date/party filters are set
    if (selectedPartyType == null && selectedParty == null && date == null) {
      queryParams['limit_start'] = limitStart;
      queryParams['limit'] = limit;
    }

    // Add the filters to queryParams
    queryParams['filters'] = jsonEncode(filters);

    try {
      // Get API response
      dynamic response = await _apiService.getGetApiResponse(AppUrl.cashVoucher, queryParams);

      // Map the response data to a list of CashVoucherListModel
      return List<CashVoucherListModel>.from(
        response['data'].map(
          (item) {
            // Map each item in the response to CashVoucherListModel
            return CashVoucherListModel.fromJson(item);
          },
        ),
      );
    } catch (e) {
      // Handle errors
      rethrow;
    }
  }

  postCashVoucher({required String date, required String party, required int amount, required String attachment}) {}

  getCashVoucherListDetail(name) {}

  postbankVoucher({required String date, required String party, required int amount, required String attachment}) {}
}
