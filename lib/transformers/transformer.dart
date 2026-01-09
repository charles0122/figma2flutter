import 'package:figma2flutter/models/token.dart';
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
    // Remove comment lines (lines starting with ///)
    final lines = input.split('\n');
    final codeLines = lines.where((line) => !line.trim().startsWith('///')).toList();
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
    if (matcher(token)) {
      final codeLine = '@override\n  $type get ${token.variableName} => ${transform(token)};';
      
      // Add description as comment if available
      if (token.description != null && token.description!.isNotEmpty) {
        final comment = _formatDescription(token.description!);
        lines.add('$comment\n  $codeLine');
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
