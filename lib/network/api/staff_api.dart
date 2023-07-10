import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/logger.dart';
import '../../models/getallEmplyesList.dart';
import '../../models/staff_model.dart';
import '../dio_client.dart';
import '../endpoints.dart';

class StaffApi {
  final DioClient _apiService = DioClient();

  Future<GetAllEmployesList> callDoctorsList(
      {Map<String, String> headers = const {},
      Map<String, dynamic>? data}) async {
    //ProgressDialogUtils.showProgressDialog();
    try {
      //await isNetworkConnected();
      final Response response = await _apiService.post(
        Endpoints.getEmployeesList,
        data: data,
      );
      //ProgressDialogUtils.hideProgressDialog();
      GetAllEmployesList model = GetAllEmployesList.fromJson(response.data);
      return model;
    } catch (error, stackTrace) {
      //ProgressDialogUtils.hideProgressDialog();
      Logger.log(
        error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<StaffData> getstaffbyid(int value) async {
    try {
      final Response response =
          await _apiService.get(Endpoints.getStaffById + "$value");
      return StaffData.fromJson(response.data);
    } on DioError catch (e) {
      print("e -- $e");
      throw Exception(e.response?.data['error_description']);
    } catch (e) {
      print("e ----- $e");
      throw Exception(e);
    }
  }
}

final staffProvider = Provider<StaffApi>((ref) => StaffApi());
