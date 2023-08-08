import 'package:flutter/material.dart';

import '../core/constants/constants.dart';
import '../core/utils/color_constant.dart';
import '../core/utils/size_utils.dart';

class CustomTextFormField extends StatefulWidget {
  CustomTextFormField(
      {super.key,
      this.shape,
      this.padding,
      this.variant,
      this.fontStyle,
      this.alignment,
      this.width,
      this.margin,
      this.controller,
      this.focusNode,
      this.isObscureText = false,
      this.textInputAction = TextInputAction.next,
      this.textInputType = TextInputType.text,
      this.maxLines,
      this.hintText,
      this.prefix,
      this.prefixConstraints,
      this.suffix,
      this.suffixConstraints,
      this.validator,
      this.size,
      this.labelText,
      this.readonly,
      this.initalValue,
      this.isRequired,
      this.maxLength});

  TextFormFieldShape? shape;

  TextFormFieldPadding? padding;

  TextFormFieldVariant? variant;

  TextFormFieldFontStyle? fontStyle;

  Alignment? alignment;

  double? width;

  Size? size;

  EdgeInsetsGeometry? margin;

  TextEditingController? controller;

  FocusNode? focusNode;

  bool? isObscureText;
  bool? isRequired = false;

  TextInputAction? textInputAction;

  TextInputType? textInputType;

  int? maxLines;
  int? maxLength;
  String? hintText;
  String? labelText;

  Widget? prefix;

  BoxConstraints? prefixConstraints;

  Widget? suffix;
  bool? readonly;
  String? initalValue;

  BoxConstraints? suffixConstraints;

