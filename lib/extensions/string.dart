import 'package:recase/recase.dart';

const negativeNumberPreface = 'Negative';

extension StringExtension on String {
  String get alphanumeric {
    // Match '-' only if it is followed by a digit and replace with negativeNumberPreface
    final patternNegative = RegExp(r'^(-)(?=\d)');
    // Match all non alphanumeric characters (excluding negativeNumberPreface replacements) and replace them with a space
    final patternNonAlphanumeric = RegExp(r'[^a-zA-Z0-9]');

    var result = replaceAll(patternNegative, negativeNumberPreface);
    result = result.replaceAll(patternNonAlphanumeric, ' ');

    return result.pascalCase;
  }

  /// Returns true if the string is a reference to another token path without any extras
  bool get isTokenReference =>
      (startsWith('{') && endsWith('}')) &&
      RegExp(r'{(.*?)}').allMatches(this).length == 1;

  bool get hasTokenReferences => RegExp(r'{(.*?)}').allMatches(this).isNotEmpty;

  bool get isColorReference {
    // what is this really used for.  It says #123456 isn't a color
    // this should probably only be done at the token level
    bool isColor =
        !startsWith('{') && RegExp(r'{(.*?)}').firstMatch(this) != null;
    // print('looked at $this to see if it is a color - $isColor');
    return isColor;
  }

  bool get isMathExpression {
    // 支持带空格和不带空格的 * / +，以及「两侧有空格」的二元减号（与
    // Token._resolveMathExpression 的 operatorPattern 保持一致）。
    //
    // 负号开头的纯数字（如 letterSpacing 的 "-0.5"）不是二元运算。
    // 词内的连字符（如 Font Awesome 的 fa-solid、kebab-case）不得视为减号，否则会
    // 误判 asset 等字符串并走进数学解析。
    //
    // 除 {token} 与尺寸字面量（数字 ± px/rem/%）外，不得含其它字母，否则视为 URL、
    // class 名等，避免误判为数学式。
    final trimmed = trim();
    if (trimmed.isNotEmpty && double.tryParse(trimmed) != null) {
      return false;
    }
    // 单独的 {token.path} 引用（路径中可含连字符，如 {sizing-base}）不是数学表达式。
    if (isTokenReference) {
      return false;
    }
    final operatorPattern = RegExp(r'\s+-\s+|\s*[*/]\s*|\s*\+\s*');
    if (!operatorPattern.hasMatch(this)) {
      return false;
    }
    if (_hasLettersOutsideTokenRefsAndNumericLiterals(this)) {
      return false;
    }
    return true;
  }

  /// Returns the path of a reference, so we can search for the token
  String get valueByRef {
    final match = RegExp(r'{(.*?)}').firstMatch(this)?.group(1);
    if (match != null) {
      return match;
    }

    throw Exception(
      'Not a valid reference ( should start with \$ or encased in { })',
    );
  }
}

/// 去掉 [input] 中的 `{引用}` 与数字/尺寸片段后，是否仍含 [a-zA-Z]。
bool _hasLettersOutsideTokenRefsAndNumericLiterals(String input) {
  var s = input.replaceAll(RegExp(r'\{[^}]*\}'), '');
  final numericWithOptionalUnit = RegExp(
    r'-?(?:\d+(?:\.\d*)?|\.\d+)\s*(?:px|rem|%)?',
  );
  String previous;
  do {
    previous = s;
    s = s.replaceAll(numericWithOptionalUnit, '');
  } while (s != previous);
  return RegExp(r'[a-zA-Z]').hasMatch(s);
}
