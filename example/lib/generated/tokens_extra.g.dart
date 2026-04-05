/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
/// Figma2Flutter
/// *****************************************************

part of 'tokens.g.dart';

/// 自适应 TextStyleTokens，根据平台和地区自动选择对应的 tokens
class AdaptiveTextStyleTokens implements TextStyleTokens {
  static final AdaptiveTextStyleTokens _instance = AdaptiveTextStyleTokens._();
  factory AdaptiveTextStyleTokens() => _instance;

  AdaptiveTextStyleTokens._();

  final TextStyleTokens _iosChTokens = const IosChTextStyleTokens();
  final TextStyleTokens _iosEngTokens = const IosEngTextStyleTokens();
  final TextStyleTokens _androidChTokens = const AndroidChTextStyleTokens();
  final TextStyleTokens _androidEngTokens = const AndroidEngTextStyleTokens();

  /// 根据平台和地区获取对应的 tokens
  TextStyleTokens get _platformTokens {
    // 判断是否为中文地区（中国大陆、台湾、香港、澳门）
    final locale = PlatformDispatcher.instance.locale;
    final isChina = locale.languageCode == 'zh' &&
        (locale.countryCode == 'CN' ||
            locale.countryCode == 'TW' ||
            locale.countryCode == 'HK' ||
            locale.countryCode == 'MO');

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return isChina ? _iosChTokens : _iosEngTokens;
    } else {
      return isChina ? _androidChTokens : _androidEngTokens;
    }
  }

  @override
  TextStyle get semanticTypographyLabel10 => _platformTokens.semanticTypographyLabel10;
  @override
  TextStyle get semanticTypographyLabel12 => _platformTokens.semanticTypographyLabel12;
  @override
  TextStyle get semanticTypographyLabel14 => _platformTokens.semanticTypographyLabel14;
  @override
  TextStyle get semanticTypographyBody12 => _platformTokens.semanticTypographyBody12;
  @override
  TextStyle get semanticTypographyBody14 => _platformTokens.semanticTypographyBody14;
  @override
  TextStyle get semanticTypographyBody16 => _platformTokens.semanticTypographyBody16;
  @override
  TextStyle get semanticTypographyTitle16 => _platformTokens.semanticTypographyTitle16;
  @override
  TextStyle get semanticTypographyTitle18 => _platformTokens.semanticTypographyTitle18;
  @override
  TextStyle get semanticTypographyTitle20 => _platformTokens.semanticTypographyTitle20;
  @override
  TextStyle get semanticTypographyTitle22 => _platformTokens.semanticTypographyTitle22;
  @override
  TextStyle get semanticTypographyDisplay22 => _platformTokens.semanticTypographyDisplay22;
  @override
  TextStyle get semanticTypographyDisplay24 => _platformTokens.semanticTypographyDisplay24;
  @override
  TextStyle get semanticTypographyDisplay28 => _platformTokens.semanticTypographyDisplay28;
  @override
  TextStyle get semanticTypographyDisplay32 => _platformTokens.semanticTypographyDisplay32;
  @override
  TextStyle get semanticTypographyNumberText12 => _platformTokens.semanticTypographyNumberText12;
  @override
  TextStyle get semanticTypographyNumberText14 => _platformTokens.semanticTypographyNumberText14;
  @override
  TextStyle get semanticTypographyNumberText16 => _platformTokens.semanticTypographyNumberText16;
  @override
  TextStyle get semanticTypographyNumber12 => _platformTokens.semanticTypographyNumber12;
  @override
  TextStyle get semanticTypographyNumber16 => _platformTokens.semanticTypographyNumber16;
  @override
  TextStyle get semanticTypographyNumber18 => _platformTokens.semanticTypographyNumber18;
  @override
  TextStyle get semanticTypographyNumber20 => _platformTokens.semanticTypographyNumber20;
  @override
  TextStyle get semanticTypographyNumber24 => _platformTokens.semanticTypographyNumber24;
  @override
  TextStyle get semanticTypographyNumber28 => _platformTokens.semanticTypographyNumber28;
  @override
  TextStyle get semanticTypographyNumber32 => _platformTokens.semanticTypographyNumber32;
  @override
  TextStyle get semanticTypographyNumber40 => _platformTokens.semanticTypographyNumber40;
  @override
  TextStyle get semanticTypographyNumber60 => _platformTokens.semanticTypographyNumber60;
  @override
  TextStyle get semanticTypographyNumber64 => _platformTokens.semanticTypographyNumber64;
}

class Tokens extends InheritedWidget {
  const Tokens({
    super.key,
    required this.tokens,
    required super.child,
  });

  final ITokens tokens;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return oldWidget is Tokens && oldWidget.tokens != tokens;
  }

  static ITokens of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Tokens>()!.tokens;
  }
}

extension TokensExtension on BuildContext {
  ITokens get tokens => Tokens.of(this);
}
