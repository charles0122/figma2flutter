/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
/// Figma2Flutter
/// *****************************************************

library tokens;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

part 'tokens_extra.g.dart';

abstract class ITokens {
  ColorTokens get color;
  SpacingTokens get spacing;
  RadiiTokens get radii;
  TextStyleTokens get textStyle;
}

abstract class ColorTokens {
  Color get globalColorBlack;
  Color get globalColorWhite;
  Color get globalColorTransparent;
  /// 已用在fill.window
  
  Color get globalColorBluegray100;
  /// 已用在border.quaternary
  
  Color get globalColorBluegray200;
  /// 已用在border.tertiary
  
  Color get globalColorBluegray300;
  /// 已用在border.secondary
  
  Color get globalColorBluegray400;
  /// 已用在border.primary
  
  Color get globalColorBluegray500;
  Color get globalColorBluegray600;
  Color get globalColorBluegray700;
  Color get globalColorBluegray800;
  Color get globalColorBluegray900;
  Color get globalColorBluegray1000;
  Color get globalColorPureblue100;
  Color get globalColorPureblue200;
  /// 已用在activity.inactive
  
  Color get globalColorPureblue300;
  Color get globalColorPureblue400;
  Color get globalColorPureblue500;
  /// 已用作brand.primary
  
  Color get globalColorPureblue600;
  Color get globalColorPureblue700;
  Color get globalColorPureblue800;
  Color get globalColorPureblue900;
  Color get globalColorPureblue1000;
  Color get globalColorPurple100;
  Color get globalColorPurple200;
  Color get globalColorPurple300;
  /// 已用作sleep.remsleep
  
  Color get globalColorPurple400;
  Color get globalColorPurple500;
  /// 已用作sleep.lightsleep
  
  Color get globalColorPurple600;
  Color get globalColorPurple700;
  Color get globalColorPurple800;
  /// 已用作sleep.primary和sleep.deepsleep
  
  Color get globalColorPurple900;
  Color get globalColorPurple1000;
  Color get globalColorPinkred100;
  Color get globalColorPinkred200;
  Color get globalColorPinkred300;
  Color get globalColorPinkred400;
  Color get globalColorPinkred500;
  Color get globalColorPinkred600;
  Color get globalColorPinkred700;
  Color get globalColorPinkred800;
  Color get globalColorPinkred900;
  Color get globalColorPinkred1000;
  Color get globalColorCyanblue100;
  Color get globalColorCyanblue200;
  Color get globalColorCyanblue300;
  Color get globalColorCyanblue400;
  Color get globalColorCyanblue500;
  Color get globalColorCyanblue600;
  Color get globalColorCyanblue700;
  Color get globalColorCyanblue800;
  Color get globalColorCyanblue900;
  Color get globalColorCyanblue1000;
  Color get globalColorOrange100;
  Color get globalColorOrange200;
  Color get globalColorOrange300;
  Color get globalColorOrange400;
  Color get globalColorOrange500;
  Color get globalColorOrange600;
  Color get globalColorOrange700;
  Color get globalColorOrange800;
  Color get globalColorOrange900;
  Color get globalColorOrange1000;
  /// 已用在fill.quaternary
  
  Color get globalColorBluegrayAlpha100;
  /// 已用在fill.tertiary
  
  Color get globalColorBluegrayAlpha200;
  /// 已用在fill.secondary
  
  Color get globalColorBluegrayAlpha300;
  /// 已用在fill.primary
  
  Color get globalColorBluegrayAlpha400;
  Color get globalColorBluegrayAlpha500;
  /// 已用在text.quaternary
  
  Color get globalColorBluegrayAlpha600;
  /// 已用在text.tertiary 和 icon.secondary
  
  Color get globalColorBluegrayAlpha700;
  Color get globalColorBluegrayAlpha800;
  Color get globalColorBluegrayAlpha900;
  Color get globalColorBluegrayAlpha1000;
  Color get globalColorBlackAlpha100;
  Color get globalColorBlackAlpha200;
  Color get globalColorBlackAlpha300;
  Color get globalColorBlackAlpha400;
  /// 已用在background.mask
  
  Color get globalColorBlackAlpha500;
  Color get globalColorBlackAlpha600;
  Color get globalColorBlackAlpha700;
  Color get globalColorBlackAlpha800;
  Color get globalColorBlackAlpha900;
  /// 已用在background.soptlight
  
  Color get globalColorBlackAlpha1000;
  Color get globalColorWhiteAlpha100;
  Color get globalColorWhiteAlpha200;
  Color get globalColorWhiteAlpha300;
  Color get globalColorWhiteAlpha400;
  Color get globalColorWhiteAlpha500;
  Color get globalColorWhiteAlpha600;
  Color get globalColorWhiteAlpha700;
  Color get globalColorWhiteAlpha800;
  Color get globalColorWhiteAlpha900;
  Color get globalColorWhiteAlpha1000;
  Color get globalColorRadicalRed100;
  Color get globalColorRadicalRed200;
  Color get globalColorRadicalRed300;
  Color get globalColorRadicalRed400;
  Color get globalColorRadicalRed500;
  Color get globalColorRadicalRed600;
  Color get globalColorRadicalRed700;
  Color get globalColorRadicalRed800;
  Color get globalColorRadicalRed900;
  Color get globalColorRadicalRed1000;
  Color get globalColorPuertoRico100;
  Color get globalColorPuertoRico200;
  Color get globalColorPuertoRico300;
  Color get globalColorPuertoRico400;
  Color get globalColorPuertoRico500;
  Color get globalColorPuertoRico600;
  Color get globalColorPuertoRico700;
  Color get globalColorPuertoRico800;
  Color get globalColorPuertoRico900;
  Color get globalColorPuertoRico1000;
  Color get globalColorTuna100;
  Color get globalColorTuna200;
  Color get globalColorTuna300;
  Color get globalColorTuna400;
  Color get globalColorTuna500;
  Color get globalColorTuna600;
  Color get globalColorTuna700;
  Color get globalColorTuna800;
  Color get globalColorTuna900;
  Color get globalColorTuna1000;
  Color get globalColorYellow100;
  Color get globalColorYellow200;
  Color get globalColorYellow300;
  Color get globalColorYellow400;
  Color get globalColorYellow500;
  Color get globalColorYellow600;
  Color get globalColorYellow700;
  Color get globalColorYellow800;
  Color get globalColorYellow900;
  Color get globalColorYellow1000;
  /// 1级文本色
  
  Color get semanticColorGreyTextPrimary;
  /// 2级文本色
  
  Color get semanticColorGreyTextSecondary;
  /// 3级文本色
  
  Color get semanticColorGreyTextTertiary;
  /// 4级文本色
  
  Color get semanticColorGreyTextQuaternary;
  /// 文本反色
  
  Color get semanticColorGreyTextInverse;
  /// 文本品牌色
  
  Color get semanticColorGreyTextBrand;
  /// 文本链接色
  
  Color get semanticColorGreyTextLink;
  /// 常规背景色
  
  Color get semanticColorGreyBackgroundLayout;
  /// 背景容器层填充色
  
  Color get semanticColorGreyBackgroundContainer;
  /// 背景弹出层填充色
  
  Color get semanticColorGreyBackgroundElevated;
  /// 遮罩填充色
  
  Color get semanticColorGreyBackgroundMask;
  /// toast填充色
  
  Color get semanticColorGreyBackgroundSpotlight;
  /// 1级填充灰色
  
  Color get semanticColorGreyFillPrimary;
  /// 2级填充灰色
  
  Color get semanticColorGreyFillSecondary;
  /// 3级填充灰色
  
  Color get semanticColorGreyFillTertiary;
  /// 4级填充灰色
  
  Color get semanticColorGreyFillQuaternary;
  /// 图表点按填充色
  
  Color get semanticColorGreyFillWindow;
  /// 填充反色
  
  Color get semanticColorGreyFillInverse;
  /// 1级线条色
  
  Color get semanticColorGreyBorderPrimary;
  /// 2级线条色
  
  Color get semanticColorGreyBorderSecondary;
  /// 3级线条色
  
  Color get semanticColorGreyBorderTertiary;
  /// 4级线条色
  
  Color get semanticColorGreyBorderQuaternary;
  /// 黑色线条色
  
  Color get semanticColorGreyBorderBlack;
  /// 1级图标色
  
  Color get semanticColorGreyIconPrimary;
  /// 2级图标色
  
  Color get semanticColorGreyIconSecondary;
  /// 3级图表色
  
  Color get semanticColorGreyIconTertiary;
  /// 图标反色
  
  Color get semanticColorGreyIconInverse;
  /// 品牌主色
  
  Color get semanticColorBrandPrimary;
  Color get semanticColorTagGood;
  /// 可提升标签色
  
  Color get semanticColorTagImprovable;
  /// 危险标签色
  
  Color get semanticColorTagWarning;
  /// 睡眠主色
  
  Color get semanticColorSleepPrimary;
  /// 睡眠分期_清醒色
  
  Color get semanticColorSleepAwake;
  /// 睡眠分期_REM色
  
  Color get semanticColorSleepRemsleep;
  /// 睡眠分期_浅睡色
  
  Color get semanticColorSleepLightsleep;
  /// 睡眠分期_深睡色
  
  Color get semanticColorSleepDeepsleep;
  /// 活动主色
  
  Color get semanticColorActivityPrimary;
  /// 活动_步数主色、低强度主色
  
  Color get semanticColorActivityStep;
  /// 活动_卡路里主色、中强度主色
  
  Color get semanticColorActivityCalories;
  /// 活动_活动时长主色、高强度主色
  
  Color get semanticColorActivityActivityTime;
  /// 不活跃主色
  
  Color get semanticColorActivityInactive;
  /// 压力主色
  
