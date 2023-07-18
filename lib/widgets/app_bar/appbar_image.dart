import 'package:flutter/material.dart';

import '../../core/utils/size_utils.dart';
import '../custom_image_view.dart';

// ignore: must_be_immutable
class AppbarImage extends StatelessWidget implements PreferredSizeWidget {
  AppbarImage(
      {required this.height,
      required this.width,
      this.imagePath,
      this.svgPath,
      this.margin,
      this.onTap,
      this.leading,
      required this.backgroundColor});

  double height;

  double width;

  String? imagePath;

  String? svgPath;

  EdgeInsetsGeometry? margin;

  Function? onTap;

  Widget? leading;

  List<Widget>? actions;

  Color? backgroundColor;

  @override
  Size get preferredSize => Size(
        size.width,
        height,
      );

  // @override
  // Widget build(BuildContext context) {
  //   return InkWell(
  //     onTap: () {
  //       onTap?.call();
  //     },
  //     child: Padding(
  //       padding: margin ?? EdgeInsets.zero,
  //       child: CustomImageView(
  //         svgPath: svgPath,
  //         imagePath: imagePath,
  //         height: height,
  //         width: width,
  //         fit: BoxFit.contain,
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          onTap?.call();
        },
        child: AppBar(
          backgroundColor: backgroundColor,
          leading: leading,
          elevation: 2,
          actions: actions,
          title: imagePath != null
              ? Image.asset(
                  imagePath!,
                  height: 80,
                  width: 220,
                )
              : CustomImageView(
                  svgPath: svgPath!,
                  height: 80,
                  width: 220,
                ),
          centerTitle: true,
        )
        // Padding(
        //   padding: margin ?? EdgeInsets.zero,
        //   child: CustomImageView(
        //     svgPath: svgPath,
        //     imagePath: imagePath,
        //     height: height,
        //     width: width,
        //     fit: BoxFit.contain,
        //   ),
        // ),
        );
  }
}
