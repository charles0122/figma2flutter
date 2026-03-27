import 'dart:math';

import 'package:figma2flutter/exceptions/resolve_token_exception.dart';
import 'package:figma2flutter/extensions/string.dart';
import 'package:figma2flutter/models/color_value.dart';
import 'package:figma2flutter/models/dimension_value.dart';
import 'package:figma2flutter/utils/json_pointer.dart';
import 'package:recase/recase.dart';

/// A [Token] represents a single token in the json file.
/// It holds the value, the type, the path and the name of the token and it
/// also holds the name of the variable that will be generated for this token.
///
/// A token can hold a reference to another token directly or indirectly when
/// one of the values in the values Map is a reference.
class Token {
  /// Create a new [Token] instance
  Token({
    required this.value,
    required this.type,
    required this.path,
    required this.name,
    this.extensions,
    this.description,
    this.deprecated,
    String? variableName,
  }) : variableName = variableName ?? _getVariableName(path, name);

  /// The value this token holds
  final dynamic value;

  // Can be null when the token is a reference
  final String? type;

  /// The path where this token was found in the json file
  final String path;

  /// The name of the token
  final String name;

  /// The name of the variable that will be generated for this token
  /// Based on the path and name of the token
  final String variableName;

  /// The extensions of the token
  final Map<String, dynamic>? extensions;

  /// The description of the token
  final String? description;

  /// The deprecated message of the token.
  /// If null, the token is not deprecated.
  /// If an empty string, the token is deprecated without a message.
  /// If a non-empty string, the token is deprecated with the given message.
  final String? deprecated;

  /// Returns true if the token is deprecated
  bool get isDeprecated => deprecated != null;

  bool get hasExtensions => extensions != null && extensions!.isNotEmpty;

  /// The value of the token as a string
  String? get valueAsString {
    if (value is String) {
      return value as String;
    }

    return null;
  }

  /// Check if the token is a reference to another token
  bool get _hasTokenReferences =>
      value is String && (value as String).hasTokenReferences;

  /// Check if the token uses JSON Pointer reference ($ref)
  bool get _hasJsonPointerReference =>
      value is Map<String, dynamic> &&
      (value as Map<String, dynamic>).containsKey('\$ref') &&
      (value as Map<String, dynamic>)['\$ref'] is String;

  /// Check if the token has an inner reference to a color
  bool get _hasColorReference =>
      type != null &&
      type?.toLowerCase() == 'color' &&
      value is String &&
      (value as String).isColorReference;

  bool get _hasMathExpression =>
      value is String && (value as String).isMathExpression;

  /// The name of the token that is referenced without the leading '$'
  /// or '{' and '}' characters
  String get valueByRef => (value as String).valueByRef;

  /// Returns a copy of this token with the given values. If the path is set,
  /// the variable name will be updated as well.
  Token copyWith({
    String? path,
    String? variableName,
    String? type,
    dynamic value,
    Map<String, dynamic>? extensions,
    String? description,
    String? deprecated,
  }) {
    if (path != null && variableName == null) {
      variableName = _getVariableName(path, name);
    }

    return Token(
      name: name,
      type: type ?? this.type,
      value: value ?? this.value,
      path: path ?? this.path,
      extensions: extensions ?? this.extensions,
      description: description ?? this.description,
      deprecated: deprecated ?? this.deprecated,
      variableName: variableName ?? this.variableName,
    );
  }

  Token resolveAllReferences(
    Map<String, Token> tokenMap, [
    Map<String, dynamic>? originalDocument,
  ]) {
    Token? token = this;

    // Handle JSON Pointer references first
    if (token._hasJsonPointerReference && originalDocument != null) {
      token = token._resolveJsonPointerReference(originalDocument, tokenMap);
    }

    if (_hasColorReference) {
      token = token._resolveColorReferences(tokenMap);
    }

    if (_hasMathExpression) {
      token = token._resolveMathExpression(tokenMap);
    }

    if (token._hasTokenReferences == true) {
      if (token.valueAsString?.isTokenReference == true) {
        final reference =
            tokenMap[token.valueByRef]?.resolveAllReferences(tokenMap, originalDocument);
        if (reference == null) {
          throw ResolveTokenException(
            'Reference not found for `${token.valueByRef}`',
          );
        }

        token = token.copyWith(
          value: reference.value,
          type: type ?? reference.type,
        );
      } else {
        var resolved = token.valueAsString!;
        var match = RegExp(r'{(.*?)}').firstMatch(resolved);
        String? type = this.type;
        while (match != null) {
          final reference =
              tokenMap[match.group(1)]?.resolveAllReferences(tokenMap, originalDocument);
          if (reference == null) {
            throw ResolveTokenException(
              'Reference not found for `${match.group(1)}`',
            );
          }

          // If the type is not set yet, set it to the type of the first reference
          type = type ?? reference.type;

          resolved = resolved.replaceRange(
            match.start,
            match.end,
            reference.value.toString(),
          );

          match = RegExp(r'{(.*?)}').firstMatch(resolved);
        }

        token = token.copyWith(
          value: resolved,
          type: type,
        );
      }
    }

    return token._resolveValueReferences(tokenMap, originalDocument);
  }

