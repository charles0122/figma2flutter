import 'dart:io';

import 'package:figma2flutter/models/token_theme.dart';
import 'package:figma2flutter/transformers/transformer.dart';
import 'package:recase/recase.dart';

const _genWarning = '''
/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
/// Figma2Flutter
/// *****************************************************''';

/// Result of shared class generation.
/// Contains both the class names map and the generated class code.
class _SharedClassResult {
  final Map<String, Map<String, String>> names;
  final List<String> classes;

  /// Transformers that have only a single implementation (can use static const)
  final Set<String> singleImplementationTransformers;

  _SharedClassResult(
      this.names, this.classes, this.singleImplementationTransformers);
}

/// 每个 transformer 的接口并集与默认值回退信息
class _InterfaceUnion {
  final List<String> interfaceStrings;

  /// transformerName -> 按顺序的 getter 并集
  final Map<String, List<GetterEntry>> unionGetters;

  /// transformerName -> (getterName -> 第一个拥有该 getter 的主题名，用于默认值)
  final Map<String, Map<String, String>> fallbackThemePerGetter;

  _InterfaceUnion(
    this.interfaceStrings,
    this.unionGetters,
    this.fallbackThemePerGetter,
  );
}

/// Generates a Dart file with all the tokens.
class Generator {
  /// Creates a new [Generator] instance.
  Generator(this.themes);

  /// The list of transformers to generate code for.
  final List<TokenTheme> themes;

  // Returns the content for tokens_extra.g.dart
  String get extra {
    if (themes.isEmpty) {
      throw StateError('Cannot generate extra without themes');
    }

    final extraContent = _buildExtraContent();
    final adaptiveTextStyleClass = _generateAdaptiveTextStyleClass();

    return '''
$_genWarning

part of 'tokens.g.dart';

${extraContent.join('\n\n')}

${adaptiveTextStyleClass != null ? '\n$adaptiveTextStyleClass' : ''}

$_helpers
''';
  }

  /// Builds extra declaration content from transformers.
  List<String> _buildExtraContent() {
    final extraContent = <String>[];
    for (final transformer in themes.first.transformers) {
      if (transformer.extraDeclaration() != null) {
        extraContent.add(transformer.extraDeclaration()!);
      }
    }
    return extraContent;
  }

  /// Returns the generated token themes code. (tokens.g.dart)
  String get output {
    if (themes.isEmpty) {
      throw StateError('Cannot generate output without themes');
    }

    final sharedClassResult = _generateSharedClasses();
    final interfaceUnion =
        _buildInterfaces(sharedClassResult.singleImplementationTransformers);
    final themeContentMap = _buildThemeContentMap();
    final classes = _generateThemeClasses(
      sharedClassResult.names,
      themeContentMap,
      sharedClassResult.classes,
      interfaceUnion,
      sharedClassResult.singleImplementationTransformers,
    );

    final imports = _buildImports();

    return '''
$_genWarning

library tokens;

$imports

part 'tokens_extra.g.dart';

${interfaceUnion.interfaceStrings.join('\n\n')}

${classes.join('\n\n')}''';
  }

  /// Builds the imports section, including adaptive text style imports if needed.
  String _buildImports() {
    final hasFontThemes = _hasAllFontThemes();
    if (hasFontThemes) {
      return '''import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';''';
    }
    return 'import \'package:flutter/material.dart\';';
  }

