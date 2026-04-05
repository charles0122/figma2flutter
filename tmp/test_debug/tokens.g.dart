/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
/// Figma2Flutter
/// *****************************************************

library tokens;

import 'package:flutter/material.dart';

part 'tokens_extra.g.dart';

abstract class ITokens {
  ColorTokens get color;
  SpacingTokens get spacing;
  TextStyleTokens get textStyle;
  RadiiTokens get radii;
  CompositionTokens get composition;
  ShadowTokens get shadow;
  BorderTokens get border;
  SizeTokens get size;
  GradientTokens get gradient;
}

abstract class ColorTokens {
  Color get brand50;
  Color get brand100;
  Color get brand200;
  Color get brand300;
  Color get brand400;
  Color get brand500;
  Color get brand600;
  Color get brand700;
  Color get brand800;
  Color get brand900;
  Color get gray50;
  Color get gray100;
  Color get gray200;
  Color get gray300;
  Color get gray400;
  Color get gray500;
  Color get gray600;
  Color get gray700;
  Color get gray800;
  Color get gray900;
  Color get red50;
  Color get red100;
  Color get red200;
  Color get red300;
  Color get red400;
  Color get red500;
  Color get red600;
  Color get red700;
  Color get red800;
  Color get red900;
  Color get yellow50;
  Color get yellow100;
  Color get yellow200;
  Color get yellow300;
  Color get yellow400;
  Color get yellow500;
  Color get yellow600;
  Color get yellow700;
  Color get yellow800;
  Color get yellow900;
  Color get green50;
  Color get green100;
  Color get green200;
  Color get green300;
  Color get green400;
  Color get green500;
  Color get green600;
  Color get green700;
  Color get green800;
  Color get green900;
  Color get white;
  Color get black;
  Color get transparent;
  Color get purple;
}

abstract class SpacingTokens {
  double get small;
  double get medium;
  double get large;
  double get spacingDefault;
}

abstract class TextStyleTokens {
  TextStyle get defaultFootnoteRegular;
  TextStyle get defaultFootnoteMedium;
  TextStyle get defaultFootnoteBold;
  TextStyle get defaultSubheadlineRegular;
  TextStyle get defaultSubheadlineMedium;
  TextStyle get defaultSubheadlineBold;
  TextStyle get defaultBodyRegular;
  TextStyle get defaultBodyMedium;
  TextStyle get defaultBodyBold;
  TextStyle get defaultTitleRegular;
  TextStyle get defaultTitleMedium;
  TextStyle get defaultTitleBold;
  TextStyle get defaultLargetitleRegular;
  TextStyle get defaultLargetitleMedium;
  TextStyle get defaultLargetitleBold;
}

abstract class RadiiTokens {
  double get radiusDefault;
}

abstract class CompositionTokens {
  CompositionToken get testCard;
}

abstract class ShadowTokens {
  List<BoxShadow> get defaultShadow;
}

abstract class BorderTokens {
  Border get borderDefault;
  Border get borderSmall;
}

abstract class SizeTokens {
  Size get sizingDefault;
}

abstract class GradientTokens {
  LinearGradient get gradient;
  LinearGradient get rgbaInGradient;
}

class DefaultTokens extends ITokens {
  @override
  ColorTokens get color => DefaultColorTokens();
  @override
  SpacingTokens get spacing => const DefaultSpacingTokens();
  @override
  TextStyleTokens get textStyle => DefaultTextStyleTokens();
  @override
  RadiiTokens get radii => const DefaultRadiiTokens();
  @override
  CompositionTokens get composition => const DefaultCompositionTokens();
  @override
  ShadowTokens get shadow => const DefaultShadowTokens();
  @override
  BorderTokens get border => const DefaultBorderTokens();
  @override
  SizeTokens get size => const DefaultSizeTokens();
  @override
  GradientTokens get gradient => const DefaultGradientTokens();
}

