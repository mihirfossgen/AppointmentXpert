import 'package:flutter/material.dart';

import '../../core/utils/color_constant.dart';
import '../../core/utils/size_utils.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar(
      {super.key, required this.height,
      this.styleType,
      this.leadingWidth,
      this.leading,
      this.title,
      this.centerTitle,
      this.actions,
      this.backgroundColor,
      this.elevation});

  double height;

  Style? styleType;

  double? leadingWidth;

  Widget? leading;

  Widget? title;

  bool? centerTitle;

  List<Widget>? actions;

  Color? backgroundColor;

  double? elevation;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: elevation,
      toolbarHeight: height,
      automaticallyImplyLeading: true,
      backgroundColor: backgroundColor == null
          ? Colors.transparent
          : ColorConstant.whiteA70087,
      flexibleSpace: _getStyle(),
      leadingWidth: leadingWidth ?? 0,
      leading: leading,
      title: title,
      titleSpacing: 0,
      centerTitle: centerTitle ?? false,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size(
        size.width,
        height,
      );
  _getStyle() {
    switch (styleType) {
      case Style.bgShadowBlack90019:
        return Container(
          height: getVerticalSize(
            40,
          ),
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: ColorConstant.whiteA700,
            boxShadow: [
              BoxShadow(
                color: ColorConstant.black90019,
                spreadRadius: getHorizontalSize(
                  2,
                ),
                blurRadius: getHorizontalSize(
                  2,
                ),
                offset: const Offset(
                  0,
                  10,
                ),
              ),
            ],
          ),
        );
      default:
        return null;
    }
  }
}

enum Style {
  bgShadowBlack90019,
}