  /// Generates AdaptiveTextStyleTokens class if all font themes are present.
  String? _generateAdaptiveTextStyleClass() {
    if (!_hasAllFontThemes()) {
      return null;
    }

    // Find font theme class names (支持带下划线和驼峰命名)
    final iosChTheme = themes.firstWhere(
      (t) =>
          _isFontTheme(t.name) &&
          (t.name.toLowerCase().contains('iosch') ||
              t.name.toLowerCase() == 'ios_ch'),
      orElse: () => throw StateError('IosCh theme not found'),
    );
    final iosEngTheme = themes.firstWhere(
      (t) =>
          _isFontTheme(t.name) &&
          (t.name.toLowerCase().contains('ioseng') ||
              t.name.toLowerCase() == 'ios_eng'),
      orElse: () => throw StateError('IosEng theme not found'),
    );
    final androidChTheme = themes.firstWhere(
      (t) =>
          _isFontTheme(t.name) &&
          (t.name.toLowerCase().contains('androidch') ||
              t.name.toLowerCase() == 'android_ch'),
      orElse: () => throw StateError('AndroidCh theme not found'),
    );
    final androidEngTheme = themes.firstWhere(
      (t) =>
          _isFontTheme(t.name) &&
          (t.name.toLowerCase().contains('androideng') ||
              t.name.toLowerCase() == 'android_eng'),
      orElse: () => throw StateError('AndroidEng theme not found'),
    );

    final iosChClassName = '${iosChTheme.name.pascalCase}TextStyleTokens';
    final iosEngClassName = '${iosEngTheme.name.pascalCase}TextStyleTokens';
    final androidChClassName =
        '${androidChTheme.name.pascalCase}TextStyleTokens';
    final androidEngClassName =
        '${androidEngTheme.name.pascalCase}TextStyleTokens';

    final jpFontThemes = themes
        .where((t) => _isFontTheme(t.name) && t.name.toLowerCase() == 'jp')
        .toList();
    final jpTheme = jpFontThemes.isEmpty ? null : jpFontThemes.first;
    final jpClassName =
        jpTheme != null ? '${jpTheme.name.pascalCase}TextStyleTokens' : null;

    final textStyleTransformer = iosChTheme.transformers.firstWhere(
      (t) => t.name == 'textStyle',
    );

    final textStyleEntries =
        Transformer.parseGetterEntries(textStyleTransformer.lines);

    final getterMethods = textStyleEntries
        .map(
          (e) => '''
  @override
  ${e.type} get ${e.name} => _platformTokens.${e.name};''',
        )
        .join('\n');

    final jpField = jpClassName != null
        ? '  final TextStyleTokens _jpTokens = const $jpClassName();\n\n'
        : '';
    final jpParam = jpClassName != null ? '\n    this.jp,' : '';
    final jpFieldDoc =
        jpClassName != null ? '\n  /// 日语字体 tokens；无 jp 主题时为 null。' : '';
    final jpMember =
        jpClassName != null ? '\n  final TextStyleTokens? jp;' : '';
    final jpArg = jpClassName != null ? '\n      jp: _jpTokens,' : '';
    final defaultResolveJp = jpClassName != null
        ? '''    if (input.jp != null && input.locale.languageCode == 'ja') {
      return input.jp!;
    }
'''
        : '';

    final iosChId = _enumVariantForThemeName(iosChTheme.name);
    final iosEngId = _enumVariantForThemeName(iosEngTheme.name);
    final androidChId = _enumVariantForThemeName(androidChTheme.name);
    final androidEngId = _enumVariantForThemeName(androidEngTheme.name);
    final jpId =
        jpClassName != null ? _enumVariantForThemeName(jpTheme!.name) : null;

    final tokenSetBlock = (jpId == null)
        ? '''
  /// 主题 `${iosChTheme.name}` → [$iosChClassName]
  $iosChId,
  /// 主题 `${iosEngTheme.name}` → [$iosEngClassName]
  $iosEngId,
  /// 主题 `${androidChTheme.name}` → [$androidChClassName]
  $androidChId,
  /// 主题 `${androidEngTheme.name}` → [$androidEngClassName]
  $androidEngId'''
        : '''
  /// 主题 `${iosChTheme.name}` → [$iosChClassName]
  $iosChId,
  /// 主题 `${iosEngTheme.name}` → [$iosEngClassName]
  $iosEngId,
  /// 主题 `${androidChTheme.name}` → [$androidChClassName]
  $androidChId,
  /// 主题 `${androidEngTheme.name}` → [$androidEngClassName]
  $androidEngId,
  /// 主题 `${jpTheme!.name}` → [$jpClassName]
  $jpId''';

    final switchCases = StringBuffer()
      ..writeln('    switch (set) {')
      ..writeln('      case TextStyleTokenSet.$iosChId:')
      ..writeln('        return _iosChTokens;')
      ..writeln('      case TextStyleTokenSet.$iosEngId:')
      ..writeln('        return _iosEngTokens;')
      ..writeln('      case TextStyleTokenSet.$androidChId:')
      ..writeln('        return _androidChTokens;')
      ..writeln('      case TextStyleTokenSet.$androidEngId:')
      ..writeln('        return _androidEngTokens;');
    if (jpId != null) {
      switchCases
        ..writeln('      case TextStyleTokenSet.$jpId:')
        ..writeln('        return _jpTokens;');
    }
    switchCases.writeln('    }');

    return '''
/// 与当前工程字体主题一一对应；[AdaptiveTextStyleOverride.tokenSet] 可强制使用其中一套。
enum TextStyleTokenSet {
$tokenSetBlock
}

/// 供 [AdaptiveTextStyleOverride.select] 使用的输入；[locale] 为**有效**择套语言（见 [AdaptiveTextStyleOverride.appLocale]），[platform] 为当前平台，其余为各套 [TextStyleTokens]。
class AdaptiveTextStyleInputs {
  const AdaptiveTextStyleInputs({
    required this.locale,
    required this.platform,
    required this.iosCh,
    required this.iosEng,
    required this.androidCh,
    required this.androidEng,$jpParam
  });

  /// 用于默认规则与 [select] 的择套：优先来自 [AdaptiveTextStyleOverride.appLocale]（若已设置），否则为系统 [PlatformDispatcher.instance.locale]。
  final Locale locale;
  final TargetPlatform platform;
  final TextStyleTokens iosCh;
  final TextStyleTokens iosEng;
  final TextStyleTokens androidCh;
  final TextStyleTokens androidEng;$jpFieldDoc$jpMember
}

/// 由调用方完全控制使用哪一套 [TextStyleTokens]；为 null 时再看 [AdaptiveTextStyleOverride.tokenSet] 与 [AdaptiveTextStyleTokens.defaultResolve]。
typedef AdaptiveTextStyleSelect = TextStyleTokens Function(
    AdaptiveTextStyleInputs input);

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

$jpField  final TextStyleTokens _iosChTokens = const $iosChClassName();
  final TextStyleTokens _iosEngTokens = const $iosEngClassName();
  final TextStyleTokens _androidChTokens = const $androidChClassName();
  final TextStyleTokens _androidEngTokens = const $androidEngClassName();

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
$defaultResolveJp    final isChina = input.locale.languageCode == 'zh' &&
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
$switchCases
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
      androidEng: _androidEngTokens,$jpArg
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

$getterMethods
}''';
  }

