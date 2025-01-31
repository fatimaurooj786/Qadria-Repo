import 'dart:developer';

import 'package:qadria/data/network/network_api_services.dart';
import 'package:qadria/model/get/delivery_note_model.dart';
import 'package:qadria/model/get/detail_models/purchase_order_detail.dart';
import 'package:qadria/model/get/purchase_order_model.dart';
import 'package:qadria/model/get/sales_invoice_model.dart';
import 'package:qadria/res/app_url.dart';

class PurchaseOrderDetailRepo {
  final _apiService = NetworkApiService();

  Future<PurchaseOrderDetail?> getPurchaseOrderDetail(String name) async {
    try {
      final Map<String, dynamic> queryParams = {
        'fields':
            '["name", "supplier","transaction_date","status","grand_total"]',
        'filters': '[["docstatus", "=", 1]]',
      };
      dynamic response = await _apiService.getGetApiResponse(
          '${AppUrl.purchaseOrder}/$name', null);

      return PurchaseOrderDetail.fromJson(response['data']);
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
