import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/logger.dart';
import '../../models/services_model.dart';
import '../dio_client.dart';
import '../endpoints.dart';

class ServicesApi {
  final DioClient _apiService = DioClient();

  Future<List<ServicesModel>> getServicesList() async {
    //ProgressDialogUtils.showProgressDialog();
    try {
      //await isNetworkConnected();
      var url = Endpoints.getServices;
      final Response response = await _apiService.get(
        url,
      );
      //ProgressDialogUtils.hideProgressDialog();
      List<dynamic> tempList = response.data;
      List<ServicesModel> list =
          tempList.map((e) => ServicesModel.fromJson(e)).toList();
      return list;
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

final serviceProvider = Provider<ServicesApi>((ref) => ServicesApi());