  /// Resolves a JSON Pointer reference ($ref).
  Token _resolveJsonPointerReference(
    Map<String, dynamic> originalDocument,
    Map<String, Token> tokenMap,
  ) {
    final valueMap = value as Map<String, dynamic>;
    final ref = valueMap['\$ref'] as String;
    
    if (!JsonPointer.isValid(ref)) {
      throw ResolveTokenException(
        'Invalid JSON Pointer: $ref',
      );
    }

    try {
      final resolvedValue = JsonPointer.resolve(ref, originalDocument);
      
      // If the resolved value is a token reference path, resolve it
      if (resolvedValue is String && resolvedValue.startsWith('{') && resolvedValue.endsWith('}')) {
        final tokenPath = resolvedValue.substring(1, resolvedValue.length - 1);
        final referencedToken = tokenMap[tokenPath]?.resolveAllReferences(tokenMap, originalDocument);
        if (referencedToken == null) {
          throw ResolveTokenException(
            'Token reference not found for JSON Pointer: $ref -> $tokenPath',
          );
        }
        return copyWith(
          value: referencedToken.value,
          type: type ?? referencedToken.type,
        );
      }
      
      return copyWith(value: resolvedValue);
    } catch (e) {
      if (e is ResolveTokenException) {
        rethrow;
      }
      throw ResolveTokenException(
        'Failed to resolve JSON Pointer $ref: $e',
      );
    }
  }

  /// Resolves all references in the value of this token.
  /// This is done recursively in case the value Map has a Map as value as well.
  ///
  /// Example:
  ///
  /// ```json
  /// {
  ///   "colors": {
  ///     "primary": {
  ///       "value": "#FF0000",
  ///       "type": "color"
  ///     }
  ///   },
  ///   "component": {
  ///     "value": {
  ///       "color": "$colors.primary"
  ///     },
  ///     "type": "component"
  ///   }
  /// }
  /// ```
  Token _resolveValueReferences(
    Map<String, Token> tokenMap, [
    Map<String, dynamic>? originalDocument,
  ]) {
    // Loop through all values and resolve references recursively
    if (value is Map<String, dynamic>) {
      final resolved = _resolvedValue(value as Map<String, dynamic>, tokenMap, originalDocument);
      return copyWith(value: resolved);
    }

    // Loop through all values in the list and resolve references recursively if they are a Map
    if (value is List) {
      final resolvedList = <dynamic>[];
      for (final element in (value as List)) {
        if (element is Map<String, dynamic>) {
          final resolved = _resolvedValue(element, tokenMap, originalDocument);
          resolvedList.add(resolved);
        } else {
          resolvedList.add(element);
        }
      }
      return copyWith(value: resolvedList);
    }

    return this;
  }

  /// Resolves all references in the given value Map recursively.
  Map<String, dynamic> _resolvedValue(
    Map<String, dynamic> value,
    Map<String, Token> tokenMap,
    Map<String, dynamic>? originalDocument,
  ) {
    final resolved = <String, dynamic>{};

    for (var entry in value.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value is Map<String, dynamic>) {
        // Check for JSON Pointer reference
        if (value.containsKey('\$ref') && value['\$ref'] is String && originalDocument != null) {
          try {
            final ref = value['\$ref'] as String;
            resolved[key] = JsonPointer.resolve(ref, originalDocument);
          } catch (e) {
            if (e is ResolveTokenException) {
              rethrow;
            }
            throw ResolveTokenException(
              'Failed to resolve JSON Pointer in value: $e',
            );
          }
        } else {
          resolved[key] = _resolvedValue(value, tokenMap, originalDocument);
        }
      } else if (value is String && value.isColorReference) {
        final color = _resolveColorValue(value, tokenMap);
        if (color != null) {
          resolved[key] = color;
        }
      } else if (value is String && value.isTokenReference) {
        final refKey = value.valueByRef;
        resolved[key] = tokenMap[refKey]?.resolveAllReferences(tokenMap, originalDocument).value;
      } else {
        resolved[key] = value;
      }
    }

