import 'package:flutter/material.dart';

/// Color palette extracted from the J.A.R.V.I.S. AI OS reference screenshot.
class AppColors {
  AppColors._();

  static const Color background = Color(0xFF040B15);
  static const Color backgroundEnd = Color(0xFF0A1930);

  static const Color panelFill = Color(0xE6081826);
  static const Color panelFillAlt = Color(0xFF08192A);
  static const Color panelBorder = Color(0xFF1C4258);
  static const Color panelBorderBright = Color(0xFF2E6A94);

  static const Color glow = Color(0xFF29B6F6);
  static const Color cyan = Color(0xFF4FC3F7);
  static const Color cyanBright = Color(0xFF8FE3FF);
  static const Color cyanDim = Color(0xFF3A7CA5);

  static const Color white = Color(0xFFEAF4FB);
  static const Color mutedBlue = Color(0xFF5D7E99);
  static const Color mutedBlueDark = Color(0xFF3D5A73);

  static const Color green = Color(0xFF4ADE80);
  static const Color orange = Color(0xFFFFA64D);
  static const Color barTrack = Color(0xFF0D2436);
}

class AppText {
  AppText._();

  static const TextStyle brand = TextStyle(
    color: AppColors.white,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
  );

  static const TextStyle brandAccent = TextStyle(
    color: AppColors.cyan,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
  );

  static const TextStyle panelTitle = TextStyle(
    color: AppColors.cyanBright,
    fontSize: 11.5,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.9,
  );

  static const TextStyle label = TextStyle(
    color: AppColors.mutedBlue,
    fontSize: 9,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.7,
  );

  static const TextStyle value = TextStyle(
    color: AppColors.white,
    fontSize: 21,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle valueSmall = TextStyle(
    color: AppColors.white,
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle sublabel = TextStyle(
    color: AppColors.mutedBlue,
    fontSize: 8.5,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle greenTag = TextStyle(
    color: AppColors.green,
    fontSize: 9,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.4,
  );

  static const TextStyle cyanTag = TextStyle(
    color: AppColors.cyan,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.6,
  );
}

const BoxDecoration panelDecoration = BoxDecoration(
  color: AppColors.panelFill,
  borderRadius: BorderRadius.all(Radius.circular(6)),
  border: Border.fromBorderSide(
    BorderSide(color: AppColors.panelBorder, width: 1),
  ),
);
