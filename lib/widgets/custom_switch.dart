import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  CustomSwitch(
      {super.key, this.alignment,
      this.margin,
      this.width,
      this.value,
      required this.onchanged});
  Alignment? alignment;
  double? width;
  EdgeInsetsGeometry? margin;
  bool? value;
  Function(bool) onchanged;
  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: _buildTextFormFieldWidget(),
          )
        : _buildTextFormFieldWidget();
  }

  _buildTextFormFieldWidget() {
    return Container(
        width: width ?? double.maxFinite,
        margin: margin,
        child: Switch(
          value: value ?? false,
          onChanged: onchanged,
        ));
  }
}
