import 'package:appointmentxpert/core/app_export.dart';
import 'package:appointmentxpert/routes/app_routes.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:dio/dio.dart' as DIO;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' as GET;

import '../network/endpoints.dart';
import '../shared_prefrences_page/shared_prefrence_page.dart';
import 'dio_exception.dart';
import 'interceptors/authorization_interceptor.dart';

class DioClient {
  static final _options = DIO.BaseOptions(
    baseUrl: Endpoints.baseURL,
    connectTimeout: const Duration(seconds: Endpoints.connectionTimeout),
    receiveTimeout: const Duration(seconds: Endpoints.receiveTimeout),
    responseType: DIO.ResponseType.json,
  );

  // dio instance
  final DIO.Dio _dio = DIO.Dio(_options)
    ..interceptors.addAll([AuthorizationInterceptor(), DIO.LogInterceptor()]);

  Future<bool> checkInternetConnectivity() async {
    bool result = await ConnectivityWrapper.instance.isConnected;
    if (result == false) {
      return false;
    } else {
      return true;
    }
  }

  // GET request
  Future<DIO.Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    DIO.Options? options,
    DIO.CancelToken? cancelToken,
    DIO.ProgressCallback? onReceiveProgress,
  }) async {
    try {
      bool isInternetConnected = await checkInternetConnectivity();
      if (isInternetConnected == true) {
        final DIO.Response response = await _dio.get(
          url,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
        );
        return response;
      } else {
        GET.Get.showSnackbar(const GetSnackBar(
          title: 'No Network',
          message:
              'No network found. Please check your internet connection and try again',
        ));
        throw 'Network problem';
      }
    } on DIO.DioException catch (err) {
      if (err.response?.statusCode == 500) {
        SharedPrefUtils.clearPreferences();
        Get.offAllNamed(AppRoutes.loginScreen);
        final errorMessage = DioException.fromDioError(err.type).toString();
        throw errorMessage;
      } else {
        final errorMessage = DioException.fromDioError(err.type).toString();
        throw errorMessage;
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // POST request
  Future<DIO.Response> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    DIO.Options? options,
    DIO.CancelToken? cancelToken,
    DIO.ProgressCallback? onSendProgress,
    DIO.ProgressCallback? onReceiveProgress,
  }) async {
    try {
      bool isInternetConnected = await checkInternetConnectivity();
      if (isInternetConnected == true) {
        final DIO.Response response = await _dio.post(
          url,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        );
        return response;
      } else {
        GET.Get.showSnackbar(const GetSnackBar(
          title: 'No Network',
          message:
              'No network found. Please check your internet connection and try again',
        ));
        throw 'Network problem';
      }
    } on DIO.DioException catch (err) {
      if (err.response?.statusCode == 500) {
        SharedPrefUtils.clearPreferences();
        Get.offAllNamed(AppRoutes.loginScreen);
        final errorMessage = DioException.fromDioError(err.type).toString();
        throw errorMessage;
      } else {
        final errorMessage = DioException.fromDioError(err.type).toString();
        throw errorMessage;
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // POST request
  Future<DIO.Response> download(
    String url,
    String savePath, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    DIO.Options? options,
    DIO.CancelToken? cancelToken,
    DIO.ProgressCallback? onSendProgress,
    DIO.ProgressCallback? onReceiveProgress,
  }) async {
    try {
      bool isInternetConnected = await checkInternetConnectivity();
      if (isInternetConnected == true) {
        final DIO.Response response = await _dio.download(url, savePath,
            cancelToken: cancelToken,
            data: data,
            onReceiveProgress: onReceiveProgress,
            options: options,
            queryParameters: queryParameters);
        return response;
      } else {
        GET.Get.showSnackbar(const GetSnackBar(
          title: 'No Network',
          message:
              'No network found. Please check your internet connection and try again',
        ));
        throw 'Network problem';
      }
    } on DIO.DioException catch (err) {
      final errorMessage = DioException.fromDioError(err.type).toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
  }

  // PUT request
  Future<DIO.Response> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    DIO.Options? options,
    DIO.CancelToken? cancelToken,
    DIO.ProgressCallback? onSendProgress,
    DIO.ProgressCallback? onReceiveProgress,
  }) async {
    try {
      bool isInternetConnected = await checkInternetConnectivity();
      if (isInternetConnected == true) {
        final DIO.Response response = await _dio.put(
          url,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        );
        return response;
      } else {
        GET.Get.showSnackbar(const GetSnackBar(
          title: 'No Network',
          message:
              'No network found. Please check your internet connection and try again',
        ));
        throw 'Network problem';
      }
    } on DIO.DioException catch (err) {
      final errorMessage = DioException.fromDioError(err.type).toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
  }

  // DELETE request
  Future<DIO.Response> delete(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    DIO.Options? options,
    DIO.CancelToken? cancelToken,
    DIO.ProgressCallback? onSendProgress,
    DIO.ProgressCallback? onReceiveProgress,
  }) async {
    try {
      bool isInternetConnected = await checkInternetConnectivity();
      if (isInternetConnected == true) {
        final DIO.Response response = await _dio.delete(
          url,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
        );
        return response;
      } else {
        GET.Get.showSnackbar(const GetSnackBar(
          title: 'No Network',
          message:
              'No network found. Please check your internet connection and try again',
        ));
        throw 'Network problem';
      }
    } on DIO.DioException catch (err) {
      final errorMessage = DioException.fromDioError(err.type).toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
  }
}
