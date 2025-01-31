import 'package:qadria/model/get/bank_voucher_list.dart';

import '../../data/network/network_api_services.dart';

import '../../res/app_url.dart';

class StatusRepo {
  final _apiService = NetworkApiService();

  Future<List<String>> getStatus() async {
    dynamic response = await _apiService.getGetApiResponse(AppUrl.status, null);

    return response['data']
        .map<String>(
          (item) => (item as Map<String, dynamic>)['name'] as String,
        )
        .toList();
  }
}
