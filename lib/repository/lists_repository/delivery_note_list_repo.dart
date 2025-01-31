import 'dart:convert';

import 'package:qadria/model/get/delivery_note_model.dart';
import 'package:qadria/model/get/sales_invoice_model.dart';

import '../../data/network/network_api_services.dart';

import '../../res/app_url.dart';

class DeliveryNoteListRepo {
  final _apiService = NetworkApiService();

  Future<List<DeliveryNote>> getDeliveryNotes({
    int? limitStart = 20,
    int? limit = 20,
    String? status,
    String? date,
    String? customer,
  }) async {
    final Map<String, dynamic> queryParams = {
      'fields':
          '["name","posting_date","status","customer","custom_dealer","grand_total"]',
      'filters': '[["docstatus", "=", 1]]',
      'order_by': 'creation desc',
    };

    // Add additional filters for status and customer if they are not null
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

    // Apply limit only when status and customer are both null
    if (status == null && customer == null && date == null) {
      queryParams['limit_start'] = limitStart;
      queryParams['limit'] = limit;
    }

    // Convert the filters list to a JSON string
    queryParams['filters'] = jsonEncode(filters);

    print(queryParams);
    dynamic response =
        await _apiService.getGetApiResponse(AppUrl.deliveryNote, queryParams);

    return List<DeliveryNote>.from(
      response['data'].map(
        (item) => DeliveryNote.fromJson(item),
      ),
    );
  }
}
