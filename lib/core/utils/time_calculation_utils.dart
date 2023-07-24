import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeCalculationUtils {
  String timeCalCulated(String? startTime, String? endTime, int? intervalTime) {
    TimeOfDay _startTime = TimeOfDay(
        hour: int.parse(startTime!.split(":")[0]),
        minute: int.parse(startTime
            .split(":")[1]
            .replaceAll(' AM', '')
            .replaceAll(' PM', '')));

    TimeOfDay _endTime = TimeOfDay(
        hour: int.parse(endTime!.split(":")[0]),
        minute: int.parse(
            endTime.split(":")[1].replaceAll(' AM', '').replaceAll(' PM', '')));
    String a = formatDate(
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
            _startTime.hour, _startTime.minute + intervalTime!),
        [hh, ':', nn, " ", am]).toString();
    String b = formatDate(
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
            _endTime.hour, _endTime.minute + intervalTime!),
        [hh, ':', nn, " ", am]).toString();
    return '${a.replaceAll(' AM', '').replaceAll(' PM', '')}-${b.replaceAll(' AM', ' PM')}';
  }

  String startTimeCalCulation(String? startTime, int? intervalTime) {
    TimeOfDay _startTime = TimeOfDay(
        hour: int.parse(startTime!.split(":")[0]),
        minute: int.parse(startTime
            .split(":")[1]
            .replaceAll(' AM', '')
            .replaceAll(' PM', '')));

    String a = formatDate(
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
            _startTime.hour, _startTime.minute + intervalTime!),
        [hh, ':', nn, " ", am]).toString();
    return a.replaceAll(' AM', ' PM');
  }
}
