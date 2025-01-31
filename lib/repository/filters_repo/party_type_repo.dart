import 'package:qadria/model/get/bank_voucher_list.dart';

import '../../data/network/network_api_services.dart';

import '../../res/app_url.dart';

class PartyTypeRepo {
  final _apiService = NetworkApiService();

  Future<List<String>> getPartyTypes() async {
    final Map<String, dynamic> queryParams = {
      'filters': '[["name", "in", ["Customer", "Supplier", "Employee"]]]',
    };
    dynamic response =
        await _apiService.getGetApiResponse(AppUrl.partyType, queryParams);

    return response['data']
        .map<String>(
          (item) => (item as Map<String, dynamic>)['name'] as String,
        )
        .toList();
  }
}