  Color get semanticColorStressPrimary;
  /// 压力分级_轻松
  
  Color get semanticColorStressRelaxed;
  /// 压力分级_正常
  
  Color get semanticColorStressNormal;
  /// 压力分级_中等
  
  Color get semanticColorStressMedium;
  /// 压力分级_高压
  
  Color get semanticColorStressHigh;
  /// 生命体征主色
  
  Color get semanticColorVitalPrimary;
  Color get semanticColorFemaleMenstrual;
  Color get semanticColorFemaleFollicular;
  Color get semanticColorFemaleOvulation;
  Color get semanticColorFemaleLuteal;
  /// 运动强调色
  
  Color get semanticColorSportGo;
  /// 运动主色
  
  Color get semanticColorSportPrimary;
  /// 热身色
  /// 
  
  Color get semanticColorSportWarmUp;
  /// 燃脂色
  /// 
  
  Color get semanticColorSportFatBurning;
  /// 有氧色
  
  Color get semanticColorSportAerobic;
  /// 无氧色
  
  Color get semanticColorSportAnaerobic;
  /// 极限色
  
  Color get semanticColorSportExtreme;
  Color get semanticColorSportLow;
  Color get semanticColorSportFair;
  Color get semanticColorSportGood;
  Color get semanticColorSportExcellent;
  Color get semanticColorSportElite;
  Color get semanticColorSportBackground;
  Color get semanticColorOsaNoAbnormalitiesDetected;
  Color get semanticColorOsaSuspectedMild;
  Color get semanticColorOsaSuspectedModerate;
  Color get semanticColorOsaSuspectedSevere;
}

abstract class SpacingTokens {
  double get globalSpacing25;
  double get globalSpacing50;
  double get globalSpacing100;
  double get globalSpacing150;
  double get globalSpacing200;
  double get globalSpacing250;
  double get globalSpacing300;
  double get globalSpacing350;
  double get globalSpacing400;
  double get globalSpacing500;
  double get globalSpacing600;
  double get globalSpacingBase;
  double get semanticSpacingGapCompXs;
  double get semanticSpacingGapCompS;
  double get semanticSpacingGapCompSm;
  double get semanticSpacingGapCompM;
  double get semanticSpacingGapCompL;
  double get semanticSpacingGapPatternXxs;
  double get semanticSpacingGapPatternXs;
  double get semanticSpacingGapPatternS;
  double get semanticSpacingGapPatternM;
  double get semanticSpacingGapPatternMd;
  double get semanticSpacingGapPatternL;
  double get semanticSpacingGapPatternXl;
  double get semanticSpacingGapPatternXxl;
  double get semanticSpacingAroundCompXxs;
  double get semanticSpacingAroundCompXs;
  double get semanticSpacingAroundCompS;
  double get semanticSpacingAroundCompM;
  double get semanticSpacingAroundCompL;
  double get semanticSpacingAroundPatternXs;
  double get semanticSpacingAroundPatternS;
  double get semanticSpacingAroundPatternSm;
  double get semanticSpacingAroundPatternM;
  double get semanticSpacingAroundPatternL;
  double get semanticSpacingAroundPatternXl;
  double get semanticSpacingAroundSectionS;
  double get semanticSpacingAroundSectionM;
  double get semanticSpacingAroundSectionL;
  double get semanticSpacingAroundSectionXl;
  double get semanticSpacingAroundSectionXxl;
}

abstract class RadiiTokens {
  double get globalBoderRadii25;
  double get globalBoderRadii50;
  double get globalBoderRadii75;
  double get globalBoderRadii100;
  double get globalBoderRadii125;
  double get globalBoderRadii150;
  double get globalBoderRadii200;
  double get globalBoderRadii250;
  double get globalBoderRadii300;
  double get globalBoderRadiiBase;
  double get globalBoderRadiiNone;
  double get globalBoderRadiiRound;
  double get semanticBoderRadiiXxs;
  double get semanticBoderRadiiXs;
  double get semanticBoderRadiiS;
  double get semanticBoderRadiiSm;
  double get semanticBoderRadiiM;
  double get semanticBoderRadiiMd;
  double get semanticBoderRadiiL;
  double get semanticBoderRadiiXl;
  /// 大卡片圆角
  
  double get semanticBoderRadiiXxl;
  double get semanticBoderRadiiRound;
}

abstract class TextStyleTokens {
  TextStyle get semanticTypographyLabel10;
  TextStyle get semanticTypographyLabel12;
  TextStyle get semanticTypographyLabel14;
  TextStyle get semanticTypographyBody12;
  TextStyle get semanticTypographyBody14;
  TextStyle get semanticTypographyBody16;
  TextStyle get semanticTypographyTitle16;
  TextStyle get semanticTypographyTitle18;
  TextStyle get semanticTypographyTitle20;
  TextStyle get semanticTypographyTitle22;
  TextStyle get semanticTypographyDisplay24;
  TextStyle get semanticTypographyDisplay28;
  TextStyle get semanticTypographyNumberText12;
  TextStyle get semanticTypographyNumberText14;
  TextStyle get semanticTypographyNumberText16;
  TextStyle get semanticTypographyNumber12;
  TextStyle get semanticTypographyNumber20;
  TextStyle get semanticTypographyNumber24;
  TextStyle get semanticTypographyNumber28;
  TextStyle get semanticTypographyNumber32;
  TextStyle get semanticTypographyNumber64;
}

class SharedSpacingTokens extends SpacingTokens {
  @override
  double get globalSpacing25 => 2.0;
  @override
  double get globalSpacing50 => 4.0;
  @override
  double get globalSpacing100 => 8.0;
  @override
  double get globalSpacing150 => 12.0;
  @override
  double get globalSpacing200 => 16.0;
  @override
  double get globalSpacing250 => 20.0;
  @override
  double get globalSpacing300 => 24.0;
  @override
  double get globalSpacing350 => 28.0;
  @override
  double get globalSpacing400 => 32.0;
  @override
  double get globalSpacing500 => 40.0;
  @override
  double get globalSpacing600 => 48.0;
  @override
  double get globalSpacingBase => 8.0;
  @override
  double get semanticSpacingGapCompXs => 2.0;
  @override
  double get semanticSpacingGapCompS => 4.0;
  @override
  double get semanticSpacingGapCompSm => 8.0;
  @override
  double get semanticSpacingGapCompM => 12.0;
  @override
  double get semanticSpacingGapCompL => 16.0;
  @override
  double get semanticSpacingGapPatternXxs => 4.0;
  @override
  double get semanticSpacingGapPatternXs => 8.0;
  @override
  double get semanticSpacingGapPatternS => 12.0;
  @override
  double get semanticSpacingGapPatternM => 16.0;
  @override
  double get semanticSpacingGapPatternMd => 20.0;
  @override
  double get semanticSpacingGapPatternL => 24.0;
  @override
  double get semanticSpacingGapPatternXl => 32.0;
  @override
  double get semanticSpacingGapPatternXxl => 40.0;
  @override
  double get semanticSpacingAroundCompXxs => 2.0;
  @override
  double get semanticSpacingAroundCompXs => 4.0;
  @override
  double get semanticSpacingAroundCompS => 8.0;
  @override
  double get semanticSpacingAroundCompM => 12.0;
  @override
  double get semanticSpacingAroundCompL => 16.0;
  @override
  double get semanticSpacingAroundPatternXs => 4.0;
  @override
  double get semanticSpacingAroundPatternS => 8.0;
  @override
  double get semanticSpacingAroundPatternSm => 12.0;
  @override
  double get semanticSpacingAroundPatternM => 16.0;
  @override
  double get semanticSpacingAroundPatternL => 20.0;
  @override
  double get semanticSpacingAroundPatternXl => 32.0;
  @override
  double get semanticSpacingAroundSectionS => 12.0;
  @override
  double get semanticSpacingAroundSectionM => 20.0;
  @override
  double get semanticSpacingAroundSectionL => 32.0;
  @override
  double get semanticSpacingAroundSectionXl => 40.0;
  @override
  double get semanticSpacingAroundSectionXxl => 48.0;
}

class SharedRadiiTokens extends RadiiTokens {
  @override
  double get globalBoderRadii25 => 2.0;
  @override
  double get globalBoderRadii50 => 4.0;
  @override
  double get globalBoderRadii75 => 6.0;
  @override
  double get globalBoderRadii100 => 8.0;
  @override
  double get globalBoderRadii125 => 10.0;
  @override
  double get globalBoderRadii150 => 12.0;
  @override
  double get globalBoderRadii200 => 16.0;
  @override
  double get globalBoderRadii250 => 20.0;
  @override
  double get globalBoderRadii300 => 24.0;
  @override
  double get globalBoderRadiiBase => 8.0;
  @override
  double get globalBoderRadiiNone => 0.0;
  @override
  double get globalBoderRadiiRound => 9999.0;
  @override
  double get semanticBoderRadiiXxs => 2.0;
  @override
  double get semanticBoderRadiiXs => 4.0;
  @override
  double get semanticBoderRadiiS => 6.0;
  @override
  double get semanticBoderRadiiSm => 8.0;
  @override
  double get semanticBoderRadiiM => 10.0;
  @override
  double get semanticBoderRadiiMd => 12.0;
  @override
  double get semanticBoderRadiiL => 16.0;
  @override
  double get semanticBoderRadiiXl => 20.0;
  /// 大卡片圆角
  @override
  double get semanticBoderRadiiXxl => 24.0;
  @override
  double get semanticBoderRadiiRound => 9999.0;
}

class LightTokens extends ITokens {
  @override
  TextStyleTokens get textStyle => AdaptiveTextStyleTokens();
  @override
  ColorTokens get color => LightColorTokens();
  @override
  SpacingTokens get spacing => SharedSpacingTokens();
  @override
  RadiiTokens get radii => SharedRadiiTokens();
}

