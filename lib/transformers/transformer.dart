import 'package:figma2flutter/models/token.dart';
import 'package:figma2flutter/models/token_theme.dart';
import 'package:meta/meta.dart';
import 'package:recase/recase.dart';

/// 表示从 transformer line 解析出的 getter 类型与名称，用于并集接口与默认值生成。
class GetterEntry {
  final String type;
  final String name;
  GetterEntry(this.type, this.name);
}

/// A transformer is responsible for transforming a token into code
/// that can be used in the generated code.
abstract class Transformer {
  // The lines of code that will be generated for this transformer
  final lines = <String>[];

  // The name of the property that will be generated in the Tokens class
  String get name;

  // The name of the class that will be generated
  String get className => '${name.pascalCase}Tokens';

  /// Current theme being processed (用于判断 token 是否来自 source set)
  TokenTheme? _currentTheme;

  /// 设置当前处理的 theme
  void setTheme(TokenTheme theme) {
    _currentTheme = theme;
  }

  /// 检查 token 是否来自 source set（标记为 source，只用于被引用，不需要生成代码）
  @protected
  bool _isSourceToken(Token token) {
    if (_currentTheme == null || _currentTheme!.sourceSets.isEmpty) {
      return false;
    }

    // 构建 token 的处理后的 key（_postProcess 之后的格式）
    // 注意：token.path 在 _postProcess 后已经移除了 set 前缀
    // tokenKeyToSet 中的 key 也是 _postProcess 后的格式，即 "path.name"
    final tokenKey =
        token.path.isEmpty ? token.name : '${token.path}.${token.name}';

    // 通过映射查找这个 token 来自哪个 set
    final sourceSet = _currentTheme!.tokenKeyToSet[tokenKey];
    if (sourceSet != null && _currentTheme!.sourceSets.contains(sourceSet)) {
      return true;
    }

    return false;
  }

  // Returns true if the token should be processed by this transformer
  @protected
  bool matcher(Token token);

  String interfaceDeclaration() {
    return '''abstract class $className {
  ${lines.map(_toInterfaceDeclaration).join('\n  ')}
}''';
  }

  String _toInterfaceDeclaration(String input) {
    final idx = input.indexOf('=');
    if (idx < 0) return input;
    final beforeEqual = input.substring(0, idx).trim();
    final parts = beforeEqual.split(RegExp(r'\s+'));
    if (parts.length >= 3 && parts[0] == 'static' && parts[1] == 'const') {
      parts.removeRange(0, 2);
    }
    return '${parts.join(' ')} get ${parts.last};';
  }

  // Returns the code that will be generated for the property declaration
  String propertyDeclaration(String theme, {bool useConst = true}) {
    final prefix = useConst ? 'const ' : '';
    return '@override\n  $className get $name => ${prefix}${theme.pascalCase}$className();';
  }

  // Returns static const property declaration for single implementation transformers
  String staticConstPropertyDeclaration() {
    return '@override\n  $className get $name => const Default$className();';
  }

  /// 提取块首的 `///` 文档与 `@` 注解（至 ` static const` / ` final` 赋值行之前），
  /// 每行已带类成员缩进（两个空格）。无内容时返回空字符串。
  static String formatMemberPrefixFromBlock(String? block) {
    if (block == null || block.isEmpty) return '';
    final out = <String>[];
    for (final raw in block.split('\n')) {
      final trimmed = raw.trim();
      if (trimmed.isEmpty) continue;
      if (trimmed.startsWith('///') || trimmed.startsWith('@')) {
        out.add('  $trimmed');
        continue;
      }
      break;
    }
    if (out.isEmpty) return '';
    return '${out.join('\n')}\n';
  }

  /// 从一条 token 代码块解析出 `super(...)` 中的 `name: value`。
  static String? toSuperInitializerArg(String block) {
    final parsed = parseGetterFromLineBlock(block);
    if (parsed == null) return null;
    final idx = _declarationEqualsIndex(block) ?? block.indexOf('=');
    if (idx < 0) return null;
    var rhs = block.substring(idx + 1).trim();
    final semi = rhs.lastIndexOf(';');
    if (semi >= 0) {
      rhs = rhs.substring(0, semi).trim();
    }
    return '${parsed.name}: $rhs';
  }

  static List<String> superInitializerArgsFromLines(List<String> lines) {
    final out = <String>[];
    for (final line in lines) {
      final arg = toSuperInitializerArg(line);
      if (arg != null) out.add(arg);
    }
    return out;
  }

  // Returns the class declaration for static const implementation
  String staticConstClassDeclaration() {
    final superArgs = superInitializerArgsFromLines(lines);
    final superCall = superArgs.isEmpty
        ? ''
        : ' : super(\n    ${superArgs.join(',\n    ')}\n  )';
    return '''
class Default$className extends $className {
  const Default$className()$superCall;
}
''';
  }

  void process(Token token);

  // Returns the class that is generated for this transformer including all processed tokens
  String classDeclaration(String theme) {
    final superArgs = superInitializerArgsFromLines(lines);
    final superCall = superArgs.isEmpty
        ? ''
        : ' : super(\n    ${superArgs.join(',\n    ')}\n  )';
    return '''
class ${theme.pascalCase}$className extends $className {
  const ${theme.pascalCase}$className()$superCall;
}
''';
  }

