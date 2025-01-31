import 'dart:convert';
import 'dart:developer';

import 'package:qadria/model/get/delivery_note_model.dart';
import 'package:qadria/model/get/purchase_order_model.dart';
import 'package:qadria/model/get/purchase_reciept_model.dart';
import 'package:qadria/model/get/sales_invoice_model.dart';

import '../../data/network/network_api_services.dart';

import '../../res/app_url.dart';

class PurchaseReceiptRepo {
  final _apiService = NetworkApiService();

  Future<List<PurchaseReceipt>> getPurchaseReceipt({
    int? limitStart = 20,
    int? limit = 20,
    String? status,
    String? date,
    String? supplier,
  }) async {
    log('getPurchaseReceipt $limitStart $limit $status $date $supplier');
    final Map<String, dynamic> queryParams = {
      'fields': '["name", "supplier","posting_date","status","grand_total"]',
      'filters': '[["docstatus", "=", 1]]',
      'order_by': 'creation desc',
    };
    List<List<dynamic>> filters = [
      ["docstatus", "=", 1]
    ];

    if (status != null) {
      filters.add(["status", "=", status]);
    }
    if (supplier != null) {
      filters.add(["supplier", "=", supplier]);
    }
    if (date != null) {
      filters.add(["posting_date", "=", date]);
    }

    // Apply limit only when status and customer are both null
    if (status == null && supplier == null && date == null) {
      queryParams['limit_start'] = limitStart;
      queryParams['limit'] = limit;
    }

    // Convert the filters list to a JSON string
    queryParams['filters'] = jsonEncode(filters);

    print(queryParams);
    dynamic response = await _apiService.getGetApiResponse(
        AppUrl.purchaseReceipt, queryParams);

    return List<PurchaseReceipt>.from(
      response['data'].map(
        (item) => PurchaseReceipt.fromJson(item),
      ),
    );
  }
}
