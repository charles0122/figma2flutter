/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
/// Figma2Flutter
/// *****************************************************

part of 'tokens.g.dart';

/// 与当前工程字体主题一一对应；[AdaptiveTextStyleOverride.tokenSet] 可强制使用其中一套。
enum TextStyleTokenSet {
  /// 主题 `ios_ch` → [IosChTextStyleTokens]
  iosCh,

  /// 主题 `ios_eng` → [IosEngTextStyleTokens]
  iosEng,

  /// 主题 `android_ch` → [AndroidChTextStyleTokens]
  androidCh,

  /// 主题 `android_eng` → [AndroidEngTextStyleTokens]
  androidEng,

  /// 主题 `jp` → [JpTextStyleTokens]
  jp
}

/// 供 [AdaptiveTextStyleOverride.select] 使用的输入；[locale] 为**有效**择套语言（见 [AdaptiveTextStyleOverride.appLocale]），[platform] 为当前平台，其余为各套 [TextStyleTokens]。
class AdaptiveTextStyleInputs {
  const AdaptiveTextStyleInputs({
    required this.locale,
    required this.platform,
    required this.iosCh,
    required this.iosEng,
    required this.androidCh,
    required this.androidEng,
    this.jp,
  });

  /// 用于默认规则与 [select] 的择套：优先来自 [AdaptiveTextStyleOverride.appLocale]（若已设置），否则为系统 [PlatformDispatcher.instance.locale]。
  final Locale locale;
  final TargetPlatform platform;
  final TextStyleTokens iosCh;
  final TextStyleTokens iosEng;
  final TextStyleTokens androidCh;
  final TextStyleTokens androidEng;

  /// 日语字体 tokens；无 jp 主题时为 null。
  final TextStyleTokens? jp;
}

/// 由调用方完全控制使用哪一套 [TextStyleTokens]；为 null 时再看 [AdaptiveTextStyleOverride.tokenSet] 与 [AdaptiveTextStyleTokens.defaultResolve]。
typedef AdaptiveTextStyleSelect = TextStyleTokens Function(AdaptiveTextStyleInputs input);

class AdaptiveTextStyleOverride {
  AdaptiveTextStyleOverride._();

  static AdaptiveTextStyleSelect? select;

  /// 应用内语言。非 null 时，默认择套以该 [Locale] 为准，**不**再使用 [PlatformDispatcher.instance.locale]。
  /// 为 null 时与系统语言一致。应在启动或用户切换语言时赋值；变更后如未改 [select] 的引用，可自增 [resolutionStamp] 或调用 [AdaptiveTextStyleTokens.clearResolutionCache]。
  static Locale? appLocale;

  /// 显式使用 [TextStyleTokenSet] 中的某一套。非 null 时忽略 [defaultResolve] 的按语言/平台规则，直到置回 null。
  /// 优先级：若 [select] 非 null，仍以 [select] 为准。与 [appLocale] 无强制关联（由业务自行用枚举表达策略）。
  static TextStyleTokenSet? tokenSet;

  /// 当 [select] 内依赖的状态与缓存键不同步时，在变更后自增以重算择套（与 [AdaptiveTextStyleTokens.clearResolutionCache] 二选一）。
  static int resolutionStamp = 0;
}

/// 自适应 TextStyleTokens；[locale] 以 [AdaptiveTextStyleOverride.appLocale] 优先，否则为系统 [PlatformDispatcher.instance.locale]；[platform] 为 [defaultTargetPlatform]。
/// 择套优先级：[AdaptiveTextStyleOverride.select] > [AdaptiveTextStyleOverride.tokenSet] > [defaultResolve]。
///
/// 对当前应使用的那一套 [TextStyleTokens] 做实例级缓存，避免在单次布局中多次读样式时重复 [AdaptiveTextStyleInputs] 与解析。
class AdaptiveTextStyleTokens implements TextStyleTokens {
  static final AdaptiveTextStyleTokens _instance = AdaptiveTextStyleTokens._();
  factory AdaptiveTextStyleTokens() => _instance;

  AdaptiveTextStyleTokens._();

  final TextStyleTokens _jpTokens = const JpTextStyleTokens();

