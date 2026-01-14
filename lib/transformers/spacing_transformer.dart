import 'dart:io';

import 'package:figma2flutter/models/multi_dimension_value.dart';
import 'package:figma2flutter/models/token.dart';
import 'package:figma2flutter/transformers/transformer.dart';

class SpacingTransformer extends SingleTokenTransformer {
  @override
  bool matcher(Token token) => token.type == 'spacing';

  @override
  String get name => 'spacing';

  @override
  String get type => 'double';

  @override
  String transform(Token token) {
    final value = token.value;

    final sizes = MultiDimensionValue.parse(value);

    if (sizes.values.isEmpty) {
      return '0.0';
    }

    // 单个值的情况，返回 double
    if (sizes.values.length == 1) {
      return '${sizes.values[0].value}';
    }

    // 多个值的情况，不支持，输出错误日志并使用第一个值
    stderr.writeln(
      'Warning: Spacing token "${token.name}" at "${token.path}" has multiple values (${sizes.values.length} values), but only single value is supported. '
      'Using the first value (${sizes.values[0].value}). Please use a single value for spacing tokens.',
    );
    
    return '${sizes.values[0].value}';
  }
}
