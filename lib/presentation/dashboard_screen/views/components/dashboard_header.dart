//part of dashboard;

import 'package:flutter/material.dart';

import '../../shared_components/header_text.dart';

class HeaderDashboard extends StatelessWidget {
  String role;
  HeaderDashboard({Key? key, required this.role}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const HeaderText("Dashboard"),
        const SizedBox(width: 10),
        const Icon(Icons.arrow_right),
        Text('$role Dashboard')
      ],
    );
  }
}
