import 'dart:convert';

import 'package:figma2flutter/token_parser.dart';
import 'package:figma2flutter/transformers/color_transformer.dart';
import 'package:test/test.dart';

void main() {
  group('Deprecated token support', () {
    test('should parse token with $deprecated as true', () {
      final input = '''
      {
        "Button background": {
          "\$value": {
            "colorSpace": "srgb",
            "components": [0.467, 0.467, 0.467],
            "hex": "#777777"
          },
          "\$type": "color",
          "\$deprecated": true
        }
      }''';

      final parsed = json.decode(input) as Map<String, dynamic>;
      final parser = TokenParser();
      parser.parse(parsed);

      final token = parser.themes.first.tokens['Button background'];
      expect(token, isNotNull);
      expect(token?.isDeprecated, isTrue);
      expect(token?.deprecated, equals(''));
    });

    test('should parse token with $deprecated as string message', () {
      final input = '''
      {
        "Button focus": {
          "\$value": {
            "colorSpace": "srgb",
            "components": [0.44, 0.753, 1],
            "hex": "#70c0ff"
          },
          "\$type": "color",
          "\$deprecated": "Please use the border style for active buttons instead."
        }
      }''';

      final parsed = json.decode(input) as Map<String, dynamic>;
      final parser = TokenParser();
      parser.parse(parsed);

      final token = parser.themes.first.tokens['Button focus'];
      expect(token, isNotNull);
      expect(token?.isDeprecated, isTrue);
      expect(token?.deprecated,
          equals('Please use the border style for active buttons instead.'));
    });

    test('should parse token without deprecated field', () {
      final input = '''
      {
        "Button normal": {
          "\$value": {
            "colorSpace": "srgb",
            "components": [0.5, 0.5, 0.5],
            "hex": "#808080"
          },
          "\$type": "color"
        }
      }''';

      final parsed = json.decode(input) as Map<String, dynamic>;
      final parser = TokenParser();
      parser.parse(parsed);

      final token = parser.themes.first.tokens['Button normal'];
      expect(token, isNotNull);
      expect(token?.isDeprecated, isFalse);
      expect(token?.deprecated, isNull);
    });

    test('should prefer $deprecated over deprecated when both exist', () {
      final input = '''
      {
        "token": {
          "value": "#111111",
          "type": "color",
          "deprecated": true,
          "\$deprecated": "Use new token instead"
        }
      }''';

      final parsed = json.decode(input) as Map<String, dynamic>;
      final parser = TokenParser();
      parser.parse(parsed);

      final token = parser.themes.first.tokens['token'];
      expect(token?.isDeprecated, isTrue);
      expect(token?.deprecated, equals('Use new token instead'));
    });

    test('should fallback to deprecated when $deprecated not present', () {
      final input = '''
      {
        "token": {
          "value": "#111111",
          "type": "color",
          "deprecated": "Fallback deprecated message"
        }
      }''';

      final parsed = json.decode(input) as Map<String, dynamic>;
      final parser = TokenParser();
      parser.parse(parsed);

      final token = parser.themes.first.tokens['token'];
      expect(token?.isDeprecated, isTrue);
      expect(token?.deprecated, equals('Fallback deprecated message'));
    });

    test('should generate @deprecated annotation in code when deprecated is true', () {
      final input = '''
      {
        "deprecatedToken": {
          "value": "#111111",
          "type": "color",
          "\$deprecated": true
        }
      }''';

      final parsed = json.decode(input) as Map<String, dynamic>;
      final parser = TokenParser();
      parser.parse(parsed);

      final token = parser.themes.first.tokens['deprecatedToken'];
      expect(token, isNotNull);
      expect(token?.isDeprecated, isTrue);

      final transformer = ColorTransformer();
      transformer.process(token!);

      expect(transformer.lines.length, equals(1));
      expect(
        transformer.lines[0],
        contains('@deprecated'),
      );
      expect(
        transformer.lines[0],
        isNot(contains('@Deprecated')),
      );
      expect(
        transformer.lines[0],
        contains('@override\n  Color get deprecatedToken'),
      );
    });

    test('should generate @Deprecated annotation with custom message', () {
      final input = '''
      {
        "deprecatedToken": {
          "value": "#111111",
          "type": "color",
          "\$deprecated": "Please use newToken instead"
        }
      }''';

      final parsed = json.decode(input) as Map<String, dynamic>;
      final parser = TokenParser();
      parser.parse(parsed);

      final token = parser.themes.first.tokens['deprecatedToken'];
      expect(token, isNotNull);
      expect(token?.isDeprecated, isTrue);

      final transformer = ColorTransformer();
      transformer.process(token!);

      expect(transformer.lines.length, equals(1));
      expect(
        transformer.lines[0],
        contains("@Deprecated('Please use newToken instead')"),
      );
    });

    test('should generate @Deprecated annotation with description', () {
      final input = '''
      {
        "deprecatedToken": {
          "value": "#111111",
          "type": "color",
          "\$description": "Old color token",
          "\$deprecated": "Use newToken instead"
        }
      }''';

      final parsed = json.decode(input) as Map<String, dynamic>;
      final parser = TokenParser();
      parser.parse(parsed);

      final token = parser.themes.first.tokens['deprecatedToken'];
      expect(token, isNotNull);

      final transformer = ColorTransformer();
      transformer.process(token!);

      expect(transformer.lines.length, equals(1));
      final generatedCode = transformer.lines[0];
      expect(generatedCode, contains("@Deprecated('Use newToken instead')"));
      expect(generatedCode, contains('/// Old color token'));
      expect(generatedCode, contains('@override\n  Color get deprecatedToken'));
    });
  });
}