  /// Checks if all font themes (IosCh, IosEng, AndroidCh, AndroidEng) are present.
  bool _hasAllFontThemes() {
    final fontThemeNames = themes
        .where((t) => _isFontTheme(t.name))
        .map((t) => t.name.toLowerCase())
        .toSet();
    // 检查是否包含所有字体主题（支持带下划线和驼峰命名）
    // 移除下划线后检查，以支持 ios_ch 和 iosch 两种格式
    final normalizedNames =
        fontThemeNames.map((name) => name.replaceAll('_', '')).toSet();
    return normalizedNames.contains('iosch') &&
        normalizedNames.contains('ioseng') &&
        normalizedNames.contains('androidch') &&
        normalizedNames.contains('androideng');
  }

  /// 为 token 分组类生成字段：将 transformer 块首的 `///` 与 `@deprecated` / `@Deprecated` 挂到对应 `final` 成员上。
  String _tokenGroupFieldDeclarations({
    required List<GetterEntry> entries,
    required Map<String, String> fallbackThemePerToken,
    required String transformerName,
  }) {
    return entries.map((e) {
      final themeName = fallbackThemePerToken[e.name];
      if (themeName == null) {
        return 'final ${e.type} ${e.name};';
      }
      final ti = themes.indexWhere((t) => t.name == themeName);
      if (ti < 0) {
        return 'final ${e.type} ${e.name};';
      }
      final theme = themes[ti];
      final tri =
          theme.transformers.indexWhere((t) => t.name == transformerName);
      if (tri < 0) {
        return 'final ${e.type} ${e.name};';
      }
      final tr = theme.transformers[tri];
      final block = Transformer.getterNameToLineBlock(tr.lines)[e.name];
      final prefix = Transformer.formatMemberPrefixFromBlock(block);
      return '${prefix}final ${e.type} ${e.name};';
    }).join('\n  ');
  }

