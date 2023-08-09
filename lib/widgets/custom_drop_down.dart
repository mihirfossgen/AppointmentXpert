import 'package:appointmentxpert/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/utils/color_constant.dart';
import '../core/utils/size_utils.dart';
import '../data/models/selectionPopupModel/selection_popup_model.dart';

class CustomDropDown extends StatelessWidget {
  CustomDropDown(
      {super.key,
      this.shape,
      this.padding,
      this.variant,
      this.fontStyle,
      this.alignment,
      this.width,
      this.margin,
      this.focusNode,
      this.icon,
      this.hintText,
      this.labelText,
      this.prefix,
      this.prefixConstraints,
      this.items,
      this.onChanged,
      this.validator,
      this.isRequired});

  DropDownShape? shape;

  DropDownPadding? padding;

  DropDownVariant? variant;

  DropDownFontStyle? fontStyle;

  Alignment? alignment;

  double? width;

  EdgeInsetsGeometry? margin;

  FocusNode? focusNode;
  bool? isRequired;

  Widget? icon;

  String? hintText;
  String? labelText;

  Widget? prefix;

  BoxConstraints? prefixConstraints;

  List<SelectionPopupModel>? items;

  Function(SelectionPopupModel)? onChanged;

  FormFieldValidator<SelectionPopupModel>? validator;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: _buildDropDownWidget(),
          )
        : _buildDropDownWidget();
  }

  _buildDropDownWidget() {
    return Container(
      width: width ?? double.maxFinite,
      height: Responsive.isMobile(Get.context!) ? 50 : 70,
      margin: margin,
      child: DropdownButtonFormField<SelectionPopupModel>(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        focusNode: focusNode,
        icon: icon,
        isExpanded: true,
        style: _setFontStyle(),
        decoration: _buildDecoration(),
        items: items?.map((SelectionPopupModel item) {
          return DropdownMenuItem<SelectionPopupModel>(
            value: item,
            child: Text(
              item.title,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: (value) {
          onChanged!(value!);
        },
        validator: validator,
      ),
    );
  }

  _buildDecoration() {
    return InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      hintText: hintText ?? "",
      hintStyle: _setFontStyle(),
      border: _setBorderStyle(),
      enabledBorder: _setBorderStyle(),
      focusedBorder: _setBorderStyle(),
      disabledBorder: _setBorderStyle(),
      prefixIcon: prefix,
      label: FittedBox(
        //color: Colors.amber,
        child: Row(
          children: [
            Text(labelText ?? ""),
            const Padding(
              padding: EdgeInsets.all(3.0),
            ),
            isRequired != null
                ? const Text('*', style: TextStyle(color: Colors.red))
                : const SizedBox(
                    width: 0,
                  ),
          ],
        ),
      ),
      labelStyle: const TextStyle(
          color: Colors.black, fontWeight: FontWeight.w400, fontSize: 20),
      prefixIconConstraints: prefixConstraints,
      fillColor: _setFillColor(),
      filled: _setFilled(),
      isDense: true,
      contentPadding: _setPadding(),
    );
  }

  _setFontStyle() {
    switch (fontStyle) {
      case DropDownFontStyle.ManropeSemiBold14Gray900:
        return TextStyle(
          color: ColorConstant.gray900,
          fontSize: getFontSize(
            14,
          ),
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w600,
          height: getVerticalSize(
            1.43,
          ),
        );
      case DropDownFontStyle.ManropeMedium14Bluegray500:
        return TextStyle(
          color: ColorConstant.black900,
          fontSize: getFontSize(
            14,
          ),
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w500,
          height: getVerticalSize(
            1.43,
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
    switch (shape) {
      default:
        return BorderRadius.circular(
          getHorizontalSize(
            5.00,
          ),
        );
    }
  }

  _setBorderStyle() {
    switch (variant) {
      case DropDownVariant.FillBluegray50:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide.none,
        );
      case DropDownVariant.None:
        return InputBorder.none;
      case DropDownVariant.GreyOutline:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            getHorizontalSize(
              5.00,
            ),
          ),
          borderSide: BorderSide(
            color: ColorConstant.gray400,
            width: 1,
          ),
        );
      default:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide(
            color: ColorConstant.gray400,
            width: 1,
          ),
        );
    }
  }

  _setFillColor() {
    switch (variant) {
      case DropDownVariant.FillBluegray50:
        return ColorConstant.blueGray50;
      case DropDownVariant.GreyOutline:
        return ColorConstant.whiteA700;
      default:
        return ColorConstant.gray50;
    }
  }

  _setFilled() {
    switch (variant) {
      case DropDownVariant.FillBluegray50:
        return true;
      case DropDownVariant.None:
        return false;
      default:
        return false;
    }
  }

  _setPadding() {
    switch (padding) {
      default:
        return getPadding(
          left: 10,
          top: 16,
          bottom: 16,
        );
    }
  }
}

enum DropDownShape {
  RoundedBorder10,
}

enum DropDownPadding {
  PaddingT11,
}

enum DropDownVariant { None, OutlineBluegray400, FillBluegray50, GreyOutline }

enum DropDownFontStyle {
  ManropeRegular14Bluegray500,
  ManropeSemiBold14Gray900,
  ManropeMedium14Bluegray500,
}