class LightColorTokens extends ColorTokens {
  @override
  Color get globalColorBlack => const Color(0xFF0C0C0E);
  @override
  Color get globalColorWhite => const Color(0xFFFFFFFF);
  @override
  Color get globalColorTransparent => const Color(0x00000000);
  /// 已用在fill.window
  @override
  Color get globalColorBluegray100 => const Color(0xFFEFEFF0);
  /// 已用在border.quaternary
  @override
  Color get globalColorBluegray200 => const Color(0xFFECEDEE);
  /// 已用在border.tertiary
  @override
  Color get globalColorBluegray300 => const Color(0xFFDFE0E2);
  /// 已用在border.secondary
  @override
  Color get globalColorBluegray400 => const Color(0xFFD4D5D8);
  /// 已用在border.primary
  @override
  Color get globalColorBluegray500 => const Color(0xFFB7B9BE);
  @override
  Color get globalColorBluegray600 => const Color(0xFF000000);
  @override
  Color get globalColorBluegray700 => const Color(0xFF46464E);
  @override
  Color get globalColorBluegray800 => const Color(0xFF1E1E1F);
  @override
  Color get globalColorBluegray900 => const Color(0xFF000000);
  @override
  Color get globalColorBluegray1000 => const Color(0xFF111112);
  @override
  Color get globalColorPureblue100 => const Color(0xFFF6F6F8);
  @override
  Color get globalColorPureblue200 => const Color(0xFF000000);
  /// 已用在activity.inactive
  @override
  Color get globalColorPureblue300 => const Color(0xFFB4CBFE);
  @override
  Color get globalColorPureblue400 => const Color(0xFF000000);
  @override
  Color get globalColorPureblue500 => const Color(0xFF000000);
  /// 已用作brand.primary
  @override
  Color get globalColorPureblue600 => const Color(0xFF3F70F8);
  @override
  Color get globalColorPureblue700 => const Color(0xFF000000);
  @override
  Color get globalColorPureblue800 => const Color(0xFF000000);
  @override
  Color get globalColorPureblue900 => const Color(0xFF000000);
  @override
  Color get globalColorPureblue1000 => const Color(0xFF000000);
  @override
  Color get globalColorPurple100 => const Color(0xFF000000);
  @override
  Color get globalColorPurple200 => const Color(0xFF000000);
  @override
  Color get globalColorPurple300 => const Color(0xFF000000);
  /// 已用作sleep.remsleep
  @override
  Color get globalColorPurple400 => const Color(0xFFBBACFB);
  @override
  Color get globalColorPurple500 => const Color(0xFF000000);
  /// 已用作sleep.lightsleep
  @override
  Color get globalColorPurple600 => const Color(0xFF8265F6);
  @override
  Color get globalColorPurple700 => const Color(0xFF000000);
  @override
  Color get globalColorPurple800 => const Color(0xFF000000);
  /// 已用作sleep.primary和sleep.deepsleep
  @override
  Color get globalColorPurple900 => const Color(0xFF4D12BF);
  @override
  Color get globalColorPurple1000 => const Color(0xFF000000);
  @override
  Color get globalColorPinkred100 => const Color(0xFF000000);
  @override
  Color get globalColorPinkred200 => const Color(0xFF000000);
  @override
  Color get globalColorPinkred300 => const Color(0xFF000000);
  @override
  Color get globalColorPinkred400 => const Color(0xFF000000);
  @override
  Color get globalColorPinkred500 => const Color(0xFF000000);
  @override
  Color get globalColorPinkred600 => const Color(0xFFFA3372);
  @override
  Color get globalColorPinkred700 => const Color(0xFF000000);
  @override
  Color get globalColorPinkred800 => const Color(0xFF000000);
  @override
  Color get globalColorPinkred900 => const Color(0xFF000000);
  @override
  Color get globalColorPinkred1000 => const Color(0xFF000000);
  @override
  Color get globalColorCyanblue100 => const Color(0xFF000000);
  @override
  Color get globalColorCyanblue200 => const Color(0xFF000000);
  @override
  Color get globalColorCyanblue300 => const Color(0xFF000000);
  @override
  Color get globalColorCyanblue400 => const Color(0xFFC9E4FF);
  @override
  Color get globalColorCyanblue500 => const Color(0xFF000000);
  @override
  Color get globalColorCyanblue600 => const Color(0xFF51A6FA);
  @override
  Color get globalColorCyanblue700 => const Color(0xFF000000);
  @override
  Color get globalColorCyanblue800 => const Color(0xFF3E5EBF);
  @override
  Color get globalColorCyanblue900 => const Color(0xFF024A92);
  @override
  Color get globalColorCyanblue1000 => const Color(0xFF000000);
  @override
  Color get globalColorOrange100 => const Color(0xFF000000);
  @override
  Color get globalColorOrange200 => const Color(0xFF000000);
  @override
  Color get globalColorOrange300 => const Color(0xFF000000);
  @override
  Color get globalColorOrange400 => const Color(0xFFFFBC8A);
  @override
  Color get globalColorOrange500 => const Color(0xFFFFA35F);
  @override
  Color get globalColorOrange600 => const Color(0xFFFF8F3D);
  @override
  Color get globalColorOrange700 => const Color(0xFFFB7D23);
  @override
  Color get globalColorOrange800 => const Color(0xFF000000);
  @override
  Color get globalColorOrange900 => const Color(0xFF000000);
  @override
  Color get globalColorOrange1000 => const Color(0xFF000000);
  /// 已用在fill.quaternary
  @override
  Color get globalColorBluegrayAlpha100 => const Color(0x081E222E);
  /// 已用在fill.tertiary
  @override
  Color get globalColorBluegrayAlpha200 => const Color(0x121E222E);
  /// 已用在fill.secondary
  @override
  Color get globalColorBluegrayAlpha300 => const Color(0x1A1E222E);
  /// 已用在fill.primary
  @override
  Color get globalColorBluegrayAlpha400 => const Color(0x2E1E222E);
  @override
  Color get globalColorBluegrayAlpha500 => const Color(0x381E222E);
  /// 已用在text.quaternary
  @override
  Color get globalColorBluegrayAlpha600 => const Color(0x4D1E222E);
  /// 已用在text.tertiary 和 icon.secondary
  @override
  Color get globalColorBluegrayAlpha700 => const Color(0x801E222E);
  @override
  Color get globalColorBluegrayAlpha800 => const Color(0x991E222E);
  @override
  Color get globalColorBluegrayAlpha900 => const Color(0xBF1E222E);
  @override
  Color get globalColorBluegrayAlpha1000 => const Color(0xE61E222E);
  @override
  Color get globalColorBlackAlpha100 => const Color(0x1A000000);
  @override
  Color get globalColorBlackAlpha200 => const Color(0x33000000);
  @override
  Color get globalColorBlackAlpha300 => const Color(0x4D000000);
  @override
  Color get globalColorBlackAlpha400 => const Color(0x66000000);
  /// 已用在background.mask
  @override
  Color get globalColorBlackAlpha500 => const Color(0x73000000);
  @override
  Color get globalColorBlackAlpha600 => const Color(0x99000000);
  @override
  Color get globalColorBlackAlpha700 => const Color(0x99000000);
  @override
  Color get globalColorBlackAlpha800 => const Color(0xB3000000);
  @override
  Color get globalColorBlackAlpha900 => const Color(0xCC000000);
  /// 已用在background.soptlight
  @override
  Color get globalColorBlackAlpha1000 => const Color(0xE6000000);
  @override
  Color get globalColorWhiteAlpha100 => const Color(0x0DFFFFFF);
  @override
  Color get globalColorWhiteAlpha200 => const Color(0x1AFFFFFF);
  @override
  Color get globalColorWhiteAlpha300 => const Color(0x26FFFFFF);
  @override
  Color get globalColorWhiteAlpha400 => const Color(0x33FFFFFF);
  @override
  Color get globalColorWhiteAlpha500 => const Color(0x80FFFFFF);
  @override
  Color get globalColorWhiteAlpha600 => const Color(0x99FFFFFF);
  @override
  Color get globalColorWhiteAlpha700 => const Color(0xB3FFFFFF);
  @override
  Color get globalColorWhiteAlpha800 => const Color(0xCCFFFFFF);
  @override
  Color get globalColorWhiteAlpha900 => const Color(0xE6FFFFFF);
  @override
  Color get globalColorWhiteAlpha1000 => const Color(0xF2FFFFFF);
  @override
  Color get globalColorRadicalRed100 => const Color(0xFF000000);
  @override
  Color get globalColorRadicalRed200 => const Color(0xFF000000);
  @override
  Color get globalColorRadicalRed300 => const Color(0xFF000000);
  @override
  Color get globalColorRadicalRed400 => const Color(0xFF000000);
  @override
  Color get globalColorRadicalRed500 => const Color(0xFFFF6254);
  @override
  Color get globalColorRadicalRed600 => const Color(0xFFF56447);
  @override
  Color get globalColorRadicalRed700 => const Color(0xFF000000);
  @override
  Color get globalColorRadicalRed800 => const Color(0xFF000000);
  @override
  Color get globalColorRadicalRed900 => const Color(0xFF000000);
  @override
  Color get globalColorRadicalRed1000 => const Color(0xFF000000);
  @override
  Color get globalColorPuertoRico100 => const Color(0xFFD8FBF5);
  @override
  Color get globalColorPuertoRico200 => const Color(0xFF88EFE0);
  @override
  Color get globalColorPuertoRico300 => const Color(0xFF60E7B5);
  @override
  Color get globalColorPuertoRico400 => const Color(0xFF2ED3E9);
  @override
  Color get globalColorPuertoRico500 => const Color(0xFF24C9B6);
  @override
  Color get globalColorPuertoRico600 => const Color(0xFF48C8BD);
  @override
  Color get globalColorPuertoRico700 => const Color(0xFF43CF9B);
  @override
  Color get globalColorPuertoRico800 => const Color(0xFF000000);
  @override
  Color get globalColorPuertoRico900 => const Color(0xFF000000);
  @override
  Color get globalColorPuertoRico1000 => const Color(0xFF000000);
  @override
  Color get globalColorTuna100 => const Color(0xFF000000);
  @override
  Color get globalColorTuna200 => const Color(0xFF000000);
  @override
  Color get globalColorTuna300 => const Color(0xFF000000);
  @override
  Color get globalColorTuna400 => const Color(0xFF000000);
  @override
  Color get globalColorTuna500 => const Color(0xFF33394A);
  @override
  Color get globalColorTuna600 => const Color(0xFF21242B);
  @override
  Color get globalColorTuna700 => const Color(0xFF1F212E);
  @override
  Color get globalColorTuna800 => const Color(0xFF151620);
  @override
  Color get globalColorTuna900 => const Color(0xFF000000);
  @override
  Color get globalColorTuna1000 => const Color(0xFF000000);
  @override
  Color get globalColorYellow100 => const Color(0xFF000000);
  @override
  Color get globalColorYellow200 => const Color(0xFF000000);
  @override
  Color get globalColorYellow300 => const Color(0xFF000000);
  @override
  Color get globalColorYellow400 => const Color(0xFF000000);
  @override
  Color get globalColorYellow500 => const Color(0xFFFBDC5E);
  @override
  Color get globalColorYellow600 => const Color(0xFFFBC250);
  @override
  Color get globalColorYellow700 => const Color(0xFFBF8C25);
  @override
  Color get globalColorYellow800 => const Color(0xFF000000);
  @override
  Color get globalColorYellow900 => const Color(0xFF000000);
  @override
  Color get globalColorYellow1000 => const Color(0xFF000000);
  /// 1级文本色
  @override
  Color get semanticColorGreyTextPrimary => const Color(0xFF0C0C0E);
  /// 2级文本色
  @override
  Color get semanticColorGreyTextSecondary => const Color(0xBF1E222E);
  /// 3级文本色
  @override
  Color get semanticColorGreyTextTertiary => const Color(0x801E222E);
  /// 4级文本色
  @override
  Color get semanticColorGreyTextQuaternary => const Color(0x4D1E222E);
  /// 文本反色
  @override
  Color get semanticColorGreyTextInverse => const Color(0xFFFFFFFF);
  /// 文本品牌色
  @override
  Color get semanticColorGreyTextBrand => const Color(0xFF3F70F8);
  /// 文本链接色
  @override
  Color get semanticColorGreyTextLink => const Color(0xFF3F70F8);
  /// 常规背景色
  @override
  Color get semanticColorGreyBackgroundLayout => const Color(0xFFF6F6F8);
  /// 背景容器层填充色
  @override
  Color get semanticColorGreyBackgroundContainer => const Color(0xFFFFFFFF);
  /// 背景弹出层填充色
  @override
  Color get semanticColorGreyBackgroundElevated => const Color(0xFFFFFFFF);
  /// 遮罩填充色
  @override
  Color get semanticColorGreyBackgroundMask => const Color(0x73000000);
  /// toast填充色
  @override
  Color get semanticColorGreyBackgroundSpotlight => const Color(0xE6000000);
  /// 1级填充灰色
  @override
  Color get semanticColorGreyFillPrimary => const Color(0x2E1E222E);
  /// 2级填充灰色
  @override
  Color get semanticColorGreyFillSecondary => const Color(0x1A1E222E);
  /// 3级填充灰色
  @override
  Color get semanticColorGreyFillTertiary => const Color(0x121E222E);
  /// 4级填充灰色
  @override
  Color get semanticColorGreyFillQuaternary => const Color(0x081E222E);
  /// 图表点按填充色
  @override
  Color get semanticColorGreyFillWindow => const Color(0xFFEFEFF0);
  /// 填充反色
  @override
  Color get semanticColorGreyFillInverse => const Color(0xFFFFFFFF);
  /// 1级线条色
  @override
  Color get semanticColorGreyBorderPrimary => const Color(0xFFB7B9BE);
  /// 2级线条色
  @override
  Color get semanticColorGreyBorderSecondary => const Color(0xFFD4D5D8);
  /// 3级线条色
  @override
  Color get semanticColorGreyBorderTertiary => const Color(0xFFDFE0E2);
  /// 4级线条色
  @override
  Color get semanticColorGreyBorderQuaternary => const Color(0xFFECEDEE);
  /// 黑色线条色
  @override
  Color get semanticColorGreyBorderBlack => const Color(0xFF0C0C0E);
  /// 1级图标色
  @override
  Color get semanticColorGreyIconPrimary => const Color(0xFF0C0C0E);
  /// 2级图标色
  @override
  Color get semanticColorGreyIconSecondary => const Color(0x801E222E);
  /// 3级图表色
  @override
  Color get semanticColorGreyIconTertiary => const Color(0x381E222E);
  /// 图标反色
  @override
  Color get semanticColorGreyIconInverse => const Color(0xFFFFFFFF);
  /// 品牌主色
  @override
  Color get semanticColorBrandPrimary => const Color(0xFF3F70F8);
  @override
  Color get semanticColorTagGood => const Color(0xFF48C8BD);
  /// 可提升标签色
  @override
  Color get semanticColorTagImprovable => const Color(0xFFFFA35F);
  /// 危险标签色
  @override
  Color get semanticColorTagWarning => const Color(0xFFF56447);
  /// 睡眠主色
  @override
  Color get semanticColorSleepPrimary => const Color(0xFF4D12BF);
  /// 睡眠分期_清醒色
  @override
  Color get semanticColorSleepAwake => const Color(0xFFFFBC8A);
  /// 睡眠分期_REM色
  @override
  Color get semanticColorSleepRemsleep => const Color(0xFFBBACFB);
  /// 睡眠分期_浅睡色
  @override
  Color get semanticColorSleepLightsleep => const Color(0xFF8265F6);
  /// 睡眠分期_深睡色
  @override
  Color get semanticColorSleepDeepsleep => const Color(0xFF4D12BF);
  /// 活动主色
  @override
  Color get semanticColorActivityPrimary => const Color(0xFFFF8F3D);
  /// 活动_步数主色、低强度主色
  @override
  Color get semanticColorActivityStep => const Color(0xFFFBC250);
  /// 活动_卡路里主色、中强度主色
  @override
  Color get semanticColorActivityCalories => const Color(0xFFFF8F3D);
  /// 活动_活动时长主色、高强度主色
  @override
  Color get semanticColorActivityActivityTime => const Color(0xFFF56447);
  /// 不活跃主色
  @override
  Color get semanticColorActivityInactive => const Color(0xFFB4CBFE);
  /// 压力主色
  @override
  Color get semanticColorStressPrimary => const Color(0xFF51A6FA);
  /// 压力分级_轻松
  @override
  Color get semanticColorStressRelaxed => const Color(0xFFC9E4FF);
  /// 压力分级_正常
  @override
  Color get semanticColorStressNormal => const Color(0xFF51A6FA);
  /// 压力分级_中等
  @override
  Color get semanticColorStressMedium => const Color(0xFF3E5EBF);
  /// 压力分级_高压
  @override
  Color get semanticColorStressHigh => const Color(0xFFFF6254);
  /// 生命体征主色
  @override
  Color get semanticColorVitalPrimary => const Color(0xFFFA3372);
  @override
  Color get semanticColorFemaleMenstrual => const Color(0xFFFF5190);
  @override
  Color get semanticColorFemaleFollicular => const Color(0xFFBB8EC2);
  @override
  Color get semanticColorFemaleOvulation => const Color(0xFF846CE5);
  @override
  Color get semanticColorFemaleLuteal => const Color(0xFFFFA852);
  /// 运动强调色
  @override
  Color get semanticColorSportGo => const Color(0xFF24C9B6);
  /// 运动主色
  @override
  Color get semanticColorSportPrimary => const Color(0xFF33394A);
  /// 热身色
  /// 
  @override
  Color get semanticColorSportWarmUp => const Color(0xFFC9E4FF);
  /// 燃脂色
  /// 
  @override
  Color get semanticColorSportFatBurning => const Color(0xFF88EFE0);
  /// 有氧色
  @override
  Color get semanticColorSportAerobic => const Color(0xFFFBC250);
  /// 无氧色
  @override
  Color get semanticColorSportAnaerobic => const Color(0xFFFF8F3D);
  /// 极限色
  @override
  Color get semanticColorSportExtreme => const Color(0xFFF56447);
  @override
  Color get semanticColorSportLow => const Color(0xFFFBDC5E);
  @override
  Color get semanticColorSportFair => const Color(0xFF60E7B5);
  @override
  Color get semanticColorSportGood => const Color(0xFF2ED3E9);
  @override
  Color get semanticColorSportExcellent => const Color(0xFF3E5EBF);
  @override
  Color get semanticColorSportElite => const Color(0xFF024A92);
  @override
  Color get semanticColorSportBackground => const Color(0xFF21242B);
  @override
  Color get semanticColorOsaNoAbnormalitiesDetected => const Color(0xFF24C9B6);
  @override
  Color get semanticColorOsaSuspectedMild => const Color(0xFFBF8C25);
  @override
  Color get semanticColorOsaSuspectedModerate => const Color(0xFFFFA35F);
  @override
  Color get semanticColorOsaSuspectedSevere => const Color(0xFFF56447);
}