  /// Builds interface declarations for all transformers.
  /// Returns a list of interface code strings, with ITokens interface first.
  /// 构建接口声明，接口包含所有主题的 getter 并集；并返回并集与默认值回退信息。
  /// [singleImplementationTransformers] - transformers with only one implementation (use static const)
  _InterfaceUnion _buildInterfaces(
      Set<String> singleImplementationTransformers) {
    final interfaceStrings = <String>[];
    final interFaceNames = <String, String>{};
    final unionGetters = <String, List<GetterEntry>>{};
    final fallbackThemePerGetter = <String, Map<String, String>>{};

    final allTransformerNames = <String>{};
    for (final theme in themes) {
      final isFontTheme = _isFontTheme(theme.name);
      for (final transformer in theme.transformers) {
        if (isFontTheme && transformer.name != 'textStyle') continue;
        if (transformer.name == 'materialColor') continue;
        allTransformerNames.add(transformer.name);
      }
    }

    final referenceTheme = themes.firstWhere(
      (t) => !_isFontTheme(t.name),
      orElse: () => themes.first,
    );

    for (final transformer in referenceTheme.transformers) {
      if (transformer.name == 'materialColor') continue;
      if (!allTransformerNames.contains(transformer.name)) continue;
      final transformerName = transformer.name;

      final seen = <String>{};
      final orderedEntries = <GetterEntry>[];
      final fallbackForTransformer = <String, String>{};

      for (final theme in themes) {
        if (_isFontTheme(theme.name) && transformerName != 'textStyle')
          continue;
        final matching =
            theme.transformers.where((t) => t.name == transformerName);
        if (matching.isEmpty) continue;
        final entries = Transformer.parseGetterEntries(matching.first.lines);
        for (final e in entries) {
          if (seen.add(e.name)) {
            orderedEntries.add(e);
            fallbackForTransformer[e.name] = theme.name;
          }
        }
      }

      unionGetters[transformerName] = orderedEntries;
      fallbackThemePerGetter[transformerName] = fallbackForTransformer;

      final params =
          orderedEntries.map((e) => 'required this.${e.name},').join('\n    ');
      final fields = _tokenGroupFieldDeclarations(
        entries: orderedEntries,
        fallbackThemePerToken: fallbackForTransformer,
        transformerName: transformerName,
      );
      interfaceStrings.add('''
class ${transformer.className} {
  const ${transformer.className}({
    $params
  });

  $fields
}''');
      interFaceNames[transformerName] = transformer.className;
    }

    if (allTransformerNames.contains('textStyle') &&
        !interFaceNames.containsKey('textStyle')) {
      TokenTheme? themeWithTextStyle;
      for (final theme in themes) {
        if (theme.transformers.any((t) => t.name == 'textStyle')) {
          themeWithTextStyle = theme;
          break;
        }
      }
      if (themeWithTextStyle != null) {
        final textStyleTransformer = themeWithTextStyle.transformers.firstWhere(
          (t) => t.name == 'textStyle',
        );
        final entries =
            Transformer.parseGetterEntries(textStyleTransformer.lines);
        unionGetters['textStyle'] = entries;
        fallbackThemePerGetter['textStyle'] = {
          for (final e in entries) e.name: themeWithTextStyle.name,
        };
        final params =
            entries.map((e) => 'required this.${e.name},').join('\n    ');
        final fields = _tokenGroupFieldDeclarations(
          entries: entries,
          fallbackThemePerToken: {
            for (final e in entries) e.name: themeWithTextStyle.name,
          },
          transformerName: 'textStyle',
        );
        interfaceStrings.add('''
class ${textStyleTransformer.className} {
  const ${textStyleTransformer.className}({
    $params
  });

  $fields
}''');
        interFaceNames['textStyle'] = textStyleTransformer.className;
      }
    }

    final iTokenInterface = '''
abstract class ITokens {
  ${interFaceNames.entries.map((e) => '${e.value} get ${e.key};').join('\n  ')}
}''';

    interfaceStrings.insert(0, iTokenInterface);
    return _InterfaceUnion(
        interfaceStrings, unionGetters, fallbackThemePerGetter);
  }

  /// Builds a map of theme -> transformer name -> content signature.
  /// This is used to look up transformer content signatures for each theme.
  Map<TokenTheme, Map<String, String>> _buildThemeContentMap() {
    final themeContentMap = <TokenTheme, Map<String, String>>{};

    for (final theme in themes) {
      themeContentMap[theme] = {};
      final isFontTheme = _isFontTheme(theme.name);
      for (final transformer in theme.transformers) {
        // 字体主题只包含 textStyle transformer
        if (isFontTheme && transformer.name != 'textStyle') {
          continue;
        }
        // 排除 materialColor transformer
        if (transformer.name == 'materialColor') {
          continue;
        }
        final contentSignature = transformer.lines.join('\n');
        themeContentMap[theme]![transformer.name] = contentSignature;
      }
    }

    return themeContentMap;
  }

