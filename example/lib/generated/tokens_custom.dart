// import 'package:example/generated/tokens.g.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/rendering.dart';

// /// 自定义代码 - 文本样式相关
// /// 此文件包含文本样式的自定义实现，不会被生成器覆盖

// abstract class BaseTextStyleTokens extends TextStyleTokens {
//   /// 获取文本字体（用于 Label/Body/Title/Display/NumberText 系列）
//   String get textFontFamily;

//   /// 获取数字字体（用于 Number 系列）
//   String get numberFontFamily;

//   /// 获取 NumberText 系列的行高
//   double get numberTextHeight => 1.6;

//   /// 获取 Title16 的行高
//   double get title16Height => 1.6;

//   @override
//   TextStyle get semanticTypographyLabel10 => TextStyle(
//         fontFamily: textFontFamily,
//         fontSize: 10.0,
//         fontWeight: FontWeight.w500,
//         height: 1.5,
//       );

//   @override
//   TextStyle get semanticTypographyLabel12 => TextStyle(
//         fontFamily: textFontFamily,
//         fontSize: 12.0,
//         fontWeight: FontWeight.w500,
//         height: 1.5,
//       );

//   @override
//   TextStyle get semanticTypographyLabel14 => TextStyle(
//         fontFamily: textFontFamily,
//         fontSize: 14.0,
//         fontWeight: FontWeight.w500,
//         height: 1.6,
//       );

//   @override
//   TextStyle get semanticTypographyBody12 => TextStyle(
//         fontFamily: textFontFamily,
//         fontSize: 12.0,
//         fontWeight: FontWeight.w400,
//         height: 1.5,
//       );

//   @override
//   TextStyle get semanticTypographyBody14 => TextStyle(
//         fontFamily: textFontFamily,
//         fontSize: 14.0,
//         fontWeight: FontWeight.w400,
//         height: 1.6,
//       );

//   @override
//   TextStyle get semanticTypographyBody16 => TextStyle(
//         fontFamily: textFontFamily,
//         fontSize: 16.0,
//         fontWeight: FontWeight.w400,
//         height: 1.6,
//       );

//   @override
//   TextStyle get semanticTypographyTitle16 => TextStyle(
//         fontFamily: textFontFamily,
//         fontSize: 16.0,
//         fontWeight: FontWeight.w500,
//         height: title16Height,
//       );

//   @override
//   TextStyle get semanticTypographyTitle18 => TextStyle(
//         fontFamily: textFontFamily,
//         fontSize: 18.0,
//         fontWeight: FontWeight.w500,
//         height: 1.4,
//       );

//   @override
//   TextStyle get semanticTypographyTitle20 => TextStyle(
//         fontFamily: textFontFamily,
//         fontSize: 20.0,
//         fontWeight: FontWeight.w500,
//         height: 1.4,
//       );

//   @override
//   TextStyle get semanticTypographyTitle22 => TextStyle(
//         fontFamily: textFontFamily,
//         fontSize: 22.0,
//         fontWeight: FontWeight.w500,
//         height: 1.4,
//       );

//   @override
//   TextStyle get semanticTypographyDisplay24 => TextStyle(
//         fontFamily: textFontFamily,
//         fontSize: 24.0,
//         fontWeight: FontWeight.w600,
//         height: 1.2,
//       );

//   @override
//   TextStyle get semanticTypographyDisplay28 => TextStyle(
//         fontFamily: textFontFamily,
//         fontSize: 28.0,
//         fontWeight: FontWeight.w600,
//         height: 1.2,
//       );

//   @override
//   TextStyle get semanticTypographyNumberText12 => TextStyle(
//         fontFamily: textFontFamily,
//         fontSize: 12.0,
//         fontWeight: FontWeight.w500,
//         height: numberTextHeight,
//       );

//   @override
//   TextStyle get semanticTypographyNumberText14 => TextStyle(
//         fontFamily: textFontFamily,
//         fontSize: 14.0,
//         fontWeight: FontWeight.w500,
//         height: numberTextHeight,
//       );

//   @override
//   TextStyle get semanticTypographyNumberText16 => TextStyle(
//         fontFamily: textFontFamily,
//         fontSize: 16.0,
//         fontWeight: FontWeight.w500,
//         height: numberTextHeight,
//       );

//   @override
//   TextStyle get semanticTypographyNumber12 => TextStyle(
//         fontFamily: numberFontFamily,
//         fontSize: 12.0,
//         fontWeight: FontWeight.w400,
//         height: 1.25,
//       );

//   @override
//   TextStyle get semanticTypographyNumber20 => TextStyle(
//         fontFamily: numberFontFamily,
//         fontSize: 20.0,
//         fontWeight: FontWeight.w600,
//         height: 1.2,
//       );

//   @override
//   TextStyle get semanticTypographyNumber24 => TextStyle(
//         fontFamily: numberFontFamily,
//         fontSize: 24.0,
//         fontWeight: FontWeight.w600,
//         height: 1.2,
//       );

