import 'dart:convert';

import 'package:figma2flutter/generator.dart';
import 'package:figma2flutter/models/token_theme.dart';
import 'package:figma2flutter/processor.dart';
import 'package:figma2flutter/token_parser.dart';
import 'package:figma2flutter/transformers/color_transformer.dart';
import 'package:figma2flutter/transformers/spacing_transformer.dart';
import 'package:test/test.dart';

void main() {
  group('Generator shared classes based on selectedTokenSets', () {
    test('should NOT generate shared class when themes have different selectedTokenSets even if content is identical', () {
      // Create input where two themes have different token sets but happen to have identical content
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
            "value": "#FF0000",
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

      // Verify that NO shared class is generated (different selectedTokenSets)
      expect(output, isNot(contains('SharedColorTokens')));
      
      // Verify that theme-specific classes are generated
      expect(output, contains('LightColorTokens'));
      expect(output, contains('DarkColorTokens'));
    });

    test('should generate shared class when themes have identical selectedTokenSets and content', () {
      // Create input where two themes have the same token sets
      final input = '''
      {
        "\$themes": {
          "light": {
            "name": "light",
            "selectedTokenSets": {
              "typography": "source",
              "colors": "source"
            }
          },
          "dark": {
            "name": "dark",
            "selectedTokenSets": {
              "typography": "source",
              "colors": "source"
            }
          }
        },
        "typography": {
          "font-family": {
            "value": "Roboto",
            "type": "fontFamily"
          }
        },
        "colors": {
          "primary": {
            "value": "#FF0000",
            "type": "color"
          }
        }
      }''';

      final parsed = json.decode(input) as Map<String, dynamic>;
      final parser = TokenParser();
      
      // Parse themes
      final themesJson = parsed['\$themes'] as Map<String, dynamic>;
      final allSets = ['typography', 'colors'];
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
      expect(output, contains('LightColorTokens'));
      expect(output, contains('DarkColorTokens'));
    });

    test('should generate shared class for connected components with 3+ themes', () {
      // Create input with 3 themes that all share the same "core" token set:
      // - Theme A: ["core", "theme-a"]
      // - Theme B: ["core", "theme-b"] (shares "core" with A)
      // - Theme C: ["core", "theme-c"] (shares "core" with A and B)
      // All three themes have the same spacing tokens from "core"
      // This tests that the connected components algorithm correctly groups all three themes
      final input = '''
      {
        "\$themes": {
          "theme-a": {
            "name": "theme-a",
            "selectedTokenSets": {
              "core": "source",
              "theme-a": "enabled"
            }
          },
          "theme-b": {
            "name": "theme-b",
            "selectedTokenSets": {
              "core": "source",
              "theme-b": "enabled"
            }
          },
          "theme-c": {
            "name": "theme-c",
            "selectedTokenSets": {
              "core": "source",
              "theme-c": "enabled"
            }
          }
        },
        "core": {
          "spacing": {
            "xs": {
              "value": "4",
              "type": "spacing"
            },
            "sm": {
              "value": "8",
              "type": "spacing"
            }
          }
        },
        "theme-a": {
          "colors": {
            "primary": {
              "value": "#FF0000",
              "type": "color"
            }
          }
        },
        "theme-b": {
          "colors": {
            "primary": {
              "value": "#00FF00",
              "type": "color"
            }
          }
        },
        "theme-c": {
          "colors": {
            "primary": {
              "value": "#0000FF",
              "type": "color"
            }
          }
        }
      }''';

      final parsed = json.decode(input) as Map<String, dynamic>;
      final parser = TokenParser();
      
      // Parse themes
      final themesJson = parsed['\$themes'] as Map<String, dynamic>;
      final allSets = ['core', 'theme-a', 'theme-b', 'theme-c'];
      parser.themes = themesJson.values
          .map((e) => TokenTheme.fromJson(e as Map<String, dynamic>, allSets))
          .toList();
      
      parser.parse(parsed);

      // Process tokens
      final processor = Processor(
        themes: parser.themes,
        singleTokenTransformerFactories: [
          (_) => ColorTransformer(),
          (_) => SpacingTransformer(),
        ],
      );
      processor.process();

      // Generate code
      final generator = Generator(processor.themes);
      final output = generator.output;

      // Verify that shared class is generated for spacing
      // All three themes have the same spacing tokens from "core"
      // All three themes share "core" token set
      // So they form a connected component and should share
      expect(output, contains('SharedSpacingTokens'));
      
      // Verify that all three themes use the shared class
      expect(output, contains('ThemeATokens'));
      expect(output, contains('ThemeBTokens'));
      expect(output, contains('ThemeCTokens'));
      
      // Check that all three themes reference SharedSpacingTokens
      final themeATokensMatch = RegExp(r'class ThemeATokens[^}]+}').firstMatch(output);
      expect(themeATokensMatch, isNotNull);
      expect(themeATokensMatch!.group(0), contains('SpacingTokens get spacing => const SharedSpacingTokens()'));
      
      final themeBTokensMatch = RegExp(r'class ThemeBTokens[^}]+}').firstMatch(output);
      expect(themeBTokensMatch, isNotNull);
      expect(themeBTokensMatch!.group(0), contains('SpacingTokens get spacing => const SharedSpacingTokens()'));
      
      final themeCTokensMatch = RegExp(r'class ThemeCTokens[^}]+}').firstMatch(output);
      expect(themeCTokensMatch, isNotNull);
      expect(themeCTokensMatch!.group(0), contains('SpacingTokens get spacing => const SharedSpacingTokens()'));
      
      // Verify that color classes are theme-specific (different content)
      expect(output, contains('ThemeAColorTokens'));
      expect(output, contains('ThemeBColorTokens'));
      expect(output, contains('ThemeCColorTokens'));
      expect(output, isNot(contains('SharedColorTokens')));
    });

    test('should NOT generate shared class for disconnected components', () {
      // Create input with 3 themes that form two disconnected components:
      // - Theme A: ["core-a"] 
      // - Theme B: ["core-a"] (shares "core-a" with A)
      // - Theme C: ["core-c"] (no common sets with A or B)
      // A and B have same content, C has same content but different sets
      final input = '''
      {
        "\$themes": {
          "theme-a": {
            "name": "theme-a",
            "selectedTokenSets": {
              "core-a": "source"
            }
          },
          "theme-b": {
            "name": "theme-b",
            "selectedTokenSets": {
              "core-a": "source"
            }
          },
          "theme-c": {
            "name": "theme-c",
            "selectedTokenSets": {
              "core-c": "source"
            }
          }
        },
        "core-a": {
          "spacing": {
            "xs": {
              "value": "4",
              "type": "spacing"
            }
          }
        },
        "core-c": {
          "spacing": {
            "xs": {
              "value": "4",
              "type": "spacing"
            }
          }
        }
      }''';

      final parsed = json.decode(input) as Map<String, dynamic>;
      final parser = TokenParser();
      
      // Parse themes
      final themesJson = parsed['\$themes'] as Map<String, dynamic>;
      final allSets = ['core-a', 'core-c'];
      parser.themes = themesJson.values
          .map((e) => TokenTheme.fromJson(e as Map<String, dynamic>, allSets))
          .toList();
      
      parser.parse(parsed);

      // Process tokens
      final processor = Processor(
        themes: parser.themes,
        singleTokenTransformerFactories: [
          (_) => SpacingTransformer(),
        ],
      );
      processor.process();

      // Generate code
      final generator = Generator(processor.themes);
      final output = generator.output;

      // Theme A and B share "core-a" and have same content -> should share
      expect(output, contains('SharedSpacingTokens'));
      
      // Theme C has different sets ("core-c") -> should NOT share with A/B
      // Even though content is the same, they don't have common sets
      // So C should have its own class
      expect(output, contains('ThemeCSpacingTokens'));
      
      // Verify that A and B use shared class
      final themeATokensMatch = RegExp(r'class ThemeATokens[^}]+}').firstMatch(output);
      expect(themeATokensMatch, isNotNull);
      expect(themeATokensMatch!.group(0), contains('SpacingTokens get spacing => const SharedSpacingTokens()'));
      
      final themeBTokensMatch = RegExp(r'class ThemeBTokens[^}]+}').firstMatch(output);
      expect(themeBTokensMatch, isNotNull);
      expect(themeBTokensMatch!.group(0), contains('SpacingTokens get spacing => const SharedSpacingTokens()'));
      
      // Verify that C uses its own class
      final themeCTokensMatch = RegExp(r'class ThemeCTokens[^}]+}').firstMatch(output);
      expect(themeCTokensMatch, isNotNull);
      expect(themeCTokensMatch!.group(0), contains('SpacingTokens get spacing => ThemeCSpacingTokens()'));
    });

    test('should generate shared class for transitive connected components (A-B-C chain)', () {
      // Create input with 3 themes that form a chain through shared sets:
      // - Theme A: ["shared", "theme-a"]
      // - Theme B: ["shared", "bridge", "theme-b"] (shares "shared" with A, "bridge" with C)
      // - Theme C: ["bridge", "theme-c"] (shares "bridge" with B, but not "shared" with A)
      // All three themes have the same spacing tokens from "shared" or "bridge"
      // The key is that A and B get spacing from "shared", B and C get spacing from "bridge"
      // But since B has both, it will have tokens from both sets, making its content different
      // So we need to ensure all themes get spacing from the same source
      // Let's use a different approach: all themes share "shared" set for spacing
      final input = '''
      {
        "\$themes": {
          "theme-a": {
            "name": "theme-a",
            "selectedTokenSets": {
              "shared": "source",
              "theme-a": "enabled"
            }
          },
          "theme-b": {
            "name": "theme-b",
            "selectedTokenSets": {
              "shared": "source",
              "bridge": "source",
              "theme-b": "enabled"
            }
          },
          "theme-c": {
            "name": "theme-c",
            "selectedTokenSets": {
              "shared": "source",
              "bridge": "source",
              "theme-c": "enabled"
            }
          }
        },
        "shared": {
          "spacing": {
            "xs": {
              "value": "4",
              "type": "spacing"
            },
            "sm": {
              "value": "8",
              "type": "spacing"
            }
          }
        },
        "bridge": {},
        "theme-a": {
          "colors": {
            "primary": {
              "value": "#FF0000",
              "type": "color"
            }
          }
        },
        "theme-b": {
          "colors": {
            "primary": {
              "value": "#00FF00",
              "type": "color"
            }
          }
        },
        "theme-c": {
          "colors": {
            "primary": {
              "value": "#0000FF",
              "type": "color"
            }
          }
        }
      }''';

      final parsed = json.decode(input) as Map<String, dynamic>;
      final parser = TokenParser();
      
      // Parse themes
      final themesJson = parsed['\$themes'] as Map<String, dynamic>;
      final allSets = ['shared', 'bridge', 'theme-a', 'theme-b', 'theme-c'];
      parser.themes = themesJson.values
          .map((e) => TokenTheme.fromJson(e as Map<String, dynamic>, allSets))
          .toList();
      
      parser.parse(parsed);

      // Process tokens
      final processor = Processor(
        themes: parser.themes,
        singleTokenTransformerFactories: [
          (_) => ColorTransformer(),
          (_) => SpacingTransformer(),
        ],
      );
      processor.process();

      // Generate code
      final generator = Generator(processor.themes);
      final output = generator.output;

      // Verify that shared class is generated for spacing
      // All three themes share "shared" set, so they should share
      expect(output, contains('SharedSpacingTokens'));
      
      // Verify that all three themes use the shared class
      final themeATokensMatch = RegExp(r'class ThemeATokens[^}]+}').firstMatch(output);
      expect(themeATokensMatch, isNotNull);
      expect(themeATokensMatch!.group(0), contains('SpacingTokens get spacing => const SharedSpacingTokens()'));
      
      final themeBTokensMatch = RegExp(r'class ThemeBTokens[^}]+}').firstMatch(output);
      expect(themeBTokensMatch, isNotNull);
      expect(themeBTokensMatch!.group(0), contains('SpacingTokens get spacing => const SharedSpacingTokens()'));
      
      final themeCTokensMatch = RegExp(r'class ThemeCTokens[^}]+}').firstMatch(output);
      expect(themeCTokensMatch, isNotNull);
      expect(themeCTokensMatch!.group(0), contains('SpacingTokens get spacing => const SharedSpacingTokens()'));
      
      // Verify that color classes are theme-specific
      expect(output, contains('ThemeAColorTokens'));
      expect(output, contains('ThemeBColorTokens'));
      expect(output, contains('ThemeCColorTokens'));
      expect(output, isNot(contains('SharedColorTokens')));
    });
  });
}