  /// Generates shared classes for transformers that are shared across multiple themes.
  /// Also detects single-implementation transformers that can use static const.
  /// Returns both the class names map and the generated class code.
  _SharedClassResult _generateSharedClasses() {
    final sharedClassesMap = _detectSharedClasses();
    final sharedClassNames = <String, Map<String, String>>{};
    final classes = <String>[];
    final usedClassNames = <String>{};
    final singleImplementationTransformers = <String>{};

    // Detect single-implementation transformers (only used by one non-font theme)
    _detectSingleImplementationTransformers(singleImplementationTransformers);

    for (final entry in sharedClassesMap.entries) {
      final transformerName = entry.key;
      final contentGroups = entry.value;

      sharedClassNames[transformerName] = {};

      for (final contentEntry in contentGroups.entries) {
        final contentSignature = contentEntry.key;
        final sharedThemes = contentEntry.value;

        if (sharedThemes.length > 1) {
          // Multiple themes share the same transformer content
          // 确保第一个主题不是字体主题（对于非 textStyle transformer）
          final nonFontThemes =
              sharedThemes.where((t) => !_isFontTheme(t.name)).toList();
          if (nonFontThemes.isEmpty && transformerName != 'textStyle') {
            // 如果没有非字体主题，且不是 textStyle，跳过
            continue;
          }

          final firstTheme = nonFontThemes.isNotEmpty
              ? nonFontThemes.first
              : sharedThemes.first;
          final matchingTransformers =
              firstTheme.transformers.where((t) => t.name == transformerName);
          if (matchingTransformers.isEmpty) {
            continue;
          }
          final transformer = matchingTransformers.first;

          // Generate class name - only use the first content signature to avoid duplicates
          // If the class name is already used, skip this content signature
          String sharedClassName = 'Shared${transformer.className}';
          if (usedClassNames.contains(sharedClassName)) {
            // Skip this content signature if class name already exists
            continue;
          }
          usedClassNames.add(sharedClassName);

          sharedClassNames[transformerName]![contentSignature] =
              sharedClassName;

          final superArgs =
              Transformer.superInitializerArgsFromLines(transformer.lines);
          final superCall = superArgs.isEmpty
              ? ''
              : ' : super(\n    ${superArgs.join(',\n    ')}\n  )';
          classes.add('''
class $sharedClassName extends ${transformer.className} {
  const $sharedClassName()$superCall;
}''');
        }
      }
    }

    return _SharedClassResult(
        sharedClassNames, classes, singleImplementationTransformers);
  }

  /// Detects transformers that have only a single non-font theme implementation.
  /// These can use static const instead of class instances.
  void _detectSingleImplementationTransformers(
      Set<String> singleImplementationTransformers) {
    final transformerThemeCount = <String, int>{};
    final transformerNonFontThemeCount = <String, int>{};

    for (final theme in themes) {
      final isFontTheme = _isFontTheme(theme.name);
      for (final transformer in theme.transformers) {
        if (transformer.name == 'materialColor') continue;
        transformerThemeCount[transformer.name] =
            (transformerThemeCount[transformer.name] ?? 0) + 1;
        if (!isFontTheme) {
          transformerNonFontThemeCount[transformer.name] =
              (transformerNonFontThemeCount[transformer.name] ?? 0) + 1;
        }
      }
    }

    // Only use static const if:
    // 1. Has only one non-font theme implementation
    // 2. Not 'color' (too many tokens) or 'textStyle'（通常多字体主题）
    for (final entry in transformerNonFontThemeCount.entries) {
      if (entry.value == 1 &&
          entry.key != 'color' &&
          entry.key != 'materialColor' &&
          entry.key != 'textStyle') {
        singleImplementationTransformers.add(entry.key);
      }
    }
  }

