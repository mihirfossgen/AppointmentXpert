// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

import '../core/utils/dimensions.dart';
import 'custom_richText.dart';

class CustomInput_eng extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? type;
  final String label;
  final bool isRequired;
  final double? height;
  const CustomInput_eng({
    required this.label,
    required this.controller,
    this.type,
    this.height,
    this.isRequired = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: Dimensions.calcH(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomRichText(
            text: label,
            children: (isRequired)
                ? [
                    const TextSpan(
                      text: " *",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ]
                : [],
          ),
          SizedBox(
            height: Dimensions.calcH(8),
          ),
          Container(
            color: Colors.red,
            height: height,
            margin: EdgeInsets.only(
              right: Dimensions.calcW(50),
            ),
            child: TextFormField(
              controller: controller,
              keyboardType: type,
              decoration: const InputDecoration(
                border: InputBorder.none,
                fillColor: Colors.red,
                filled: true,
              ),
            ),
          )
        ],
      ),
    );
  }
}
