import 'package:appointmentxpert/core/utils/color_constant.dart';
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
    return Image.asset('assets/images/$assetName', width: width);
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
            autoScrollDuration: 5000,
            infiniteAutoScroll: false,
            globalHeader: Align(
              alignment: Alignment.topCenter,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, right: 16),
                  child: _buildImage('logo-opdxpert.png', 280),
                ),
              ),
            ),
            globalFooter: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
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
                title: "",
                bodyWidget: const Text(
                  "Dr. Manoj Duraira is working in cardiovascular and thoracic surgery since 1996",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                image: _buildImage('img_7xm5.png'),
                reverse: true,
                decoration: pageDecoration.copyWith(
                  bodyFlex: 2,
                  imageFlex: 4,
                  bodyAlignment: Alignment.bottomCenter,
                  imageAlignment: Alignment.topCenter,
                ),
              ),
              PageViewModel(
                title: "",
                bodyWidget: const Text(
                  "He has worked with senior surgeons from Pune and Mumbai and gained enough experience..",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                image: _buildImage('img_7xm5.png'),
                reverse: true,
                decoration: pageDecoration.copyWith(
                  bodyFlex: 2,
                  imageFlex: 4,
                  bodyAlignment: Alignment.bottomCenter,
                  imageAlignment: Alignment.topCenter,
                ),
              ),
              PageViewModel(
                title: "",
                bodyWidget: const Text(
                  "Let's get started to know more about the app click done.",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                image: _buildImage('img_7xm5.png'),
                decoration: pageDecoration.copyWith(
                  bodyFlex: 2,
                  imageFlex: 4,
                  bodyAlignment: Alignment.bottomCenter,
                  imageAlignment: Alignment.topCenter,
                ),
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
              color: ColorConstant.whiteA700,
            ),
            skip: Text('Skip',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: ColorConstant.whiteA700,
                )),
            next: Icon(
              Icons.arrow_forward,
              color: ColorConstant.whiteA700,
            ),
            done: Text('Done',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: ColorConstant.whiteA700,
                )),
            curve: Curves.fastLinearToSlowEaseIn,
            controlsMargin: const EdgeInsets.all(16),
            controlsPadding: kIsWeb
                ? const EdgeInsets.all(12.0)
                : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
            dotsDecorator: DotsDecorator(
              size: const Size(10.0, 10.0),
              //color: Color(0xFFBDBDBD),
              color: ColorConstant.whiteA700,
              activeColor: Colors.red,
              activeSize: const Size(22.0, 10.0),
              activeShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
            ),
            dotsContainerDecorator: const ShapeDecoration(
              color: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
