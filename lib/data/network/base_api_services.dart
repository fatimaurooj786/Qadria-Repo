abstract class BaseApiServices {
  Future<dynamic> getGetApiResponse(
      String url, Map<String, dynamic>? queryParameters);

  Future<dynamic> getPostApiResponse(
      String url, Map<String, dynamic> data);

  Future<dynamic> getPutApiResponse(
      String url, dynamic data, Map<String, dynamic>? queryParameters);

  Future<dynamic> getDeleteApiResponse(
      String url, Map<String, dynamic>? queryParameters);
}