class DarkTokens extends ITokens {
  @override
  TextStyleTokens get textStyle => AdaptiveTextStyleTokens();
  @override
  ColorTokens get color => DarkColorTokens();
  @override
  SpacingTokens get spacing => SharedSpacingTokens();
  @override
  RadiiTokens get radii => SharedRadiiTokens();
}

class DarkColorTokens extends ColorTokens {
  @override
  Color get globalColorBlack => const Color(0xFF0C0C0E);
  @override
  Color get globalColorWhite => const Color(0xFFFFFFFF);
  @override
  Color get globalColorTransparent => const Color(0x00000000);
  /// 已用在fill.window
  @override
  Color get globalColorBluegray100 => const Color(0xFFEFEFF0);
  /// 已用在border.quaternary
  @override
  Color get globalColorBluegray200 => const Color(0xFFECEDEE);
  /// 已用在border.tertiary
  @override
  Color get globalColorBluegray300 => const Color(0xFFDFE0E2);
  /// 已用在border.secondary
  @override
  Color get globalColorBluegray400 => const Color(0xFFD4D5D8);
  /// 已用在border.primary
  @override
  Color get globalColorBluegray500 => const Color(0xFFB7B9BE);
  @override
  Color get globalColorBluegray600 => const Color(0xFF000000);
  @override
  Color get globalColorBluegray700 => const Color(0xFF46464E);
  @override
  Color get globalColorBluegray800 => const Color(0xFF1E1E1F);
  @override
  Color get globalColorBluegray900 => const Color(0xFF000000);
  @override
  Color get globalColorBluegray1000 => const Color(0xFF111112);
  @override
  Color get globalColorPureblue100 => const Color(0xFFF6F6F8);
  @override
  Color get globalColorPureblue200 => const Color(0xFF000000);
  /// 已用在activity.inactive
  @override
  Color get globalColorPureblue300 => const Color(0xFFB4CBFE);
  @override
  Color get globalColorPureblue400 => const Color(0xFF000000);
  @override
  Color get globalColorPureblue500 => const Color(0xFF000000);
  /// 已用作brand.primary
  @override
  Color get globalColorPureblue600 => const Color(0xFF3F70F8);
  @override
  Color get globalColorPureblue700 => const Color(0xFF000000);
  @override
  Color get globalColorPureblue800 => const Color(0xFF000000);
  @override
  Color get globalColorPureblue900 => const Color(0xFF000000);
  @override
  Color get globalColorPureblue1000 => const Color(0xFF000000);
  @override
  Color get globalColorPurple100 => const Color(0xFF000000);
  @override
  Color get globalColorPurple200 => const Color(0xFF000000);
  @override
  Color get globalColorPurple300 => const Color(0xFF000000);
  /// 已用作sleep.remsleep
  @override
  Color get globalColorPurple400 => const Color(0xFFBBACFB);
  @override
  Color get globalColorPurple500 => const Color(0xFF000000);
  /// 已用作sleep.lightsleep
  @override
  Color get globalColorPurple600 => const Color(0xFF8265F6);
  @override
  Color get globalColorPurple700 => const Color(0xFF000000);
  @override
  Color get globalColorPurple800 => const Color(0xFF000000);
  /// 已用作sleep.primary和sleep.deepsleep
  @override
  Color get globalColorPurple900 => const Color(0xFF4D12BF);
  @override
  Color get globalColorPurple1000 => const Color(0xFF000000);
  @override
  Color get globalColorPinkred100 => const Color(0xFF000000);
  @override
  Color get globalColorPinkred200 => const Color(0xFF000000);
  @override
  Color get globalColorPinkred300 => const Color(0xFF000000);
  @override
  Color get globalColorPinkred400 => const Color(0xFF000000);
  @override
  Color get globalColorPinkred500 => const Color(0xFF000000);
  @override
  Color get globalColorPinkred600 => const Color(0xFFFA3372);
  @override
  Color get globalColorPinkred700 => const Color(0xFF000000);
  @override
  Color get globalColorPinkred800 => const Color(0xFF000000);
  @override
  Color get globalColorPinkred900 => const Color(0xFF000000);
  @override
  Color get globalColorPinkred1000 => const Color(0xFF000000);
  @override
  Color get globalColorCyanblue100 => const Color(0xFF000000);
  @override
  Color get globalColorCyanblue200 => const Color(0xFF000000);
  @override
  Color get globalColorCyanblue300 => const Color(0xFF000000);
  @override
  Color get globalColorCyanblue400 => const Color(0xFFC9E4FF);
  @override
  Color get globalColorCyanblue500 => const Color(0xFF000000);
  @override
  Color get globalColorCyanblue600 => const Color(0xFF51A6FA);
  @override
  Color get globalColorCyanblue700 => const Color(0xFF000000);
  @override
  Color get globalColorCyanblue800 => const Color(0xFF3E5EBF);
  @override
  Color get globalColorCyanblue900 => const Color(0xFF024A92);
  @override
  Color get globalColorCyanblue1000 => const Color(0xFF000000);
  @override
  Color get globalColorOrange100 => const Color(0xFF000000);
  @override
  Color get globalColorOrange200 => const Color(0xFF000000);
  @override
  Color get globalColorOrange300 => const Color(0xFF000000);
  @override
  Color get globalColorOrange400 => const Color(0xFFFFBC8A);
  @override
  Color get globalColorOrange500 => const Color(0xFFFFA35F);
  @override
  Color get globalColorOrange600 => const Color(0xFFFF8F3D);
  @override
  Color get globalColorOrange700 => const Color(0xFFFB7D23);
  @override
  Color get globalColorOrange800 => const Color(0xFF000000);
  @override
  Color get globalColorOrange900 => const Color(0xFF000000);
  @override
  Color get globalColorOrange1000 => const Color(0xFF000000);
  /// 已用在fill.quaternary
  @override
  Color get globalColorBluegrayAlpha100 => const Color(0x081E222E);
  /// 已用在fill.tertiary
  @override
  Color get globalColorBluegrayAlpha200 => const Color(0x121E222E);
  /// 已用在fill.secondary
  @override
  Color get globalColorBluegrayAlpha300 => const Color(0x1A1E222E);
  /// 已用在fill.primary
  @override
  Color get globalColorBluegrayAlpha400 => const Color(0x2E1E222E);
  @override
  Color get globalColorBluegrayAlpha500 => const Color(0x381E222E);
  /// 已用在text.quaternary
  @override
  Color get globalColorBluegrayAlpha600 => const Color(0x4D1E222E);
  /// 已用在text.tertiary 和 icon.secondary
  @override
  Color get globalColorBluegrayAlpha700 => const Color(0x801E222E);
  @override
  Color get globalColorBluegrayAlpha800 => const Color(0x991E222E);
  @override
  Color get globalColorBluegrayAlpha900 => const Color(0xBF1E222E);
  @override
  Color get globalColorBluegrayAlpha1000 => const Color(0xE61E222E);
  @override
  Color get globalColorBlackAlpha100 => const Color(0x1A000000);
  @override
  Color get globalColorBlackAlpha200 => const Color(0x33000000);
  @override
  Color get globalColorBlackAlpha300 => const Color(0x4D000000);
  @override
  Color get globalColorBlackAlpha400 => const Color(0x66000000);
  /// 已用在background.mask
  @override
  Color get globalColorBlackAlpha500 => const Color(0x73000000);
  @override
  Color get globalColorBlackAlpha600 => const Color(0x99000000);
  @override
  Color get globalColorBlackAlpha700 => const Color(0x99000000);
  @override
  Color get globalColorBlackAlpha800 => const Color(0xB3000000);
  @override
  Color get globalColorBlackAlpha900 => const Color(0xCC000000);
  /// 已用在background.soptlight
  @override
  Color get globalColorBlackAlpha1000 => const Color(0xE6000000);
  @override
  Color get globalColorWhiteAlpha100 => const Color(0x0DFFFFFF);
  @override
  Color get globalColorWhiteAlpha200 => const Color(0x1AFFFFFF);
  @override
  Color get globalColorWhiteAlpha300 => const Color(0x26FFFFFF);
  @override
  Color get globalColorWhiteAlpha400 => const Color(0x33FFFFFF);
  @override
  Color get globalColorWhiteAlpha500 => const Color(0x80FFFFFF);
  @override
  Color get globalColorWhiteAlpha600 => const Color(0x99FFFFFF);
  @override
  Color get globalColorWhiteAlpha700 => const Color(0xB3FFFFFF);
  @override
  Color get globalColorWhiteAlpha800 => const Color(0xCCFFFFFF);
  @override
  Color get globalColorWhiteAlpha900 => const Color(0xE6FFFFFF);
  @override
  Color get globalColorWhiteAlpha1000 => const Color(0xF2FFFFFF);
  @override
  Color get globalColorRadicalRed100 => const Color(0xFF000000);
  @override
  Color get globalColorRadicalRed200 => const Color(0xFF000000);
  @override
  Color get globalColorRadicalRed300 => const Color(0xFF000000);
  @override
  Color get globalColorRadicalRed400 => const Color(0xFF000000);
  @override
  Color get globalColorRadicalRed500 => const Color(0xFFFF6254);
  @override
  Color get globalColorRadicalRed600 => const Color(0xFFF56447);
  @override
  Color get globalColorRadicalRed700 => const Color(0xFF000000);
  @override
  Color get globalColorRadicalRed800 => const Color(0xFF000000);
  @override
  Color get globalColorRadicalRed900 => const Color(0xFF000000);
  @override
  Color get globalColorRadicalRed1000 => const Color(0xFF000000);
  @override
  Color get globalColorPuertoRico100 => const Color(0xFFD8FBF5);
  @override
  Color get globalColorPuertoRico200 => const Color(0xFF88EFE0);
  @override
  Color get globalColorPuertoRico300 => const Color(0xFF60E7B5);
  @override
  Color get globalColorPuertoRico400 => const Color(0xFF2ED3E9);
  @override
  Color get globalColorPuertoRico500 => const Color(0xFF24C9B6);
  @override
  Color get globalColorPuertoRico600 => const Color(0xFF48C8BD);
  @override
  Color get globalColorPuertoRico700 => const Color(0xFF43CF9B);
  @override
  Color get globalColorPuertoRico800 => const Color(0xFF000000);
  @override
  Color get globalColorPuertoRico900 => const Color(0xFF000000);
  @override
  Color get globalColorPuertoRico1000 => const Color(0xFF000000);
  @override
  Color get globalColorTuna100 => const Color(0xFF000000);
  @override
  Color get globalColorTuna200 => const Color(0xFF000000);
  @override
  Color get globalColorTuna300 => const Color(0xFF000000);
  @override
  Color get globalColorTuna400 => const Color(0xFF000000);
  @override
  Color get globalColorTuna500 => const Color(0xFF33394A);
  @override
  Color get globalColorTuna600 => const Color(0xFF21242B);
  @override
  Color get globalColorTuna700 => const Color(0xFF1F212E);
  @override
  Color get globalColorTuna800 => const Color(0xFF151620);
  @override
  Color get globalColorTuna900 => const Color(0xFF000000);
  @override
  Color get globalColorTuna1000 => const Color(0xFF000000);
  @override
  Color get globalColorYellow100 => const Color(0xFF000000);
  @override
  Color get globalColorYellow200 => const Color(0xFF000000);
  @override
  Color get globalColorYellow300 => const Color(0xFF000000);
  @override
  Color get globalColorYellow400 => const Color(0xFF000000);
  @override
  Color get globalColorYellow500 => const Color(0xFFFBDC5E);
  @override
  Color get globalColorYellow600 => const Color(0xFFFBC250);
  @override
  Color get globalColorYellow700 => const Color(0xFFBF8C25);
  @override
  Color get globalColorYellow800 => const Color(0xFF000000);
  @override
  Color get globalColorYellow900 => const Color(0xFF000000);
  @override
  Color get globalColorYellow1000 => const Color(0xFF000000);
  /// 1级文本色
  @override
  Color get semanticColorGreyTextPrimary => const Color(0xF2FFFFFF);
  /// 2级文本色
  @override
  Color get semanticColorGreyTextSecondary => const Color(0x99FFFFFF);
  /// 3级文本色
  @override
  Color get semanticColorGreyTextTertiary => const Color(0x80FFFFFF);
  /// 4级文本色
  @override
  Color get semanticColorGreyTextQuaternary => const Color(0x33FFFFFF);
  /// 文本反色
  @override
  Color get semanticColorGreyTextInverse => const Color(0xFFFFFFFF);
  /// 文本品牌色
  @override
  Color get semanticColorGreyTextBrand => const Color(0xFF3F70F8);
  /// 文本链接色
  @override
  Color get semanticColorGreyTextLink => const Color(0xFF3F70F8);
  /// 常规背景色
  @override
  Color get semanticColorGreyBackgroundLayout => const Color(0xFF111112);
  /// 背景容器层填充色
  @override
  Color get semanticColorGreyBackgroundContainer => const Color(0xFF1E1E1F);
  /// 背景弹出层填充色
  @override
  Color get semanticColorGreyBackgroundElevated => const Color(0xFF46464E);
  /// 遮罩填充色
  @override
  Color get semanticColorGreyBackgroundMask => const Color(0x73000000);
  /// toast填充色
  @override
  Color get semanticColorGreyBackgroundSpotlight => const Color(0xE6000000);
  /// 1级填充灰色
  @override
  Color get semanticColorGreyFillPrimary => const Color(0x33FFFFFF);
  /// 2级填充灰色
  @override
  Color get semanticColorGreyFillSecondary => const Color(0x26FFFFFF);
  /// 3级填充灰色
  @override
  Color get semanticColorGreyFillTertiary => const Color(0x1AFFFFFF);
  /// 4级填充灰色
  @override
  Color get semanticColorGreyFillQuaternary => const Color(0x0DFFFFFF);
  /// 图表点按填充色
  @override
  Color get semanticColorGreyFillWindow => const Color(0xFFEFEFF0);
  /// 填充反色
  @override
  Color get semanticColorGreyFillInverse => const Color(0x1AFFFFFF);
  /// 1级线条色
  @override
  Color get semanticColorGreyBorderPrimary => const Color(0x1AFFFFFF);
  /// 2级线条色
  @override
  Color get semanticColorGreyBorderSecondary => const Color(0x26FFFFFF);
  /// 3级线条色
  @override
  Color get semanticColorGreyBorderTertiary => const Color(0x1AFFFFFF);
  /// 4级线条色
  @override
  Color get semanticColorGreyBorderQuaternary => const Color(0x0DFFFFFF);
  /// 黑色线条色
  @override
  Color get semanticColorGreyBorderBlack => const Color(0xFF0C0C0E);
  /// 1级图标色
  @override
  Color get semanticColorGreyIconPrimary => const Color(0xF2FFFFFF);
  /// 2级图标色
  @override
  Color get semanticColorGreyIconSecondary => const Color(0x99FFFFFF);
  /// 3级图表色
  @override
  Color get semanticColorGreyIconTertiary => const Color(0x80FFFFFF);
  /// 图标反色
  @override
  Color get semanticColorGreyIconInverse => const Color(0xFFFFFFFF);
  /// 品牌主色
  @override
  Color get semanticColorBrandPrimary => const Color(0xFF3F70F8);
  /// 优秀标签色
  @override
  Color get semanticColorTagGood => const Color(0xFF48C8BD);
  /// 可提升标签色
  @override
  Color get semanticColorTagImprovable => const Color(0xFFFFA35F);
  @override
  Color get semanticColorTagWarning => const Color(0xFFF56447);
  /// 睡眠主色
  @override
  Color get semanticColorSleepPrimary => const Color(0xFF4D12BF);
  /// 睡眠分期_清醒色
  @override
  Color get semanticColorSleepAwake => const Color(0xFFFAB979);
  /// 睡眠分期_REM色
  @override
  Color get semanticColorSleepRemsleep => const Color(0xFFBBACFB);
  /// 睡眠分期_浅睡色
  @override
  Color get semanticColorSleepLightsleep => const Color(0xFF8265F6);
  /// 睡眠分期_深睡色
  @override
  Color get semanticColorSleepDeepsleep => const Color(0xFF4D12BF);
  /// 活动主色
  @override
  Color get semanticColorActivityPrimary => const Color(0xFFFB7D23);
  /// 活动_步数主色、低强度主色
  @override
  Color get semanticColorActivityStep => const Color(0xFFFBC250);
  /// 活动_卡路里主色、中强度主色
  @override
  Color get semanticColorActivityCalories => const Color(0xFFFF8F3D);
  /// 活动_活动时长主色、高强度主色
  @override
  Color get semanticColorActivityActivityTime => const Color(0xFFF56447);
  /// 不活跃主色
  @override
  Color get semanticColorActivityInactive => const Color(0xFFB4CBFE);
  /// 压力主色
  @override
  Color get semanticColorStressPrimary => const Color(0xFF51A6FA);
  /// 压力分级_轻松
  @override
  Color get semanticColorStressRelaxed => const Color(0xFFC9E4FF);
  /// 压力分级_正常
  @override
  Color get semanticColorStressNormal => const Color(0xFF51A6FA);
  /// 压力分级_中等
  @override
  Color get semanticColorStressMedium => const Color(0xFF3E5EBF);
  /// 压力分级_高压
  @override
  Color get semanticColorStressHigh => const Color(0xFFFF6254);
  /// 生命体征主色
  @override
  Color get semanticColorVitalPrimary => const Color(0xFFFA3372);
  @override
  Color get semanticColorFemaleMenstrual => const Color(0xFFFF5190);
  @override
  Color get semanticColorFemaleFollicular => const Color(0xFFBB8EC2);
  @override
  Color get semanticColorFemaleOvulation => const Color(0xFF846CE5);
  @override
  Color get semanticColorFemaleLuteal => const Color(0xFFFFA852);
  /// 运动强调色
  @override
  Color get semanticColorSportGo => const Color(0xFF24C9B6);
  /// 运动主色
  @override
  Color get semanticColorSportPrimary => const Color(0xFF33394A);
  /// 热身色
  /// 
  @override
  Color get semanticColorSportWarmUp => const Color(0xFFC9E4FF);
  /// 燃脂色
  /// 
  @override
  Color get semanticColorSportFatBurning => const Color(0xFF88EFE0);
  /// 有氧色
  @override
  Color get semanticColorSportAerobic => const Color(0xFFFBC250);
  /// 无氧色
  @override
  Color get semanticColorSportAnaerobic => const Color(0xFFFF8F3D);
  /// 极限色
  @override
  Color get semanticColorSportExtreme => const Color(0xFFF56447);
  @override
  Color get semanticColorSportLow => const Color(0xFFFBDC5E);
  @override
  Color get semanticColorSportFair => const Color(0xFF60E7B5);
  @override
  Color get semanticColorSportGood => const Color(0xFF2ED3E9);
  @override
  Color get semanticColorSportExcellent => const Color(0xFF3E5EBF);
  @override
  Color get semanticColorSportElite => const Color(0xFF024A92);
  @override
  Color get semanticColorSportBackground => const Color(0xFF21242B);
  /// 当前主题 (dark) 未定义此 token，使用 light 主题的值作为默认值。
  @override
  Color get semanticColorOsaNoAbnormalitiesDetected => LightColorTokens().semanticColorOsaNoAbnormalitiesDetected;
  /// 当前主题 (dark) 未定义此 token，使用 light 主题的值作为默认值。
  @override
  Color get semanticColorOsaSuspectedMild => LightColorTokens().semanticColorOsaSuspectedMild;
  /// 当前主题 (dark) 未定义此 token，使用 light 主题的值作为默认值。
  @override
  Color get semanticColorOsaSuspectedModerate => LightColorTokens().semanticColorOsaSuspectedModerate;
  /// 当前主题 (dark) 未定义此 token，使用 light 主题的值作为默认值。
  @override
  Color get semanticColorOsaSuspectedSevere => LightColorTokens().semanticColorOsaSuspectedSevere;
}


