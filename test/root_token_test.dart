import 'dart:convert';

import 'package:figma2flutter/token_parser.dart';
import 'package:test/test.dart';

void main() {
  group('Root Tokens (\$root) support', () {
    test('should parse root token in a group', () {
      final input = '''
      {
        "color": {
          "accent": {
            "\$root": {
              "\$type": "color",
              "\$value": {
                "colorSpace": "srgb",
                "components": [0.867, 0, 0],
                "hex": "#dd0000"
              }
            },
            "light": {
              "\$type": "color",
              "\$value": {
                "colorSpace": "srgb",
                "components": [1, 0.133, 0.133],
                "hex": "#ff2222"
              }
            },
            "dark": {
              "\$type": "color",
              "\$value": {
                "colorSpace": "srgb",
                "components": [0.667, 0, 0],
                "hex": "#aa0000"
              }
            }
          }
        }
      }''';

      final parsed = json.decode(input) as Map<String, dynamic>;
      final parser = TokenParser();
      parser.parse(parsed);

      // Check that $root token exists
      final rootToken = parser.resolve('color.accent.\$root');
      expect(rootToken, isNotNull);
      expect(rootToken?.name, equals('\$root'));
      expect(rootToken?.type, equals('color'));
      
      final rootValue = rootToken?.value as Map<String, dynamic>?;
      expect(rootValue?['hex'], equals('#dd0000'));

      // Check that other tokens still work
      final lightToken = parser.resolve('color.accent.light');
      expect(lightToken, isNotNull);
      final lightValue = lightToken?.value as Map<String, dynamic>?;
      expect(lightValue?['hex'], equals('#ff2222'));
    });

    test('should reference root token using curly brace syntax', () {
      final input = '''
      {
        "spacing": {
          "\$type": "dimension",
          "\$root": {
            "\$value": {"value": 16, "unit": "px"}
          },
          "small": {
            "\$value": {"value": 8, "unit": "px"}
          },
          "large": {
            "\$value": {"value": 32, "unit": "px"}
          }
        },
        "reference": {
          "\$value": "{spacing.\$root}",
          "\$type": "dimension"
        }
      }''';

      final parsed = json.decode(input) as Map<String, dynamic>;
      final parser = TokenParser();
      parser.parse(parsed);

      final rootToken = parser.resolve('spacing.\$root');
      expect(rootToken, isNotNull);
      
      final referenceToken = parser.resolve('reference');
      expect(referenceToken, isNotNull);
      final refValue = referenceToken?.value as Map<String, dynamic>?;
      expect(refValue?['value'], equals(16));
      expect(refValue?['unit'], equals('px'));
    });

    test('should handle root token with description and deprecated', () {
      final input = '''
      {
        "color": {
          "accent": {
            "\$root": {
              "\$type": "color",
              "\$value": {
                "colorSpace": "srgb",
                "components": [0.867, 0, 0],
                "hex": "#dd0000"
              },
              "\$description": "Base accent color",
              "\$deprecated": true
            }
          }
        }
      }''';

      final parsed = json.decode(input) as Map<String, dynamic>;
      final parser = TokenParser();
      parser.parse(parsed);

      final rootToken = parser.resolve('color.accent.\$root');
      expect(rootToken, isNotNull);
      expect(rootToken?.description, equals('Base accent color'));
      expect(rootToken?.isDeprecated, isTrue);
    });
  });
}
