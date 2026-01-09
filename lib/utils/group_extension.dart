import 'package:figma2flutter/exceptions/resolve_token_exception.dart';
import 'package:figma2flutter/utils/json_pointer.dart';

/// Handles group extension ($extends) resolution and deep merging.
/// 
/// Group extension allows a group to inherit tokens and properties from
/// another group, with local overrides taking precedence.
class GroupExtension {
  /// Resolves a group extension reference.
  /// 
  /// [extendsValue] - The \$extends value (can be {group} syntax or JSON Pointer)
  /// [document] - The full document to resolve against
  /// 
  /// Returns the resolved group structure.
  static Map<String, dynamic> resolveExtension(
    dynamic extendsValue,
    Map<String, dynamic> document,
  ) {
    if (extendsValue is! String) {
      throw ResolveTokenException(
        'Invalid \$extends value: must be a string',
      );
    }

    Map<String, dynamic>? targetGroup;

    // Check if it's a JSON Pointer
    if (extendsValue.startsWith('#')) {
      try {
        final resolved = JsonPointer.resolve(extendsValue, document);
        if (resolved is Map<String, dynamic>) {
          targetGroup = resolved;
        } else {
          throw ResolveTokenException(
            'JSON Pointer \$extends must resolve to a group (Map), got: ${resolved.runtimeType}',
          );
        }
      } catch (e) {
        if (e is ResolveTokenException) {
          rethrow;
        }
        throw ResolveTokenException(
          'Failed to resolve JSON Pointer in \$extends: $e',
        );
      }
    } else if (extendsValue.startsWith('{') && extendsValue.endsWith('}')) {
      // Curly brace syntax: {group.name}
      final groupPath = extendsValue.substring(1, extendsValue.length - 1);
      targetGroup = _resolveGroupByPath(groupPath, document);
    } else {
      throw ResolveTokenException(
        'Invalid \$extends syntax: $extendsValue. Must be {group} or JSON Pointer',
      );
    }

    if (targetGroup == null) {
      throw ResolveTokenException(
        'Group not found for \$extends: $extendsValue',
      );
    }

    return targetGroup;
  }

  /// Resolves a group by path (dot-separated).
  static Map<String, dynamic>? _resolveGroupByPath(
    String path,
    Map<String, dynamic> document,
  ) {
    final segments = path.split('.');
    dynamic current = document;

    for (var segment in segments) {
      if (current is Map<String, dynamic>) {
        if (!current.containsKey(segment)) {
          return null;
        }
        current = current[segment];
      } else {
        return null;
      }
    }

    if (current is Map<String, dynamic>) {
      // Check if it's a group (doesn't have $value, value, or $ref)
      final hasValue = current.containsKey('\$value') || current.containsKey('value');
      final hasRef = current.containsKey('\$ref') && current['\$ref'] is String;
      if (!hasValue && !hasRef) {
        return current;
      }
    }

    return null;
  }

  /// Performs deep merge of two groups.
  /// 
  /// Local properties override inherited properties at the same path.
  /// New local properties are added alongside inherited ones.
  static Map<String, dynamic> deepMerge(
    Map<String, dynamic> inherited,
    Map<String, dynamic> local,
  ) {
    final merged = Map<String, dynamic>.from(inherited);

    for (var entry in local.entries) {
      final key = entry.key;
      final localValue = entry.value;

      // Skip $extends as it's already processed
      if (key == '\$extends') {
        continue;
      }

      if (merged.containsKey(key)) {
        final inheritedValue = merged[key];

        // If both are maps, merge recursively
        if (inheritedValue is Map<String, dynamic> &&
            localValue is Map<String, dynamic>) {
        // Check if either is a token (has $value or $ref)
        // A token is identified by having $value, value, or $ref property
        final inheritedIsToken = inheritedValue.containsKey('\$value') ||
            inheritedValue.containsKey('value') ||
            (inheritedValue.containsKey('\$ref') && inheritedValue['\$ref'] is String);
        final localIsToken = localValue.containsKey('\$value') ||
            localValue.containsKey('value') ||
            (localValue.containsKey('\$ref') && localValue['\$ref'] is String);

          // If both are tokens or both are groups, local overrides completely
          if (inheritedIsToken == localIsToken) {
            if (inheritedIsToken) {
              // Both are tokens: local completely replaces inherited
              merged[key] = localValue;
            } else {
              // Both are groups: merge recursively
              merged[key] = deepMerge(inheritedValue, localValue);
            }
          } else {
            // One is token, one is group: local overrides
            merged[key] = localValue;
          }
        } else {
          // Local value completely replaces inherited value
          merged[key] = localValue;
        }
      } else {
        // New property: add it
        merged[key] = localValue;
      }
    }

    return merged;
  }

  /// Detects circular references in group extensions.
  /// 
  /// [groupPath] - The path of the group being checked
  /// [document] - The full document
  /// [visited] - Set of visited group paths (for cycle detection)
  /// 
  /// Throws [ResolveTokenException] if a circular reference is detected.
  static void detectCircularReference(
    String groupPath,
    Map<String, dynamic> document,
    Set<String> visited,
  ) {
    if (visited.contains(groupPath)) {
      throw ResolveTokenException(
        'Circular reference detected in group extensions: ${visited.join(' -> ')} -> $groupPath',
      );
    }

    visited.add(groupPath);

    final group = _resolveGroupByPath(groupPath, document);
    if (group == null) {
      visited.remove(groupPath);
      return;
    }

    final extendsValue = group['\$extends'];
    if (extendsValue is String) {
      String? extendsPath;
      if (extendsValue.startsWith('{') && extendsValue.endsWith('}')) {
        extendsPath = extendsValue.substring(1, extendsValue.length - 1);
      } else if (extendsValue.startsWith('#')) {
        // For JSON Pointer, we need to extract the path
        // This is simplified - in practice, we'd need to resolve and track
        extendsPath = extendsValue;
      }

      if (extendsPath != null) {
        if (extendsPath.startsWith('#')) {
          // JSON Pointer - we can't easily track the path for cycle detection
          // This is a limitation - we'd need to resolve and track the actual group path
          // For now, we'll skip cycle detection for JSON Pointer references
        } else {
          detectCircularReference(extendsPath, document, visited);
        }
      }
    }

    visited.remove(groupPath);
  }
}
