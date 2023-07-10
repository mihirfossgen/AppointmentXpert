import 'dart:convert';
import 'dart:io';

import 'package:bs_flutter/bs_flutter.dart';
import 'package:dio/dio.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart' as Get;
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';

import '../../core/utils/logger.dart';
import '../../core/utils/progress_dialog_utils.dart';
import '../../models/getAllApointments.dart';
import '../../models/patient_model.dart';
import '../../models/patient_visit_model.dart';
import '../../models/treatmentmodel.dart';
import '../../widgets/responsive.dart';
import '../dio_client.dart';
import '../endpoints.dart';

class AppointmentApi {
  final DioClient _apiService = DioClient();

  Future<GetAllAppointments> getAllAppointments(int pageValue) async {
    try {
      final Response response =
          await _apiService.get("${Endpoints.getAllAppointments}/$pageValue");
      return GetAllAppointments.fromJson(response.data);
    } on DioError catch (e) {
      print("e -- $e");
      throw Exception(e.response?.data['error_description']);
    } catch (e) {
      print("e ----- $e");
      throw Exception(e);
    }
  }

  Future<List<AppointmentContent>> getAllAppointmentBYPatientId(
      int value, int pageIndex) async {
    try {
      debugPrint('ssssss');
      var response = await _apiService
          .get(Endpoints.getAllAppoinmentByPatirntId + '${value}/true/');
      //var newResponse = {"data": response.data};
      List<dynamic> data = response.data;
      List<AppointmentContent> list =
          data.map((e) => AppointmentContent.fromJson(e)).toList();
      return list;
    } on DioError catch (e) {
      print("e -- $e");
      throw Exception(e.response?.data['error_description']);
    } catch (e) {
      print("e ----- $e");
      throw Exception(e);
    }
  }

  Future<PatientVisitModel> patientVisitAdd(var data) async {
    try {
      debugPrint('ssssss');
      final Response response =
          await _apiService.post(Endpoints.patientVisitAdd, data: data);
      return PatientVisitModel.fromJson(response.data);
    } on DioError catch (e) {
      print("e -- $e");
      throw Exception(e.response?.data['error_description']);
    } catch (e) {
      print("e ----- $e");
      throw Exception(e);
    }
  }

  Future<PatientVisitModel> patientVisitUpdate(var data) async {
    try {
      debugPrint('ssssss');
      final Response response =
          await _apiService.post(Endpoints.visitUpdate, data: data);
      return PatientVisitModel.fromJson(response.data);
    } on DioError catch (e) {
      print("e -- $e");
      throw Exception(e.response?.data['error_description']);
    } catch (e) {
      print("e ----- $e");
      throw Exception(e);
    }
  }

  Future<PatientVisitModel> patientExaminationAdd(var data) async {
    try {
      debugPrint('ssssss');
      final Response response =
          await _apiService.post(Endpoints.patientExaminationAdd, data: data);
      return PatientVisitModel.fromJson(response.data);
    } on DioError catch (e) {
      print("e -- $e");
      throw Exception(e.response?.data['error_description']);
    } catch (e) {
      print("e ----- $e");
      throw Exception(e);
    }
  }

  Future<PatientVisitModel> patientExaminationUpdate(var data) async {
    try {
      debugPrint('ssssss');
      final Response response =
          await _apiService.post(Endpoints.examinationUpdate, data: data);
      return PatientVisitModel.fromJson(response.data);
    } on DioError catch (e) {
      print("e -- $e");
      throw Exception(e.response?.data['error_description']);
    } catch (e) {
      print("e ----- $e");
      throw Exception(e);
    }
  }

  Future<PatientVisitModel> patientTreatmentAdd(var data) async {
    try {
      debugPrint('ssssss');
      final Response response =
          await _apiService.post(Endpoints.patientTreatmentAdd, data: data);
      return PatientVisitModel.fromJson(response.data);
    } on DioError catch (e) {
      print("e -- $e");
      throw Exception(e.response?.data['error_description']);
    } catch (e) {
      print("e ----- $e");
      throw Exception(e);
    }
  }

  Future<TreatmentModel> createTreatment(var data) async {
    try {
      debugPrint('ssssss');
      final Response response =
          await _apiService.post(Endpoints.createTreatment, data: data);
      return TreatmentModel.fromJson(response.data);
    } on DioError catch (e) {
      print("e -- $e");
      throw Exception(e.response?.data['error_description']);
    } catch (e) {
      print("e ----- $e");
      throw Exception(e);
    }
  }

