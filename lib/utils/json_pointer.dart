import 'package:figma2flutter/exceptions/resolve_token_exception.dart';

/// JSON Pointer parser following RFC 6901 specification.
/// 
/// JSON Pointer defines a string syntax for identifying a specific value
/// within a JSON document. It uses a sequence of reference tokens separated
/// by '/' characters.
/// 
/// Example: #/colors/blue/$value
class JsonPointer {
  /// Parse a JSON Pointer string and resolve it against a document.
  /// 
  /// [pointer] - The JSON Pointer string (e.g., "#/colors/blue/$value")
  /// [document] - The root document to resolve against
  /// 
  /// Returns the resolved value, or throws [ResolveTokenException] if not found.
  static dynamic resolve(String pointer, Map<String, dynamic> document) {
    if (!pointer.startsWith('#')) {
      throw ResolveTokenException(
        'JSON Pointer must start with "#": $pointer',
      );
    }

    // Remove the '#' prefix
    final path = pointer.substring(1);
    
    // Empty path refers to the root document
    if (path.isEmpty || path == '/') {
      return document;
    }

    // Split the path into segments
    final segments = _parseSegments(path);
    
    // Navigate through the document
    dynamic current = document;
    
    for (var segment in segments) {
      if (current is Map<String, dynamic>) {
        if (!current.containsKey(segment)) {
          throw ResolveTokenException(
            'JSON Pointer path not found: $pointer (segment: $segment)',
          );
        }
        current = current[segment];
      } else if (current is List) {
        final index = int.tryParse(segment);
        if (index == null || index < 0 || index >= current.length) {
          throw ResolveTokenException(
            'JSON Pointer array index out of bounds: $pointer (index: $segment)',
          );
        }
        current = current[index];
      } else {
        throw ResolveTokenException(
          'JSON Pointer cannot traverse through non-object/non-array: $pointer',
        );
      }
    }
    
    return current;
  }

  /// Parse JSON Pointer segments, handling escape sequences.
  /// 
  /// According to RFC 6901:
  /// - '~0' represents '~'
  /// - '~1' represents '/'
  static List<String> _parseSegments(String path) {
    if (!path.startsWith('/')) {
      throw ResolveTokenException(
        'JSON Pointer path must start with "/": $path',
      );
    }

    // Remove leading '/'
    final pathWithoutLeading = path.substring(1);
    
    if (pathWithoutLeading.isEmpty) {
      return [];
    }

    // Split by '/' and unescape each segment
    final segments = pathWithoutLeading.split('/');
    return segments.map(_unescape).toList();
  }

  /// Unescape a JSON Pointer segment.
  /// 
  /// According to RFC 6901:
  /// - '~0' represents '~' (escaped tilde)
  /// - '~1' represents '/' (escaped slash)
  /// 
  /// Note: The order matters - we replace '~1' first, then '~0'.
  /// This is safe because '~1' and '~0' are distinct sequences and don't overlap.
  /// For example, '~10' is not an escape sequence (it's literal '~' + '1' + '0').
  static String _unescape(String segment) {
    return segment.replaceAll('~1', '/').replaceAll('~0', '~');
  }

  /// Escape a string for use in a JSON Pointer segment.
  /// 
  /// Replaces '~' with '~0' and '/' with '~1'.
  static String escape(String segment) {
    return segment.replaceAll('~', '~0').replaceAll('/', '~1');
  }

  /// Check if a string is a valid JSON Pointer.
  static bool isValid(String pointer) {
    if (!pointer.startsWith('#')) {
      return false;
    }
    
    final path = pointer.substring(1);
    if (path.isEmpty) {
      return true; // Empty path is valid (refers to root)
    }
    
    if (!path.startsWith('/')) {
      return false;
    }
    
    return true;
  }
}