class IosChTextStyleTokens extends TextStyleTokens {
  @override
  TextStyle get semanticTypographyLabel10 => const TextStyle(
  fontFamily: 'PingFang SC',
  fontSize: 10.0,
  fontWeight: FontWeight.w500,
  height: 1.5,
);
  @override
  TextStyle get semanticTypographyLabel12 => const TextStyle(
  fontFamily: 'PingFang SC',
  fontSize: 12.0,
  fontWeight: FontWeight.w500,
  height: 1.5,
);
  @override
  TextStyle get semanticTypographyLabel14 => const TextStyle(
  fontFamily: 'PingFang SC',
  fontSize: 14.0,
  fontWeight: FontWeight.w500,
  height: 1.6,
);
  @override
  TextStyle get semanticTypographyBody12 => const TextStyle(
  fontFamily: 'PingFang SC',
  fontSize: 12.0,
  fontWeight: FontWeight.w400,
  height: 1.5,
);
  @override
  TextStyle get semanticTypographyBody14 => const TextStyle(
  fontFamily: 'PingFang SC',
  fontSize: 14.0,
  fontWeight: FontWeight.w400,
  height: 1.6,
);
  @override
  TextStyle get semanticTypographyBody16 => const TextStyle(
  fontFamily: 'PingFang SC',
  fontSize: 16.0,
  fontWeight: FontWeight.w400,
  height: 1.6,
);
  @override
  TextStyle get semanticTypographyTitle16 => const TextStyle(
  fontFamily: 'PingFang SC',
  fontSize: 16.0,
  fontWeight: FontWeight.w500,
  height: 1.6,
);
  @override
  TextStyle get semanticTypographyTitle18 => const TextStyle(
  fontFamily: 'PingFang SC',
  fontSize: 18.0,
  fontWeight: FontWeight.w500,
  height: 1.4,
);
  @override
  TextStyle get semanticTypographyTitle20 => const TextStyle(
  fontFamily: 'PingFang SC',
  fontSize: 20.0,
  fontWeight: FontWeight.w500,
  height: 1.4,
);
  @override
  TextStyle get semanticTypographyTitle22 => const TextStyle(
  fontFamily: 'PingFang SC',
  fontSize: 22.0,
  fontWeight: FontWeight.w500,
  height: 1.4,
);
  @override
  TextStyle get semanticTypographyDisplay24 => const TextStyle(
  fontFamily: 'PingFang SC',
  fontSize: 24.0,
  fontWeight: FontWeight.w600,
  height: 1.2,
);
  @override
  TextStyle get semanticTypographyDisplay28 => const TextStyle(
  fontFamily: 'PingFang SC',
  fontSize: 28.0,
  fontWeight: FontWeight.w600,
  height: 1.2,
);
  @override
  TextStyle get semanticTypographyNumberText12 => const TextStyle(
  fontFamily: 'PingFang SC',
  fontSize: 12.0,
  fontWeight: FontWeight.w500,
  height: 1.7,
);
  @override
  TextStyle get semanticTypographyNumberText14 => const TextStyle(
  fontFamily: 'PingFang SC',
  fontSize: 14.0,
  fontWeight: FontWeight.w500,
  height: 1.7,
);
  @override
  TextStyle get semanticTypographyNumberText16 => const TextStyle(
  fontFamily: 'PingFang SC',
  fontSize: 16.0,
  fontWeight: FontWeight.w500,
  height: 1.7,
);
  @override
  TextStyle get semanticTypographyNumber12 => const TextStyle(
  fontFamily: 'SF Pro',
  fontSize: 12.0,
  fontWeight: FontWeight.w400,
  height: 1.25,
);
  @override
  TextStyle get semanticTypographyNumber20 => const TextStyle(
  fontFamily: 'SF Pro',
  fontSize: 20.0,
  fontWeight: FontWeight.w600,
  height: 1.2,
);
  @override
  TextStyle get semanticTypographyNumber24 => const TextStyle(
  fontFamily: 'SF Pro',
  fontSize: 24.0,
  fontWeight: FontWeight.w600,
  height: 1.2,
);
  @override
  TextStyle get semanticTypographyNumber28 => const TextStyle(
  fontFamily: 'SF Pro',
  fontSize: 28.0,
  fontWeight: FontWeight.w600,
  height: 1.2,
);
  @override
  TextStyle get semanticTypographyNumber32 => const TextStyle(
  fontFamily: 'SF Pro',
  fontSize: 32.0,
  fontWeight: FontWeight.w600,
  height: 1.2,
);
  @override
  TextStyle get semanticTypographyNumber64 => const TextStyle(
  fontFamily: 'SF Pro',
  fontSize: 60.0,
  fontWeight: FontWeight.w600,
  height: 1.0,
);
}


