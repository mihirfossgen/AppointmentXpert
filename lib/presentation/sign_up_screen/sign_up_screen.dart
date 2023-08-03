import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/utils/color_constant.dart';
import '../../core/utils/image_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../theme/app_style.dart';
import '../../widgets/app_bar/appbar_subtitle_2.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_checkbox.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/responsive.dart';
import '../dashboard_screen/shared_components/responsive_builder.dart';
import '../sign_up_success_dialog/controller/sign_up_success_controller.dart';
import '../sign_up_success_dialog/sign_up_success_dialog.dart';
import 'controller/sign_up_controller.dart';

class SignUpScreen extends GetWidget<SignUpController> {
  List<Map> types = [
    {"id": 5, "name": "Admin"},
    {"id": 6, "name": "Reception"},
    {"id": 7, "name": "Finance"},
    {"id": 8, "name": "Patient"},
    {"id": 9, "name": "Examiner"},
    {"id": 10, "name": "Nurse"}
  ];
  String? name;
  String? email;

  SignUpScreen({super.key, this.name, this.email});

  SignUpController controller = Get.put(SignUpController());

  getStringValue(String text) {
    switch (text.toLowerCase()) {
      case "admin":
        return "ADMIN";
      case "reception":
        return "RECEPTION";
      case "finance":
        return "FINANCE";
      case "nurse":
        return "NURSE";
      case "examiner":
        return "EXAMINER";
      case "patient":
        return "PATIENT";
      default:
        return "";
    }
  }

  RxBool selectConditions = false.obs;

