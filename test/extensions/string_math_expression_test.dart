import 'package:figma2flutter/extensions/string.dart';
import 'package:figma2flutter/models/token.dart';
import 'package:test/test.dart';

void main() {
  group('isMathExpression', () {
    test('negative numeric literals are not math expressions', () {
      expect('-0.5'.isMathExpression, isFalse);
      expect(' -0.5 '.isMathExpression, isFalse);
      expect('-12'.isMathExpression, isFalse);
      expect('0.25'.isMathExpression, isFalse);
    });

    test('binary operators still count as math expressions', () {
      expect('1+2'.isMathExpression, isTrue);
      expect('1 - 2'.isMathExpression, isTrue);
      expect('{a} * 2'.isMathExpression, isTrue);
    });

    test('single token ref with hyphen in path is not math expression', () {
      expect('{sizing-base}'.isMathExpression, isFalse);
    });
  });

  test('letterSpacing token with string -0.5 resolves without math error', () {
    final t = Token(
      value: '-0.5',
      type: 'letterSpacing',
      path: '.global.letterspacing',
      name: '5',
    );
    final resolved = t.resolveAllReferences({});
    // 不再误判为数学表达式；保留字符串值供后续 transformer 解析
    expect(resolved.value, equals('-0.5'));
  });
}
