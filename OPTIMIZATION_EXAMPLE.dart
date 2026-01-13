/// 优化方案示例：将四个类合并为一个
/// 
/// 方案1: 使用抽象方法获取字体（推荐）
abstract class BaseTextStyleTokens extends TextStyleTokens {
  // 抽象方法：获取文本字体（用于 Label/Body/Title/Display/NumberText）
  String get textFontFamily;
  
  // 抽象方法：获取数字字体（用于 Number 系列）
  String get numberFontFamily;
  
  // 抽象方法：获取 NumberText 系列的行高
  double get numberTextHeight => 1.6;
  
  // 抽象方法：获取 Title16 的行高
  double get title16Height => 1.6;

  @override
  TextStyle get semanticTypographyLabel10 => TextStyle(
        fontFamily: textFontFamily,
        fontSize: 10.0,
        fontWeight: FontWeight.w500,
        height: 1.5,
      );

  @override
  TextStyle get semanticTypographyLabel12 => TextStyle(
        fontFamily: textFontFamily,
        fontSize: 12.0,
        fontWeight: FontWeight.w500,
        height: 1.5,
      );

  @override
  TextStyle get semanticTypographyLabel14 => TextStyle(
        fontFamily: textFontFamily,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        height: 1.6,
      );

  @override
  TextStyle get semanticTypographyBody12 => TextStyle(
        fontFamily: textFontFamily,
        fontSize: 12.0,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  @override
  TextStyle get semanticTypographyBody14 => TextStyle(
        fontFamily: textFontFamily,
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        height: 1.6,
      );

  @override
  TextStyle get semanticTypographyBody16 => TextStyle(
        fontFamily: textFontFamily,
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        height: 1.6,
      );

  @override
  TextStyle get semanticTypographyTitle16 => TextStyle(
        fontFamily: textFontFamily,
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        height: title16Height,
      );

  @override
  TextStyle get semanticTypographyTitle18 => TextStyle(
        fontFamily: textFontFamily,
        fontSize: 18.0,
        fontWeight: FontWeight.w500,
        height: 1.4,
      );

  @override
  TextStyle get semanticTypographyTitle20 => TextStyle(
        fontFamily: textFontFamily,
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
        height: 1.4,
      );

  @override
  TextStyle get semanticTypographyTitle22 => TextStyle(
        fontFamily: textFontFamily,
        fontSize: 22.0,
        fontWeight: FontWeight.w500,
        height: 1.4,
      );

  @override
  TextStyle get semanticTypographyDisplay24 => TextStyle(
        fontFamily: textFontFamily,
        fontSize: 24.0,
        fontWeight: FontWeight.w600,
        height: 1.2,
      );

  @override
  TextStyle get semanticTypographyDisplay28 => TextStyle(
        fontFamily: textFontFamily,
        fontSize: 28.0,
        fontWeight: FontWeight.w600,
        height: 1.2,
      );

  @override
  TextStyle get semanticTypographyNumberText12 => TextStyle(
        fontFamily: textFontFamily,
        fontSize: 12.0,
        fontWeight: FontWeight.w500,
        height: numberTextHeight,
      );

  @override
  TextStyle get semanticTypographyNumberText14 => TextStyle(
        fontFamily: textFontFamily,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        height: numberTextHeight,
      );

  @override
  TextStyle get semanticTypographyNumberText16 => TextStyle(
        fontFamily: textFontFamily,
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        height: numberTextHeight,
      );

  @override
  TextStyle get semanticTypographyNumber12 => TextStyle(
        fontFamily: numberFontFamily,
        fontSize: 12.0,
        fontWeight: FontWeight.w400,
        height: 1.25,
      );

  @override
  TextStyle get semanticTypographyNumber20 => TextStyle(
        fontFamily: numberFontFamily,
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
        height: 1.2,
      );

  @override
  TextStyle get semanticTypographyNumber24 => TextStyle(
        fontFamily: numberFontFamily,
        fontSize: 24.0,
        fontWeight: FontWeight.w600,
        height: 1.2,
      );

  @override
  TextStyle get semanticTypographyNumber28 => TextStyle(
        fontFamily: numberFontFamily,
        fontSize: 28.0,
        fontWeight: FontWeight.w600,
        height: 1.2,
      );

  @override
  TextStyle get semanticTypographyNumber32 => TextStyle(
        fontFamily: numberFontFamily,
        fontSize: 32.0,
        fontWeight: FontWeight.w600,
        height: 1.2,
      );

  @override
  TextStyle get semanticTypographyNumber56 => TextStyle(
        fontFamily: numberFontFamily,
        fontSize: 56.0,
        fontWeight: FontWeight.w600,
        height: 1.1,
      );
}

// 子类只需要实现字体配置
class IosChTextStyleTokens extends BaseTextStyleTokens {
  @override
  String get textFontFamily => 'PingFang SC';
  
