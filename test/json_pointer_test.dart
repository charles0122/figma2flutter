import 'dart:convert';

import 'package:figma2flutter/exceptions/resolve_token_exception.dart';
import 'package:figma2flutter/token_parser.dart';
import 'package:test/test.dart';

void main() {
  group('JSON Pointer support', () {
    test('should parse token with \$ref using JSON Pointer', () {
      final input = '''
      {
        "colors": {
          "blue": {
            "\$value": {
              "colorSpace": "srgb",
              "components": [0.2, 0.4, 0.9],
              "hex": "#3366e6"
            },
            "\$type": "color"
          }
        },
        "semantic": {
          "primary": {
            "\$ref": "#/colors/blue/\$value",
            "\$type": "color"
          }
        }
      }''';

      final parsed = json.decode(input) as Map<String, dynamic>;
      final parser = TokenParser();
      parser.parse(parsed);

      final token = parser.themes.first.tokens['semantic.primary'];
      expect(token, isNotNull);
      
      // Resolve the token
      final resolved = parser.resolve('semantic.primary');
      expect(resolved, isNotNull);
      expect(resolved?.type, equals('color'));
      
      // The value should be resolved from the JSON Pointer
      final value = resolved?.value as Map<String, dynamic>?;
      expect(value, isNotNull);
      expect(value?['colorSpace'], equals('srgb'));
      expect(value?['components'], equals([0.2, 0.4, 0.9]));
    });

    test('should resolve JSON Pointer to property-level value', () {
      final input = '''
      {
        "colors": {
          "blue": {
            "\$value": {
              "colorSpace": "srgb",
              "components": [0.2, 0.4, 0.9],
              "hex": "#3366e6"
            },
            "\$type": "color"
          }
        },
        "semantic": {
          "primaryHue": {
            "\$ref": "#/colors/blue/\$value/components/0",
            "\$type": "number"
          }
        }
      }''';

      final parsed = json.decode(input) as Map<String, dynamic>;
      final parser = TokenParser();
      parser.parse(parsed);

      final resolved = parser.resolve('semantic.primaryHue');
      expect(resolved, isNotNull);
      expect(resolved?.type, equals('number'));
      expect(resolved?.value, equals(0.2));
    });

    test('should handle JSON Pointer with escaped characters', () {
      final input = '''
      {
        "my~group": {
          "token": {
            "\$value": "test",
            "\$type": "string"
          }
        },
        "reference": {
          "\$ref": "#/my~0group/token/\$value",
          "\$type": "string"
        }
      }''';

      final parsed = json.decode(input) as Map<String, dynamic>;
      final parser = TokenParser();
      parser.parse(parsed);

      final resolved = parser.resolve('reference');
      expect(resolved, isNotNull);
      expect(resolved?.value, equals('test'));
    });

    test('should throw error for invalid JSON Pointer', () {
      final input = '''
      {
        "token": {
          "\$ref": "invalid-pointer",
          "\$type": "string"
        }
      }''';

      final parsed = json.decode(input) as Map<String, dynamic>;
      final parser = TokenParser();
      parser.parse(parsed);

      expect(
        () => parser.resolve('token'),
        throwsA(isA<ResolveTokenException>()),
      );
    });

    test('should throw error for non-existent JSON Pointer path', () {
      final input = '''
      {
        "token": {
          "\$ref": "#/nonexistent/path",
          "\$type": "string"
        }
      }''';

      final parsed = json.decode(input) as Map<String, dynamic>;
      final parser = TokenParser();
      parser.parse(parsed);

      expect(
        () => parser.resolve('token'),
        throwsA(isA<ResolveTokenException>()),
      );
    });
  });
}
