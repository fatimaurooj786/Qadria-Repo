import 'dart:developer';

import 'package:qadria/data/network/network_api_services.dart';
import 'package:qadria/model/get/detail_models/sales_invoice_detail.dart';
import 'package:qadria/res/app_url.dart';

class SalesInvoiceDetailRepo {
  final _apiService = NetworkApiService();

  Future<SalesInvoiceDetail?> getSalesInvoiceDetail(String name) async {
    try {
      final Map<String, dynamic> queryParams = {
        'fields':
            '["name", "customer", "custom_dealer", "posting_date", "status", "grand_total"]',
        'filters': '[["docstatus", "=", 1]]',
      };
      // Fetch the data from the API
      dynamic response = await _apiService.getGetApiResponse(
          '${AppUrl.salesInvoiceList}/$name', queryParams);

      // Check if 'data' exists in the response and map it to SalesInvoiceDetail
      if (response != null && response['data'] != null) {
        return SalesInvoiceDetail.fromJson(response['data']);
      } else {
        log("Error: Response data is null.");
      }
    } catch (e) {
      log("Error fetching sales invoice details: ${e.toString()}");
    }
    return null;
  }
}
