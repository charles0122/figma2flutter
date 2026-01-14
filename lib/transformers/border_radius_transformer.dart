import 'dart:io';

import 'package:figma2flutter/models/multi_dimension_value.dart';
import 'package:figma2flutter/models/token.dart';
import 'package:figma2flutter/transformers/transformer.dart';

/// https://docs.tokens.studio/available-tokens/border-radius-tokens
///
/// Radius tokens give you the possibility to define values for your border
/// radius. Only single value tokens are supported.
class BorderRadiusTransformer extends SingleTokenTransformer {
  @override
  bool matcher(Token token) {
    return token.type == 'borderRadius';
  }

  @override
  String get name => 'radii';

  @override
  String get type => 'double';

  @override
  String transform(Token token) {
    final dimensions = MultiDimensionValue.parse(token.value);

    if (dimensions.values.isEmpty) {
      return '0.0';
    }

    // 单个值的情况，返回 double
    if (dimensions.values.length == 1) {
      return '${dimensions.values[0].value}';
    }

    // 多个值的情况，不支持，输出错误日志并使用第一个值
    stderr.writeln(
      'Warning: BorderRadius token "${token.name}" at "${token.path}" has multiple values (${dimensions.values.length} values), but only single value is supported. '
      'Using the first value (${dimensions.values[0].value}). Please use a single value for borderRadius tokens.',
    );
    
    return '${dimensions.values[0].value}';
  }
}
