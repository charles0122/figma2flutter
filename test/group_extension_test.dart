import 'dart:convert';

import 'package:figma2flutter/exceptions/resolve_token_exception.dart';
import 'package:figma2flutter/token_parser.dart';
import 'package:test/test.dart';

void main() {
  group('Group Extension (\$extends) support', () {
    test('should extend group and inherit tokens', () {
      final input = '''
      {
        "button": {
          "\$type": "color",
          "background": {
            "\$value": {
              "colorSpace": "srgb",
              "components": [0, 0.4, 0.8],
              "hex": "#0066cc"
            }
          },
          "text": {
            "\$value": {
              "colorSpace": "srgb",
              "components": [1, 1, 1],
              "hex": "#ffffff"
            }
          }
        },
        "button-primary": {
          "\$extends": "{button}",
          "background": {
            "\$value": {
              "colorSpace": "srgb",
              "components": [0.8, 0, 0.4],
              "hex": "#cc0066"
            }
          }
        }
      }''';

      final parsed = json.decode(input) as Map<String, dynamic>;
      final parser = TokenParser();
      parser.parse(parsed);

      // Check that button-primary.background is overridden
      final primaryBackground = parser.resolve('button-primary.background');
      expect(primaryBackground, isNotNull);
      final bgValue = primaryBackground?.value as Map<String, dynamic>?;
      expect(bgValue?['hex'], equals('#cc0066'));

      // Check that button-primary.text is inherited
      final primaryText = parser.resolve('button-primary.text');
      expect(primaryText, isNotNull);
      final textValue = primaryText?.value as Map<String, dynamic>?;
      expect(textValue?['hex'], equals('#ffffff'));
    });

    test('should extend group with new tokens', () {
      final input = '''
      {
        "base": {
          "color": {
            "\$value": "#blue",
            "\$type": "color"
          },
          "spacing": {
            "\$value": "16px",
            "\$type": "dimension"
          }
        },
        "extended": {
          "\$extends": "{base}",
          "color": {
            "\$value": "#red",
            "\$type": "color"
          },
          "border": {
            "\$value": "1px solid",
            "\$type": "border"
          }
        }
      }''';

      final parsed = json.decode(input) as Map<String, dynamic>;
      final parser = TokenParser();
      parser.parse(parsed);

      // Check overridden token
      final color = parser.resolve('extended.color');
      expect(color?.value, equals('#red'));

      // Check inherited token
      final spacing = parser.resolve('extended.spacing');
      expect(spacing?.value, equals('16px'));

      // Check new token
      final border = parser.resolve('extended.border');
      expect(border?.value, equals('1px solid'));
    });

    test('should throw error for circular reference', () {
      final input = '''
      {
        "groupA": {
          "\$extends": "{groupB}",
          "token": {
            "\$value": "valueA",
            "\$type": "string"
          }
        },
        "groupB": {
          "\$extends": "{groupA}",
          "token": {
            "\$value": "valueB",
            "\$type": "string"
          }
        }
      }''';

      final parsed = json.decode(input) as Map<String, dynamic>;
      final parser = TokenParser();
      
      expect(
        () => parser.parse(parsed),
        throwsA(isA<ResolveTokenException>()),
      );
    });

    test('should throw error for non-existent group', () {
      final input = '''
      {
        "extended": {
          "\$extends": "{nonexistent}",
          "token": {
            "\$value": "value",
            "\$type": "string"
          }
        }
      }''';

      final parsed = json.decode(input) as Map<String, dynamic>;
      final parser = TokenParser();
      
      expect(
        () => parser.parse(parsed),
        throwsA(isA<ResolveTokenException>()),
      );
    });

    test('should support JSON Pointer in \$extends', () {
      final input = '''
      {
        "button": {
          "background": {
            "\$value": {
              "colorSpace": "srgb",
              "components": [0, 0.4, 0.8],
              "hex": "#0066cc"
            },
            "\$type": "color"
          }
        },
        "button-primary": {
          "\$extends": "#/button",
          "background": {
            "\$value": {
              "colorSpace": "srgb",
              "components": [0.8, 0, 0.4],
              "hex": "#cc0066"
            },
            "\$type": "color"
          }
        }
      }''';

      final parsed = json.decode(input) as Map<String, dynamic>;
      final parser = TokenParser();
      parser.parse(parsed);

      final primaryBackground = parser.resolve('button-primary.background');
      expect(primaryBackground, isNotNull);
      final bgValue = primaryBackground?.value as Map<String, dynamic>?;
      expect(bgValue?['hex'], equals('#cc0066'));
    });
  });
}
