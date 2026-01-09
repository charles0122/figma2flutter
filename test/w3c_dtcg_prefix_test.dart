import 'dart:convert';

import 'package:figma2flutter/token_parser.dart';
import 'package:test/test.dart';

void main() {
  group(r'W3C DTCG $ prefix support', () {
    test(r'should parse token with $value prefix', () {
      final input = '''
      {
        "token": {
          "\$value": "#111111",
          "\$type": "color"
        }
      }''';

      final parsed = json.decode(input) as Map<String, dynamic>;
      final parser = TokenParser();
      parser.parse(parsed);

      expect(parser.themes.first.tokens.length, equals(1));
      expect(parser.themes.first.tokens['token']?.value, equals('#111111'));
      expect(parser.themes.first.tokens['token']?.type, equals('color'));
    });

    test(r'should parse token with $type prefix', () {
      final input = '''
      {
        "token": {
          "value": "#111111",
          "\$type": "color"
        }
      }''';

      final parsed = json.decode(input) as Map<String, dynamic>;
      final parser = TokenParser();
      parser.parse(parsed);

      expect(parser.themes.first.tokens['token']?.type, equals('color'));
    });

    test(r'should parse token with $description prefix', () {
      final input = '''
      {
        "token": {
          "value": "#111111",
          "type": "color",
          "\$description": "Primary color token"
        }
      }''';

      final parsed = json.decode(input) as Map<String, dynamic>;
      final parser = TokenParser();
      parser.parse(parsed);

      expect(parser.themes.first.tokens['token']?.description,
          equals('Primary color token'));
    });

    test(r'should prefer $value over value when both exist', () {
      final input = '''
      {
        "token": {
          "value": "#000000",
          "\$value": "#111111",
          "type": "color"
        }
      }''';

      final parsed = json.decode(input) as Map<String, dynamic>;
      final parser = TokenParser();
      parser.parse(parsed);

      // Should prefer $value
      expect(parser.themes.first.tokens['token']?.value, equals('#111111'));
    });

    test(r'should prefer $type over type when both exist', () {
      final input = '''
      {
        "token": {
          "value": "#111111",
          "type": "dimension",
          "\$type": "color"
        }
      }''';

      final parsed = json.decode(input) as Map<String, dynamic>;
      final parser = TokenParser();
      parser.parse(parsed);

      // Should prefer $type
      expect(parser.themes.first.tokens['token']?.type, equals('color'));
    });

    test(r'should prefer $description over description when both exist', () {
      final input = '''
      {
        "token": {
          "value": "#111111",
          "type": "color",
          "description": "Old description",
          "\$description": "New description"
        }
      }''';

      final parsed = json.decode(input) as Map<String, dynamic>;
      final parser = TokenParser();
      parser.parse(parsed);

      // Should prefer $description
      expect(parser.themes.first.tokens['token']?.description,
          equals('New description'));
    });

    test(r'should parse group type with $type prefix', () {
      final input = '''
      {
        "token group": {
          "\$type": "dimension",
          "token": {
            "value": "2rem"
          }
        }
      }''';

      final parsed = json.decode(input) as Map<String, dynamic>;
      final parser = TokenParser();
      parser.parse(parsed);

      expect(
        parser.themes.first.tokens['token group.token']?.type,
        equals('dimension'),
      );
    });

    test(r'should fallback to non-prefixed fields when $ prefix not present', () {
      final input = '''
      {
        "token": {
          "value": "#111111",
          "type": "color",
          "description": "Fallback description"
        }
      }''';

      final parsed = json.decode(input) as Map<String, dynamic>;
      final parser = TokenParser();
      parser.parse(parsed);

      expect(parser.themes.first.tokens['token']?.value, equals('#111111'));
      expect(parser.themes.first.tokens['token']?.type, equals('color'));
      expect(parser.themes.first.tokens['token']?.description,
          equals('Fallback description'),);
    });
  });
}