  Future<List<AppointmentContent>> getTodaysAppointments(
      int patientId, bool active) async {
    try {
      debugPrint('ssssss');
      final Response response = await _apiService.get(
          Endpoints.getTodaysAppointmentByPatientId + '$patientId/$active');
      List<dynamic> data = response.data;
      List<AppointmentContent> list =
          data.map((e) => AppointmentContent.fromJson(e)).toList();
      return list;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AppointmentContent>> getTodaysAppointmentsByExaminerId(
      int staffId, bool active) async {
    try {
      debugPrint('ssssss');
      final Response response = await _apiService
          .get(Endpoints.getTodaysAppointmentByExaminerId + '$staffId/$active');
      List<dynamic> data = response.data;
      List<AppointmentContent> list =
          data.map((e) => AppointmentContent.fromJson(e)).toList();
      return list;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> signUp(var data) async {
    try {
      debugPrint('ssssss');
      final Response response =
          await _apiService.post(Endpoints.register, data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> createPatientCase(var data) async {
    try {
      debugPrint('ssssss');
      final Response response =
          await _apiService.post(Endpoints.createPatientCase, data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> createAppointment(var data, var headers) async {
    try {
      final Response response = await _apiService.post(
        Endpoints.createAppointment,
        data: jsonEncode(data),
        options: Options(headers: headers),
      );
      if (response.statusCode == 200) {
        return true;
      }
    } on DioError catch (e) {
      print("e -- $e");
      throw Exception(e.response?.data['error_description']);
    } catch (e) {
      print("e ----- $e");
      throw Exception(e);
    }
  }

  Future<dynamic> updateAppointment(var data) async {
    print(jsonEncode(data));

    try {
      debugPrint('ssssss');
      final Response response = await _apiService.post(
        Endpoints.updateAppointment,
        data: jsonEncode(data),
        options: Options(headers: {"content-type": "application/json"}),
      );
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<AppointmentContent>> getAllReceiptionstAppointment(
      int value) async {
    try {
      debugPrint('ssssss');
      var response = await _apiService
          .get(Endpoints.getAllAppointments + '/' + value.toString());
      GetAllAppointments appointmentContent =
          GetAllAppointments.fromJson(response.data);
      List<AppointmentContent>? list = appointmentContent.content;
      return list ?? [];
    } on DioError catch (e) {
      print("e -- $e");
      throw Exception(e.response?.data['error_description']);
    } catch (e) {
      print("e ----- $e");
      throw Exception(e);
    }
  }

  Future<List<AppointmentContent>> getAllReceiptionstTodayAppointment() async {
    try {
      debugPrint('ssssss');
      var response =
          await _apiService.get(Endpoints.getReceptionistTodayAppoitments);
      List<dynamic> data = response.data;
      List<AppointmentContent> list =
          data.map((e) => AppointmentContent.fromJson(e)).toList();
      return list;
    } on DioError catch (e) {
      print("e -- $e");
      throw Exception(e.response?.data['error_description']);
    } catch (e) {
      print("e ----- $e");
      throw Exception(e);
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

  Future<String> callGeneratePrecription(
      int patientId, int appointmentId, int examinationId) async {
    try {
      String fileName = 'Precription_${appointmentId}_${patientId}.pdf';
      ProgressDialogUtils.showProgressDialog();
      var response = await _apiService.post(
        Endpoints.generatePrecription,
        options: Options(
          responseType: ResponseType.bytes,
          contentType: 'application/octet-stream',
        ),
        queryParameters: {
          'patientId': patientId,
          'appoinmentId': appointmentId,
          'examinationId': examinationId
        },
      );
      //var newResponse = {"data": response.data};
      var data = response.data;
      // Directory? directory = Platform.isAndroid
      //     ? await getExternalStorageDirectory()
      //     : await getApplicationDocumentsDirectory();
      if (Responsive.isMobile(Get.Get.context!)) {
        Directory? directory = Platform.isAndroid
            ? await getExternalStorageDirectory()
            : await getApplicationDocumentsDirectory();
        final fullPath =
            '${directory?.path}/Precriptions'; //create new directory here

        Directory(fullPath).createSync(recursive: true);
        File? file;
        final path = '${directory?.path}/Precriptions/${fileName}';
        file = File(path);

        try {
          await file.writeAsBytes(
              data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
        } on FileSystemException catch (err) {
          // handle error
        }
        return path;
      } else {
        ProgressDialogUtils.hideProgressDialog();
        showPdfPopup('Prescription PDF', data, fileName);
        //DocumentFileSavePlus.saveFile(data, fileName, "appliation/pdf");
        return '';
      }
    } on DioError catch (e) {
      print("e -- $e");
      throw Exception(e.response?.data['error_description']);
    } catch (e) {
      print("e ----- $e");
      throw Exception(e);
    } finally {
      ProgressDialogUtils.hideProgressDialog();
    }
  }

  Future<String> callGenerateInvoice(int patientId, int appointmentId,
      int paymentReferenceId, int staffId) async {
    try {
      ProgressDialogUtils.showProgressDialog();
      var response = await _apiService.post(Endpoints.generateInvoice,
          options: Options(
            responseType: ResponseType.bytes,
            contentType: 'application/octet-stream',
          ),
          queryParameters: {
            'patientId': patientId,
            'appoinmentId': appointmentId,
            'paymentReferenceId': paymentReferenceId,
            'staffId': staffId
          });
      //var newResponse = {"data": response.data};
      var data = response.data;
      String fileName = 'Invoice_${appointmentId}_${patientId}.pdf';
      //var bytes = base64Decode(data);
      if (Responsive.isMobile(Get.Get.context!)) {
        Directory? directory = Platform.isAndroid
            ? await getExternalStorageDirectory()
            : await getApplicationDocumentsDirectory();
        final fullPath =
            '${directory?.path}/Invoices'; //create new directory here

        Directory(fullPath).createSync(recursive: true);
        File? file;
        final path = '${directory?.path}/Invoices/${fileName}';
        file = File(path);

        try {
          await file.writeAsBytes(
              data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
        } on FileSystemException catch (err) {
          // handle error
        }
        //DocumentFileSavePlus.saveFile(data, fileName, "appliation/pdf");
        return path;
      } else {
        ProgressDialogUtils.hideProgressDialog();
        showPdfPopup('Invoice PDF', data, fileName);
        return '';
      }
    } on DioError catch (e) {
      print("e -- $e");
      throw Exception(e.response?.data['error_description']);
    } catch (e) {
      print("e ----- $e");
      throw Exception(e);
    } finally {
      ProgressDialogUtils.hideProgressDialog();
    }
  }

  showPdfPopup(String title, dynamic pdfData, String fileName) {
    final pdfController = PdfController(
        document: PdfDocument.openData(pdfData), viewportFraction: 2.0);
    showDialog(
      context: Get.Get.context!,
      builder: (builder) => BsModal(
        context: Get.Get.context!,
        dialog: BsModalDialog(
          size: BsModalSize.xl,
          child: BsModalContent(
            children: [
              BsModalContainer(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  title: Text(title),
                  closeButton: true),
              BsModalContainer(
                child: Column(children: [
                  SizedBox(
                      height: 500,
                      //height: MediaQuery.of(Get.Get.context!).size.height,
                      //width: MediaQuery.of(Get.Get.context!).size.width,
                      child: PdfView(
                        controller: pdfController,
                        pageSnapping: false,
                        backgroundDecoration: BoxDecoration(color: Colors.grey),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: BsButton(
                      style: BsButtonStyle.info,
                      label: Text('Download'),
                      prefixIcon: Icons.download,
                      onPressed: () async {
                        //controller.onClose();
                        await FileSaver.instance.saveFile(
                            name: fileName,
                            bytes: pdfData,
                            customMimeType: 'appliation/pdf',
                            ext: 'pdf',
                            mimeType: MimeType.pdf);
                        Get.Get.back();
                      },
                    ),
                  )
                ]),
              ),
              BsModalContainer(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                closeButton: false,
                onClose: () {
                  //controller.onClose();
                  Get.Get.back();
                },
                actions: [
                  BsButton(
                    style: BsButtonStyle.danger,
                    label: Text('Close'),
                    prefixIcon: Icons.close,
                    onPressed: () {
                      //controller.onClose();
                      Get.Get.back();
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

final appointmentProvider = Provider<AppointmentApi>((ref) => AppointmentApi());
