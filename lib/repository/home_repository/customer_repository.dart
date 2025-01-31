
import '../../data/network/network_api_services.dart';
import '../../model/get/customer_model.dart';
import '../../res/app_url.dart';

class CustomerRepo {
  final _apiService = NetworkApiService();

  Future<List<CustomerModel>> getCustomer() async {
    dynamic response =
        await _apiService.getGetApiResponse(AppUrl.customer, null);

    return List<CustomerModel>.from(
      response['data'].map(
        (item) => CustomerModel.fromJson(item),
      ),
    );
  }
}
