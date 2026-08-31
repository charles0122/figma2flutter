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
    test('inlines color fallback values instead of constructing another theme',
        () {
      const input = '''
      {
        "\$themes": {
          "light": {
            "name": "light",
            "selectedTokenSets": {"colors-light": "enabled"}
          },
          "halloween": {
            "name": "halloween",
            "selectedTokenSets": {"colors-halloween": "enabled"}
          }
        },
        "colors-light": {
          "shared": {"value": "#111111", "type": "color"},
          "lightOnly": {"value": "#FFFFFF", "type": "color"}
        },
        "colors-halloween": {
          "shared": {"value": "#222222", "type": "color"},
          "halloweenOnly": {"value": "#FF0000", "type": "color"}
        }
      }''';
      final parsed = json.decode(input) as Map<String, dynamic>;
      const allSets = ['colors-light', 'colors-halloween'];
      final parser = TokenParser()
        ..themes = (parsed['\$themes'] as Map<String, dynamic>)
            .values
            .map((theme) => TokenTheme.fromJson(
                  theme as Map<String, dynamic>,
                  allSets,
                ))
            .toList()
        ..parse(parsed);
      final processor = Processor(
        themes: parser.themes,
        singleTokenTransformerFactories: [(_) => ColorTransformer()],
      )..process();

      final output = Generator(processor.themes).output;

      expect(output,
          contains('colorsHalloweenHalloweenOnly: const Color(0xFFFF0000)'));
      expect(output, contains('colorsLightLightOnly: const Color(0xFFFFFFFF)'));
      expect(
          output,
          isNot(
              contains('HalloweenColorTokens().colorsHalloweenHalloweenOnly')));
      expect(
          output, isNot(contains('LightColorTokens().colorsLightLightOnly')));
    });

    test(
        'adds adaptive text styles to a non-font theme without typography tokens',
        () {
      final input = '''
      {
        "\$themes": {
          "light": {"name": "light", "selectedTokenSets": {"empty": "enabled"}},
          "dark": {"name": "dark", "selectedTokenSets": {"empty": "enabled"}},
          "halloween": {"name": "halloween", "selectedTokenSets": {"empty": "enabled"}},
          "ios_ch": {"name": "ios_ch", "selectedTokenSets": {"ios-ch": "enabled"}},
          "ios_eng": {"name": "ios_eng", "selectedTokenSets": {"ios-eng": "enabled"}},
          "android_ch": {"name": "android_ch", "selectedTokenSets": {"android-ch": "enabled"}},
          "android_eng": {"name": "android_eng", "selectedTokenSets": {"android-eng": "enabled"}}
        },
        "empty": {},
        "ios-ch": {"body": {"value": {"fontFamily": "Roboto", "fontSize": "14px", "fontWeight": "400"}, "type": "typography"}},
        "ios-eng": {"body": {"value": {"fontFamily": "Roboto", "fontSize": "14px", "fontWeight": "400"}, "type": "typography"}},
        "android-ch": {"body": {"value": {"fontFamily": "Roboto", "fontSize": "14px", "fontWeight": "400"}, "type": "typography"}},
        "android-eng": {"body": {"value": {"fontFamily": "Roboto", "fontSize": "14px", "fontWeight": "400"}, "type": "typography"}}
      }''';
      final parsed = json.decode(input) as Map<String, dynamic>;
      final allSets = [
        'empty',
        'ios-ch',
        'ios-eng',
        'android-ch',
        'android-eng'
      ];
      final parser = TokenParser()
        ..themes = (parsed['\$themes'] as Map<String, dynamic>)
            .values
            .map((theme) => TokenTheme.fromJson(
                  theme as Map<String, dynamic>,
                  allSets,
                ))
            .toList()
        ..parse(parsed);
      final processor = Processor(
        themes: parser.themes,
        singleTokenTransformerFactories: [(_) => TypographyTransformer()],
      )..process();

      final output = Generator(processor.themes).output;

      expect(
        output,
        contains('''class HalloweenTokens extends ITokens {
  @override
  TextStyleTokens get textStyle => AdaptiveTextStyleTokens();'''),
      );
    });

    test(
        'should generate shared class when multiple themes have identical selectedTokenSets and transformer content',
        () {
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
      final lightTokensMatch =
          RegExp(r'class LightTokens[^}]+}').firstMatch(output);
      expect(lightTokensMatch, isNotNull);
      final lightTokensContent = lightTokensMatch!.group(0)!;
      expect(lightTokensContent,
          contains('ColorTokens get color => const LightColorTokens()'));

      final darkTokensMatch =
          RegExp(r'class DarkTokens[^}]+}').firstMatch(output);
      expect(darkTokensMatch, isNotNull);
      final darkTokensContent = darkTokensMatch!.group(0)!;
      expect(darkTokensContent,
          contains('ColorTokens get color => const DarkColorTokens()'));
    });

    test(
        'should generate theme-specific class when transformer content differs',
        () {
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
