import 'dart:developer';

import 'package:qadria/data/network/network_api_services.dart';
import 'package:qadria/model/get/detail_models/purchase_invoice_detail.dart';
import 'package:qadria/model/get/purchase_invoice_model.dart';
import 'package:qadria/model/get/sales_invoice_model.dart';
import 'package:qadria/res/app_url.dart';

class PurchaseInvoiceDetailRepo {
  final _apiService = NetworkApiService();

  Future<PurchaseInvoiceDetail?> getPurchaseInvoiceDetail(String name) async {
    try {
      final Map<String, dynamic> queryParams = {
        'fields': '["name", "supplier","posting_date","status","grand_total"]',
        'filters': '[["docstatus", "=", 1]]',
        'order_by': 'creation desc',
      };
      dynamic response = await _apiService.getGetApiResponse(
          '${AppUrl.purchaseInvoiceList}/$name', queryParams);

      return PurchaseInvoiceDetail.fromJson(response['data']);
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