  static GetterEntry? _getterEntryFromBeforeEqual(String beforeEqual) {
    final parts = beforeEqual.split(RegExp(r'\s+'));
    if (parts.length >= 3 && parts[0] == 'static' && parts[1] == 'const') {
      final type = parts.sublist(2, parts.length - 1).join(' ');
      final name = parts.last;
      if (type.isEmpty || name.isEmpty) return null;
      return GetterEntry(type, name);
    }
    if (parts.length >= 2 && parts[0] == 'final') {
      final type = parts.sublist(1, parts.length - 1).join(' ');
      final name = parts.last;
      if (type.isEmpty || name.isEmpty) return null;
      return GetterEntry(type, name);
    }
    if (parts.length < 2) return null;
    final type = parts.sublist(0, parts.length - 1).join(' ');
    final name = parts.last;
    if (type.isEmpty || name.isEmpty) return null;
    return GetterEntry(type, name);
  }

  /// 查找含 `static const` / `final` 声明的赋值行的第一个 `=` 在 [block] 内的下标。
  static int? _declarationEqualsIndex(String block) {
    var offset = 0;
    for (final raw in block.split('\n')) {
      final line = raw.trim();
      final skipOnlyAnnotation = line.startsWith('@') && !line.contains('=');
      if (line.isEmpty || line.startsWith('///') || skipOnlyAnnotation) {
        offset += raw.length + 1;
        continue;
      }
      if (!line.contains('=')) {
        offset += raw.length + 1;
        continue;
      }
      final localEq = raw.indexOf('=');
      final beforeEqual = raw.substring(0, localEq).trim();
      final parts = beforeEqual.split(RegExp(r'\s+'));
      final isDecl = (parts.length >= 3 &&
              parts[0] == 'static' &&
              parts[1] == 'const') ||
          (parts.length >= 2 && parts[0] == 'final');
      if (isDecl) {
        return offset + localEq;
      }
      offset += raw.length + 1;
    }
    return null;
  }

  /// 从单条 line 块（可能含注释/注解）解析出 getter 的返回类型和名称，用于并集接口与默认值生成。
  /// 返回 null 表示无法解析（例如没有 = 的块）。
  static GetterEntry? parseGetterFromLineBlock(String lineBlock) {
    for (final raw in lineBlock.split('\n')) {
      final line = raw.trim();
      final skipOnlyAnnotation = line.startsWith('@') && !line.contains('=');
      if (line.isEmpty || line.startsWith('///') || skipOnlyAnnotation) {
        continue;
      }
      if (!line.contains('=')) continue;
      final beforeEqual = line.substring(0, line.indexOf('=')).trim();
      final parsed = _getterEntryFromBeforeEqual(beforeEqual);
      if (parsed != null) return parsed;
    }
    final idx = lineBlock.indexOf('=');
    if (idx < 0) return null;
    return _getterEntryFromBeforeEqual(lineBlock.substring(0, idx).trim());
  }

  /// 从 transformer 的 lines 列表中按顺序解析出所有 getter 的 GetterEntry。
  static List<GetterEntry> parseGetterEntries(List<String> lines) {
    final entries = <GetterEntry>[];
    for (final block in lines) {
      final parsed = parseGetterFromLineBlock(block);
      if (parsed != null) {
        entries.add(parsed);
      }
    }
    return entries;
  }

  /// 从 transformer 的 lines 列表中解析出 getter 名称到其完整 line 块的映射。
  static Map<String, String> getterNameToLineBlock(List<String> lines) {
    final map = <String, String>{};
    for (final block in lines) {
      final parsed = parseGetterFromLineBlock(block);
      if (parsed != null) {
        map[parsed.name] = block;
      }
    }
    return map;
  }

  String? extraDeclaration() => null;
}

abstract class SingleTokenTransformer extends Transformer {
  // Returns the code that will be generated for the token
  @protected
  String transform(Token token);

  // The type of the properties that will be generated
  String get type;

  // Processes the token and adds the generated code to the lines list
  @override
  void process(Token token) {
    // 跳过来自 source set 的 token（标记为 source，只用于被引用，不需要生成代码）
    if (_isSourceToken(token)) {
      return;
    }

    if (matcher(token)) {
      final codeLine =
          'static const $type ${token.variableName} = ${transform(token)};';

      final parts = <String>[];

      // Add deprecated annotation if available
      if (token.isDeprecated) {
        if (token.deprecated?.isNotEmpty == true) {
          // Use @Deprecated with message when message is provided
          parts.add("@Deprecated('${token.deprecated}')");
        } else {
          // Use @deprecated without message when deprecated is true
          parts.add('@deprecated');
        }
      }

      // Add description as comment if available
      if (token.description != null && token.description!.isNotEmpty) {
        parts.add(_formatDescription(token.description!));
      }

      // Combine all parts with the code line
      if (parts.isNotEmpty) {
        lines.add('${parts.join('\n  ')}\n  $codeLine');
      } else {
        lines.add(codeLine);
      }
    }
  }

  // Formats the description as a Dart documentation comment
  String _formatDescription(String description) {
    // Split description into lines and format each line as a comment
    final lines = description.split('\n');
    if (lines.length == 1) {
      return '/// ${lines[0]}';
    } else {
      return lines.map((line) => '/// $line').join('\n  ');
    }
  }
}

abstract class MultiTokenTransformer extends Transformer {
  final List<Token> token;

  MultiTokenTransformer(this.token);

  void postProcess();
}
