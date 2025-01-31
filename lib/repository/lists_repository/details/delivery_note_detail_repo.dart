import 'dart:developer';

import 'package:qadria/data/network/network_api_services.dart';
import 'package:qadria/model/get/delivery_note_model.dart';
import 'package:qadria/model/get/detail_models/delivery_notes_detail.dart';
import 'package:qadria/model/get/sales_invoice_model.dart';
import 'package:qadria/res/app_url.dart';
import 'package:qadria/view_models/lists/details/delivery_note_detail_controller.dart';

class DeliveryNoteDetailRepo {
  final _apiService = NetworkApiService();

  Future<DeliveryNoteDetail?> getDeliveryNoteDetail(String name) async {
    try {
      final Map<String, dynamic> queryParams = {
        'fields':
            '["name","posting_date","status","customer","custom_dealer","grand_total"]',
        'filters': '[["docstatus", "=", 1]]',
      };
      dynamic response = await _apiService.getGetApiResponse(
          '${AppUrl.deliveryNote}/$name', queryParams);

      return DeliveryNoteDetail.fromJson(response['data']);
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
