import 'package:flutter/material.dart';
import '../core/utils/color_constant.dart';
import '../core/utils/size_utils.dart';

class AppDecoration {
  static BoxDecoration get fillGray50 => BoxDecoration(
        color: ColorConstant.gray50,
      );
  static BoxDecoration get outlineGray2001 => BoxDecoration(
        color: ColorConstant.whiteA700,
        border: Border.all(
          color: ColorConstant.gray200,
          width: getHorizontalSize(
            1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: ColorConstant.gray60014,
            spreadRadius: getHorizontalSize(
              2,
            ),
            blurRadius: getHorizontalSize(
              2,
            ),
            offset: const Offset(
              0,
              4,
            ),
          ),
        ],
      );
  static BoxDecoration get txtFillGray10002 => BoxDecoration(
        color: ColorConstant.gray10002,
      );
  static BoxDecoration get fillWhiteA70001 => BoxDecoration(
        color: ColorConstant.whiteA70001,
      );
  static BoxDecoration get gradientBlack90000Black900b2 => BoxDecoration(
        color: ColorConstant.whiteA700,
        gradient: LinearGradient(
          begin: const Alignment(
            0.5,
            0.5,
          ),
          end: const Alignment(
            0.5,
            1,
          ),
          colors: [
            ColorConstant.black90000,
            ColorConstant.black900B2,
          ],
        ),
      );
  static BoxDecoration get linear => BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(
            0.5,
            0,
          ),
          end: const Alignment(
            0.5,
            1,
          ),
          colors: [
            ColorConstant.blue60001,
            ColorConstant.blue700,
          ],
        ),
      );
  static BoxDecoration get txtStyle => BoxDecoration(
        color: ColorConstant.blue6006c,
      );
  static BoxDecoration get gradientBlue60001Blue700 => BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(
            0,
            0,
          ),
          end: const Alignment(
            1,
            0.43,
          ),
          colors: [
            ColorConstant.blue60001,
            ColorConstant.blue700,
          ],
        ),
      );
  static BoxDecoration get outlineGray200 => BoxDecoration(
        color: ColorConstant.whiteA700,
        border: Border.all(
          color: ColorConstant.gray200,
          width: getHorizontalSize(
            1,
          ),
        ),
      );
  static BoxDecoration get txtFillBluegray50 => BoxDecoration(
        color: ColorConstant.blueGray50,
      );
  static BoxDecoration get white => BoxDecoration(
        color: ColorConstant.whiteA700,
      );
  static BoxDecoration get outlineBluegray501 => BoxDecoration(
        border: Border.all(
          color: ColorConstant.blueGray50,
          width: getHorizontalSize(
            1,
          ),
        ),
      );
  static BoxDecoration get fillBlue60002 => BoxDecoration(
        color: ColorConstant.blue60002,
      );
  static BoxDecoration get fillBlue50 => BoxDecoration(
        color: ColorConstant.blue50,
      );
  static BoxDecoration get fillRed50 => BoxDecoration(
        color: ColorConstant.red50,
      );
  static BoxDecoration get style => BoxDecoration(
        color: ColorConstant.blue600,
      );
  static BoxDecoration get fillGray200 => BoxDecoration(
        color: ColorConstant.gray200,
      );
  static BoxDecoration get txtFillBlue600 => BoxDecoration(
        color: ColorConstant.blue600,
      );
  static BoxDecoration get outlineBlack90019 => BoxDecoration(
        color: ColorConstant.blue5001,
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
              17,
            ),
          ),
        ],
      );
  static BoxDecoration get outlineBluegray50 => BoxDecoration(
        color: ColorConstant.whiteA700,
        border: Border.all(
          color: ColorConstant.blueGray50,
          width: getHorizontalSize(
            1,
          ),
        ),
      );
}

class BorderRadiusStyle {
  static BorderRadius customBorderTL64 = BorderRadius.only(
    topLeft: Radius.circular(
      getHorizontalSize(
        64,
      ),
    ),
  );

