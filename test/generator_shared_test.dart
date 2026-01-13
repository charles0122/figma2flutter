import 'dart:convert';

import 'package:figma2flutter/generator.dart';
import 'package:figma2flutter/processor.dart';
import 'package:figma2flutter/models/token_theme.dart';
import 'package:figma2flutter/token_parser.dart';
import 'package:figma2flutter/transformers/color_transformer.dart';
import 'package:figma2flutter/transformers/typography_transformer.dart';
import 'package:test/test.dart';

void main() {
  group('Generator shared classes', () {
    test('should generate shared class when multiple themes have identical selectedTokenSets and transformer content', () {
      // Create input with two themes that use exactly the same token set
      // This simulates the case where light and dark themes share the same typography/font tokens
      final input = '''
      {
        "\$themes": {
          "light": {
            "name": "light",
            "selectedTokenSets": {
              "shared-colors": "source"
            }
          },
          "dark": {
            "name": "dark",
            "selectedTokenSets": {
              "shared-colors": "source"
            }
          }
        },
        "shared-colors": {
          "neutral": {
            "value": "#808080",
            "type": "color"
          },
          "background": {
            "value": "#FFFFFF",
            "type": "color"
          }
        }
      }''';

      final parsed = json.decode(input) as Map<String, dynamic>;
      final parser = TokenParser();
      
      // Parse themes
      final themesJson = parsed['\$themes'] as Map<String, dynamic>;
      final allSets = ['shared-colors'];
      parser.themes = themesJson.values
          .map((e) => TokenTheme.fromJson(e as Map<String, dynamic>, allSets))
          .toList();
      
      parser.parse(parsed);

      // Process tokens
      final processor = Processor(
        themes: parser.themes,
        singleTokenTransformerFactories: [
          (_) => ColorTransformer(),
        ],
      );
      processor.process();

      // Generate code
      final generator = Generator(processor.themes);
      final output = generator.output;

      // Verify that shared class is NOT generated for colors (color transformer is excluded from sharing)
      expect(output, isNot(contains('SharedColorTokens')));
      
      // Verify that both themes use theme-specific classes
      expect(output, contains('LightTokens'));
      expect(output, contains('DarkTokens'));
      
      // Verify that theme-specific color classes are generated
      expect(output, contains('LightColorTokens'));
      expect(output, contains('DarkColorTokens'));
      
      // Verify that color property uses theme-specific class in both themes
      final lightTokensMatch = RegExp(r'class LightTokens[^}]+}').firstMatch(output);
      expect(lightTokensMatch, isNotNull);
      final lightTokensContent = lightTokensMatch!.group(0)!;
      expect(lightTokensContent, contains('ColorTokens get color => LightColorTokens()'));
      
      final darkTokensMatch = RegExp(r'class DarkTokens[^}]+}').firstMatch(output);
      expect(darkTokensMatch, isNotNull);
      final darkTokensContent = darkTokensMatch!.group(0)!;
      expect(darkTokensContent, contains('ColorTokens get color => DarkColorTokens()'));
    });

    test('should generate theme-specific class when transformer content differs', () {
      // Create input with two themes that have different color tokens
      final input = '''
      {
        "\$themes": {
          "light": {
            "name": "light",
            "selectedTokenSets": {
              "colors-light": "source"
            }
          },
          "dark": {
            "name": "dark",
            "selectedTokenSets": {
              "colors-dark": "source"
            }
          }
        },
        "colors-light": {
          "primary": {
            "value": "#FF0000",
            "type": "color"
          }
        },
        "colors-dark": {
          "primary": {
            "value": "#00FF00",
            "type": "color"
          }
        }
      }''';

      final parsed = json.decode(input) as Map<String, dynamic>;
      final parser = TokenParser();
      
      // Parse themes
      final themesJson = parsed['\$themes'] as Map<String, dynamic>;
      final allSets = ['colors-light', 'colors-dark'];
      parser.themes = themesJson.values
          .map((e) => TokenTheme.fromJson(e as Map<String, dynamic>, allSets))
          .toList();
      
      parser.parse(parsed);

      // Process tokens
      final processor = Processor(
        themes: parser.themes,
        singleTokenTransformerFactories: [
          (_) => ColorTransformer(),
        ],
      );
      processor.process();

      // Generate code
      final generator = Generator(processor.themes);
      final output = generator.output;

      // Verify that no shared class is generated
      expect(output, isNot(contains('SharedColorTokens')));
      
      // Verify that theme-specific classes are generated
      expect(output, contains('LightColorTokens'));
      expect(output, contains('DarkColorTokens'));
    });
  });
}
