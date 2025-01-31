import 'dart:developer';

import 'package:qadria/data/network/network_api_services.dart';
import 'package:qadria/model/get/delivery_note_model.dart';
import 'package:qadria/model/get/detail_models/purchase_receipts_detail.dart';
import 'package:qadria/model/get/purchase_order_model.dart';
import 'package:qadria/model/get/purchase_reciept_model.dart';
import 'package:qadria/model/get/sales_invoice_model.dart';
import 'package:qadria/res/app_url.dart';

class PurchaseRecieptDetailRepo {
  final _apiService = NetworkApiService();

  Future<PurchaseReceiptDetail?> getPurchaseReceiptDetail(String name) async {
    try {
      final Map<String, dynamic> queryParams = {
        'fields': '["name", "supplier","posting_date","status","grand_total"]',
        'filters': '[["docstatus", "=", 1]]',
      };
      dynamic response = await _apiService.getGetApiResponse(
          '${AppUrl.purchaseReceipt}/$name', queryParams);

      return PurchaseReceiptDetail.fromJson(response['data']);
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
