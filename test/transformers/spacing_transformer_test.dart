import 'dart:convert';

import 'package:figma2flutter/token_parser.dart';
import 'package:figma2flutter/transformers/spacing_transformer.dart';
import 'package:test/test.dart';

final input = '''
{
	"pixelValue": {
		"value": "10px",
		"type": "spacing"
	},
	"intValue": {
		"value": "100",
		"type": "spacing"
	},
	"remValue": {
		"value": "3rem",
		"type": "spacing"
	},
	"twoValues": {
		"value": "100 15px",
		"type": "spacing"
	},
	"threeValues": {
		"value": "1rem 2rem 3rem",
		"type": "spacing"
	},
	"fourValues": {
		"value": "{pixelValue} 8 {pixelValue} 8",
		"type": "spacing"
	}
}''';

void main() {
  test('Test all spacing variants', () {
    final parsed = json.decode(input) as Map<String, dynamic>;
    final parser = TokenParser();
    parser.parse(parsed);

    expect(parser.resolvedTokens().length, equals(6));
    expect(parser.themes.first.tokens['pixelValue']?.type, equals('spacing'));

    final transformer = SpacingTransformer();
    parser.resolvedTokens().forEach(transformer.process);

    expect(transformer.lines.length, equals(6));
    expect(
      transformer.lines[0],
      contains(
        'static const double pixelValue = 10.0;',
      ),
    );
    expect(
      transformer.lines[1],
      contains(
        'static const double intValue = 100.0;',
      ),
    );
    expect(
      transformer.lines[2],
      contains(
        'static const double remValue = 48.0;',
      ),
    );
    expect(
      transformer.lines[3],
      contains(
        'static const double twoValues = 100.0;',
      ),
    );
    expect(
      transformer.lines[4],
      contains(
        'static const double threeValues = 16.0;',
      ),
    );
    expect(
      transformer.lines[5],
      contains(
        'static const double fourValues = 10.0;',
      ),
    );
  });
}