  // Widget _title(String value) {
  //   return Padding(
  //     padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
  //     child: Row(
  //       children: [
  //         Text(
  //           value,
  //           style: const TextStyle(color: Colors.grey, fontSize: 16),
  //         ),
  //         Text(
  //           "*",
  //           style: TextStyle(color: Colors.red),
  //         )
  //       ],
  //     ),
  //   );
  // }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var theme = Theme.of(context);
    if (name != null && email != null) {
      controller.enternameController.text = name.toString();
      controller.enteremailController.text = email.toString();
    }
    return SafeArea(
        top: false,
        bottom: false,
        child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: ColorConstant.whiteA700,
                appBar: !Responsive.isDesktop(context)
                    ? CustomAppBar(
                        height: getVerticalSize(40),
                        leadingWidth: 64,
                        elevation: 0,
                        backgroundColor: ColorConstant.blue700,
                        leading: !Responsive.isDesktop(context)
                            ? InkWell(
                                onTap: () {
                                  onTapArrowleft1();
                                },
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.black,
                                ),
                              )
                            // AppbarImage(
                            //     height: getSize(40),
                            //     width: getSize(40),
                            //     backgroundColor: Colors.white,
                            //     svgPath: ImageConstant.imgArrowleft,
                            //     margin: getMargin(left: 24),
                            //     onTap: () {
                            //       onTapArrowleft1();
                            //     })
                            : null,
                        centerTitle: true,
                        title: AppbarSubtitle2(
                            text: !Responsive.isDesktop(context)
                                ? "lbl_sign_up".tr
                                : ''))
                    : null,
                body: ResponsiveBuilder(
                  mobileBuilder: (context, constraints) {
                    return _buildSmallScreen(size, controller, theme);
                  },
                  desktopBuilder: (context, constraints) {
                    return _buildLargeScreen(size, controller, theme);
                  },
                  tabletBuilder: (context, constraints) {
                    return _buildSmallScreen(size, controller, theme);
                  },
                ))));
  }

  /// For large screens
  Widget _buildLargeScreen(
      Size size, SignUpController signUpController, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: RotatedBox(
            quarterTurns: 0,
            child: Image.asset(
              !Responsive.isDesktop(Get.context!)
                  ? 'assets' '/images/bannerbg.png'
                  : '/images/bannerbg.png',
              fit: BoxFit.contain,
              // height: size.height * 0.2,
              // width: size.width * 0.8,
            ),
          ),
        ),
        SizedBox(width: size.width * 0.04),
        Expanded(
          flex: 5,
          child: _buildMainBody(size, signUpController, theme),
        ),
      ],
    );
  }

  /// For Small screens
  Widget _buildSmallScreen(
      Size size, SignUpController simpleUIController, ThemeData theme) {
    return SingleChildScrollView(
      child: _buildMainBody(size, simpleUIController, theme),
    );
  }

  Future<void> _launchUrl(String type) async {
    Uri _url;
    if (type == "termsandcondition") {
      _url = Uri.parse('https://fossgentechnologies.com/terms-conditions/');
    } else {
      _url = Uri.parse('https://fossgentechnologies.com/privacy-policy/');
    }
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  /// Main Body
  Widget _buildMainBody(
      Size size, SignUpController signUpController, ThemeData theme) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: size.width < 600
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          SizedBox(
            height: size.height * 0.02,
          ),
          size.width < 600
              ? Container()
              : Center(
                  child: Image.asset(
                    !Responsive.isDesktop(Get.context!)
                        ? 'assets' '/images/logo-opdxpert.png'
                        : '/images/logo-opdxpert.png',
                    fit: BoxFit.contain,
                    height: size.height * 0.145,
                    width: size.width * 0.8,
                  ),
                ),
          SizedBox(
            height: size.height * 0.02,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              'Sign Up',
              style: kLoginTitleStyle(size),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              'Create Account',
              style: kLoginSubtitleStyle(size),
            ),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  /// username
                  // CustomTextFormField(
                  //     labelText: "lbl_enter_your_name".tr,
                  //     controller: controller.enternameController,
                  //     padding: TextFormFieldPadding.PaddingT14,
                  //     isRequired: true,
                  //     validator: (value) {
                  //       return controller.userNameValidator(value ?? "");
                  //     },
                  //     prefixConstraints:
                  //         BoxConstraints(maxHeight: getVerticalSize(56))),
                  // SizedBox(
                  //   height: size.height * 0.03,
                  // ),
                  CustomTextFormField(
                      labelText: "Enter your Email",
                      controller: controller.enteremailController,
                      isRequired: true,
                      //padding: TextFormFieldPadding.PaddingT16_2,
                      padding: TextFormFieldPadding.PaddingT14,
                      validator: (value) {
                        return controller.emailValidator(value ?? "");
                      },
                      textInputType: TextInputType.emailAddress,
                      prefixConstraints:
                          BoxConstraints(maxHeight: getVerticalSize(56))),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  CustomTextFormField(
                      labelText: "Enter your number",
                      controller: controller.enternumberController,
                      isRequired: true,
                      maxLength: 10,
                      validator: (value) {
                        return controller.numberValidator(value ?? "");
                      },
                      //padding: TextFormFieldPadding.PaddingT16_2,
                      padding: TextFormFieldPadding.PaddingT14,
                      textInputType: TextInputType.phone,
                      prefixConstraints:
                          BoxConstraints(maxHeight: getVerticalSize(56))),
                  // SizedBox(
                  //   height: size.height * 0.03,
                  // ),
                  // Obx(() => CustomTextFormField(
                  //     labelText: "msg_enter_your_pass".tr,
                  //     alignment: Alignment.centerLeft,
                  //     controller: controller.enterpasswordController,
                  //     isRequired: false,
                  //     textInputAction: TextInputAction.done,
                  //     padding: TextFormFieldPadding.PaddingT14,
                  //     textInputType: TextInputType.visiblePassword,
                  //     // validator: (value) {
                  //     //   return controller.passwordValidator(value ?? "");
                  //     // },
                  //     prefixConstraints:
                  //         BoxConstraints(maxHeight: getVerticalSize(56)),
                  //     suffix: InkWell(
                  //         onTap: () {
                  //           controller.isShowPassword.value =
                  //               !controller.isShowPassword.value;
                  //         },
                  //         child: Container(
                  //             width: 30,
                  //             margin: getMargin(
                  //                 left: 15, top: 16, right: 12, bottom: 16),
                  //             child: CustomImageView(
                  //                 svgPath: controller.isShowPassword.value
                  //                     ? ImageConstant.imgCheckmark24x24
                  //                     : ImageConstant.imgCheckmark24x24))),
                  //     suffixConstraints:
                  //         BoxConstraints(maxHeight: getVerticalSize(56)),
                  //     isObscureText: controller.isShowPassword.value)),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => CustomCheckbox(
                          // text: "msg_i_agree_to_the2".tr,
                          iconSize: getHorizontalSize(20),
                          value: controller.isCheckbox.value,
                          // margin: getMargin(
                          //   top: 16,
                          // ),
                          alignment: Alignment.centerLeft,
                          fontStyle: CheckboxFontStyle
                              .SFProDisplayRegular14Bluegray800,
                          onChange: (value) {
                            controller.isCheckbox.value = value;
                          })),
                      RichText(
                        softWrap: true,
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: 'I agree to the OPDXpert ',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Terms of Service',
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      _launchUrl('termsandcondition');
                                    }),
                              const TextSpan(
                                  text: ' and ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  )),
                              TextSpan(
                                text: '\n Privacy Policy',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {});

                                    Get.dialog(const AlertDialog(
                                      title: Text('Privacy policy'),
                                      actions: [
                                        SizedBox(
                                          height: 600,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Text(
                                                "We, Marian Cardiac Center Research & Foundation, the creator of this Privacy Policy ensure our firm commitment to your privacy vis-à-vis the protection of your priceless information. The Privacy Policy contains information about ‘www.marianheart.fossgen.in’ and the 'MarianHeart’ android/iOS or any other platform app. In order to endow you with our uninterrupted use of services, we may collect and, in some circumstances, disclose information about you. To enhance better protection of your privacy, we provide this notice explaining our information practices and the choices you can make about the way your information is collected and used. If you do not agree to the terms in this Policy, we kindly ask you to leave the site or uninstall our app. If you have any questions or concerns regarding this privacy policy, you should contact our Customer Support Desk at support@remedoapp.com\nOVERVIEW We commit to respecting your online privacy and data. We further recognize your need for appropriate protection and management of any personally identifiable information (Personal Information) you share with us. Information that is considered personal about you by us includes, but may not be limited to, your name, phone number, e-mail address, residential address, health and medical information or record, prescription by medical practitioners, family background and information about insurance policies taken by you or your family members. In order to use the MarianHeart app, you are required to register yourself by providing the following information which includes, but may not be limited to: (1) Name (2) E-mail Address (3) Residential Address (3) Contact Number (4) Credit/Debit/Account detailsa1 Medical background and information including any prescription by a medical practitioner (6) Details of insurance cover (7) Any information on family/Professional background, if required. These information points can be collected by third party as well for registration on our website/Mobile Application.\nNOTIFICATION OF MODIFICATIONS AND CHANGES TO THE TERMS AND CONDITONS AND PRIVACY POLICY we reserve the right to change the Terms and Privacy Policy from time to time as seen fit, without any intimation to you, and your continued use of the site/app will signify your acceptance of any amendment to these terms. You are therefore advised to re-read the Terms of Service on a regular basis. Should it be that you do not accept any of the modifications or amendments to the Terms, you may terminate your use of this service immediately.\nINFORMATION WE COLLECT As a user of this service you are required to provide a valid e-mail address at the time of registration and/or choose username or alias that represents your identity on our app/website. Certain information, such as your name, e-mail address and contact number is collected in order to verify your identity and for use as account numbers in our record system, among other things. E-mail addresses, geo-locations, intellectual property, listings viewed, any information entered in the “Contact Us” form or any other form displayed on any section of the website are also collected.\nCOOKIES We use our as well as third parties data collection devices such as cookies on certain pages of our website. Cookies are small files stored on your hard drive that assist us in providing services customized to your requirements and tastes. We also offer certain features that are only available through the use of a cookie. Cookiescan also help us provide information, which is targeted to your interests. Cookies may be used whether you choose to register with us or not. Third party vendors such as www.google.com (“Google”) may use cookies to serve ads based on your visits to this Website. You may visit the website of the third party and choose to opt out of the use of cookies for interest-based advertising, if the third party offers such an option. You may choose to opt-out of the DoubleClick cookie that Google and its partners use for interest-based advertising by visiting Ads Settings.\nEXTERNAL LINKS ON WEBSITE AND APP The website and app may contain hyperlinks to other websites, content or resources. We have no control over any websites or resources, which are provided by other companies or persons. You acknowledge and agree that we are not responsible for the availability of any such external sites or resources, and does not endorse any advertising, products or other materials on or available from such websites or resources. You acknowledge and agree that we are not liable for any loss or damage which may be incurred by you as a result of the availability of those external sites or resources, or as a result of any reliance placed by you on the completeness, accuracy or existence of any advertising, products or other materials on, or available from, such websites or resources. These third-party service providers and third-party sites may have their own privacy policies governing the storage and retention of your Personal Information that you may be subject to. We recommend that when you enter a third-party website, you review the third party site’s privacy policy as it relates to safeguarding your Personal Information. We may use third-party advertising companies to serve ads when you visit the website or app. You may visit the third party websites and choose to opt-out of the use of cookies for interest-based advertising if the third party offers such an option.\nOUR USE OF YOUR INFORMATION Your contact information is also used to contact you whenever necessary. We use your IP address to help diagnose problems with our server, and to administer our Website. Your IP address is also used to help identify you and together broad demographic information. Finally, we may use your IP address to help protect our partners and ourselves from fraud. We will continue to enhance our security procedures as new technology becomes available. We will transfer information about you if we are acquired by or merged with another company. In this event, we will notify you by email or by putting a prominent notice on the site before information about you is transferred and becomes subject to a different privacy policy. We may release your Personal Information to a third-party in order to comply with a court order or other similar legal procedure, or when we believe in good faith that such disclosure is necessary to comply with the applicable laws; as per any instruction of any Governmental, administrative, judicial or quasi judicial authority, prevent imminent physical harm or financial loss; or investigate or take action regarding illegal activities, suspected fraud, orviolations of our terms of service. We may also disclose any Personal Information to our affiliates, partners, agents or other related third parties in compliance with our copyright policy as mentioned in the terms of service as we in our sole discretion believe necessary or appropriate in connection with compliance with any applicable laws, for the purpose of our business development or increasing the quality of our services, an investigation of fraud, intellectual property infringement, piracy, or other unlawful activity. In such events, we shall disclose any such Personal Information only in accordance with the confidentiality and security standards as provided in the terms of this policy and by accepting this policy you hereby expressly consent to any such disclosure.\nCONFIDENTIALITY You further acknowledge that the Website and App may contain information which is designated confidential by us and that you shall not disclose such information without our prior written consent. Your information is regarded as confidential and therefore will not be divulged to any third party, unless if legally required to do so to the appropriate authorities. We will not sell, share, or rent your Personal Information to any third party or use your e-mail address for unsolicited mail other than as per the terms of this policy or our terms of service. Any emails sent by us will only be in connection with the provision of agreed services and products or any related services being provided or available which in our opinion may be useful to you.\nOUR DISCLOSURE OF YOUR INFORMATION Due to the existing regulatory environment, we cannot ensure that all of your private communications and other Personal Information will never be disclosed in ways not otherwise described in this Privacy Policy. By way of example (without limiting and foregoing), we may be forced to disclose information to the government, law enforcement agencies or third parties. Under certain circumstances, third parties may unlawfully intercept or access transmissions or private communications, or members may abuse or misuse your information that they collect from our Website. Therefore, although we use industry standard practices to protect your privacy, we do not promise, and you should not expect, that your Personal Information or private communications would always remain private. As a matter of policy, we do not sell or rent any personally identifiable information about you to any third party. However, the following describes some of the ways that your personally identifiable information may be disclosed. 8.1 External Service Providers: There may be a number of services offered by external service providers that help you use our Websites. If you choose to use these optional services, and in the course of doing so, disclose information to the external service providers, and/or grant them permission to collect information about you, then their use of your information is governed by their private policy. 8.2 Other Corporate Entities: We share much of our data, including personally identifiable information about you, with our parent and/or subsidiaries or other affiliates or business partners that are committed to serving your online needs and related services, throughout the world. Such data will be shared for the sole purpose of enhancing your browsing experience. To the extent that these entities have access to your information, they will treat it at least as protectively as they treat information they obtain from their other members. It is possible that we and/or its subsidiaries, or any combination of such, could merge with or be acquired by another business entity. Should such a combination occur, you should expect that we would share some or all of your information in order to continue to provide the service. You will receive notice of such event (to the extent that it occurs). 8.3 Law and Order: We cooperate with law enforcement inquiries, as well as other third parties to enforce laws, such as: intellectual property rights, fraud and other rights. We can (and you authorize us to) disclose any information about you to law enforcement and other government officials as we, in our sole discretion, believe necessary or appropriate, in connection with an investigation of fraud, intellectual property infringements, or other activity that is illegal or may expose us or you to legal liability\nOTHER INFORMATION COLLECTORS Except as otherwise expressly mentioned in this Privacy Policy, this document only addresses the use and disclosure of information we collect from you. To the extent that you disclose your information to other parties, whether they are on our Websites or on other sites throughout the Internet, different rules may apply to their use or disclosure of the information you disclose to them. To the extent that we use third party advertisers, they adhere to their own privacy policies. Since we do not control the privacy policies of the third parties, you are subject to ask questions before you disclose your Personal Information to others. Any information that you make publicly available on the sitemay be potentially viewed by any party, and by posting such material it is deemed that you consent to share such information with such parties.\nSECURITY The security of your Personal Information is a top priority for us. We are committed to protecting the security of your Personal Information. We treat data as an asset that must be protected against loss and unauthorized access. Experts design our security measures and we use a variety of technologies and procedures to protect such data from unauthorized access by members inside and outside the company. We do not recommend transfer of sensitive information (such as credit card number) and bank account details via the Site to any third party. Users are recommended to do so offline, on the phone or via personal emails. We follow generally accepted industry standards to protect the Personal Information submitted to us, both during transmission and once we receive it. However, perfect security does not exist on the Internet. You therefore agree that any security breaches beyond the control of our standard security procedures are at your sole risk and discretion. The data entered by you can be seen by doctors, technical members and maintenance or business team of MarianHeart. We do not have any Non-disclosure agreement with these concerned parties on the data entered by the user. We may use the information you submit to study results and produce reports. Such information may be shared with our partners and advertisers under our sole discretion Email Policy: We have a strict 'No Spam' policy. We don't share email address of our users for marketing purpose. The email address entered when you log into with us is not visible to anyone but you. We will be sending emails at the email ids provided by you and we will be making calls on the phone numbers provided by you if required. In case you have given a wrong email id or wrong phone number for correspondence, We will not be responsible for the information loss or privacy loss due to the message going to an another destination. 11. DISCLAIMER we cannot ensure that all of your private communications and other Personal Information will never be disclosed in ways not otherwise described in this privacy policy. Therefore, although we are committed to protecting your privacy, we do not promise, and you should not expect, that your Personal Information will always remain private. As a user of the Website and App, you understand and agree that you assume all responsibility and risk for your use of the website and app, the internet generally, and the documents you post or access and for your conduct on and off the Website and App. Your use of site is subjected to our Privacy Policy and terms of services.If you do not agree to this we request you not to use this portal"),
                                          ),
                                        )
                                      ],
                                    ));
                                  },
                                style: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline),
                              )
                            ]),
                      ),
                      const SizedBox(
                        width: 15,
                      )
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Obx(() => selectConditions.value
                      ? Column(
                          children: [
                            Text(
                              'Please agree to the terms and condition and privacy policy',
                              style: TextStyle(color: Colors.red.shade600),
                            ),
                            // SizedBox(
                            //   height: size.height * 0.03,
                            // ),
                          ],
                        )
                      : const SizedBox()),

                  /// SignUp Button
                  signUpButton(theme),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Powered By',
                          style: AppStyle.txtInterRegular16,
                        ),
                        const SizedBox(
                          height: 75,
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Image(
                              image: AssetImage('assets/images/logof.png'),
                              fit: BoxFit.contain, // use this
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Navigate To Login Screen
                  // GestureDetector(
                  //   onTap: () {
                  //     // Navigator.push(
                  //     //     context,
                  //     //     CupertinoPageRoute(
                  //     //         builder: (ctx) => const LoginView()));
                  //     controller.enteremailController.clear();
                  //     controller.enternameController.clear();
                  //     controller.enternumberController.clear();
                  //     controller.enterpasswordController.clear();
                  //     _formKey.currentState?.reset();

                  //     signUpController.isShowPassword.value = true;
                  //   },
                  //   child: RichText(
                  //     text: TextSpan(
                  //       text: 'Already have an account?',
                  //       style: kHaveAnAccountStyle(size),
                  //       children: [
                  //         TextSpan(
                  //             text: " Login",
                  //             style: kLoginOrSignUpTextStyle(size)),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // SignUp Button
  Widget signUpButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 65,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(ColorConstant.blue700),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        onPressed: () async {
          FocusScope.of(Get.context!).unfocus();
          // Validate returns true if the form is valid, or false otherwise.
          if (controller.isCheckbox.value == false) {
            selectConditions.value = true;
          } else {
            selectConditions.value = false;
          }
          if (_formKey.currentState!.validate()) {
            // ... Navigate To your Home Page
            FocusScope.of(Get.context!).unfocus();
            onTapSignup();
          }
        },
        child: Text(
          'Sign up',
          style: AppStyle.txtRalewayRomanSemiBold18,
        ),
      ),
    );
  }

  Future<void> onTapSignup() async {
    Map<String, dynamic> requestData = {
      "email": controller.enteremailController.text,
      "mobile": controller.enternumberController.text,
      "password": "",
      "role": "PATIENT",
      "termsAndConditionFlag": controller.isCheckbox.value,
      "username": controller.enternumberController.text
    };
    print(jsonEncode(requestData));
    try {
      await controller.callRegister(requestData);
    } on Map {
      _onOnTapSignInError();
    } on NoInternetException catch (e) {
      Get.rawSnackbar(message: e.toString());
    } catch (e) {
      Get.rawSnackbar(message: e.toString());
    }
  }

  void _onOnTapSignInError() {
    Fluttertoast.showToast(
      msg: "Facing technicl Difficulties",
    );
  }

  onTapTxtLogIn() {
    // Get.toNamed(
    //   AppRoutes.loginScreen,
    // );
    onTapArrowleft1();
  }

  onTapArrowleft1() {
    Get.back();
  }
}
