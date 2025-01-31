import '../../data/network/base_api_services.dart';
import '../../data/network/network_api_services.dart';
import '../../res/app_url.dart';

class AuthRepo {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> loginAPi(
      {required String email, required String password}) async {
    final Map<String, dynamic> data = {"usr": email, "pwd": password};
    try {
      dynamic response =
          await _apiServices.getPostApiResponse(AppUrl.login, data);

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
