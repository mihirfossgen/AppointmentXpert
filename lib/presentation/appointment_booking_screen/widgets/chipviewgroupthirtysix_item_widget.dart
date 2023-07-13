import 'package:get/get.dart';

import '../../../core/utils/color_constant.dart';
import '../../../core/utils/size_utils.dart';
import '../models/chipviewgroupthirtysix_item_model.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ChipviewgroupthirtysixItemWidget extends StatelessWidget {
  ChipviewgroupthirtysixItemWidget(this.chipviewgroupthirtysixItemModelObj);

  ChipviewgroupthirtysixItemModel chipviewgroupthirtysixItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => RawChip(
        padding: getPadding(
          left: 25,
          right: 25,
        ),
        showCheckmark: false,
        labelPadding: EdgeInsets.zero,
        label: Text(
          chipviewgroupthirtysixItemModelObj.groupThirtySixTxt.value,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: chipviewgroupthirtysixItemModelObj.isSelected.value
                ? ColorConstant.gray400
                : ColorConstant.gray90001,
            fontSize: getFontSize(
              12,
            ),
            fontFamily: 'Raleway',
            fontWeight: FontWeight.w400,
          ),
        ),
        selected: chipviewgroupthirtysixItemModelObj.isSelected.value,
        backgroundColor: ColorConstant.whiteA700,
        selectedColor: ColorConstant.whiteA700,
        shape: chipviewgroupthirtysixItemModelObj.isSelected.value
            ? RoundedRectangleBorder(
                side: BorderSide(
                  color: ColorConstant.gray10001,
                  width: getHorizontalSize(
                    1,
                  ),
                ),
                borderRadius: BorderRadius.circular(
                  getHorizontalSize(
                    15,
                  ),
                ),
              )
            : RoundedRectangleBorder(
                side: BorderSide(
                  color: ColorConstant.blueGray10001,
                  width: getHorizontalSize(
                    1,
                  ),
                ),
                borderRadius: BorderRadius.circular(
                  getHorizontalSize(
                    15,
                  ),
                ),
              ),
        onSelected: (value) {
          chipviewgroupthirtysixItemModelObj.isSelected.value = value;
        },
      ),
    );
  }
}
