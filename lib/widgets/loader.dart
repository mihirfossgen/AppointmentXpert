import 'package:appointmentxpert/core/utils/color_constant.dart';
import 'package:appointmentxpert/widgets/spin_kit_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ThreeDotLoader extends StatelessWidget {
  final Color? color;
  ThreeDotLoader({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Center(
            child: SpinKitThreeBounce(
          color: ColorConstant.blue700,
        )));
  }
}
