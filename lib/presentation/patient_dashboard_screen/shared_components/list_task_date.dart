import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_constants.dart';
import '../../../models/getAllApointments.dart';

class ListAppointmentDateData {
  final DateTime date;
  final String label;
  final String details;

  const ListAppointmentDateData({
    required this.date,
    required this.label,
    required this.details,
  });
}

class ListAppointmentDate extends StatelessWidget {
  const ListAppointmentDate({
    required this.data,
    required this.onPressed,
    this.dividerColor,
    Key? key,
  }) : super(key: key);

  final AppointmentContent data;
  final Function() onPressed;
  final Color? dividerColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(kBorderRadius),
      child: Padding(
        padding: const EdgeInsets.all(kSpacing / 2),
        child: Row(
          children: [
            _buildHours(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kSpacing),
              child: _buildDivider(),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(),
                  const SizedBox(height: 5),
                  _buildSubtitle(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHours() {
    DateTime parseDate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").parse(data.date!);
    return Text(
      DateFormat.Hm().format(parseDate),
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 3,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        gradient: LinearGradient(
          colors: [
            dividerColor ?? Colors.amber,
            dividerColor?.withOpacity(.6) ?? Colors.amber.withOpacity(.6),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    var text = '';
    if (data.note != null && data.note != '') {
      text = data.note!;
    } else {
      text = data.purpose ?? 'N/A';
    }
    return Text(
      'Appointment for $text',
      maxLines: 2,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w200,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildSubtitle() {
    return Text(
      '${data.patient?.prefix}'
      '${data.patient?.firstName} '
      '${data.patient?.lastName}',
      maxLines: 1,
      style: const TextStyle(fontWeight: FontWeight.w600),
      overflow: TextOverflow.ellipsis,
    );
  }
}
