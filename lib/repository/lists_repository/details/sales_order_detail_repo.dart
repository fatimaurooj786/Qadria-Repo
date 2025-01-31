import 'dart:convert';
import 'dart:developer';

import 'package:qadria/data/network/network_api_services.dart';
import 'package:qadria/model/get/detail_models/sales_order_detail.dart';
import 'package:qadria/model/get/sales_order_model.dart';
import 'package:qadria/res/app_url.dart';

class SalesOrderDetailRepo {
  final _apiService = NetworkApiService();

  Future<SalesOrderDetail?> getSalesOrderDetail(
      {String? orderId, String? email}) async {
    log("Sales orderId : $orderId, Email: $email");
    try {
      final Map<String, dynamic> queryParams = {
        'sales_order': orderId,
        'email': email
      };
      dynamic response =
          await _apiService.getGetApiResponse(AppUrl.partyBalance, queryParams);

      return SalesOrderDetail.fromJson(response);
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<String> approvalOrder({String? orderId, String? email}) async {
    try {
      final Map<String, dynamic> queryParams = {
        'sales_order_id': orderId,
        'user_email': email
      };
      // Fetch the response
      dynamic response = await _apiService.getGetApiResponse(
          AppUrl.salesApproval, queryParams);
      log("Approval Response: ${response.runtimeType}");

      // Explicitly cast to Map<String, dynamic> if needed
      if (response is Map<String, dynamic>) {
        log("Approval Response: ${response['status']}");
        return response['status'] ?? 'Unknown status';
      } else {
        log("Unexpected response type: ${response.runtimeType}");
        return 'Error: Unexpected response type';
      }
    } catch (e) {
      log(e.toString());
      return 'Error';
    }
  }
}
