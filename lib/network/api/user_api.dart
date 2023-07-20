import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import '../../core/utils/logger.dart';
import '../../core/utils/progress_dialog_utils.dart';
import '../../models/create_staff_model.dart';
import '../../models/createpatient_model.dart';
import '../../models/get_all_clinic_model.dart';
import '../../models/sign_up_model.dart';
import '../../presentation/login_screen/models/login_model.dart';
import '../dio_client.dart';
import '../endpoints.dart';

class UserApi {
  final DioClient _apiService = DioClient();

  Future<LoginModel> callLogin(
      {Map<String, String> headers = const {},
      Map<String, dynamic>? data}) async {
    ProgressDialogUtils.showProgressDialog();
    try {
      //await isNetworkConnected();
      final Response response = await _apiService.post(
        Endpoints.login,
        queryParameters: data,
      );
      ProgressDialogUtils.hideProgressDialog();
      LoginModel model = LoginModel.fromJson(response.data);
      return model;
    } catch (error, stackTrace) {
      ProgressDialogUtils.hideProgressDialog();
      Logger.log(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<SignUpModel> callRegister(
      {Map<String, String> headers = const {},
      Map<String, dynamic>? data}) async {
    ProgressDialogUtils.showProgressDialog();
    try {
      //await isNetworkConnected();
      final Response response =
          await _apiService.post(Endpoints.register, data: data);
      ProgressDialogUtils.hideProgressDialog();
      return SignUpModel.fromJson(response.data);
    } catch (error, stackTrace) {
      ProgressDialogUtils.hideProgressDialog();
      Logger.log(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<bool> callForgotPassword(
      {Map<String, String> headers = const {},
      String? newPassword,
      String? confirmPassword,
      String? username}) async {
    ProgressDialogUtils.showProgressDialog();
    try {
      //await isNetworkConnected();
      final Response response = await _apiService.post(
        Endpoints.forgotpassword +
            "confirmPassword=$confirmPassword&newPassword=$newPassword&userName=$username",
      );

      if (response.statusCode == 200) {
        ProgressDialogUtils.hideProgressDialog();
        return true;
      }
      return false;
    } catch (error, stackTrace) {
      ProgressDialogUtils.hideProgressDialog();
      Logger.log(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<GetAllClinic> callGetAllClinics(
      {Map<String, String> headers = const {},
      Map<String, dynamic>? data}) async {
    ProgressDialogUtils.showProgressDialog();
    try {
      //await isNetworkConnected();
      final Response response = await _apiService.get(
        Endpoints.getAllClinic,
      );
      var newResp = {"data": response.data};
      ProgressDialogUtils.hideProgressDialog();
      return GetAllClinic.fromJson(newResp);
    } catch (error, stackTrace) {
      ProgressDialogUtils.hideProgressDialog();
      Logger.log(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<CreateStaff> callCreateEmployee(
      {Map<String, String> headers = const {},
      Map<String, dynamic>? data}) async {
    ProgressDialogUtils.showProgressDialog();
    try {
      //await isNetworkConnected();
      final Response response = await _apiService.post(Endpoints.createEmployee,
          data: jsonEncode(data));
      ProgressDialogUtils.hideProgressDialog();
      return CreateStaff.fromJson(response.data);
    } catch (error, stackTrace) {
      ProgressDialogUtils.hideProgressDialog();
      Logger.log(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<CreatepatientModel> callCreatePatient(
      {Map<String, String> headers = const {},
      Map<String, dynamic>? data}) async {
    ProgressDialogUtils.showProgressDialog();
    try {
      //await isNetworkConnected();
      final Response response = await _apiService.post(Endpoints.createPatient,
          data: jsonEncode(data));
      ProgressDialogUtils.hideProgressDialog();
      return CreatepatientModel.fromJson(response.data);
    } catch (error, stackTrace) {
      ProgressDialogUtils.hideProgressDialog();
      Logger.log(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<CreatepatientModel> upLoadEmplyeePhoto(
      String id, String path, String fileName) async {
    try {
      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(path,
            filename: fileName, contentType: MediaType('image', 'jpeg'))
      });

      final response = await _apiService.post(
        Endpoints.uploadEmployeePhoto + id,
        data: formData,
        options: Options(headers: {
          "Accept": "*/*",
          "content-type":
              "multipart/form-data;boundary=YourBoundaryOfChoiceHere",
        }),
      );
      print(response);
      if (response.statusCode == 200) {
        return CreatepatientModel.fromJson(response.data);
      } else {
        throw Exception(response.statusMessage);
      }
    } catch (error, stackTrace) {
      ProgressDialogUtils.hideProgressDialog();
      Logger.log(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<CreatepatientModel> upLoadPatientPhoto(
      String id, String path, String fileName) async {
    try {
      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(path,
            filename: fileName, contentType: MediaType('image', 'jpeg'))
      });

      final response = await _apiService.post(
        Endpoints.uploadPatientPhoto + id,
        data: formData,
        options: Options(headers: {
          "Accept": "*/*",
          "content-type":
              "multipart/form-data;boundary=YourBoundaryOfChoiceHere",
        }),
      );
      print(response);
      if (response.statusCode == 200) {
        return CreatepatientModel.fromJson(response.data);
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioError catch (e) {
      print("e -- $e");
      throw Exception(e.response?.data['error_description']);
    } catch (e) {
      print("e ----- $e");
      throw Exception("Couldn't login. Is the device online?");
    }
  }
}

final userProvider = Provider<UserApi>((ref) => UserApi());