class IosEngTextStyleTokens extends TextStyleTokens {
  @override
  TextStyle get semanticTypographyLabel10 => const TextStyle(
  fontFamily: 'Inter',
  fontSize: 10.0,
  fontWeight: FontWeight.w500,
  height: 1.5,
);
  @override
  TextStyle get semanticTypographyLabel12 => const TextStyle(
  fontFamily: 'Inter',
  fontSize: 12.0,
  fontWeight: FontWeight.w500,
  height: 1.5,
);
  @override
  TextStyle get semanticTypographyLabel14 => const TextStyle(
  fontFamily: 'Inter',
  fontSize: 14.0,
  fontWeight: FontWeight.w500,
  height: 1.6,
);
  @override
  TextStyle get semanticTypographyBody12 => const TextStyle(
  fontFamily: 'Inter',
  fontSize: 12.0,
  fontWeight: FontWeight.w400,
  height: 1.5,
);
  @override
  TextStyle get semanticTypographyBody14 => const TextStyle(
  fontFamily: 'Inter',
  fontSize: 14.0,
  fontWeight: FontWeight.w400,
  height: 1.6,
);
  @override
  TextStyle get semanticTypographyBody16 => const TextStyle(
  fontFamily: 'Inter',
  fontSize: 16.0,
  fontWeight: FontWeight.w400,
  height: 1.6,
);
  @override
  TextStyle get semanticTypographyTitle16 => const TextStyle(
  fontFamily: 'Inter',
  fontSize: 16.0,
  fontWeight: FontWeight.w500,
  height: 1.5,
);
  @override
  TextStyle get semanticTypographyTitle18 => const TextStyle(
  fontFamily: 'Inter',
  fontSize: 18.0,
  fontWeight: FontWeight.w500,
  height: 1.4,
);
  @override
  TextStyle get semanticTypographyTitle20 => const TextStyle(
  fontFamily: 'Inter',
  fontSize: 20.0,
  fontWeight: FontWeight.w500,
  height: 1.4,
);
  @override
  TextStyle get semanticTypographyTitle22 => const TextStyle(
  fontFamily: 'Inter',
  fontSize: 22.0,
  fontWeight: FontWeight.w500,
  height: 1.4,
);
  @override
  TextStyle get semanticTypographyDisplay24 => const TextStyle(
  fontFamily: 'Inter',
  fontSize: 24.0,
  fontWeight: FontWeight.w600,
  height: 1.2,
);
  @override
  TextStyle get semanticTypographyDisplay28 => const TextStyle(
  fontFamily: 'Inter',
  fontSize: 28.0,
  fontWeight: FontWeight.w600,
  height: 1.2,
);
  @override
  TextStyle get semanticTypographyNumberText12 => const TextStyle(
  fontFamily: 'Inter',
  fontSize: 12.0,
  fontWeight: FontWeight.w500,
  height: 1.6,
);
  @override
  TextStyle get semanticTypographyNumberText14 => const TextStyle(
  fontFamily: 'Inter',
  fontSize: 14.0,
  fontWeight: FontWeight.w500,
  height: 1.6,
);
  @override
  TextStyle get semanticTypographyNumberText16 => const TextStyle(
  fontFamily: 'Inter',
  fontSize: 16.0,
  fontWeight: FontWeight.w500,
  height: 1.6,
);
  @override
  TextStyle get semanticTypographyNumber12 => const TextStyle(
  fontFamily: 'SF Pro',
  fontSize: 12.0,
  fontWeight: FontWeight.w400,
  height: 1.25,
);
  @override
  TextStyle get semanticTypographyNumber20 => const TextStyle(
  fontFamily: 'SF Pro',
  fontSize: 20.0,
  fontWeight: FontWeight.w600,
  height: 1.2,
);
  @override
  TextStyle get semanticTypographyNumber24 => const TextStyle(
  fontFamily: 'SF Pro',
  fontSize: 24.0,
  fontWeight: FontWeight.w600,
  height: 1.2,
);
  @override
  TextStyle get semanticTypographyNumber28 => const TextStyle(
  fontFamily: 'SF Pro',
  fontSize: 28.0,
  fontWeight: FontWeight.w600,
  height: 1.2,
);
  @override
  TextStyle get semanticTypographyNumber32 => const TextStyle(
  fontFamily: 'SF Pro',
  fontSize: 32.0,
  fontWeight: FontWeight.w600,
  height: 1.2,
);
  @override
  TextStyle get semanticTypographyNumber64 => const TextStyle(
  fontFamily: 'SF Pro',
  fontSize: 60.0,
  fontWeight: FontWeight.w600,
  height: 1.0,
);
}


