import 'package:figma2flutter/exceptions/resolve_token_exception.dart';
import 'package:figma2flutter/exceptions/theme_configuration_exception.dart';
import 'package:figma2flutter/models/token.dart';
import 'package:figma2flutter/models/token_theme.dart';
import 'package:figma2flutter/utils/group_extension.dart';
import 'package:meta/meta.dart';

const kDefaultThemeName = 'default';

/// A parser that will parse a map of Design tokens and can resolve references
/// to other tokens (e.g. {color.primary})
class TokenParser {
  // Figma supports multiple sets. Sets are used to override tokens in a specific
  // set. This list is used to make sure that the overrides are applied in the
  // correct order.
  final List<String> sets;

  // List of themes, each theme contains a list of sets that are enabled.
  List<TokenTheme> themes;

  /// Creates a new [TokenParser] instance.
  TokenParser([
    this.sets = const [],
    this.themes = const [],
  ]);

  /// Parses the given json map recursively and saves the tokens in the [tokenMap].
  void parse(Map<String, dynamic> input) {
    if (themes.isEmpty) {
      themes = [TokenTheme(kDefaultThemeName, sets)];
    }

    for (final theme in themes) {
      final Map<String, dynamic> tokensForTheme;
      if (theme.sets.isEmpty) {
        tokensForTheme = input;
      } else {
        tokensForTheme = {};
        for (final set in theme.sets) {
          if (input[set] == null) {
            throw (ThemeConfigurationException(
              'No metadata entry named "$set" expected by theme "${theme.name}"',
            ));
          }
          tokensForTheme[set] = input[set] as Map<String, dynamic>;
        }
      }

      final tokens = findTokens('.', tokensForTheme, null, tokensForTheme);
      
      // 在 _postProcess 之前，保存原始 key 到 set 的映射
      // findTokens 返回的 key 格式取决于 tokensForTheme 的结构：
      // - 如果 tokensForTheme 是 { "set": { ... } }，key 格式是 "set.path.name"
      // - 如果 tokensForTheme 是直接的 token 数据，key 格式是 "path.name"
      final keyToSetMap = <String, String>{};
      for (final entry in tokens.entries) {
        final key = entry.key;
        // 找到这个 key 对应的 set（按 sets 顺序，后面的会覆盖前面的）
        // 注意：_postProcess 使用的是全局 sets，但这里我们使用 theme.sets 来建立映射
        for (final set in theme.sets) {
          final setPrefix = '$set.';
          if (key.startsWith(setPrefix)) {
            keyToSetMap[key] = set;
            // 不 break，让后面的 set 覆盖前面的（与 _postProcess 逻辑一致）
          }
        }
      }
      
      // 保存 _postProcess 之前的 tokens 快照，用于后续映射
      final tokensBeforePostProcess = Map<String, Token>.from(tokens);
      
      // 使用全局 sets 进行 _postProcess（与原始逻辑一致）
      _postProcess(tokens);

      // 保存处理后的 key 到原始 set 的映射
      // _postProcess 会移除 set 前缀（使用全局 sets），所以处理后的 key 是 "path.name"
      // 我们需要从处理后的 key 找到原始 key，然后找到对应的 set
      for (final entry in tokens.entries) {
        final processedKey = entry.key;
        
        // 直接从 keyToSetMap 查找（使用原始 key，即 _postProcess 之前的 key）
        // keyToSetMap 中的 key 是 "set.path.name" 格式
        String? matchedSet;
        
        // 反向遍历 theme.sets，找到最后一个匹配的 set（与 _postProcess 逻辑一致）
        // 注意：_postProcess 使用全局 sets，但这里我们使用 theme.sets 来建立映射
        // 因为我们需要知道 token 来自哪个 theme set，而不是全局 set
        for (final set in theme.sets.toList().reversed) {
          final setPrefix = '$set.';
          final originalKey = '$setPrefix$processedKey';
          if (keyToSetMap.containsKey(originalKey)) {
            matchedSet = keyToSetMap[originalKey];
            break;
          }
        }
        
        // 如果通过 keyToSetMap 查找失败，尝试从 tokensBeforePostProcess 查找
        // 这可以处理一些边界情况
        if (matchedSet == null) {
          for (final set in theme.sets.toList().reversed) {
            final setPrefix = '$set.';
            final originalKey = '$setPrefix$processedKey';
            if (tokensBeforePostProcess.containsKey(originalKey)) {
              matchedSet = set;
              break;
            }
          }
        }
        
        if (matchedSet != null) {
          theme.tokenKeyToSet[processedKey] = matchedSet;
        }
      }

      theme.addTokens(tokens);
      // Store original document for JSON Pointer resolution
      theme.setOriginalDocument(tokensForTheme);
    }
  }

