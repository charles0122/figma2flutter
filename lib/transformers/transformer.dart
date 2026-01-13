import 'package:figma2flutter/models/token.dart';
import 'package:figma2flutter/models/token_theme.dart';
import 'package:meta/meta.dart';
import 'package:recase/recase.dart';

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
    final tokenKey = token.path.isEmpty 
        ? token.name 
        : '${token.path}.${token.name}';
    
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

  // Returns the code that will be generated for the property declaration
  String propertyDeclaration(String theme) {
    return '@override\n  $className get $name => ${theme.pascalCase}$className();';
  }

  void process(Token token);

  // Returns the class that is generated for this transformer including all processed tokens
  String classDeclaration(String theme) {
    return '''
class ${theme.pascalCase}$className extends $className {
  ${lines.join('\n  ')}
}
''';
  }

  String _toInterfaceDeclaration(String input) {
    // Remove comment lines (lines starting with ///) and deprecated annotations
    final lines = input.split('\n');
    final codeLines = lines.where((line) {
      final trimmed = line.trim();
      return !trimmed.startsWith('///') && 
             !trimmed.startsWith('@Deprecated') && 
             !trimmed.startsWith('@deprecated');
    }).toList();
    final codeOnly = codeLines.join('\n');
    
    return '${codeOnly.substring(0, codeOnly.indexOf('=>')).replaceAll('@override\n', '').trim()};';
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
      final codeLine = '@override\n  $type get ${token.variableName} => ${transform(token)};';
      
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