//   @override
//   TextStyle get semanticTypographyNumber28 => TextStyle(
//         fontFamily: numberFontFamily,
//         fontSize: 28.0,
//         fontWeight: FontWeight.w600,
//         height: 1.2,
//       );

//   @override
//   TextStyle get semanticTypographyNumber32 => TextStyle(
//         fontFamily: numberFontFamily,
//         fontSize: 32.0,
//         fontWeight: FontWeight.w600,
//         height: 1.2,
//       );

//   @override
//   TextStyle get semanticTypographyNumber56 => TextStyle(
//         fontFamily: numberFontFamily,
//         fontSize: 56.0,
//         fontWeight: FontWeight.w600,
//         height: 1.1,
//       );
// }

// class IosChTextStyleTokens extends BaseTextStyleTokens {
//   @override
//   String get textFontFamily => 'PingFang SC';

//   @override
//   String get numberFontFamily => 'SF Pro';

//   @override
//   double get numberTextHeight => 1.7;
// }

// class IosEngTextStyleTokens extends BaseTextStyleTokens {
//   @override
//   String get textFontFamily => 'PingFang SC';

//   @override
//   String get numberFontFamily => 'SF Pro';

//   @override
//   double get title16Height => 1.5;
// }

// class AndroidChTextStyleTokens extends BaseTextStyleTokens {
//   @override
//   String get textFontFamily => '';

//   @override
//   String get numberFontFamily => 'Inter';

//   @override
//   double get numberTextHeight => 1.7;
// }

// class AndroidEngTextStyleTokens extends BaseTextStyleTokens {
//   @override
//   String get textFontFamily => '';

//   @override
//   String get numberFontFamily => 'Inter';
// }

// /// 自适应 TextStyleTokens，根据平台和地区自动选择对应的 tokens
// class AdaptiveTextStyleTokens extends TextStyleTokens {
//   /// 根据平台和地区获取对应的 tokens
//   BaseTextStyleTokens get _platformTokens {
//     // 判断是否为中文地区（中国大陆、台湾、香港、澳门）
//     final locale = PlatformDispatcher.instance.locale;
//     final isChina = locale.languageCode == 'zh' &&
//         (locale.countryCode == 'CN' ||
//             locale.countryCode == 'TW' ||
//             locale.countryCode == 'HK' ||
//             locale.countryCode == 'MO');

//     if (defaultTargetPlatform == TargetPlatform.iOS) {
//       return isChina ? IosChTextStyleTokens() : IosEngTextStyleTokens();
//     } else {
//       return isChina ? AndroidChTextStyleTokens() : AndroidEngTextStyleTokens();
//     }
//   }

//   @override
//   TextStyle get semanticTypographyLabel10 => _platformTokens.semanticTypographyLabel10;

//   @override
//   TextStyle get semanticTypographyLabel12 => _platformTokens.semanticTypographyLabel12;

//   @override
//   TextStyle get semanticTypographyLabel14 => _platformTokens.semanticTypographyLabel14;

//   @override
//   TextStyle get semanticTypographyBody12 => _platformTokens.semanticTypographyBody12;

//   @override
//   TextStyle get semanticTypographyBody14 => _platformTokens.semanticTypographyBody14;

//   @override
//   TextStyle get semanticTypographyBody16 => _platformTokens.semanticTypographyBody16;

//   @override
//   TextStyle get semanticTypographyTitle16 => _platformTokens.semanticTypographyTitle16;

//   @override
//   TextStyle get semanticTypographyTitle18 => _platformTokens.semanticTypographyTitle18;

//   @override
//   TextStyle get semanticTypographyTitle20 => _platformTokens.semanticTypographyTitle20;

//   @override
//   TextStyle get semanticTypographyTitle22 => _platformTokens.semanticTypographyTitle22;

//   @override
//   TextStyle get semanticTypographyDisplay24 => _platformTokens.semanticTypographyDisplay24;

//   @override
//   TextStyle get semanticTypographyDisplay28 => _platformTokens.semanticTypographyDisplay28;

//   @override
//   TextStyle get semanticTypographyNumberText12 => _platformTokens.semanticTypographyNumberText12;

//   @override
//   TextStyle get semanticTypographyNumberText14 => _platformTokens.semanticTypographyNumberText14;

//   @override
//   TextStyle get semanticTypographyNumberText16 => _platformTokens.semanticTypographyNumberText16;

//   @override
//   TextStyle get semanticTypographyNumber12 => _platformTokens.semanticTypographyNumber12;

//   @override
//   TextStyle get semanticTypographyNumber20 => _platformTokens.semanticTypographyNumber20;

//   @override
//   TextStyle get semanticTypographyNumber24 => _platformTokens.semanticTypographyNumber24;

//   @override
//   TextStyle get semanticTypographyNumber28 => _platformTokens.semanticTypographyNumber28;

//   @override
//   TextStyle get semanticTypographyNumber32 => _platformTokens.semanticTypographyNumber32;

//   @override
//   TextStyle get semanticTypographyNumber56 => _platformTokens.semanticTypographyNumber56;
// }
