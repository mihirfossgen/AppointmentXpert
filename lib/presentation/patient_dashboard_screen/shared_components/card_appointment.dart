import 'package:appointmentxpert/core/utils/app_helpers.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/getAllApointments.dart';

class CardAppointmentData {
  final AppointmentContent appointment;

  const CardAppointmentData({
    required this.appointment,
  });
}

class CardAppointment extends StatelessWidget {
  const CardAppointment({
    required this.appointment,
    required this.primary,
    required this.onPrimary,
    Key? key,
  }) : super(key: key);

  final AppointmentContent appointment;
  final Color primary;
  final Color onPrimary;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Material(
        child: InkWell(
          onTap: () {
            // Navigator.push(
            //     Get.context!,
            //     MaterialPageRoute(
            //         builder: (context) => AppointmentDetailsPage(
            //               appointment: appointment,
            //               appointmentid: appointment.id!,
            //             )));
          },
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primary, primary.withOpacity(.7)],
                begin: AlignmentDirectional.topCenter,
                end: AlignmentDirectional.bottomCenter,
              ),
            ),
            child: _BackgroundDecoration(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildPatientName(),
                          const SizedBox(height: 10),
                          _buildDoctorName(),
                          const SizedBox(height: 10),
                          _buildDiesease(),
                        ],
                      ),
                    ),
                    const Spacer(flex: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDate(),
                        SizedBox(
                          height: 20,
                          child: VerticalDivider(
                            thickness: 1,
                            color: onPrimary,
                          ),
                        ),
                        _buildHours(),
                      ],
                    ),
                    const Spacer(flex: 2),
                    _doneButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPatientName() {
    return Text(
      '${appointment.patient?.firstName} ' '${appointment.patient?.lastName}',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: onPrimary,
        letterSpacing: 1,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDoctorName() {
    return Text(
      '${appointment.examiner?.firstName} ' '${appointment.examiner?.lastName}',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: onPrimary,
        letterSpacing: 1,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDiesease() {
    return Container(
      decoration: BoxDecoration(
        color: onPrimary.withOpacity(.3),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(
        appointment.note ?? '',
        style: TextStyle(
          color: onPrimary,
          fontSize: 12,
          letterSpacing: 1,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildDate() {
    return _IconLabel(
      color: onPrimary,
      iconData: EvaIcons.calendarOutline,
      label: DateFormat('d MMM').format(DateTime.parse(appointment.date ?? '')),
    );
  }

  Widget _buildHours() {
    return _IconLabel(
      color: onPrimary,
      iconData: EvaIcons.clockOutline,
      label: DateTime.parse(appointment.date ?? '').dueDate(),
    );
  }

  Widget _doneButton() {
    return ElevatedButton.icon(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        foregroundColor: primary, backgroundColor: onPrimary,
      ),
      icon: const Icon(EvaIcons.checkmarkCircle2Outline),
      label: const Text("Done"),
    );
  }
}

class _IconLabel extends StatelessWidget {
  const _IconLabel({
    required this.color,
    required this.iconData,
    required this.label,
    Key? key,
  }) : super(key: key);

  final Color color;
  final IconData iconData;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          iconData,
          color: color,
          size: 18,
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color.withOpacity(.8),
          ),
        )
      ],
    );
  }
}

class _BackgroundDecoration extends StatelessWidget {
  const _BackgroundDecoration({required this.child, Key? key})
      : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Transform.translate(
            offset: const Offset(25, -25),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white.withOpacity(.1),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Transform.translate(
            offset: const Offset(-70, 70),
            child: CircleAvatar(
              radius: 100,
              backgroundColor: Colors.white.withOpacity(.1),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
