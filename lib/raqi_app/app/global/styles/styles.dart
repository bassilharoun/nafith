//___  __   __ _  ____  ____  ____   __   __  __ _  ____    ____  ____  _  _  __    ____  ____
/// __)/  \ (  ( \/ ___)(_  _)(  _ \ / _\ (  )(  ( \(_  _)  / ___)(_  _)( \/ )(  )  (  __)/ ___)
//( (__(  O )/    /\___ \  )(   )   //    \ )( /    /  )(    \___ \  )(   )  / / (_/\ ) _) \___ \
//\___)\__/ \_)__)(____/ (__) (__\_)\_/\_/(__)\_)__) (__)   (____/ (__) (__/  \____/(____)(____/
//Contraint Styles for devices of different widths and heights
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nafith/raqi_app/app/global/styles/colors.dart';
import 'package:provider/provider.dart';


EdgeInsetsGeometry marginWizardLeftRight =
    const EdgeInsets.only(left: 10.0, right: 5.0);

enum FontFamily {
  Cairo("cairo"),
  OUTFIT("Outfit");

  const FontFamily(this.familyName);
  final String familyName;
}

class AppStyles {
  static const String cairo = 'cairo';
  

  static TextStyle style36Bold(FontFamily fontFamily,context ,{Color? color, bool listen = true}) {
    return TextStyle(
      fontSize: 36.sp ,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily.familyName,
      color: color ?? ColorNeutrals.black,
    );
  }

  static TextStyle style24SemiBold(FontFamily fontFamily,context ,{Color? color, bool listen = true}) {

    return TextStyle(
      fontSize: 24.sp,
      fontWeight: FontWeight.w600,
      fontFamily: fontFamily.familyName,
      color: color ?? ColorNeutrals.black,
    );
  }

  static TextStyle style20SemiBold(FontFamily fontFamily, context,{Color? color, bool listen = true}) {
    return TextStyle(
      fontSize: 20.sp ,
      fontWeight: FontWeight.w600,
      fontFamily: fontFamily.familyName,
      color: color ?? ColorNeutrals.black,
    );
  }

  static TextStyle style18SemiBold(FontFamily fontFamily, context,{Color? color, bool listen = true}) {

    return TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w600,
      fontFamily: fontFamily.familyName,
      color: color ?? ColorNeutrals.black,
    );
  }

  static TextStyle style16Medium(FontFamily fontFamily, context,{Color? color, bool listen = true}) {

    return TextStyle(
      fontSize: 16.sp ,
      fontWeight: FontWeight.w500,
      fontFamily: fontFamily.familyName,
      color: color ?? ColorNeutrals.black,
    );
  }

  static TextStyle style14Regular(FontFamily fontFamily, context,{Color? color, bool listen = true}) {

    return TextStyle(
      fontSize: 14.sp ,
      fontWeight: FontWeight.w400,
      fontFamily: fontFamily.familyName,
      color: color ?? ColorNeutrals.black,
    );
  }

  static TextStyle style12Regular(FontFamily fontFamily, context,{Color? color, bool listen = true}) {

    return TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      fontFamily: fontFamily.familyName,
      color: color ?? ColorNeutrals.black,
    );
  }

  static TextStyle style10Regular(FontFamily fontFamily, context,{Color? color, bool listen = true}) {

    return TextStyle(
      fontSize: 10.sp,
      fontWeight: FontWeight.w400,
      fontFamily: fontFamily.familyName,
      color: color ?? ColorNeutrals.black,
    );
  }
}
