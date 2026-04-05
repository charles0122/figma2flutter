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
      expect('{sizing-base} / 8'.isMathExpression, isTrue);
      expect('16px*2'.isMathExpression, isTrue);
      expect('10px + 1rem'.isMathExpression, isTrue);
    });

    test('identifiers or URLs with operators are not math expressions', () {
      expect('foo + 1'.isMathExpression, isFalse);
      expect('a+b'.isMathExpression, isFalse);
      expect(
        'https://www.svgrepo.com/show/507460/alert-triangle.svg'
            .isMathExpression,
        isFalse,
      );
    });

    test('single token ref with hyphen in path is not math expression', () {
      expect('{sizing-base}'.isMathExpression, isFalse);
    });

    test('icon / asset class strings with hyphens are not math expressions', () {
      expect('fa-solid fa-house'.isMathExpression, isFalse);
      expect('fa-regular fa-user'.isMathExpression, isFalse);
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

  test('asset token with icon class string resolves without math error', () {
    final t = Token(
      value: 'fa-solid fa-house',
      type: 'asset',
      path: '.icons.house',
      name: 'solidHouse',
    );
    final resolved = t.resolveAllReferences({});
    expect(resolved.value, equals('fa-solid fa-house'));
  });

  test('asset token with URL value resolves without math error', () {
    final url =
        'https://www.svgrepo.com/show/507460/alert-triangle.svg';
    final t = Token(
      value: url,
      type: 'asset',
      path: '.icons.alert',
      name: 'alert-triangle',
    );
    final resolved = t.resolveAllReferences({});
    expect(resolved.value, equals(url));
  });
}