  FormFieldValidator<String>? validator;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.alignment != null
        ? Align(
            alignment: widget.alignment ?? Alignment.center,
            child: _buildTextFormFieldWidget(),
          )
        : _buildTextFormFieldWidget();
  }

  _buildTextFormFieldWidget() {
    return Container(
      width: widget.width ?? double.maxFinite,
      //height: Responsive.isMobile(context) ? 50 : 80,
      margin: widget.margin,
      child: TextFormField(
        readOnly: widget.readonly ?? false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: widget.controller,
        initialValue: widget.initalValue,
        focusNode: widget.focusNode,
        style: kTextFormFieldStyle(),
        obscureText: widget.isObscureText!,
        textInputAction: widget.textInputAction,
        keyboardType: widget.textInputType,
        maxLines: widget.maxLines ?? 1,
        maxLength: widget.maxLength ?? null,
        decoration: _buildDecoration(),
        validator: widget.validator,
      ),
    );
  }

  _buildDecoration() {
    return InputDecoration(
      counterText: '',
      hintText: widget.hintText ?? "",
      hintStyle: _setFontStyle(),
      border: _setBorderStyle(),
      enabledBorder: _setBorderStyle(),
      focusedBorder: _setBorderStyle(),
      disabledBorder: _setBorderStyle(),
      prefixIcon: widget.prefix,
      label: FittedBox(
        //color: Colors.amber,
        child: Row(
          children: [
            Text(widget.labelText!),
            const Padding(
              padding: EdgeInsets.all(3.0),
            ),
            widget.isRequired == true
                ? const Text('*', style: TextStyle(color: Colors.red))
                : const SizedBox(
                    width: 0,
                  ),
          ],
        ),
      ),
      // floatingLabelAlignment: FloatingLabelAlignment.start,
      labelStyle: const TextStyle(
          color: Colors.black, fontWeight: FontWeight.w400, fontSize: 20),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      prefixIconConstraints: widget.prefixConstraints,
      suffixIcon: widget.suffix,
      suffixIconConstraints: widget.suffixConstraints,
      fillColor: _setFillColor(),
      filled: _setFilled(),
      isDense: true,
      contentPadding: _setPadding(),
    );
  }

  _setFontStyle() {
    switch (widget.fontStyle) {
      case TextFormFieldFontStyle.RalewayRomanMedium16Gray900:
        return TextStyle(
          color: ColorConstant.gray900,
          fontSize: getFontSize(
            16,
          ),
          fontFamily: 'Raleway',
          fontWeight: FontWeight.w500,
          height: getVerticalSize(
            1.19,
          ),
        );
      case TextFormFieldFontStyle.RalewayRomanRegular14Gray500:
        return TextStyle(
          color: ColorConstant.gray500,
          fontSize: getFontSize(
            14,
          ),
          fontFamily: 'Raleway',
          fontWeight: FontWeight.w400,
          height: getVerticalSize(
            1.21,
          ),
        );
      case TextFormFieldFontStyle.RalewayRomanSemiBold14Gray90001:
        return TextStyle(
          color: ColorConstant.gray90001,
          fontSize: getFontSize(
            14,
          ),
          fontFamily: 'Raleway',
          fontWeight: FontWeight.w600,
          height: getVerticalSize(
            1.21,
          ),
        );
      default:
        return TextStyle(
          color: ColorConstant.blueGray300,
          fontSize: getFontSize(
            16,
          ),
          fontFamily: 'Raleway',
          fontWeight: FontWeight.w400,
          height: getVerticalSize(
            1.19,
          ),
        );
    }
  }

  _setOutlineBorderRadius() {
    switch (widget.shape) {
      default:
        return BorderRadius.circular(
          getHorizontalSize(
            5.00,
          ),
        );
    }
  }

  _setBorderStyle() {
    switch (widget.variant) {
      case TextFormFieldVariant.OutlineBlue600:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide(
            color: ColorConstant.blue600,
            width: 1,
          ),
        );
      case TextFormFieldVariant.OutlineBluegray50:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide(
            color: ColorConstant.blueGray50,
            width: 1,
          ),
        );
      case TextFormFieldVariant.UnderLineBluegray50:
        return UnderlineInputBorder(
          borderSide: BorderSide(
            color: ColorConstant.blueGray50,
          ),
        );
      case TextFormFieldVariant.None:
        return InputBorder.none;
      default:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide(
            color: Colors.grey.shade400,
            width: 1,
          ),
        );
    }
  }

  _setFillColor() {
    switch (widget.variant) {
      case TextFormFieldVariant.OutlineBluegray50:
        return ColorConstant.whiteA700;
      default:
        return null;
    }
  }

  _setFilled() {
    switch (widget.variant) {
      case TextFormFieldVariant.OutlineGray200:
        return false;
      case TextFormFieldVariant.OutlineBlue600:
        return false;
      case TextFormFieldVariant.OutlineBluegray50:
        return true;
      case TextFormFieldVariant.UnderLineBluegray50:
        return false;
      case TextFormFieldVariant.None:
        return false;
      default:
        return false;
    }
  }

  _setPadding() {
    switch (widget.padding) {
      case TextFormFieldPadding.PaddingT16:
        return getPadding(
          top: 18,
          right: 12,
          bottom: 18,
        );
      case TextFormFieldPadding.PaddingT16_2:
        return getPadding(
          top: 18,
          right: 18,
          bottom: 18,
        );
      case TextFormFieldPadding.PaddingT14:
        return getPadding(
          left: 10,
          top: 10,
          bottom: 16,
        );
      default:
        return getPadding(
          top: 18,
          bottom: 18,
        );
    }
  }
}

enum TextFormFieldShape {
  RoundedBorder6,
}

enum TextFormFieldPadding {
  PaddingT16,
  PaddingT16_1,
  PaddingT16_2,
  PaddingT14,
}

enum TextFormFieldVariant {
  None,
  OutlineGray200,
  OutlineBlue600,
  OutlineBluegray50,
  UnderLineBluegray50,
}

enum TextFormFieldFontStyle {
  RalewayRomanRegular16Bluegray300,
  RalewayRomanMedium16Gray900,
  RalewayRomanRegular14Gray500,
  RalewayRomanSemiBold14Gray90001,
}
