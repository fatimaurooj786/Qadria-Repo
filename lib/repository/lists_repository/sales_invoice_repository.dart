import 'dart:convert';
import 'dart:developer';

import 'package:qadria/model/get/sales_invoice_model.dart';

import '../../data/network/network_api_services.dart';

import '../../res/app_url.dart';

class SalesInvoiceRepo {
  final _apiService = NetworkApiService();

  Future<List<SalesInvoice>> getSalesInvoices({
    int? limitStart = 20,
    int? limit = 20,
    String? status,
    String? date,
    String? customer,
  }) async {
    log("Fetching sales invoices");
    final Map<String, dynamic> queryParams = {
      'fields':
          '["name", "customer", "posting_date","status","grand_total"]',
      'filters': '[["docstatus", "=", 1]]',
      'order_by': 'creation desc',
    };

    List<List<dynamic>> filters = [
      ["docstatus", "=", 1]
    ];

    if (status != null) {
      filters.add(["status", "=", status]);
    }
    if (customer != null) {
      filters.add(["customer", "=", customer]);
    }
    if (date != null) {
      filters.add(["posting_date", "=", date]);
    }

    if (status == null && customer == null && date == null) {
      queryParams['limit_start'] = limitStart;
      queryParams['limit'] = limit;
    }

    // Convert the filters list to a JSON string
    queryParams['filters'] = jsonEncode(filters);

    dynamic response = await _apiService.getGetApiResponse(
        AppUrl.salesInvoiceList, queryParams);

    return List<SalesInvoice>.from(
      response['data'].map(
        (item) => SalesInvoice.fromJson(item),
      ),
    );
  }
}
