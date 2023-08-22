import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../shared_prefrences_page/shared_prefrence_page.dart';

// ignore: constant_identifier_names
const String API_KEY =
    'cdc9a8ca8aa17b6bed3aa3611a835105bbb4632514d7ca8cf55dbbc5966a7cae';

//* Request methods PUT, POST, PATCH, DELETE needs access token,
//* which needs to be passed with "Authorization" header as Bearer token.
class AuthorizationInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String deviceToken = SharedPrefUtils.readPrefStr('device_token');
    String deviceType = Platform.operatingSystem;
    if (_needAuthorizationHeader(options)) {
      debugPrint(SharedPrefUtils.readPrefStr("auth_token").toString());
      options.headers['Authorization'] =
          'Bearer ${SharedPrefUtils.readPrefStr("auth_token")}';
      options.headers['token'] = deviceToken;
      options.headers['deviceType'] = deviceType;
    }
    super.onRequest(options, handler);
  }

  bool _needAuthorizationHeader(RequestOptions options) {
    if (options.path.contains("signup") ||
        options.path.contains("signin") ||
        options.path.contains("otp") ||
        options.path.contains("forgotPassword")) {
      return false;
    } else {
      return true;
    }
  }
}
