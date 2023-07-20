import 'package:dio/dio.dart';
import '../../core/utils/logger.dart';
import '../../models/verify_otp_model.dart';
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
          "${Endpoints.callOtp}type=$type&userName=$number",
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

  Future<OtpModel> verifyOtp(String number, String otp) async {
    try {
      final Response response = await _apiService
          .get("${Endpoints.verifyOtp}otp=$otp&userName=$number");
      return OtpModel.fromJson(response.data);
    } on DioError catch (e) {
      print("e -- $e");
      throw Exception(e.response?.data['error_description']);
    } catch (e) {
      print("e ----- $e");
      throw Exception(e);
    }
  }
}
