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

  _SharedClassResult(this.names, this.classes);
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
    
    final interfaces = _buildInterfaces();
    final themeContentMap = _buildThemeContentMap();
    final sharedClassResult = _generateSharedClasses();
    final classes = _generateThemeClasses(
      sharedClassResult.names,
      themeContentMap,
      sharedClassResult.classes,
    );

    final imports = _buildImports();
    
    return '''
$_genWarning

library tokens;

$imports

part 'tokens_extra.g.dart';

${interfaces.join('\n\n')}

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
      (t) => _isFontTheme(t.name) && (t.name.toLowerCase().contains('iosch') || t.name.toLowerCase() == 'ios_ch'),
      orElse: () => throw StateError('IosCh theme not found'),
    );
    final iosEngTheme = themes.firstWhere(
      (t) => _isFontTheme(t.name) && (t.name.toLowerCase().contains('ioseng') || t.name.toLowerCase() == 'ios_eng'),
      orElse: () => throw StateError('IosEng theme not found'),
    );
    final androidChTheme = themes.firstWhere(
      (t) => _isFontTheme(t.name) && (t.name.toLowerCase().contains('androidch') || t.name.toLowerCase() == 'android_ch'),
      orElse: () => throw StateError('AndroidCh theme not found'),
    );
    final androidEngTheme = themes.firstWhere(
      (t) => _isFontTheme(t.name) && (t.name.toLowerCase().contains('androideng') || t.name.toLowerCase() == 'android_eng'),
      orElse: () => throw StateError('AndroidEng theme not found'),
    );
    
    final iosChClassName = '${iosChTheme.name.pascalCase}TextStyleTokens';
    final iosEngClassName = '${iosEngTheme.name.pascalCase}TextStyleTokens';
    final androidChClassName = '${androidChTheme.name.pascalCase}TextStyleTokens';
    final androidEngClassName = '${androidEngTheme.name.pascalCase}TextStyleTokens';
    
    // Get all TextStyle getters from the transformer lines
    final textStyleTransformer = iosChTheme.transformers.firstWhere(
      (t) => t.name == 'textStyle',
    );
    
    // Generate getter methods for all TextStyle properties
    // Extract getter names from lines (format: "@override\n  TextStyle get tokenName => ...;")
    final getters = <String>[];
    for (final line in textStyleTransformer.lines) {
      final trimmed = line.trim();
      // Match patterns like: "TextStyle get tokenName =>" or "@override\n  TextStyle get tokenName =>"
      if (trimmed.contains('TextStyle get ')) {
        final match = RegExp(r'TextStyle get (\w+)').firstMatch(trimmed);
        if (match != null) {
          final getterName = match.group(1)!;
          if (!getters.contains(getterName)) {
            getters.add(getterName);
          }
        }
      }
    }
    
    final getterMethods = getters.map((getter) => '''
  @override
  TextStyle get $getter => _platformTokens.$getter;''').join('\n');
    
    return '''
/// 自适应 TextStyleTokens，根据平台和地区自动选择对应的 tokens
class AdaptiveTextStyleTokens extends TextStyleTokens {
  final TextStyleTokens _iosChTokens = $iosChClassName();
  final TextStyleTokens _iosEngTokens = $iosEngClassName();
  final TextStyleTokens _androidChTokens = $androidChClassName();
  final TextStyleTokens _androidEngTokens = $androidEngClassName();

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

$getterMethods
}''';
  }
  
  /// Checks if all font themes (IosCh, IosEng, AndroidCh, AndroidEng) are present.
  bool _hasAllFontThemes() {
    final fontThemeNames = themes.where((t) => _isFontTheme(t.name)).map((t) => t.name.toLowerCase()).toSet();
    // 检查是否包含所有字体主题（支持带下划线和驼峰命名）
    // 移除下划线后检查，以支持 ios_ch 和 iosch 两种格式
    final normalizedNames = fontThemeNames.map((name) => name.replaceAll('_', '')).toSet();
    return normalizedNames.contains('iosch') &&
        normalizedNames.contains('ioseng') &&
        normalizedNames.contains('androidch') &&
        normalizedNames.contains('androideng');
  }

  /// Builds interface declarations for all transformers.
  /// Returns a list of interface code strings, with ITokens interface first.
  List<String> _buildInterfaces() {
    final interfaces = <String>[];
    final interFaceNames = <String, String>{};
    
    // 收集所有主题使用的 transformer（排除字体主题的非 textStyle transformer，排除 materialColor）
    final allTransformerNames = <String>{};
    for (final theme in themes) {
      final isFontTheme = _isFontTheme(theme.name);
      for (final transformer in theme.transformers) {
        if (isFontTheme && transformer.name != 'textStyle') {
          continue;
        }
        // 排除 materialColor transformer
        if (transformer.name == 'materialColor') {
          continue;
        }
        allTransformerNames.add(transformer.name);
      }
    }
    
    // 使用第一个非字体主题来获取 transformer 实例（用于生成接口）
    final referenceTheme = themes.firstWhere(
      (t) => !_isFontTheme(t.name),
      orElse: () => themes.first,
    );
    
    for (final transformer in referenceTheme.transformers) {
      // 排除 materialColor transformer
      if (transformer.name == 'materialColor') {
        continue;
      }
      if (allTransformerNames.contains(transformer.name)) {
        interfaces.add(transformer.interfaceDeclaration());
        interFaceNames[transformer.name] = transformer.className;
      }
    }
    
    // 如果 textStyle 不在 referenceTheme 中，需要从字体主题中获取
    if (allTransformerNames.contains('textStyle') && !interFaceNames.containsKey('textStyle')) {
      // 查找有 textStyle transformer 的主题
      TokenTheme? themeWithTextStyle;
      for (final theme in themes) {
        final hasTextStyle = theme.transformers.any((t) => t.name == 'textStyle');
        if (hasTextStyle) {
          themeWithTextStyle = theme;
          break;
        }
      }
      
      if (themeWithTextStyle != null) {
        final textStyleTransformer = themeWithTextStyle.transformers.firstWhere(
          (t) => t.name == 'textStyle',
        );
        interfaces.add(textStyleTransformer.interfaceDeclaration());
        interFaceNames['textStyle'] = textStyleTransformer.className;
      }
    }

    final iTokenInterface = '''
