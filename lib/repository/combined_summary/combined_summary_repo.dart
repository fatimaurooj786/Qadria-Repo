import 'dart:developer';

import 'package:qadria/model/get/combined_summary_model.dart';
import 'package:qadria/model/get/purchase_invoice_model.dart';
import 'package:qadria/model/get/sales_invoice_model.dart';
import 'package:qadria/model/get/summary_model.dart';

import '../../data/network/network_api_services.dart';

import '../../res/app_url.dart';

class CombinedSummaryRepo {
  final _apiService = NetworkApiService();

  Future<CombinedSummaryModel> getCombinedActivitySummary(
      String from, String to) async {
    log("From: $from, To: $to");
    try {
      final paramters = {"from_date": from, "to_date": to};
      dynamic response = await _apiService.getGetApiResponse(
          AppUrl.combinedActivitySummary, paramters);

      // print("combined activity summary: $response");
      return CombinedSummaryModel.fromJson(response);
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }
}