  /// Generates theme-specific classes and theme token classes.
  List<String> _generateThemeClasses(
    Map<String, Map<String, String>> sharedClassNames,
    Map<TokenTheme, Map<String, String>> themeContentMap,
    List<String> sharedClasses,
    _InterfaceUnion interfaceUnion,
    Set<String> singleImplementationTransformers,
  ) {
    final classes = <String>[];

    // Add shared classes first
    classes.addAll(sharedClasses);

    // Generate theme-specific classes and properties
    for (final theme in themes) {
      final isFontTheme = _isFontTheme(theme.name);

      // 字体主题只生成 TextStyleTokens 实现类，不生成 ITokens 类和其他 transformer 类
      if (isFontTheme) {
        // 只处理 textStyle transformer，生成 TextStyleTokens 实现类
        final textStyleTransformers =
            theme.transformers.where((t) => t.name == 'textStyle');
        if (textStyleTransformers.isNotEmpty &&
            themeContentMap[theme]!.containsKey('textStyle')) {
          classes.add(textStyleTransformers.first.classDeclaration(theme.name));
        }
        // 字体主题不生成 ITokens 类和其他 transformer 类，直接跳过
        continue;
      }

      // 非字体主题的处理
      final properties = <String>[];
      final insertAt = classes.length;

      // 所有非字体主题在存在完整字体主题时，使用统一的自适应 textStyle。
      final usesAdaptiveTextStyles = _hasAllFontThemes();
      if (usesAdaptiveTextStyles) {
        // 查找 textStyle transformer（可能来自字体主题或其他主题）
        Transformer? textStyleTransformer;
        for (final t in themes) {
          final textStyleTrans =
              t.transformers.where((tr) => tr.name == 'textStyle');
          if (textStyleTrans.isNotEmpty) {
            textStyleTransformer = textStyleTrans.first;
            break;
          }
        }
        if (textStyleTransformer != null) {
          properties.add(
              '@override\n  ${textStyleTransformer.className} get textStyle => AdaptiveTextStyleTokens();');
        }
      }

      for (final transformer in theme.transformers) {
        final transformerName = transformer.name;

        // 检查 themeContentMap 中是否存在该 transformer（可能被过滤掉了）
        if (!themeContentMap[theme]!.containsKey(transformerName)) {
          continue;
        }

        // 已添加自适应 textStyle getter 时，跳过主题自身的 textStyle transformer。
        if (usesAdaptiveTextStyles && transformerName == 'textStyle') {
          continue;
        }

        final contentSignature = themeContentMap[theme]![transformerName]!;
        final hasSharedClass = sharedClassNames.containsKey(transformerName) &&
            sharedClassNames[transformerName]!.containsKey(contentSignature);

        if (hasSharedClass) {
          // Use shared class
          final sharedClassName =
              sharedClassNames[transformerName]![contentSignature]!;
          properties.add(
              '@override\n  ${transformer.className} get $transformerName => const $sharedClassName();');
        } else if (singleImplementationTransformers.contains(transformerName)) {
          // Single implementation - use static const
          properties.add(transformer.staticConstPropertyDeclaration());
          classes.add(transformer.staticConstClassDeclaration());
        } else {
          // Generate theme-specific class (with default stubs for getters missing in this theme)
          final unionEntries = interfaceUnion.unionGetters[transformerName];
          final fallbackMap =
              interfaceUnion.fallbackThemePerGetter[transformerName];
          final themeGetterCount =
              Transformer.getterNameToLineBlock(transformer.lines).length;
          final isPartialUnion = unionEntries != null &&
              unionEntries.isNotEmpty &&
              fallbackMap != null &&
              unionEntries.length != themeGetterCount;

          properties.add(transformer.propertyDeclaration(theme.name,
              useConst: !isPartialUnion));

          if (unionEntries == null ||
              unionEntries.isEmpty ||
              fallbackMap == null ||
              unionEntries.length == themeGetterCount) {
            classes.add(transformer.classDeclaration(theme.name));
          } else {
            final getterToBlock =
                Transformer.getterNameToLineBlock(transformer.lines);
            final superParts = <String>[];
            final missingTokenNames = <String>[];
            for (final e in unionEntries) {
              if (getterToBlock.containsKey(e.name)) {
                final arg =
                    Transformer.toSuperInitializerArg(getterToBlock[e.name]!);
                if (arg != null) superParts.add(arg);
              } else {
                missingTokenNames.add(e.name);
                final fallbackTheme = fallbackMap[e.name] ?? theme.name;
                final fallbackThemeObject = themes.firstWhere(
                  (candidate) => candidate.name == fallbackTheme,
                  orElse: () => theme,
                );

                // Color values are immutable literals.  Referencing another
                // theme's ColorTokens here constructs that theme while this
                // constructor is still running; if both themes have missing
                // colors, that creates an infinite constructor recursion.
                // Reuse the fallback transformer's already-generated literal
                // instead, so the fallback remains entirely local.
                if (transformerName == 'color') {
                  final fallbackTransformer = fallbackThemeObject.transformers
                      .where((candidate) => candidate.name == transformerName)
                      .firstOrNull;
                  final fallbackBlock = fallbackTransformer == null
                      ? null
                      : Transformer.getterNameToLineBlock(
                          fallbackTransformer.lines)[e.name];
                  final fallbackArg = fallbackBlock == null
                      ? null
                      : Transformer.toSuperInitializerArg(fallbackBlock);
                  if (fallbackArg != null) {
                    superParts.add(fallbackArg);
                    continue;
                  }
                }

                final fallbackSignature =
                    themeContentMap[fallbackThemeObject]?[transformerName];
                final fallbackClassName = fallbackSignature == null
                    ? null
                    : sharedClassNames[transformerName]?[fallbackSignature];
                final className = fallbackClassName ??
                    '${fallbackTheme.pascalCase}${transformer.className}';
                superParts.add('${e.name}: $className().${e.name}');
              }
            }
            if (missingTokenNames.isNotEmpty) {
              stderr.writeln(
                'Warning: 主题 "${theme.name}" 的 ${transformer.className} 中以下 token 未提供，已使用默认主题的值: ${missingTokenNames.join(', ')}',
              );
            }
            final implName = '${theme.name.pascalCase}${transformer.className}';
            classes.add('''
class $implName extends ${transformer.className} {
  $implName() : super(
    ${superParts.join(',\n    ')}
  );
}
''');
          }
        }
      }

      // 生成 ITokens 类
      final tokenClass = '''
class ${theme.name.pascalCase}Tokens extends ITokens {
  ${properties.join('\n  ')}
}''';

      classes.insert(insertAt, tokenClass);
    }

    return classes;
  }

