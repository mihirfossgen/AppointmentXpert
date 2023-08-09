import 'package:appointmentxpert/core/utils/color_constant.dart';
import 'package:appointmentxpert/widgets/responsive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(builder: (_) => const HomePage()),
    // );
    Get.offAllNamed(AppRoutes.loginScreen);
  }

  Widget _buildFullscreenImage() {
    return Image.asset(
      'assets/images/logo-opdxpert.png',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset(
      'assets/images/$assetName',
      width: width,
      //height: 60,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: IntroductionScreen(
            key: introKey,
            globalBackgroundColor: Colors.white,
            allowImplicitScrolling: true,
            autoScrollDuration: 3000,
            infiniteAutoScroll: false,
            globalHeader: Container(
              color: ColorConstant.whiteA700,
              child: Align(
                alignment: Alignment.topCenter,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 8, right: 8),
                    child: _buildImage('logo-opdxpert.png', 280),
                  ),
                ),
              ),
            ),
            globalFooter: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  child: const Text(
                    'Go to Login',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => _onIntroEnd(context),
                ),
              ),
            ),
            pages: [
              PageViewModel(
                //title: "Dr. Manuel Durairaj",
                titleWidget: const Text(
                  'Dr. Manuel Durairaj',
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
                useScrollView: true,
                bodyWidget: const SizedBox(
                  //height: 300,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cardiologist',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Founding Member, Fellow and Former President of the Indian College of Cardiology. Former Professor and Chairman of the Academic Department of Cardiology at Grant Medical Foundation in Pune",
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),
                image: _buildImage('manuel_duriaraj.png'),
                reverse: true,
                decoration: pageDecoration.copyWith(
                  bodyFlex: 2,
                  imageFlex: 2,
                  bodyAlignment: Alignment.bottomCenter,
                  imageAlignment: Alignment.topCenter,
                ),
              ),
              PageViewModel(
                //title: "Dr. Manoj Durairaj",
                titleWidget: const Text(
                  'Dr. Manoj Durairaj',
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
                bodyWidget: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cardiac Surgeon | Pediatric and Adult Cardiac Surgery',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "First Heart Transplant Performed in Pune on 05-March-2017. First LVAD in Pune | 15,000+ Cardiac Surgeries",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
                image: _buildImage('dr-manoj-image.png'),
                reverse: true,
                decoration: pageDecoration.copyWith(
                  bodyFlex: 2,
                  imageFlex: 2,
                  bodyAlignment: Alignment.bottomCenter,
                  imageAlignment: Alignment.topCenter,
                ),
              ),
              PageViewModel(
                title: "",
                bodyWidget: GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: Responsive.isMobile(context)
                        ? 2
                        : Responsive.isTablet(context)
                            ? 3
                            : 6,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height / 1.4),
                  ),
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '1st',
                                style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "FIRST HEART TRANSPLANT IN PUNE MAHARASHTRA*",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '1st',
                                style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: ColorConstant.blue60001),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                "FIRST SURGEON TO START 3 HEART TRANSPLANT CENTRES IN MAHARASHTRA",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '1st',
                                style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "FIRST SUCCESSFUL LVAD IN PUNE / AND REST OF MAHARASHTRA*",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '1st',
                                style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: ColorConstant.blue60001),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                "FIRST CARDIAC SURGEON IN PUNE TO BE ELECTED AS FELLOW OF THE AMERICAN COLLEGE OF CARDIOLOGY",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '1st',
                                style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "FIRST INDIAN SURGEON, TO HAVE PERFORMED PAEDIATRIC CARDIAC SURGERY IN NIGERIA",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '1st',
                                style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "FIRST OFF PUMP CORONARY SURGERY IN AL THAWARA HOSPITAL, YEMEN",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '30',
                                style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: ColorConstant.blue60001),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                "HEART TRANSPLANTS",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '15000+',
                                style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "MORE THAN 15000 SUCCESSFUL HEART SURGERIES",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '600+',
                                  style: TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                      color: ColorConstant.blue60001),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  "LIVES SAVED THROUGH SAVING LITTLE HEARTS PROJECT BY MARIAN",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
                // image: _buildImage('img_7xm5.png'),
                // decoration: pageDecoration.copyWith(
                //   bodyFlex: 2,
                //   imageFlex: 4,
                //   bodyAlignment: Alignment.bottomCenter,
                //   imageAlignment: Alignment.topCenter,
                // ),
                reverse: true,
              ),
            ],
            onDone: () => _onIntroEnd(context),
            onSkip: () =>
                _onIntroEnd(context), // You can override onSkip callback
            showSkipButton: false,
            skipOrBackFlex: 0,
            nextFlex: 0,
            showBackButton: true,
            //rtl: true, // Display as right-to-left
            back: Icon(
              Icons.arrow_back,
              color: ColorConstant.black900,
            ),
            skip: Text('Skip',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: ColorConstant.black900,
                )),
            next: Icon(
              Icons.arrow_forward,
              color: ColorConstant.black900,
            ),
            done: Text('Done',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: ColorConstant.black900,
                )),
            curve: Curves.fastLinearToSlowEaseIn,
            controlsMargin: const EdgeInsets.all(16),
            controlsPadding: kIsWeb
                ? const EdgeInsets.all(8.0)
                : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
            dotsDecorator: DotsDecorator(
              size: const Size(10.0, 10.0),
              //color: Color(0xFFBDBDBD),
              color: ColorConstant.black900,
              activeColor: Colors.red,
              activeSize: const Size(12.0, 10.0),
              activeShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
            ),
            dotsContainerDecorator: ShapeDecoration(
              color: Colors.grey.shade300,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