  // Loop trough the ordered sets and remove the set name from key an path
  // this will make sure that overrides are properly applied
  void _postProcess(Map<String, Token> tokenMap) {
    for (var element in sets) {
      final set = '$element.';
      final setLength = set.length - 1;

      tokenMap.entries
          .where((element) => element.key.startsWith(set))
          .toList()
          .forEach((entry) {
        final key = entry.key;
        final value = entry.value;

        if (key.startsWith(set)) {
          tokenMap.remove(key);
          // 安全地处理 key 和 path 的 substring 操作
          final newKey = key.length > setLength + 1 
              ? key.substring(setLength + 1) 
              : '';
          final newPath = value.path.length > setLength
              ? value.path.substring(setLength)
              : '';
          tokenMap[newKey] = value.copyWith(
            path: newPath,
          );
        }
      });
    }
  }

  // Recursively find all tokens in the given map
  Map<String, Token> findTokens(
    String parent,
    Map<String, dynamic> input, [
    String? groupType,
    Map<String, dynamic>? rootDocument,
  ]) {
    // Use input as root document if not provided (for backward compatibility)
    final root = rootDocument ?? input;
    final tokens = <String, Token>{};

    // Check for value with $ prefix (W3C DTCG standard) or without prefix
    // Also check for $ref (JSON Pointer reference)
    final hasValue = input.containsKey('\$value') || input.containsKey('value');
    final hasRef = input.containsKey('\$ref') && input['\$ref'] is String;
    
    if (hasValue || hasRef) {
      final token = _createToken(input, parent, groupType);
      final path = token.path;
      final name = token.name;
      
      return {
        [path, name].where((e) => e.isNotEmpty).join('.'): token,
      };
    }

    // Check for group extension ($extends)
    final hasExtends = input.containsKey('\$extends');
    Map<String, dynamic> groupToProcess = input;

    if (hasExtends) {
      final extendsValue = input['\$extends'];
      
      // Detect circular references before resolving
      if (extendsValue is String && 
          extendsValue.startsWith('{') && 
          extendsValue.endsWith('}')) {
        final groupPath = extendsValue.substring(1, extendsValue.length - 1);
        final currentPath = parent.isEmpty ? '' : parent.substring(0, parent.length - 1);
        if (currentPath.isNotEmpty) {
          try {
            GroupExtension.detectCircularReference(
              groupPath,
              root,
              {currentPath},
            );
          } catch (e) {
            if (e is ResolveTokenException) {
              rethrow;
            }
          }
        }
      }
      
      try {
        // Resolve the extension using the root document
        final inheritedGroup = GroupExtension.resolveExtension(
          extendsValue,
          root,
        );
        
        // Deep merge inherited group with local group
        groupToProcess = GroupExtension.deepMerge(inheritedGroup, input);
      } catch (e) {
        if (e is ResolveTokenException) {
          rethrow;
        }
        throw ResolveTokenException(
          'Failed to resolve group extension: $e',
        );
      }
    }

    for (var entry in groupToProcess.entries) {
      final key = entry.key;
      final value = entry.value;

      // Skip $extends as it's already processed
      if (key == '\$extends') {
        continue;
      }

      // Handle $root token (reserved token name)
      if (key == '\$root' && value is Map<String, dynamic>) {
        final hasValue = value.containsKey('\$value') || value.containsKey('value');
        final hasRef = value.containsKey('\$ref') && value['\$ref'] is String;
        
        if (hasValue || hasRef) {
          final rootToken = _createToken(value, parent, groupType, '\$root');
          final path = rootToken.path;
          final tokenKey = path.isEmpty ? '\$root' : '$path.\$root';
          tokens[tokenKey] = rootToken;
        }
        continue;
      }

      if (value is Map<String, dynamic>) {
        // Get group type, preferring $type over type (W3C DTCG standard)
        final groupTypeValue = _getValue(groupToProcess, 'type') as String?;
        tokens.addAll(
          findTokens('$parent$key.', value, groupTypeValue, root),
        );
      }
    }

    return tokens;
  }