class AndroidChTextStyleTokens extends TextStyleTokens {
  @override
  TextStyle get semanticTypographyLabel10 => const TextStyle(
  fontFamily: 'HarmonyOS Sans SC',
  fontSize: 10.0,
  fontWeight: FontWeight.w500,
  height: 1.5,
);
  @override
  TextStyle get semanticTypographyLabel12 => const TextStyle(
  fontFamily: 'HarmonyOS Sans SC',
  fontSize: 12.0,
  fontWeight: FontWeight.w500,
  height: 1.5,
);
  @override
  TextStyle get semanticTypographyLabel14 => const TextStyle(
  fontFamily: 'HarmonyOS Sans SC',
  fontSize: 14.0,
  fontWeight: FontWeight.w500,
  height: 1.6,
);
  @override
  TextStyle get semanticTypographyBody12 => const TextStyle(
  fontFamily: 'HarmonyOS Sans SC',
  fontSize: 12.0,
  fontWeight: FontWeight.w400,
  height: 1.5,
);
  @override
  TextStyle get semanticTypographyBody14 => const TextStyle(
  fontFamily: 'HarmonyOS Sans SC',
  fontSize: 14.0,
  fontWeight: FontWeight.w400,
  height: 1.6,
);
  @override
  TextStyle get semanticTypographyBody16 => const TextStyle(
  fontFamily: 'HarmonyOS Sans SC',
  fontSize: 16.0,
  fontWeight: FontWeight.w400,
  height: 1.6,
);
  @override
  TextStyle get semanticTypographyTitle16 => const TextStyle(
  fontFamily: 'HarmonyOS Sans SC',
  fontSize: 16.0,
  fontWeight: FontWeight.w500,
  height: 1.6,
);
  @override
  TextStyle get semanticTypographyTitle18 => const TextStyle(
  fontFamily: 'HarmonyOS Sans SC',
  fontSize: 18.0,
  fontWeight: FontWeight.w500,
  height: 1.4,
);
  @override
  TextStyle get semanticTypographyTitle20 => const TextStyle(
  fontFamily: 'HarmonyOS Sans SC',
  fontSize: 20.0,
  fontWeight: FontWeight.w500,
  height: 1.4,
);
  @override
  TextStyle get semanticTypographyTitle22 => const TextStyle(
  fontFamily: 'HarmonyOS Sans SC',
  fontSize: 22.0,
  fontWeight: FontWeight.w500,
  height: 1.4,
);
  @override
  TextStyle get semanticTypographyDisplay24 => const TextStyle(
  fontFamily: 'HarmonyOS Sans SC',
  fontSize: 24.0,
  fontWeight: FontWeight.w600,
  height: 1.2,
);
  @override
  TextStyle get semanticTypographyDisplay28 => const TextStyle(
  fontFamily: 'HarmonyOS Sans SC',
  fontSize: 28.0,
  fontWeight: FontWeight.w600,
  height: 1.2,
);
  @override
  TextStyle get semanticTypographyNumberText12 => const TextStyle(
  fontFamily: 'HarmonyOS Sans SC',
  fontSize: 12.0,
  fontWeight: FontWeight.w500,
  height: 1.7,
);
  @override
  TextStyle get semanticTypographyNumberText14 => const TextStyle(
  fontFamily: 'HarmonyOS Sans SC',
  fontSize: 14.0,
  fontWeight: FontWeight.w500,
  height: 1.7,
);
  @override
  TextStyle get semanticTypographyNumberText16 => const TextStyle(
  fontFamily: 'HarmonyOS Sans SC',
  fontSize: 16.0,
  fontWeight: FontWeight.w500,
  height: 1.7,
);
  @override
  TextStyle get semanticTypographyNumber12 => const TextStyle(
  fontFamily: 'Inter',
  fontSize: 12.0,
  fontWeight: FontWeight.w400,
  height: 1.25,
);
  @override
  TextStyle get semanticTypographyNumber20 => const TextStyle(
  fontFamily: 'Inter',
  fontSize: 20.0,
  fontWeight: FontWeight.w600,
  height: 1.2,
);
  @override
  TextStyle get semanticTypographyNumber24 => const TextStyle(
  fontFamily: 'Inter',
  fontSize: 24.0,
  fontWeight: FontWeight.w600,
  height: 1.2,
);
  @override
  TextStyle get semanticTypographyNumber28 => const TextStyle(
  fontFamily: 'Inter',
  fontSize: 28.0,
  fontWeight: FontWeight.w600,
  height: 1.2,
);
  @override
  TextStyle get semanticTypographyNumber32 => const TextStyle(
  fontFamily: 'SF Pro',
  fontSize: 32.0,
  fontWeight: FontWeight.w600,
  height: 1.2,
);
  @override
  TextStyle get semanticTypographyNumber64 => const TextStyle(
  fontFamily: 'SF Pro',
  fontSize: 60.0,
  fontWeight: FontWeight.w600,
  height: 1.0,
);
}