class DefaultColorTokens extends ColorTokens {
  static const Color brand50 = const Color(0xFFF0FAFF);
  static const Color brand100 = const Color(0xFFE0F5FE);
  static const Color brand200 = const Color(0xFFBAE8FD);
  static const Color brand300 = const Color(0xFF7DD5FC);
  static const Color brand400 = const Color(0xFF38BCF8);
  static const Color brand500 = const Color(0xFF000000);
  static const Color brand600 = const Color(0xFF028AC7);
  static const Color brand700 = const Color(0xFF0370A1);
  static const Color brand800 = const Color(0xFF075E85);
  static const Color brand900 = const Color(0xFF0C506E);
  static const Color gray50 = const Color(0xFFF9FAFB);
  static const Color gray100 = const Color(0xFFF3F4F6);
  static const Color gray200 = const Color(0xFFE5E7EB);
  static const Color gray300 = const Color(0xFFD1D5DB);
  static const Color gray400 = const Color(0xFF9CA3AF);
  static const Color gray500 = const Color(0xFF6B7280);
  static const Color gray600 = const Color(0xFF4B5563);
  static const Color gray700 = const Color(0xFF374151);
  static const Color gray800 = const Color(0xFF1F2937);
  static const Color gray900 = const Color(0xFF111827);
  static const Color red50 = const Color(0xFFFEF2F2);
  static const Color red100 = const Color(0xFFFEE2E2);
  static const Color red200 = const Color(0xFFFECACA);
  static const Color red300 = const Color(0xFFFCA5A5);
  static const Color red400 = const Color(0xFFF87171);
  static const Color red500 = const Color(0xFFEF4444);
  static const Color red600 = const Color(0xFFDC2626);
  static const Color red700 = const Color(0xFFB91C1C);
  static const Color red800 = const Color(0xFF991B1B);
  static const Color red900 = const Color(0xFF7F1D1D);
  static const Color yellow50 = const Color(0xFFFEFCE8);
  static const Color yellow100 = const Color(0xFFFEF9C3);
  static const Color yellow200 = const Color(0xFFFEF08A);
  static const Color yellow300 = const Color(0xFFFDE047);
  static const Color yellow400 = const Color(0xFFFACC15);
  static const Color yellow500 = const Color(0xFFEAB308);
  static const Color yellow600 = const Color(0xFFCA8A04);
  static const Color yellow700 = const Color(0xFFA16207);
  static const Color yellow800 = const Color(0xFF854D0E);
  static const Color yellow900 = const Color(0xFF713F12);
  static const Color green50 = const Color(0xFFF0FDF4);
  static const Color green100 = const Color(0xFFDCFCE7);
  static const Color green200 = const Color(0xFFBBF7D0);
  static const Color green300 = const Color(0xFF86EFAC);
  static const Color green400 = const Color(0xFF4ADE80);
  static const Color green500 = const Color(0xFF22C55E);
  static const Color green600 = const Color(0xFF16A34A);
  static const Color green700 = const Color(0xFF15803D);
  static const Color green800 = const Color(0xFF166534);
  static const Color green900 = const Color(0xFF14532D);
  static const Color white = const Color(0xFFFFFFFF);
  static const Color black = const Color(0xFF000000);
  static const Color transparent = const Color(0x00FFFFFF);
  static const Color purple = const Color(0xFFFFB000);
}


class DefaultSpacingTokens extends SpacingTokens {
  const DefaultSpacingTokens({
    small = 4.0,
    medium = 8.0,
    large = 32.0,
    spacingDefault = 8.0
  });
  
  @override
  double get small => small;
  @override
  double get medium => medium;
  @override
  double get large => large;
  @override
  double get spacingDefault => spacingDefault;
}


class DefaultTextStyleTokens extends TextStyleTokens {
  static const TextStyle defaultFootnoteRegular = const TextStyle(
  fontFamily: 'Mali',
  fontSize: 13.0,
  fontWeight: FontWeight.w400,
  height: 1.4,
  letterSpacing: 0.0,
);
  static const TextStyle defaultFootnoteMedium = const TextStyle(
  fontFamily: 'Mali',
  fontSize: 13.0,
  fontWeight: FontWeight.w500,
  height: 1.4,
  letterSpacing: 0.0,
);
  static const TextStyle defaultFootnoteBold = const TextStyle(
  fontFamily: 'Mali',
  fontSize: 13.0,
  fontWeight: FontWeight.w700,
  height: 1.4,
  letterSpacing: 0.0,
);
  static const TextStyle defaultSubheadlineRegular = const TextStyle(
  fontFamily: 'Mali',
  fontSize: 15.0,
  fontWeight: FontWeight.w400,
  height: 1.4,
  letterSpacing: 0.0,
);
  static const TextStyle defaultSubheadlineMedium = const TextStyle(
  fontFamily: 'Mali',
  fontSize: 15.0,
  fontWeight: FontWeight.w500,
  height: 1.4,
  letterSpacing: 0.0,
);
  static const TextStyle defaultSubheadlineBold = const TextStyle(
  fontFamily: 'Mali',
  fontSize: 15.0,
  fontWeight: FontWeight.w700,
  height: 1.4,
  letterSpacing: 0.0,
);
  static const TextStyle defaultBodyRegular = const TextStyle(
  fontFamily: 'Mali',
  fontSize: 17.0,
  fontWeight: FontWeight.w400,
  height: 1.4,
  letterSpacing: 0.0,
);
  static const TextStyle defaultBodyMedium = const TextStyle(
  fontFamily: 'Mali',
  fontSize: 17.0,
  fontWeight: FontWeight.w500,
  height: 1.4,
  letterSpacing: 0.0,
);
  static const TextStyle defaultBodyBold = const TextStyle(
  fontFamily: 'Mali',
  fontSize: 17.0,
  fontWeight: FontWeight.w700,
  height: 1.4,
  letterSpacing: 0.0,
);
  static const TextStyle defaultTitleRegular = const TextStyle(
  fontFamily: 'Mali',
  fontSize: 20.0,
  fontWeight: FontWeight.w400,
  height: 1.4,
  letterSpacing: 0.0,
);
  static const TextStyle defaultTitleMedium = const TextStyle(
  fontFamily: 'Mali',
  fontSize: 20.0,
  fontWeight: FontWeight.w500,
  height: 1.4,
  letterSpacing: 0.0,
);
  static const TextStyle defaultTitleBold = const TextStyle(
  fontFamily: 'Mali',
  fontSize: 20.0,
  fontWeight: FontWeight.w700,
  height: 1.4,
  letterSpacing: 0.0,
);
  static const TextStyle defaultLargetitleRegular = const TextStyle(
  fontFamily: 'Mali',
  fontSize: 34.0,
  fontWeight: FontWeight.w400,
  height: 1.4,
  letterSpacing: 0.0,
);
  static const TextStyle defaultLargetitleMedium = const TextStyle(
  fontFamily: 'Mali',
  fontSize: 34.0,
  fontWeight: FontWeight.w500,
  height: 1.4,
  letterSpacing: 0.0,
);
  static const TextStyle defaultLargetitleBold = const TextStyle(
  fontFamily: 'Mali',
  fontSize: 34.0,
  fontWeight: FontWeight.w700,
  height: 1.4,
  letterSpacing: 0.0,
);
}


