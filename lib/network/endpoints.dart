class Endpoints {
  Endpoints._();

  //static const String baseURL = 'http://192.168.0.106:7070/';
  static const String baseURL = 'http://103.250.185.39:7070/appointmentxpert/';

  static const int receiveTimeout = 5000;

  static const int connectionTimeout = 3000;

  static const String signIn = '/generate-token';
  static const String register = baseURL + 'authenticate/signup';
  static const String login = baseURL + "authenticate/signin?";
  static const String forgotpassword = baseURL + "authenticate/forgotPassword?";
  static const String getUser = '/user/getUser';
  static const String deleteUser = '/user/deleteUser';
  static const String getPatientsList = 'patient/list';
  static const String getDoctorsList = '/doctor/getall';
  static const String getEmployeesList = 'staff/byQuery';
  static const String getAllAppoinmentsByExaminerId = 'appointment/byExaminer/';
  static const String getAllAppoinmentByPatirntId = 'appointment/byPatient/';
  static const String getTodaysAppointmentByPatientId =
      'appointment/todayByPatient/';
  static const String getTodaysAppointmentByExaminerId =
      'appointment/todayByExaminer/';
  static const String getEmplyeeByUserId = 'employees/getByUserId/';
  static const String getPatientByUserId = 'patients/getByUserId/';
  static const String createPatient = 'patient/add';
  static const String createEmployee = 'staff/add';
  static const String uploadEmployeePhoto = 'staff/uploadPhoto/';
  static const String uploadPatientPhoto = 'patient/uploadPhoto/';
  static const String downLoadEmployePhoto = "staff/profilePhoto/";
  static const String downLoadPatientPhoto = "patient/profilePhoto/";
  static const String createPatientCase = baseURL + 'patientCases/create';
  static const String createAppointment = baseURL + 'appointment/create';
  static const String updateAppointment = baseURL + "appointment/update";
  static const String getAllDept = "department/getAll";
  static const String getAllClinic = "clinic/getAll";
  static const String patientVisitAdd = "patientVisit/add";
  static const String patientExaminationAdd = "examination/addExamination";
  static const String patientTreatmentAdd = "patientTreatment/create";
  static const String createTreatment = "treatment/create";
  static const String getStaffById = "staff/";
  static const String staffList = "staff/list?pageNumber=";
  static const String staffUpdate = "staff/update";
  static const String getPatientById = "patient/";
  static const String getReceptionistTodayAppoitments = "appointment/today";
  static const String getStaffToadyAppointments =
      "appointment/todayAppointmentWithExaminerId?";
  static const String getAllAppointmentsPaged = "appointment/list";
  static const String getAllAppointmentsWithoutPaged =
      "appointment/allAppointments";
  //static const String getReceptionistAllAppoitments = "appointment/";
  static const String callPhoneOtp = "otp/generateOtp?";
  static const String callEmailOtp = "otp/emailOtp?";
  static const String verifyPhoneOtp = "otp/verifyOtp?";
  static const String verifyEmailOtp = "otp/verifyEmailOtp?";
  static const String generatePrecription = "report/patientReport/?";
  static const String generateInvoice = "report/patientInvoice/?";
  static const String getServices = baseURL + 'service/list';
  static const String visitUpdate = baseURL + 'patientVisit/update';
  static const String examinationUpdate =
      baseURL + 'examination/updateDiagnosis';
  static const String addEmergencyAppointment =
      baseURL + 'emergencyAppointment/create';
  static const String emergencyPatientList =
      baseURL + 'emergencyAppointment/today';
  static const String getappointmentDatesWithoutStaffId =
      'appointment/getAppointmentDetailsForDateWithoutExaminerId';
  static const String getappointmentDatesWithStaffId =
      'appointment/getAppointmentDetailsForDate?id=';
  static const String patientUpdate = 'patient/update';
  static const String appointmentByUserId =
      "appointment/allAppointmentsWithExaminerId?";
  static const String cancelledAppointments =
      "appointment/getCancelAppointmentDetailsForDate?";
}
