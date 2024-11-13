import 'package:flutter/material.dart';

abstract class ColorRaqi {
  static const Color purple100 = Color(0xFF672CBC);
  static const Color purple75 = Color(0xFF9580C1);
  static const Color purple50 = Color(0xFFB8AAD6);
  static const Color purple25 = Color(0xFFDCD5EA);
  static const Color purple10 = Color(0xFFF1EEF7);
}

abstract class ColorSecondary {
  static const Color orange100 = Color(0xFFF4743B);
  static const Color orange75 = Color(0xFFF7976C);
  static const Color orange50 = Color(0xFFF9B99D);
  static const Color orange25 = Color(0xFFFCDCCE);
  static const Color orange10 = Color(0xFFFEF1EB);
}

abstract class ColorNeutrals {
  static const Color black = Color(0xFF262626);
  static const Color secondaryText = Color(0xFF8B898F);
  static const Color grey1 = Color(0xFFB9B7BC);
  static const Color grey2 = Color(0xFFD0CFD2);
  static const Color grey3 = Color(0xFFE8E7E9);
  static const Color grey4 = Color(0xFFEFEFF0);
  static const Color grey5 = Color(0xFFF6F6F6); // was added as chat background without naming in the figma
  static const Color white = Color(0xFFFFFFFF);
}

abstract class ColorStatus {
  static const Color errorDark = Color(0xFFE83A3A);
  static const Color errorLight = Color(0xFFF39C9C);
  static const Color errorFaded = Color(0xFFFDEBEB);

  static const Color successDark = Color(0xFF00A651);
  static const Color successLight = Color(0xFF99DBB9);
  static const Color successFaded = Color(0xFFEFEFEF);

  static const Color warningDark = Color(0xFFCC8225);
  static const Color warningLight = Color(0xFFFFBF70);
  static const Color warningFaded = Color(0xFFFFF5E6);

  static const Color infoDark = Color(0xFF3A77FF);
  static const Color infoMedium = Color(0xFF9CBBFF);
  static const Color infoLight = Color(0xFFEDF4FA);
}

abstract class ColorTheme {
  static const Color backgroundContent = Color(0xFFFFFFFF);
  static const Color backgroundSuccess = Color(0xFFF5FBF8);
  static const Color backgroundWarning = Color(0xFFFFF5E6);
  static const Color backgroundError = Color(0xFFFDEBEB);
  static const Color backgroundInfo = Color(0xFFEDF4FA);

  static const Color contentPrimary = Color(0xFF0D0E1F);
  static const Color contentSecondary = Color(0xFF86878F);

  static const Color borderDefault = Color(0xFFF3F3F4);
  static const Color borderSelected = Color(0xFFAFD6AA);

  static const Color iconDeepBlue = Color(0xFF9CBBFF);
  static const Color iconBackgroundBlue = Color(0xFFEDF3FE);

  static const Color iconDarkYellow = Color(0xFFFBDA63);
  static const Color iconBackgroundYellow = Color(0xFFFBFDE5);

  static const Color iconRed = Color(0xFFF39C9C);
  static const Color iconBackgroundRed = Color(0xFFFDEBEB);

  static const Color iconGreen = Color(0xFF99DBB9);
  static const Color iconBackgroundGreen = Color(0xFFE5F6ED);
}
