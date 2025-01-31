import 'package:qadria/model/get/receiveable_leddger.dart';
import 'package:qadria/model/get/sales_invoice_model.dart';

import '../../data/network/network_api_services.dart';

import '../../res/app_url.dart';

class RecievableLedggerRepo {
  final _apiService = NetworkApiService();

  Future<List<LedgerItem>> getRecieveableLeddger({String? city}) async {
    final Map<String, dynamic> body = {
      'order_by': 'creation desc',
      'city': city, // Include the city in the body
    };

    print(body);

    dynamic response = await _apiService.getGetApiResponse(
      AppUrl.recievebaleLeddger,
      body, // Send the body with the POST request
    );

    return List<LedgerItem>.from(
      response['data'].map(
        (item) => LedgerItem.fromJson(item),
      ),
    );
  }
}
