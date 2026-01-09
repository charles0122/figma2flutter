import 'package:figma2flutter/exceptions/process_token_exception.dart';

const kBaseFontSize = 16.0;

/// A value that represents a dimension.
/// This can be a number, a percentage, or a rem value.
/// A percentage is converted to a decimal value between 0 and 1.
/// A rem value is converted to a pixel value based on the base font size (see [kBaseFontSize]).
/// Px values are converted to a double and returned as is.
/// Last but not least, if the value is a number, it is converted to a double and returned as is.
class DimensionValue {
  final double value;

  DimensionValue(this.value);

  static DimensionValue get zero => DimensionValue(0);

  static DimensionValue? maybeParse(dynamic value) {
    if (value == null) return null;

    try {
      return DimensionValue(_parseNum(value.toString()));
    } catch (e) {
      return null;
    }
  }

  @override
  String toString() => value.toString();

  DimensionValue operator /(num divisor) => DimensionValue(value / divisor);
  DimensionValue operator +(num addend) => DimensionValue(value + addend);
  DimensionValue operator -(num difference) =>
      DimensionValue(value - difference);
  DimensionValue operator *(num multiplicand) =>
      DimensionValue(value * multiplicand);

  @override
  bool operator ==(Object other) =>
      other is DimensionValue && value == other.value;

  @override
  int get hashCode => value.hashCode;
}

double _parseNum(String value) {
  // 1px = 1.0
  if (value.endsWith('px')) {
    final numStr = value.substring(0, value.length - 2);
    final parsed = double.tryParse(numStr);
    if (parsed == null) {
      throw ProcessTokenException(
        'Failed to parse pixel value: "$value"',
        FormatException('Cannot parse "$numStr" as a number', value),
      );
    }
    return parsed;
  }

  // 1rem = 16px (base font size)
  if (value.endsWith('rem')) {
    final numStr = value.substring(0, value.length - 3);
    final parsed = double.tryParse(numStr);
    if (parsed == null) {
      throw ProcessTokenException(
        'Failed to parse rem value: "$value"',
        FormatException('Cannot parse "$numStr" as a number', value),
      );
    }
    return parsed * kBaseFontSize;
  }

  // 100% = 1.0
  // 50% = 0.5
  if (value.endsWith('%')) {
    final numStr = value.substring(0, value.length - 1);
    final parsed = double.tryParse(numStr);
    if (parsed == null) {
      throw ProcessTokenException(
        'Failed to parse percentage value: "$value"',
        FormatException('Cannot parse "$numStr" as a number', value),
      );
    }
    return parsed / 100;
  }

  final parsed = double.tryParse(value);
  if (parsed == null) {
    throw ProcessTokenException(
      'Failed to parse numeric value: "$value"',
      FormatException('Cannot parse "$value" as a number', value),
    );
  }
  return parsed;
}