  final TextStyleTokens _iosChTokens = const IosChTextStyleTokens();
  final TextStyleTokens _iosEngTokens = const IosEngTextStyleTokens();
  final TextStyleTokens _androidChTokens = const AndroidChTextStyleTokens();
  final TextStyleTokens _androidEngTokens = const AndroidEngTextStyleTokens();

  Locale? _cacheLocale;
  TargetPlatform? _cachePlatform;
  AdaptiveTextStyleSelect? _cacheSelect;
  TextStyleTokenSet? _cacheTokenSet;
  int? _cacheStamp;
  TextStyleTokens? _cacheResolved;

  /// 丢弃择套缓存；例如 [AdaptiveTextStyleOverride.appLocale] 或 [select] / [tokenSet] 已变但想避免自增 [AdaptiveTextStyleOverride.resolutionStamp] 时调用。
  static void clearResolutionCache() {
    final o = _instance;
    o._cacheResolved = null;
    o._cacheLocale = null;
    o._cachePlatform = null;
    o._cacheSelect = null;
    o._cacheTokenSet = null;
    o._cacheStamp = null;
  }

  /// 与生成器内置规则一致：按 [input.locale]（已含 app 优先逻辑）判断日语/中文区，日语 → jp（若有）、中文区 → *Ch、否则 → *Eng；[input.platform] 区分 iOS / Android。
  static TextStyleTokens defaultResolve(AdaptiveTextStyleInputs input) {
    if (input.jp != null && input.locale.languageCode == 'ja') {
      return input.jp!;
    }
    final isChina = input.locale.languageCode == 'zh' &&
        (input.locale.countryCode == 'CN' ||
            input.locale.countryCode == 'TW' ||
            input.locale.countryCode == 'HK' ||
            input.locale.countryCode == 'MO');

    if (input.platform == TargetPlatform.iOS) {
      return isChina ? input.iosCh : input.iosEng;
    } else {
      return isChina ? input.androidCh : input.androidEng;
    }
  }

  /// 按枚举取与单例内 `const` 实现一致的那一套，便于在业务或测试中直接使用。
  TextStyleTokens textStyleForSet(TextStyleTokenSet set) => _textStyleForSet(set);

  TextStyleTokens _textStyleForSet(TextStyleTokenSet set) {
    switch (set) {
      case TextStyleTokenSet.iosCh:
        return _iosChTokens;
      case TextStyleTokenSet.iosEng:
        return _iosEngTokens;
      case TextStyleTokenSet.androidCh:
        return _androidChTokens;
      case TextStyleTokenSet.androidEng:
        return _androidEngTokens;
      case TextStyleTokenSet.jp:
        return _jpTokens;
    }
  }

  TextStyleTokens get _platformTokens {
    final systemLocale = PlatformDispatcher.instance.locale;
    final app = AdaptiveTextStyleOverride.appLocale;
    final effectiveLocale = app ?? systemLocale;
    final platform = defaultTargetPlatform;
    final select = AdaptiveTextStyleOverride.select;
    final explicit = AdaptiveTextStyleOverride.tokenSet;
    final stamp = AdaptiveTextStyleOverride.resolutionStamp;
    final c = _cacheResolved;
    if (c != null &&
        _cacheLocale == effectiveLocale &&
        _cachePlatform == platform &&
        identical(_cacheSelect, select) &&
        _cacheTokenSet == explicit &&
        _cacheStamp == stamp) {
      return c;
    }
    final input = AdaptiveTextStyleInputs(
      locale: effectiveLocale,
      platform: platform,
      iosCh: _iosChTokens,
      iosEng: _iosEngTokens,
      androidCh: _androidChTokens,
      androidEng: _androidEngTokens,
      jp: _jpTokens,
    );
    final TextStyleTokens resolved;
    if (select != null) {
      resolved = select(input);
    } else if (explicit != null) {
      resolved = _textStyleForSet(explicit);
    } else {
      resolved = AdaptiveTextStyleTokens.defaultResolve(input);
    }
    _cacheLocale = effectiveLocale;
    _cachePlatform = platform;
    _cacheSelect = select;
    _cacheTokenSet = explicit;
    _cacheStamp = stamp;
    _cacheResolved = resolved;
    return resolved;
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