  @override
  String get numberFontFamily => 'SF Pro';
  
  @override
  double get numberTextHeight => 1.7;
}

class IosEngTextStyleTokens extends BaseTextStyleTokens {
  @override
  String get textFontFamily => 'Inter';
  
  @override
  String get numberFontFamily => 'SF Pro';
  
  @override
  double get title16Height => 1.5;
}

class AndroidChTextStyleTokens extends BaseTextStyleTokens {
  @override
  String get textFontFamily => 'HarmonyOS Sans SC';
  
  // 注意：AndroidCh 的 Number 系列使用了两种字体
  // 需要特殊处理 Number32 和 Number56
  @override
  String get numberFontFamily => 'Inter'; // 默认用于 Number12/20/24/28
  
  @override
  double get numberTextHeight => 1.7;
  
  // 需要重写 Number32 和 Number56
  @override
  TextStyle get semanticTypographyNumber32 => TextStyle(
        fontFamily: 'SF Pro', // 特殊字体
        fontSize: 32.0,
        fontWeight: FontWeight.w600,
        height: 1.2,
      );

  @override
  TextStyle get semanticTypographyNumber56 => TextStyle(
        fontFamily: 'SF Pro', // 特殊字体
        fontSize: 56.0,
        fontWeight: FontWeight.w600,
        height: 1.1,
      );
}

class AndroidEngTextStyleTokens extends BaseTextStyleTokens {
  @override
  String get textFontFamily => 'SF Pro';
  
  @override
  String get numberFontFamily => 'SF Pro';
}

/// ============================================
/// 方案2: 使用构造函数参数（更简洁）
/// ============================================

class UnifiedTextStyleTokens extends TextStyleTokens {
  final String textFontFamily;
  final String numberFontFamily;
  final double numberTextHeight;
  final double title16Height;
  
  const UnifiedTextStyleTokens({
    required this.textFontFamily,
    required this.numberFontFamily,
    this.numberTextHeight = 1.6,
    this.title16Height = 1.6,
  });

  // 工厂方法创建不同配置的实例
  factory UnifiedTextStyleTokens.iosCh() => const UnifiedTextStyleTokens(
        textFontFamily: 'PingFang SC',
        numberFontFamily: 'SF Pro',
        numberTextHeight: 1.7,
      );

  factory UnifiedTextStyleTokens.iosEng() => const UnifiedTextStyleTokens(
        textFontFamily: 'Inter',
        numberFontFamily: 'SF Pro',
        title16Height: 1.5,
      );

  factory UnifiedTextStyleTokens.androidCh() => const UnifiedTextStyleTokens(
        textFontFamily: 'HarmonyOS Sans SC',
        numberFontFamily: 'Inter',
        numberTextHeight: 1.7,
      );

  factory UnifiedTextStyleTokens.androidEng() => const UnifiedTextStyleTokens(
        textFontFamily: 'SF Pro',
        numberFontFamily: 'SF Pro',
      );

  // 所有 TextStyle getter 的实现（与方案1相同）
  @override
  TextStyle get semanticTypographyLabel10 => TextStyle(
        fontFamily: textFontFamily,
        fontSize: 10.0,
        fontWeight: FontWeight.w500,
        height: 1.5,
      );
  
  // ... 其他 getter 实现 ...
  
  // 注意：AndroidCh 需要特殊处理 Number32 和 Number56
  // 可以通过额外的参数或条件判断来处理
}
