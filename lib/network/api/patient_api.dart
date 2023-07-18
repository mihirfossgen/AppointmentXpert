import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/logger.dart';
import '../../models/patient_list_model.dart';
import '../../models/patient_model.dart';
import '../dio_client.dart';
import '../endpoints.dart';

class PatientApi {
  final DioClient _apiService = DioClient();

  Future<dynamic> getAllPatientsList(int pageIndex) async {
    var url = '${Endpoints.getPatientsList}/$pageIndex';
    try {
      final Response response = await _apiService.get(url);
      return PatientList.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<PatientData> getPatientDetails(
      {Map<String, String> headers = const {}, int? id}) async {
    //ProgressDialogUtils.showProgressDialog();
    try {
      //await isNetworkConnected();
      final Response response = await _apiService.get(
        Endpoints.getPatientById + id.toString(),
      );
      //ProgressDialogUtils.hideProgressDialog();
      PatientData model = PatientData.fromJson(response.data);
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
}

final patientProvider = Provider<PatientApi>((ref) => PatientApi());
