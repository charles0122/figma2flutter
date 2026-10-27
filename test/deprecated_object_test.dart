import 'dart:convert';
import 'dart:io';

import 'package:figma2flutter/generator.dart';
import 'package:figma2flutter/models/token.dart';
import 'package:figma2flutter/processor.dart';
import 'package:figma2flutter/token_parser.dart';
import 'package:figma2flutter/transformers/color_transformer.dart';
import 'package:figma2flutter/transformers/spacing_transformer.dart';
import 'package:test/test.dart';

Token _parseToken(Object? deprecation, {String field = r'$deprecated'}) {
  final parser = TokenParser()
    ..parse({
      'oldToken': {
        r'$type': 'color',
        r'$value': '#111111',
        field: deprecation,
      },
    });
  return parser.themes.first.tokens['oldToken']!;
}

void main() {
  group('Tokens Studio deprecation objects', () {
    for (final field in ['deprecated', r'$deprecated']) {
      test('reads a warning message from $field', () {
        final token = _parseToken(
          {
            'severity': 'warning',
            'message': 'Use the new token instead',
          },
          field: field,
        );
        expect(token.deprecated, 'Use the new token instead');
      });

      test('preserves advanced metadata from $field', () {
        final token = _parseToken(
          {
            'severity': 'error',
            'message': 'Use the new token instead',
            'replacementToken': '{color.new}',
            'removeAfter': 'v3.0',
          },
          field: field,
        );
        expect(
          token.deprecated,
          'Severity: error. Use the new token instead '
          'Replacement: {color.new}. Scheduled removal: v3.0.',
        );
      });
    }

    test('recognizes a valid object without a message as deprecated', () {
      final token = _parseToken({'severity': 'warning', 'message': ''});
      expect(token.isDeprecated, isTrue);
      expect(token.deprecated, '');
      final transformer = ColorTransformer()..process(token);
      expect(transformer.lines.single, startsWith('@deprecated\n'));
    });

    test('ignores malformed optional metadata without losing deprecation', () {
      final token = _parseToken({
        'severity': 'warning',
        'message': 'Use new',
        'replacementToken': 42,
        'removeAfter': ['v3.0'],
      });
      expect(token.deprecated, 'Use new');
    });

    test('trims optional metadata and skips blank values', () {
      final token = _parseToken({
        'severity': 'warning',
        'message': '',
        'replacementToken': '  {color.new}  ',
        'removeAfter': '   ',
      });
      expect(token.deprecated, 'Replacement: {color.new}.');
    });

    for (final invalid in <Object?>[
      null,
      false,
      42,
      [],
      <String, dynamic>{},
      {'severity': 'info', 'message': 'Unknown severity'},
      {'severity': 'warning'},
      {'severity': 'error', 'message': 42},
    ]) {
      test('does not deprecate malformed value ${jsonEncode(invalid)}', () {
        expect(_parseToken(invalid).isDeprecated, isFalse);
      });
    }

    for (final preferred in <Object?>[
      false,
      null,
      {'severity': 'warning', 'message': 'Preferred message'},
    ]) {
      test('keeps dollar-prefixed precedence for ${jsonEncode(preferred)}', () {
        final parser = TokenParser()
          ..parse({
            'oldToken': {
              'type': 'color',
              'value': '#111111',
              'deprecated': 'Legacy message',
              r'$deprecated': preferred,
            },
          });
        expect(
          parser.themes.first.tokens['oldToken']!.deprecated,
          preferred is Map ? 'Preferred message' : null,
        );
      });
    }
  });

  test('carries object metadata containing equals into generated fields', () {
    final parser = TokenParser()
      ..parse({
        'oldToken': {
          r'$type': 'color',
          r'$value': '#111111',
          r'$deprecated': {
            'severity': 'warning',
            'message': 'Use a=b instead',
            'replacementToken': '{color.new}',
            'removeAfter': 'v3.0',
          },
        },
      });
    final processor = Processor(
      themes: parser.themes,
      singleTokenTransformerFactories: [(_) => ColorTransformer()],
    )..process();
    final output = Generator(processor.themes).output;
    expect(output, contains('final Color oldToken;'));
    expect(output, contains('oldToken: const Color(0xFF111111)'));
    expect(
      output,
      contains(
        "@Deprecated('Use a=b instead Replacement: {color.new}. "
        "Scheduled removal: v3.0.')",
      ),
    );
  });

  for (final isObject in [false, true]) {
    test('generates executable Dart with literal messages (object: $isObject)',
        () async {
      const message =
          "Don't use \"old\" = \\\n\r\t\u0000" r'$value ${expression}';
      final token = _parseToken(
        isObject ? {'severity': 'warning', 'message': message} : message,
      ).copyWith(type: 'spacing', value: '4');
      final transformer = SpacingTransformer()..process(token);
      final directory = Directory.systemTemp.createTempSync('deprecation-');
      addTearDown(() => directory.deleteSync(recursive: true));
      final source = File('${directory.path}/tokens.dart');
      source.writeAsStringSync('''
import 'dart:convert';
import 'dart:mirrors';
class Tokens {
  ${transformer.lines.single}
}
void main() {
  final field = reflectClass(Tokens).declarations[#oldToken]!;
  final annotation = field.metadata.single.reflectee as Deprecated;
  print(jsonEncode(annotation.message));
}
''');
      final result =
          await Process.run(Platform.resolvedExecutable, [source.path]);
      expect(result.exitCode, 0, reason: result.stderr.toString());
      expect(jsonDecode(result.stdout.toString()), message);
    });
  }
}
