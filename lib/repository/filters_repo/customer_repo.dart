import 'dart:developer';

import 'package:qadria/model/get/bank_voucher_list.dart';

import '../../data/network/network_api_services.dart';

import '../../res/app_url.dart';

class CustomerRepo {
  final _apiService = NetworkApiService();

  Future<List<String>> getCustomers() async {
    final Map<String, dynamic> queryParams = {
      // 'fields': '["name", "type", "party_type" ,"party", "amount", "total"]',
      // 'filters': '[["name", "in", ["Customer", "Supplier", "Employee"]]]',
      // limit_page_length
      'limit_page_length': 1000,
    };
    dynamic response =
        await _apiService.getGetApiResponse(AppUrl.customer, queryParams);
    log('Customer Response: ${response['data'][0]['name']}');

    return response['data']
        .map<String>(
          (item) => (item as Map<String, dynamic>)['name'] as String,
        )
        .toList();
  }
}