class AndroidEngTextStyleTokens extends TextStyleTokens {
  @override
  TextStyle get semanticTypographyLabel10 => const TextStyle(
  fontFamily: 'SF Pro',
  fontSize: 10.0,
  fontWeight: FontWeight.w500,
  height: 1.5,
);
  @override
  TextStyle get semanticTypographyLabel12 => const TextStyle(
  fontFamily: 'SF Pro',
  fontSize: 12.0,
  fontWeight: FontWeight.w500,
  height: 1.5,
);
  @override
  TextStyle get semanticTypographyLabel14 => const TextStyle(
  fontFamily: 'SF Pro',
  fontSize: 14.0,
  fontWeight: FontWeight.w500,
  height: 1.6,
);
  @override
  TextStyle get semanticTypographyBody12 => const TextStyle(
  fontFamily: 'SF Pro',
  fontSize: 12.0,
  fontWeight: FontWeight.w400,
  height: 1.5,
);
  @override
  TextStyle get semanticTypographyBody14 => const TextStyle(
  fontFamily: 'SF Pro',
  fontSize: 14.0,
  fontWeight: FontWeight.w400,
  height: 1.6,
);
  @override
  TextStyle get semanticTypographyBody16 => const TextStyle(
  fontFamily: 'SF Pro',
  fontSize: 16.0,
  fontWeight: FontWeight.w400,
  height: 1.6,
);
  @override
  TextStyle get semanticTypographyTitle16 => const TextStyle(
  fontFamily: 'SF Pro',
  fontSize: 16.0,
  fontWeight: FontWeight.w500,
  height: 1.6,
);
  @override
  TextStyle get semanticTypographyTitle18 => const TextStyle(
  fontFamily: 'SF Pro',
  fontSize: 18.0,
  fontWeight: FontWeight.w500,
  height: 1.4,
);
  @override
  TextStyle get semanticTypographyTitle20 => const TextStyle(
  fontFamily: 'SF Pro',
  fontSize: 20.0,
  fontWeight: FontWeight.w500,
  height: 1.4,
);
  @override
  TextStyle get semanticTypographyTitle22 => const TextStyle(
  fontFamily: 'SF Pro',
  fontSize: 22.0,
  fontWeight: FontWeight.w500,
  height: 1.4,
);
  @override
  TextStyle get semanticTypographyDisplay24 => const TextStyle(
  fontFamily: 'SF Pro',
  fontSize: 24.0,
  fontWeight: FontWeight.w600,
  height: 1.2,
);
  @override
  TextStyle get semanticTypographyDisplay28 => const TextStyle(
  fontFamily: 'SF Pro',
  fontSize: 28.0,
  fontWeight: FontWeight.w600,
  height: 1.2,
);
  @override
  TextStyle get semanticTypographyNumberText12 => const TextStyle(
  fontFamily: 'SF Pro',
  fontSize: 12.0,
  fontWeight: FontWeight.w500,
  height: 1.6,
);
  @override
  TextStyle get semanticTypographyNumberText14 => const TextStyle(
  fontFamily: 'SF Pro',
  fontSize: 14.0,
  fontWeight: FontWeight.w500,
  height: 1.6,
);
  @override
  TextStyle get semanticTypographyNumberText16 => const TextStyle(
  fontFamily: 'SF Pro',
  fontSize: 16.0,
  fontWeight: FontWeight.w500,
  height: 1.6,
);
  @override
  TextStyle get semanticTypographyNumber12 => const TextStyle(
  fontFamily: 'SF Pro',
  fontSize: 12.0,
  fontWeight: FontWeight.w400,
  height: 1.25,
);
  @override
  TextStyle get semanticTypographyNumber20 => const TextStyle(
  fontFamily: 'SF Pro',
  fontSize: 20.0,
  fontWeight: FontWeight.w600,
  height: 1.2,
);
  @override
  TextStyle get semanticTypographyNumber24 => const TextStyle(
  fontFamily: 'SF Pro',
  fontSize: 24.0,
  fontWeight: FontWeight.w600,
  height: 1.2,
);
  @override
  TextStyle get semanticTypographyNumber28 => const TextStyle(
  fontFamily: 'SF Pro',
  fontSize: 28.0,
  fontWeight: FontWeight.w600,
  height: 1.2,
);
  @override
  TextStyle get semanticTypographyNumber32 => const TextStyle(
  fontFamily: 'SF Pro',
  fontSize: 32.0,
  fontWeight: FontWeight.w600,
  height: 1.2,
);
  @override
  TextStyle get semanticTypographyNumber64 => const TextStyle(
  fontFamily: 'SF Pro',
  fontSize: 60.0,
  fontWeight: FontWeight.w600,
  height: 1.0,
);
}