class DefaultRadiiTokens extends RadiiTokens {
  const DefaultRadiiTokens({
    radiusDefault = 12.0
  });
  
  @override
  double get radiusDefault => radiusDefault;
}


class DefaultCompositionTokens extends CompositionTokens {
  const DefaultCompositionTokens({
    testCard = CompositionToken(
  size: const Size(300.0, 200.0),
  padding: const EdgeInsets.only(
    top: 16.0,
    right: 16.0,
    bottom: 16.0,
    left: 16.0,
  ),
  gradient: const LinearGradient(
  colors: [Color(0x80FFFFFF), Color(0xFFFFB000),],
  stops: [0.0, 1.0],
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
  transform: GradientRotation(0.785),
),
  itemSpacing: 8.0,
  borderRadius: BorderRadius.circular(12.0),
  border: Border.all(color: const Color(0xFF000000), width: 5.0, style: BorderStyle.solid),
  boxShadow: const [
  BoxShadow(
    offset: Offset(2.0, 8.0),
    blurRadius: 5.0,
    spreadRadius: 5.0,
    color: Color(0xFFBAE8FD),
  ),
],
  textStyle: const TextStyle(
  fontFamily: 'Mali',
  fontSize: 17.0,
  fontWeight: FontWeight.w400,
  height: 1.4,
  letterSpacing: 0.0,
),
)
  });
  
  @override
  CompositionToken get testCard => testCard;
}


class DefaultShadowTokens extends ShadowTokens {
  const DefaultShadowTokens({
    defaultShadow = const [
  BoxShadow(
    offset: Offset(2.0, 8.0),
    blurRadius: 5.0,
    spreadRadius: 5.0,
    color: Color(0xFFBAE8FD),
  ),
]
  });
  
  @override
  List<BoxShadow> get defaultShadow => defaultShadow;
}


class DefaultBorderTokens extends BorderTokens {
  const DefaultBorderTokens({
    borderDefault = Border.all(color: const Color(0xFF000000), width: 5.0, style: BorderStyle.solid),
    borderSmall = Border.all(color: const Color(0xFF000000), width: 2.0, style: BorderStyle.solid)
  });
  
  @override
  Border get borderDefault => borderDefault;
  @override
  Border get borderSmall => borderSmall;
}


class DefaultSizeTokens extends SizeTokens {
  const DefaultSizeTokens({
    sizingDefault = const Size(16.0, 16.0)
  });
  
  @override
  Size get sizingDefault => sizingDefault;
}


class DefaultGradientTokens extends GradientTokens {
  const DefaultGradientTokens({
    gradient = const LinearGradient(
  colors: [Color(0xFFFFFFFF), Color(0xFF000000),],
  stops: [0.0, 1.0],
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
  transform: GradientRotation(0.785),
),
    rgbaInGradient = const LinearGradient(
  colors: [Color(0x80FFFFFF), Color(0xFFFFB000),],
  stops: [0.0, 1.0],
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
  transform: GradientRotation(0.785),
)
  });
  
  @override
  LinearGradient get gradient => gradient;
  @override
  LinearGradient get rgbaInGradient => rgbaInGradient;
}