    return resolved;
  }

  // If the value is a reference and starts with 'rgba', we need to
  // resolve the reference to the color token and use the value of that
  // token as the value of this token. See [references_test.dart:145] for
  // an example. Eg: rgba({brand.500}, 0.5) => rgba(255, 255, 255, 0.5)
  Token _resolveColorReferences(Map<String, Token> tokenMap) {
    final value = _resolveColorValue(valueAsString!, tokenMap);
    if (value != null) {
      return copyWith(value: value);
    }
    return this;
  }

  Token _resolveMathExpression(Map<String, Token> tokenMap) {
    // 支持带空格和不带空格的 * / +，以及二元减号。
    // 二元减号须为「两侧有空格的 -」，避免把路径里的连字符（如 sizing-base）、
    // 纯数字里的负号（-0.5）、或「{a} - -12」里操作数的负号误判为运算符。
    // 不使用带捕获组的 split，避免 Dart 把捕获段插入 split 结果导致左右操作数错位。
    final operatorPattern = RegExp(
      r'\s+-\s+|\s*[*/]\s*|\s*\+\s*',
    );
    final match = operatorPattern.firstMatch(valueAsString!);

    if (match == null) {
      throw FormatException(
        'Could not find operator in math expression for Token $name (path: $path) `$valueAsString`',
      );
    }

    final matchedOp = match.group(0)!;
    final isMultiply = matchedOp.contains('*');
    final isDivide = matchedOp.contains('/');
    final isAdd = matchedOp.contains('+');
    final isSubtract =
        matchedOp.contains('-') && !isMultiply && !isDivide && !isAdd;

    final splitted = valueAsString!.split(operatorPattern);
    if (splitted.length < 2) {
      throw FormatException(
        'Could not parse math expression for Token $name (path: $path) `$valueAsString`',
      );
    }

    final leftPart = splitted[0].trim();
    final rightPart = splitted[1].trim();

    final leftValue = leftPart.isTokenReference
        ? tokenMap[leftPart.valueByRef]?.resolveAllReferences(tokenMap).value
        : leftPart;
    final rightValue = rightPart.isTokenReference
        ? tokenMap[rightPart.valueByRef]?.resolveAllReferences(tokenMap).value
        : rightPart;

    final left = DimensionValue.maybeParse(leftValue);
    final right = DimensionValue.maybeParse(rightValue);

    if (left == null || right == null) {
      throw FormatException(
        'Could not parse math expression for Token $name (path: $path) `$valueAsString`',
      );
    }

    double? solved = 0.0;
    if (isMultiply) {
      solved = left.value * right.value;
    } else if (isDivide) {
      solved = left.value / right.value;
    } else if (isAdd) {
      solved = left.value + right.value;
    } else if (isSubtract) {
      solved = left.value - right.value;
    }
    // Fails if function like `roundTo(). Should throw. Note: NaN if division.
    // if (solved.isNaN) {
    //   print('solved to `$solved` for $this');
    // } else if (solved == 0.0) {
    //   print('solved to `0.0` for $this');
    // }

    return copyWith(value: solved);
  }

  @override
  String toString() {
    return ('{"value": $value, "type": "$type", "path": "$path", "name": "$name", "variableName": "$variableName" }\n');
  }
}

String? _resolveColorValue(String initialValue, Map<String, Token> tokenMap) {
  var value = initialValue;
  var match = RegExp(r'{(.*?)}').firstMatch(initialValue);
  while (match != null) {
    final reference = tokenMap[match.group(1)]?.resolveAllReferences(tokenMap);
    if (reference == null) {
      throw ResolveTokenException(
        'Reference not found for `${match.group(1)}`',
      );
    }
    final color = ColorValue.maybeParse(reference.value)
        ?.applyStudioExtension(reference.extensions);
    if (color == null) {
      return null;
      // throw ResolveTokenException(
      //   'Could not parse color for `${reference.value}` originating from `${match.group(1)}`',
      // );
    }

    // Check if is inside a rgba() function
    final isRgb =
        value.substring(max(0, match.start - 7), match.start).contains('rgba(');
    final String replaceWith;
    if (isRgb) {
      replaceWith = color.toRgb().join(', ');
    } else {
      replaceWith = color.toHex();
    }

    value = value.replaceRange(
      match.start,
      match.end,
      replaceWith,
    );

    // Search next match
    match = RegExp(r'{(.*?)}').firstMatch(value);
  }
  return value;
}

/// Makes variable name compatible with Dart name requireents
/// Path + name with all dots, spaces, special chars removed and in camelCase
String _getVariableName(String path, String name) {
  final parts = path
      .split('.')
      .where((e) => e.isNotEmpty)
      .map((e) => e.alphanumeric)
      .toList()
    ..add(name.alphanumeric);
  return parts.join(' ').camelCase;
}
