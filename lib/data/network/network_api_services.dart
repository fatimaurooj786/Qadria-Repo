import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../res/app_url.dart';
import '../app_exceptions.dart';
import 'base_api_services.dart';

class NetworkApiService implements BaseApiServices {
  final Dio _dio = Dio();
  final HeaderManager _headerManager = HeaderManager();

  final String _baseUrl = AppUrl.baseUrl;

  @override
  Future<dynamic> getGetApiResponse(
      String endpoint, dynamic queryParams) async {
    try {
      final url = _baseUrl + endpoint;
      log('GET API URL: $url' ' Query Params: $queryParams');
      final response = await _dio.get(url,
          options: _headerManager.defaultOptions, queryParameters: queryParams);
      log('Response: $response');
      return returnResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<dynamic> getPostApiResponse(String endpoint, dynamic data) async {
    try {
      final url = _baseUrl + endpoint;
      log('POST API URL: $url');
      final response = await _dio.post(url,
          data: data, options: _headerManager.defaultOptions);
      log('Response: $response');
      log(data.toString());
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<dynamic> getPutApiResponse(
      String endpoint, dynamic data, dynamic queryParams) async {
    try {
      final url = _baseUrl + endpoint;
      log('PUT API URL: $url');
      final response = await _dio.put(url,
          data: data, options: _headerManager.defaultOptions);
      log(data.toString());
      return returnResponse(response);
    } on DioException catch (e) {
      log(e.toString());
      log(e.response.toString());
      throw _handleDioError(e);
    }
  }

  @override
  Future<dynamic> getDeleteApiResponse(
      String endpoint, dynamic queryParams) async {
    try {
      final url = _baseUrl + endpoint;
      log('DELETE API URL: $url');
      final response =
          await _dio.delete(url, options: _headerManager.defaultOptions);
      return returnResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  dynamic returnResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        return response.data;
      case 400:
        throw BadRequestException(response.data.toString());
      case 401:
        throw UnauthorisedException(response.data.toString());
      case 404:
        throw NotFoundException(response.data.toString());
      case 500:
        throw InternalServerErrorException(response.data.toString());
      default:
        throw FetchDataException(
            'Error occurred while communicating with server');
    }
  }
}

class HeaderManager {
  final Map<String, dynamic> _defaultHeaders = {
    'Content-Type': 'application/json; charset=UTF-8',
    'accept': 'application/json',
    // 'Authorization': 'token a34f3188a1de44b:4ccd4e7c271a481',

    'Authorization':
        'token a12dd257880a838:995ef71858126ee', // API Key: API Secret
  };

  Options get defaultOptions => Options(
        receiveTimeout: const Duration(seconds: 10),
        headers: _defaultHeaders,
      );
}

AppException _handleDioError(DioException error) {
  if (error.error is SocketException) {
    return NoInternetException('');
  } else if (error.response != null) {
    final errorMessage = error.response!.data['message'];
    debugPrint("$errorMessage Error Caught");
    switch (error.response!.statusCode) {
      case 400:
        return BadRequestException(errorMessage);
      case 401:
        return UnauthorisedException('$errorMessage ');
      case 404:
        return NotFoundException(errorMessage);
      case 500:
        return InternalServerErrorException(errorMessage);
      default:
        return FetchDataException('Error During Communication: $errorMessage');
    }
  } else {
    return FetchDataException(' ${error.response!.data.toString()}');
  }
}
