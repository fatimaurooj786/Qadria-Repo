import 'dart:convert';
import 'package:qadria/model/get/bank_voucher_list.dart'; // Correct import for BankVoucherListModel
import 'package:qadria/data/network/network_api_services.dart'; // Ensure NetworkApiService is correctly imported
import 'package:qadria/res/app_url.dart'; // Ensure AppUrl is correctly imported

class BankVoucherListRepo {
  final _apiService = NetworkApiService();

  // Function to fetch a list of BankVoucherListModel
  Future<List<BankVoucherListModel>> getBankVouchers({
    int limitStart = 0, // Default to start at 0
    int limit = 20, // Default limit to 20
    String? selectedPartyType,
    String? selectedParty,
    String? date,
  }) async {
    final Map<String, dynamic> queryParams = {
      'fields': '["name", "type", "party_type", "party", "amount", "total", "date", "cash_entries"]',
      'order_by': 'creation desc',
      // Default filters for docstatus = 1 (you already have this part)
      'filters': '[["docstatus", "=", 1]]',
    };

    List<List<dynamic>> filters = [
      ["docstatus", "=", 1]
    ];

    // Apply the partyType and party filter if provided
    if (selectedPartyType != null && selectedParty != null) {
      filters.add(["party", "=", selectedParty]);
    }

    // Add date filter if provided
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
      dynamic response = await _apiService.getGetApiResponse(AppUrl.bankVoucher, queryParams); // Updated API URL for bank vouchers

      // Map the response data to a list of BankVoucherListModel
      return List<BankVoucherListModel>.from(
        response['data'].map(
          (item) {
            // Map each item in the response to BankVoucherListModel
            return BankVoucherListModel.fromJson(item);
          },
        ),
      );
    } catch (e) {
      // Handle errors
      rethrow;
    }
  }

  // Placeholder for posting a new bank voucher
  postBankVoucher({
    required String date,
    required String party,
    required int amount,
    required String attachment,
  }) {
    // Implement the POST request here
  }

  // Placeholder for getting a single bank voucher's details
  getBankVoucherListDetail(String name) {
    // Implement the GET request for detailed information
  }

  // Another placeholder for posting a bank voucher (duplicate method name issue)
  postBankVoucherDuplicate({
    required String date,
    required String party,
    required int amount,
    required String attachment,
  }) {
    // Implement the POST request for creating a bank voucher here
  }

  // Placeholder for getting bank voucher detail
  getBankVoucherDetail(String name) {
    // Implement the GET request for bank voucher detail
  }
}
