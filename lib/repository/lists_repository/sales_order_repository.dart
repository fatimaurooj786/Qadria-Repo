import 'dart:convert';
import 'dart:developer';

import 'package:qadria/model/get/sales_order_model.dart';

import '../../data/network/network_api_services.dart';

import '../../res/app_url.dart';

class SalesOrderRepo {
  final _apiService = NetworkApiService();

  Future<List<SaleOrder>> getSalesOrders({
    int? limitStart = 20,
    int? limit = 20,
    String? status,
    String? date,
    String? customer,
  }) async {
    log("Fetching Sales Orders repo with status: $status and customer: $customer");

    // Prepare the base query parameters
    final Map<String, dynamic> queryParams = {
      'fields':
          '["name", "custom_dealer", "custom_dealer_city", "customer","transaction_date","grand_total"]',
      'filters': '[["docstatus", "!=", 2]]',
      'order_by': 'creation desc',
    };

    // Add additional filters for status and customer if they are not null
    List<List<dynamic>> filters = [
      ["docstatus", "!=", 2]
    ];

    if (status != null) {
      filters.add(["status", "=", status]);
    }
    if (customer != null) {
      filters.add(["customer", "=", customer]);
    }
    if (date != null) {
      filters.add(["transaction_date", "=", date]);
    }

    // Apply limit only when status and customer are both null
    if (status == null && customer == null && date == null) {
      queryParams['limit_start'] = limitStart;
      queryParams['limit'] = limit;
    }

    // Convert the filters list to a JSON string
    queryParams['filters'] = jsonEncode(filters);

    print(queryParams);

    // Fetch the API response
    dynamic response =
        await _apiService.getGetApiResponse(AppUrl.salesOrderList, queryParams);

    return List<SaleOrder>.from(
      response['data'].map(
        (item) => SaleOrder.fromJson(item),
      ),
    );
  }
}
