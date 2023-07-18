import 'package:appointmentxpert/routes/app_routes.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' as Get;

import '../network/endpoints.dart';
import '../shared_prefrences_page/shared_prefrence_page.dart';
import 'dio_exception.dart';
import 'interceptors/authorization_interceptor.dart';

class DioClient {
  static final _options = BaseOptions(
    baseUrl: Endpoints.baseURL,
    connectTimeout: Endpoints.connectionTimeout,
    receiveTimeout: Endpoints.receiveTimeout,
    responseType: ResponseType.json,
  );

  // dio instance
  final Dio _dio = Dio(_options)
    ..interceptors.addAll([AuthorizationInterceptor(), LogInterceptor()]);

  // GET request
  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioError catch (err) {
      if (err.response?.statusCode == 500) {
        SharedPrefUtils.clearPreferences();
        Get.Get.offAllNamed(AppRoutes.loginScreen);
        final errorMessage = DioException.fromDioError(err).toString();
        throw errorMessage;
      } else {
        final errorMessage = DioException.fromDioError(err).toString();
        throw errorMessage;
      }
    } catch (e) {
      if (kDebugMode) print(e);
      throw e.toString();
    }
  }

  // POST request
  Future<Response> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioError catch (err) {
      if (err.response?.statusCode == 500) {
        SharedPrefUtils.clearPreferences();
        Get.Get.offAllNamed(AppRoutes.loginScreen);
        final errorMessage = DioException.fromDioError(err).toString();
        throw errorMessage;
      } else {
        final errorMessage = DioException.fromDioError(err).toString();
        throw errorMessage;
      }
    } catch (e) {
      if (kDebugMode) print(e);
      throw e.toString();
    }
  }

  // POST request
  Future<Response> download(
    String url,
    String savePath, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.download(url, savePath,
          cancelToken: cancelToken,
          data: data,
          onReceiveProgress: onReceiveProgress,
          options: options,
          queryParameters: queryParameters);
      return response;
    } on DioError catch (err) {
      final errorMessage = DioException.fromDioError(err).toString();
      throw errorMessage;
    } catch (e) {
      if (kDebugMode) print(e);
      throw e.toString();
    }
  }

  // PUT request
  Future<Response> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioError catch (err) {
      final errorMessage = DioException.fromDioError(err).toString();
      throw errorMessage;
    } catch (e) {
      if (kDebugMode) print(e);
      throw e.toString();
    }
  }

  // DELETE request
  Future<Response> delete(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioError catch (err) {
      final errorMessage = DioException.fromDioError(err).toString();
      throw errorMessage;
    } catch (e) {
      if (kDebugMode) print(e);
      throw e.toString();
    }
  }
}
