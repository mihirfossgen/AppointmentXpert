import 'dart:io';

import 'package:dio/dio.dart';

import '../../core/utils/logger.dart';
import '../../models/verify_otp_model.dart';
import '../../shared_prefrences_page/shared_prefrence_page.dart';
import '../dio_client.dart';
import '../endpoints.dart';

class VerifyOtpApi {
  final DioClient _apiService = DioClient();

  Future<OtpModel> callOtp(
      {Map<String, String> headers = const {},
      String? number,
      String? type}) async {
    //ProgressDialogUtils.showProgressDialog();
    Map<String, dynamic> req = {"userName": number};
    try {
      Response response = await _apiService.post(
          "${Endpoints.callPhoneOtp}type=$type&userName=$number",
          options: Options(headers: headers));
      return OtpModel.fromJson(response.data);
    } catch (error, stackTrace) {
      //ProgressDialogUtils.hideProgressDialog();
      Logger.log(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<OtpModel> callEmailOtp(
      {Map<String, String> headers = const {},
      String? email,
      String? type}) async {
    //ProgressDialogUtils.showProgressDialog();
    Map<String, dynamic> req = {"userName": email};
    try {
      Response response = await _apiService.post(
          "${Endpoints.callEmailOtp}type=$type&userName=$email",
          options: Options(headers: headers));
      return OtpModel.fromJson(response.data);
    } catch (error, stackTrace) {
      //ProgressDialogUtils.hideProgressDialog();
      Logger.log(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<OtpModel> verifyPhoneOtp(String number, String otp) async {
    String deviceToken = SharedPrefUtils.readPrefStr('device_token');
    String deviceType = Platform.operatingSystem;
    try {
      final Response response = await _apiService.get(
          "${Endpoints.verifyPhoneOtp}otp=$otp&userName=$number&token=$deviceToken&deviceType=$deviceType");
      return OtpModel.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception(e.response?.data['error_description']);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<OtpModel> verifyEmailOtp(String number, String otp) async {
    String deviceToken = SharedPrefUtils.readPrefStr('device_token');
    String deviceType = Platform.operatingSystem;
    try {
      final Response response = await _apiService.get(
          "${Endpoints.verifyEmailOtp}deviceType=$deviceType&otp=$otp&token=$deviceToken&type=login&userName=$number");
      return OtpModel.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception(e.response?.data['error_description']);
    } catch (e) {
      throw Exception(e);
    }
  }
}
