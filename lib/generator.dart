import 'dart:io';

import 'package:figma2flutter/models/token_theme.dart';
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
    
    return '''
$_genWarning

part of 'tokens.g.dart';

${extraContent.join('\n\n')}

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

    return '''
$_genWarning

library tokens;

import 'package:flutter/material.dart';

part 'tokens_extra.g.dart';

${interfaces.join('\n\n')}

${classes.join('\n\n')}''';
  }

  /// Builds interface declarations for all transformers.
  /// Returns a list of interface code strings, with ITokens interface first.
  List<String> _buildInterfaces() {
    final interfaces = <String>[];
    final interFaceNames = <String, String>{};
    
    for (final transformer in themes.first.transformers) {
      interfaces.add(transformer.interfaceDeclaration());
      interFaceNames[transformer.name] = transformer.className;
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
      for (final transformer in theme.transformers) {
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

    for (final entry in sharedClassesMap.entries) {
      final transformerName = entry.key;
      final contentGroups = entry.value;
      
      sharedClassNames[transformerName] = {};
      
      for (final contentEntry in contentGroups.entries) {
        final contentSignature = contentEntry.key;
        final sharedThemes = contentEntry.value;
        
        if (sharedThemes.length > 1) {
          // Multiple themes share the same transformer content
          final firstTheme = sharedThemes.first;
          final transformer = firstTheme.transformers.firstWhere(
            (t) => t.name == transformerName,
          );
          final sharedClassName = 'Shared${transformer.className}';
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
      final properties = <String>[];
      final insertAt = classes.length;
      
      for (final transformer in theme.transformers) {
        final transformerName = transformer.name;
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
      // Group themes by transformer content (lines)
      final contentGroups = <String, List<TokenTheme>>{};
      
      for (final theme in themes) {
        final transformer = theme.transformers.firstWhere(
          (t) => t.name == transformerName,
          orElse: () => throw StateError(
            'Transformer "$transformerName" not found in theme "${theme.name}". '
            'Available transformers: ${theme.transformers.map((t) => t.name).join(", ")}',
          ),
        );
        
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
            
            // Only create shared class if we have at least 2 themes
            if (allSharedThemes.length >= 2) {
              sharedContentGroups[entry.key] = allSharedThemes;
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