abstract class ITokens {
  ${interFaceNames.entries.map((e) => '${e.value} get ${e.key};').join('\n  ')}
}''';

    interfaces.insert(0, iTokenInterface);
    return interfaces;
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
  /// Returns both the class names map and the generated class code.
  _SharedClassResult _generateSharedClasses() {
    final sharedClassesMap = _detectSharedClasses();
    final sharedClassNames = <String, Map<String, String>>{};
    final classes = <String>[];
    final usedClassNames = <String>{};

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
          final nonFontThemes = sharedThemes.where((t) => !_isFontTheme(t.name)).toList();
          if (nonFontThemes.isEmpty && transformerName != 'textStyle') {
            // 如果没有非字体主题，且不是 textStyle，跳过
            continue;
          }
          
          final firstTheme = nonFontThemes.isNotEmpty ? nonFontThemes.first : sharedThemes.first;
          final matchingTransformers = firstTheme.transformers.where((t) => t.name == transformerName);
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
          
          sharedClassNames[transformerName]![contentSignature] = sharedClassName;
          
          // Generate shared class (only once per content signature)
          classes.add('''
class $sharedClassName extends ${transformer.className} {
  ${transformer.lines.join('\n  ')}
}''');
        }
      }
    }
    
    return _SharedClassResult(sharedClassNames, classes);
  }

  /// Generates theme-specific classes and theme token classes.
  /// Returns a list of class code strings.
  List<String> _generateThemeClasses(
    Map<String, Map<String, String>> sharedClassNames,
    Map<TokenTheme, Map<String, String>> themeContentMap,
    List<String> sharedClasses,
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
        final textStyleTransformers = theme.transformers.where((t) => t.name == 'textStyle');
        if (textStyleTransformers.isNotEmpty && themeContentMap[theme]!.containsKey('textStyle')) {
          classes.add(textStyleTransformers.first.classDeclaration(theme.name));
        }
        // 字体主题不生成 ITokens 类和其他 transformer 类，直接跳过
        continue;
      }
      
      // 非字体主题的处理
      final properties = <String>[];
      final insertAt = classes.length;
      
      // 对于 Light 和 Dark 主题，如果存在所有字体主题，添加 textStyle getter（使用 AdaptiveTextStyleTokens）
      final isLightOrDark = theme.name.toLowerCase() == 'light' || theme.name.toLowerCase() == 'dark';
      if (isLightOrDark && _hasAllFontThemes()) {
        // 查找 textStyle transformer（可能来自字体主题或其他主题）
        Transformer? textStyleTransformer;
        for (final t in themes) {
          final textStyleTrans = t.transformers.where((tr) => tr.name == 'textStyle');
          if (textStyleTrans.isNotEmpty) {
            textStyleTransformer = textStyleTrans.first;
            break;
          }
        }
        if (textStyleTransformer != null) {
          properties.add('@override\n  ${textStyleTransformer.className} get textStyle => AdaptiveTextStyleTokens();');
        }
      }
      
      for (final transformer in theme.transformers) {
        final transformerName = transformer.name;
        
        // 检查 themeContentMap 中是否存在该 transformer（可能被过滤掉了）
        if (!themeContentMap[theme]!.containsKey(transformerName)) {
          continue;
        }
        
        // 对于 Light 和 Dark 主题，如果已经添加了 textStyle getter（使用 AdaptiveTextStyleTokens），跳过
        if (isLightOrDark && transformerName == 'textStyle' && _hasAllFontThemes()) {
          continue;
        }
        
        final contentSignature = themeContentMap[theme]![transformerName]!;
        final hasSharedClass = sharedClassNames.containsKey(transformerName) &&
            sharedClassNames[transformerName]!.containsKey(contentSignature);
        
        if (hasSharedClass) {
          // Use shared class
          final sharedClassName = sharedClassNames[transformerName]![contentSignature]!;
          properties.add('@override\n  ${transformer.className} get $transformerName => $sharedClassName();');
        } else {
          // Generate theme-specific class
          properties.add(transformer.propertyDeclaration(theme.name));
          classes.add(transformer.classDeclaration(theme.name));
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
    final transformerNames = themes.first.transformers.map((t) => t.name).toSet();
    
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
        final matchingTransformers = theme.transformers.where((t) => t.name == transformerName);
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
              final nonFontThemes = allSharedThemes.where((t) => !_isFontTheme(t.name)).toList();
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

  /// Checks if a theme is a font theme (only contains textStyle transformer).
  /// Font themes are: ios_ch, ios_eng, android_ch, android_eng (or IosCh, IosEng, AndroidCh, AndroidEng)
  bool _isFontTheme(String themeName) {
    final lowerName = themeName.toLowerCase();
    // 支持带下划线的名称 (ios_ch, ios_eng, android_ch, android_eng)
    // 也支持驼峰命名 (IosCh, IosEng, AndroidCh, AndroidEng)
    return lowerName == 'ios_ch' ||
        lowerName == 'ios_eng' ||
        lowerName == 'android_ch' ||
        lowerName == 'android_eng' ||
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
