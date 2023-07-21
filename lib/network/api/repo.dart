import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../../../network/dio_client.dart';
import '../../../network/endpoints.dart';
import '../../models/create_staff_model.dart';
import '../../models/createpatient_model.dart';
import '../../models/get_all_clinic_model.dart';
import '../../models/get_all_department.model.dart';

class CreatePateintRepositoryImpl {
  final DioClient _apiService = DioClient();

  Future<CreatepatientModel> createPatient(
      Map<String, dynamic> credentials) async {
    try {
      final response = await _apiService.post(
        Endpoints.createPatient,
        data: jsonEncode(credentials),
        options: Options(headers: {"content-type": "application/json"}),
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

  Future<CreateStaff> createEmployee(Map<String, dynamic> credentials) async {
    print(jsonEncode(credentials));

    try {
      final response = await _apiService.post(
        Endpoints.createEmployee,
        data: jsonEncode(credentials),
        options: Options(headers: {
          "content-type": "application/json",
        }),
      );
      print(response);
      if (response.statusCode == 200) {
        return CreateStaff.fromJson(response.data);
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
    } on DioError catch (e) {
      print("e -- $e");
      throw Exception(e.response?.data['error_description']);
    } catch (e) {
      print("e ----- $e");
      throw Exception("Couldn't login. Is the device online?");
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

  Future<GetAllDepartemnt> getAllDept() async {
    try {
      final resp = await _apiService.get(Endpoints.getAllDept);
      print(resp);
      print(resp.data);
      return GetAllDepartemnt.fromJson(resp.data);
    } on DioError catch (e) {
      print("e -- $e");
      throw Exception(e.response?.data['error_description']);
    } catch (e) {
      print("e ----- $e");
      throw Exception(e);
    }
  }

  Future<GetAllClinic> getAllClinic() async {
    try {
      final response = await _apiService.get(Endpoints.getAllClinic);
      var newResp = {"data": response.data};
      if (response.statusCode == 200) {
        return GetAllClinic.fromJson(newResp);
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
