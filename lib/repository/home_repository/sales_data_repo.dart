import 'package:qadria/model/get/delivery_note_model.dart';
import 'package:qadria/model/get/sales_data_model.dart';

import '../../data/network/network_api_services.dart';

import '../../res/app_url.dart';

class SalesDataRepo {
  final _apiService = NetworkApiService();

  Future<List<SalesData>> getSalesData() async {
    // final Map<String, dynamic> queryParams = {
    //   'fields':
    //       '["name","posting_date","status","customer","custom_dealer","grand_total"]',
    //   'filters': '[["docstatus", "=", 1]]',
    // };
    dynamic response =
        await _apiService.getGetApiResponse(AppUrl.monthlySales, null);

    return List<SalesData>.from(
      response['message'].map(
        (item) => SalesData.fromJson(item),
      ),
    );
  }
}
