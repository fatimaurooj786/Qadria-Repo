import 'package:qadria/model/get/bank_voucher_list.dart';

import '../../data/network/network_api_services.dart';

import '../../res/app_url.dart';

class CityRepo {
  final _apiService = NetworkApiService();

  Future<List<String>> getCities() async {
    // final Map<String, dynamic> queryParams = {
    //   'fields': '["name", "type", "party_type" ,"party", "amount", "total"]',
    //   'filters': '[["name", "in", ["Customer", "Supplier", "Employee"]]]',
    // };
    dynamic response = await _apiService.getGetApiResponse(AppUrl.city, null);

    return response['data']
        .map<String>(
          (item) => (item as Map<String, dynamic>)['name'] as String,
        )
        .toList();
  }
}
