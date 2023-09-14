import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/color_constant.dart';

class TodaysAppointmentsProgressData {
  final int totalAppointments;
  final int totalCompleted;

  const TodaysAppointmentsProgressData({
    required this.totalAppointments,
    required this.totalCompleted,
  });
}

class AppointmentProgress extends StatelessWidget {
  const AppointmentProgress({
    required this.data,
    Key? key,
  }) : super(key: key);

  final TodaysAppointmentsProgressData data;

  double percent(int totalCompleted, int totalAppointments) {
    if (totalCompleted == 0 && totalAppointments == 0) {
      return 0.0;
    } else {
      double calculatedValue = data.totalCompleted / data.totalAppointments;
      return calculatedValue == 0 ? 0.0 : calculatedValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildText(),
        Expanded(child: _buildProgress()),
      ],
    );
  }

  Widget _buildText() {
    return Text(
      "${data.totalCompleted} of ${data.totalAppointments} completed",
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: kFontColorPallets[2],
        fontSize: 13,
      ),
    );
  }

  Widget _buildProgress() {
    return LinearPercentIndicator(
        width: 90.0,
        lineHeight: 8.0,
        percent: percent(data.totalCompleted, data.totalAppointments),
        progressColor: ColorConstant.blue700,
        backgroundColor: Colors.blueGrey[200]);
  }
}