  /// Detects transformers that have identical content across multiple themes.
  /// Only considers themes that have common selectedTokenSets.
  /// Returns a map of transformer name -> content signature -> list of themes.
  Map<String, Map<String, List<TokenTheme>>> _detectSharedClasses() {
    if (themes.isEmpty) return {};

    final sharedMap = <String, Map<String, List<TokenTheme>>>{};
    final transformerNames =
        themes.first.transformers.map((t) => t.name).toSet();

    for (final transformerName in transformerNames) {
      // 禁止生成 SharedColorTokens 和 SharedMaterialColorTokens - 排除 color 和 materialColor transformer 的共享类生成
      if (transformerName == 'color' || transformerName == 'materialColor') {
        continue;
      }

      // Group themes by transformer content (lines)
      final contentGroups = <String, List<TokenTheme>>{};

      for (final theme in themes) {
        // 对于非 textStyle transformer，排除字体主题（它们不应该共享非 textStyle 的 transformer）
        if (transformerName != 'textStyle' && _isFontTheme(theme.name)) {
          continue;
        }

        // 查找 transformer，如果找不到则跳过（字体主题可能没有某些 transformer）
        final matchingTransformers =
            theme.transformers.where((t) => t.name == transformerName);
        if (matchingTransformers.isEmpty) {
          continue;
        }
        final transformer = matchingTransformers.first;

        // Create a content signature from the transformer's lines
        final contentSignature = transformer.lines.join('\n');

        if (!contentGroups.containsKey(contentSignature)) {
          contentGroups[contentSignature] = [];
        }
        contentGroups[contentSignature]!.add(theme);
      }

      // Only include content signatures that are shared by multiple themes
      // AND the themes have at least one common token set
      // Use connected components algorithm to group themes correctly
      final sharedContentGroups = <String, List<TokenTheme>>{};
      for (final entry in contentGroups.entries) {
        if (entry.value.length > 1) {
          // Multiple themes share this content
          // Find connected components: themes that can share (have common sets)
          final sharedGroups = _findConnectedComponents(entry.value);

          // If there's only one connected component, all themes can share
          // If there are multiple components, we need to handle them separately
          // For now, we'll merge all components that have the same content
          // This is safe because they all have identical transformer content
          if (sharedGroups.isNotEmpty) {
            // Merge all groups into one list (they all have the same content anyway)
            final allSharedThemes = <TokenTheme>[];
            for (final group in sharedGroups) {
              allSharedThemes.addAll(group);
            }

            // 对于非 textStyle transformer，排除字体主题（它们不应该共享非 textStyle 的 transformer）
            if (transformerName != 'textStyle') {
              final nonFontThemes =
                  allSharedThemes.where((t) => !_isFontTheme(t.name)).toList();
              if (nonFontThemes.length >= 2) {
                sharedContentGroups[entry.key] = nonFontThemes;
              }
            } else {
              // Only create shared class if we have at least 2 themes
              if (allSharedThemes.length >= 2) {
                sharedContentGroups[entry.key] = allSharedThemes;
              }
            }
          }
        }
      }

      if (sharedContentGroups.isNotEmpty) {
        sharedMap[transformerName] = sharedContentGroups;
      }
    }

    return sharedMap;
  }

