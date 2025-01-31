import '../../data/network/network_api_services.dart';
import '../../model/get/bank_account_model.dart';
import '../../res/app_url.dart';

class BackAccountRepo {
  final _apiService = NetworkApiService();

  Future<List<BankAccountModel>> getBankAccount() async {
    final Map<String, dynamic> queryParams = {
      'fields': '["name","account"]',
    };
    dynamic response =
    await _apiService.getGetApiResponse(AppUrl.bankAccount, queryParams);

    return List<BankAccountModel>.from(
      response['data'].map(
            (item) => BankAccountModel.fromJson(item),
      ),
    );
  }
}