  static BorderRadius customBorderTL30 = BorderRadius.only(
    topLeft: Radius.circular(
      getHorizontalSize(
        30,
      ),
    ),
    topRight: Radius.circular(
      getHorizontalSize(
        30,
      ),
    ),
  );

  static BorderRadius customBorderBL5 = BorderRadius.only(
    topRight: Radius.circular(
      getHorizontalSize(
        5,
      ),
    ),
    bottomLeft: Radius.circular(
      getHorizontalSize(
        5,
      ),
    ),
    bottomRight: Radius.circular(
      getHorizontalSize(
        5,
      ),
    ),
  );

  static BorderRadius customBorderTL8 = BorderRadius.only(
    topLeft: Radius.circular(
      getHorizontalSize(
        8,
      ),
    ),
    bottomLeft: Radius.circular(
      getHorizontalSize(
        8,
      ),
    ),
    bottomRight: Radius.circular(
      getHorizontalSize(
        8,
      ),
    ),
  );

  static BorderRadius circleBorder29 = BorderRadius.circular(
    getHorizontalSize(
      29,
    ),
  );

  static BorderRadius roundedBorder8 = BorderRadius.circular(
    getHorizontalSize(
      8,
    ),
  );

  static BorderRadius roundedBorder16 = BorderRadius.circular(
    getHorizontalSize(
      16,
    ),
  );

  static BorderRadius circleBorder44 = BorderRadius.circular(
    getHorizontalSize(
      44,
    ),
  );

  static BorderRadius circleBorder51 = BorderRadius.circular(
    getHorizontalSize(
      51,
    ),
  );

  static BorderRadius circleBorder40 = BorderRadius.circular(
    getHorizontalSize(
      40,
    ),
  );

  static BorderRadius roundedBorder24 = BorderRadius.circular(
    getHorizontalSize(
      24,
    ),
  );

  static BorderRadius roundedBorder3 = BorderRadius.circular(
    getHorizontalSize(
      3,
    ),
  );

  static BorderRadius roundedBorder35 = BorderRadius.circular(
    getHorizontalSize(
      35,
    ),
  );

  static BorderRadius roundedBorder57 = BorderRadius.circular(
    getHorizontalSize(
      57,
    ),
  );

  static BorderRadius circleBorder20 = BorderRadius.circular(
    getHorizontalSize(
      20,
    ),
  );

  static BorderRadius roundedBorder11 = BorderRadius.circular(
    getHorizontalSize(
      11,
    ),
  );

  static BorderRadius circleBorder32 = BorderRadius.circular(
    getHorizontalSize(
      32,
    ),
  );

  static BorderRadius customBorderBL8 = BorderRadius.only(
    topRight: Radius.circular(
      getHorizontalSize(
        8,
      ),
    ),
    bottomLeft: Radius.circular(
      getHorizontalSize(
        8,
      ),
    ),
    bottomRight: Radius.circular(
      getHorizontalSize(
        8,
      ),
    ),
  );

  static BorderRadius txtRoundedBorder8 = BorderRadius.circular(
    getHorizontalSize(
      8,
    ),
  );

  static BorderRadius roundedBorder81 = BorderRadius.circular(
    getHorizontalSize(
      81,
    ),
  );

  static BorderRadius txtRoundedBorder2 = BorderRadius.circular(
    getHorizontalSize(
      2,
    ),
  );
}

// Comment/Uncomment the below code based on your Flutter SDK version.

// For Flutter SDK Version 3.7.2 or greater.

double get strokeAlignInside => BorderSide.strokeAlignInside;

double get strokeAlignCenter => BorderSide.strokeAlignCenter;

double get strokeAlignOutside => BorderSide.strokeAlignOutside;

// For Flutter SDK Version 3.7.1 or less.

// StrokeAlign get strokeAlignInside => StrokeAlign.inside;
//
// StrokeAlign get strokeAlignCenter => StrokeAlign.center;
//
// StrokeAlign get strokeAlignOutside => StrokeAlign.outside;