  /// 将主题名（如 `ios_ch`、`jp`）转为合法 Dart 枚举值标识符。
  String _enumVariantForThemeName(String themeName) {
    final id = themeName.replaceAll('-', '_').camelCase;
    if (id.isEmpty) {
      return 'fontTheme';
    }
    if (RegExp(r'^[0-9]').hasMatch(id)) {
      return 'n$id';
    }
    return id;
  }

  /// Checks if a theme is a font theme (only contains textStyle transformer).
  /// Font themes are: ios_ch, ios_eng, android_ch, android_eng, jp (or camelCase)
  bool _isFontTheme(String themeName) {
    final lowerName = themeName.toLowerCase();
    // 支持带下划线的名称 (ios_ch, ios_eng, android_ch, android_eng, jp)
    // 也支持驼峰命名 (IosCh, IosEng, AndroidCh, AndroidEng, Jp)
    return lowerName == 'ios_ch' ||
        lowerName == 'ios_eng' ||
        lowerName == 'android_ch' ||
        lowerName == 'android_eng' ||
        lowerName == 'jp' ||
        lowerName.contains('iosch') ||
        lowerName.contains('ioseng') ||
        lowerName.contains('androidch') ||
        lowerName.contains('androideng');
  }

  /// Checks if two themes have at least one common token set.
  bool _hasCommonTokenSets(TokenTheme theme1, TokenTheme theme2) {
    final sets1 = theme1.sets.toSet();
    final sets2 = theme2.sets.toSet();
    return sets1.intersection(sets2).isNotEmpty;
  }

  /// Finds connected components of themes that share common token sets.
  /// Uses a simple union-find approach to group themes that can share classes.
  /// Returns a list of groups, where each group contains themes that can share.
  List<List<TokenTheme>> _findConnectedComponents(List<TokenTheme> themes) {
    if (themes.length <= 1) return [];

    final groups = <List<TokenTheme>>[];
    final processed = <TokenTheme>{};

    for (final theme in themes) {
      if (processed.contains(theme)) continue;

      // Start a new group with this theme
      final group = <TokenTheme>[theme];
      processed.add(theme);

      // Find all themes that can share with any theme in this group
      // (i.e., have at least one common token set)
      bool foundNew;
      do {
        foundNew = false;
        for (final otherTheme in themes) {
          if (processed.contains(otherTheme)) continue;

          // Check if otherTheme shares common sets with any theme in current group
          for (final groupTheme in group) {
            if (_hasCommonTokenSets(otherTheme, groupTheme)) {
              group.add(otherTheme);
              processed.add(otherTheme);
              foundNew = true;
              break;
            }
          }
        }
      } while (foundNew);

      // Only add groups with at least 2 themes
      if (group.length >= 2) {
        groups.add(group);
      }
    }

    return groups;
  }

  /// Saves the generated code to the given [outputDirectory].
  void save(String outputDirectory) {
    final dir = Directory(outputDirectory)..createSync(recursive: true);

    _save(output, to: '${dir.path}/tokens.g.dart');
    _save(extra, to: '${dir.path}/tokens_extra.g.dart');
  }

  void _save(String content, {required String to}) {
    final file = File(to);
    if (file.existsSync()) {
      file.deleteSync();
    }
    file.writeAsStringSync(content);
  }
}

final _helpers = '''
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
''';
