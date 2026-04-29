# 共享类生成问题分析

## 问题描述

在生成的代码中，`SpacingTokens`、`TextStyleTokens`、`RadiiTokens` 都有 Light 和 Dark 两个主题的实现，但它们的内容完全相同。

## 当前情况

### 主题配置

**Light 主题**:
```json
{
  "name": "light",
  "selectedTokenSets": {
    "core": "source",
    "light": "enabled",
    "theme": "enabled"
  }
}
```
`theme.sets = ["core", "light", "theme"]`

**Dark 主题**:
```json
{
  "name": "dark",
  "selectedTokenSets": {
    "core": "source",
    "dark": "enabled",
    "theme": "enabled"
  }
}
```
`theme.sets = ["core", "dark", "theme"]`

### Token 来源

- **SpacingTokens**: 所有 token 都来自 `core` token set
- **TextStyleTokens**: 所有 token 都来自 `core` token set  
- **RadiiTokens**: 所有 token 都来自 `core` token set

### 生成的代码

```dart
// Light 和 Dark 的内容完全相同
class LightSpacingTokens extends SpacingTokens {
  EdgeInsets get spacingXs => const EdgeInsets.all(4.0);
  // ... 其他属性
}

class DarkSpacingTokens extends SpacingTokens {
  EdgeInsets get spacingXs => const EdgeInsets.all(4.0);
  // ... 其他属性（完全相同）
}
```

## 问题根源

当前的 `_detectSharedClasses()` 实现：

```dart
final setsSignature = theme.sets.join(',');
final contentSignature = transformer.lines.join('\n');
final combinedSignature = '$setsSignature|$contentSignature';
```

**问题**：
- Light 主题的 `setsSignature` = `"core,light,theme"`
- Dark 主题的 `setsSignature` = `"core,dark,theme"`
- 因为 sets 不同，即使 transformer 内容相同，也不会生成共享类

## 期望行为

如果某个 transformer 的所有 token 都来自两个主题都选择的 token set（比如都来自 `core`），那么应该生成共享类。

例如：
- Light 选择了 `["core", "light", "theme"]`
- Dark 选择了 `["core", "dark", "theme"]`
- SpacingTokens 的所有 token 都来自 `core`
- 因为 `core` 在两个主题中都存在，且内容相同，应该生成 `SharedSpacingTokens`

## 解决方案

需要更细粒度的判断逻辑：

1. **方案 1**: 根据 token 的来源 token set 判断
   - 需要跟踪每个 token 来自哪个 token set
   - 如果 transformer 中的所有 token 都来自两个主题都选择的 token set，则共享
   - **问题**: 当前实现中，token 在解析时已经被合并，无法直接知道来源

2. **方案 2**: 根据 transformer 内容 + 共同选择的 token set 判断
   - 找出两个主题都选择的 token set（交集）
   - 如果 transformer 内容相同，且内容完全来自这些共同的 token set，则共享
   - **问题**: 无法确定 transformer 内容是否完全来自共同的 token set

3. **方案 3**: 简化判断 - 如果 transformer 内容相同，且两个主题都选择了某个共同的 token set，则共享
   - 更宽松的条件：只要内容相同，且存在共同的 token set，就共享
   - **问题**: 可能误判（如果内容来自不同的 token set，但恰好相同）

4. **方案 4**: 根据 transformer 名称和内容判断，不考虑 sets
   - 如果 transformer 内容完全相同，就共享
   - **问题**: 这回到了最初的问题，可能合并不应该合并的主题

## 推荐方案

**方案 3 的改进版**：
- 如果两个主题的 transformer 内容相同
- 且两个主题都选择了至少一个共同的 token set
- 则生成共享类

这样可以处理大多数情况：
- ✅ SpacingTokens 来自 `core`，两个主题都选择了 `core` → 共享
- ✅ TextStyleTokens 来自 `core`，两个主题都选择了 `core` → 共享
- ✅ RadiiTokens 来自 `core`，两个主题都选择了 `core` → 共享
- ❌ ColorTokens 可能来自 `light` 和 `dark`，内容不同 → 不共享

## 实现建议

修改 `_detectSharedClasses()` 方法：

```dart
// 检查两个主题是否有共同的 token set
bool hasCommonSets(TokenTheme theme1, TokenTheme theme2) {
  final sets1 = theme1.sets.toSet();
  final sets2 = theme2.sets.toSet();
  return sets1.intersection(sets2).isNotEmpty;
}

// 如果内容相同且有共同 sets，则共享
if (contentSignature1 == contentSignature2 && 
    hasCommonSets(theme1, theme2)) {
  // 生成共享类
}
```