  // Helper method to get value with $ prefix preference (W3C DTCG standard)
  // Returns $key if exists, otherwise returns key, or null if neither exists
  dynamic _getValue(Map<String, dynamic> input, String key) {
    if (input.containsKey('\$$key')) {
      return input['\$$key'];
    }
    return input[key];
  }

  /// Parses deprecated value from input map.
  /// Returns empty string if true, the string value if string, null otherwise.
  String? _parseDeprecated(Map<String, dynamic> input) {
    final deprecatedValue = _getValue(input, 'deprecated');
    if (deprecatedValue == true) {
      return '';
    } else if (deprecatedValue is String) {
      return deprecatedValue;
    }
    return null;
  }

  /// Creates a token from input map.
  /// 
  /// [input] - The token input map
  /// [parent] - The parent path (e.g., "group.subgroup.")
  /// [groupType] - The type inherited from parent group
  /// [tokenName] - Optional token name (if null, extracted from parent)
  Token _createToken(
    Map<String, dynamic> input,
    String parent,
    String? groupType, [
    String? tokenName,
  ]) {
    final cleaned = parent.isEmpty ? '' : parent.substring(0, parent.length - 1);
    final name = tokenName ?? cleaned.split('.').last;
    
    // Calculate path
    String path;
    if (tokenName != null) {
      // When tokenName is explicitly provided (e.g., $root), 
      // the path is the cleaned parent (without leading dot)
      path = cleaned.isEmpty ? '' : (cleaned.startsWith('.') ? cleaned.substring(1) : cleaned);
    } else {
      // When tokenName is extracted from parent, remove the name from cleaned
      final end = cleaned.length - name.length - 1;
      path = end > 0 ? cleaned.substring(1, end) : '';
    }
    
    final hasValue = input.containsKey('\$value') || input.containsKey('value');
    final hasRef = input.containsKey('\$ref') && input['\$ref'] is String;
    
    final value = hasRef && !hasValue
        ? {'\$ref': input['\$ref']}
        : (input['\$value'] ?? input['value']);
    
    final type = _getValue(input, 'type') as String? ?? groupType;
    final description = _getValue(input, 'description') as String?;
    final deprecated = _parseDeprecated(input);
    
    return Token(
      value: value,
      type: type,
      path: path,
      name: name,
      extensions: input['\$extensions'] as Map<String, dynamic>?,
      description: description,
      deprecated: deprecated,
    );
  }

  /// Returns a list of all tokens that have been parsed and all references resolved.
  List<Token> resolvedTokens({String themeName = kDefaultThemeName}) =>
      themes.firstWhere((element) => element.name == themeName).resolvedTokens;

  // Fetch a token by key and theme name and resolve all references
  @visibleForTesting
  Token? resolve(String key, [String theme = kDefaultThemeName]) {
    return themes.firstWhere((e) => e.name == theme).resolve(key);
  }
}
