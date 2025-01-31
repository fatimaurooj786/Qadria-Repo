import 'dart:developer';

import 'package:qadria/model/get/purchase_invoice_model.dart';
import 'package:qadria/model/get/sales_invoice_model.dart';
import 'package:qadria/model/get/summary_model.dart';

import '../../data/network/network_api_services.dart';

import '../../res/app_url.dart';

class SummaryRepository {
  final _apiService = NetworkApiService();

  Future<SummaryModel> getActivitySummary(String from, String to) async {
    log("From: $from, To: $to");
    try {
      final paramters = {"from_date": from, "to_date": to};
      dynamic response = await _apiService.getGetApiResponse(
          AppUrl.activitySummary, paramters);

      return SummaryModel.fromJson(response);
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }
}
