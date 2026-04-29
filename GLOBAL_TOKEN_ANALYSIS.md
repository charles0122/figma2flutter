# Global 层 Token 生成分析

## 当前情况

### 1. Source 标记的含义

根据 Design Tokens 规范：
- `source`: 表示这是基础数据源，通常用于被其他 token 引用
- `enabled`: 表示这个 token set 在当前主题中被启用，会生成代码

### 2. 当前实现

从代码分析：
- `source` 标记的 token set 会被添加到 `sets` 列表的开头（`sets.insert(0, key)`）
- **但仍然会被处理和生成代码**
- 从生成的代码看，`globalColor*`, `globalSpacing*`, `globalBoder*` 等都被生成了（共 629 个匹配项）

### 3. Global Token 的使用情况

从 JSON 文件分析：
- `global` token 被标记为 `source`
- 其他 token 通过引用使用 global token：
  ```json
  {
    "value": "{global.spacing.base}*2",
    "value": "{global.color.black}",
    "value": "{global.boderRadii.base}*1.5"
  }
  ```

## 问题分析

### 是否需要生成 Global Token？

**两种观点：**

#### 观点 1：不需要生成
- `source` 标记表示这是基础数据，只用于被引用
- 如果所有 global token 都只被引用，不直接使用，则不需要生成
- 可以减少生成的代码量（约 629 个 global token）

#### 观点 2：需要生成
- 某些场景可能需要直接访问 global token（如调试、测试）
- 如果代码中直接使用了 `tokens.color.globalColorBlack`，则需要生成
- 保持 API 的完整性

## 建议方案

### 方案 1：根据 Token Path 过滤（推荐）

在 transformer 的 `process` 方法中，过滤掉 path 以 `global.` 开头的 token：

```dart
@override
void process(Token token) {
  // 跳过 global 层的 token（标记为 source）
  if (token.path.startsWith('global.')) {
    return;
  }
  
  if (matcher(token)) {
    // ... 处理逻辑
  }
}
```

**优点：**
- 简单直接
- 减少生成的代码量
- 符合 Design Tokens 规范中 `source` 的含义

**缺点：**
- 如果确实需要直接访问 global token，会无法使用

### 方案 2：根据 Token Set 标记过滤

在 processor 中，根据 token 的来源 set 是否标记为 `source` 来决定是否生成：

```dart
// 需要跟踪每个 token 来自哪个 set
// 如果该 set 在所有主题中都标记为 source，则不生成
```

**优点：**
- 更符合 Design Tokens 规范
- 可以精确控制哪些 token 不生成

**缺点：**
- 实现复杂，需要跟踪 token 的来源 set
- 需要修改 token 解析逻辑

### 方案 3：配置选项

添加配置选项，允许用户选择是否生成 source token：

```dart
class Options {
  final bool generateSourceTokens; // 默认 false
}
```

**优点：**
- 灵活性高
- 向后兼容

**缺点：**
- 需要额外的配置

## 推荐实现

**推荐使用方案 1**：根据 Token VariableName 过滤

从生成的代码分析：
- Global token 的 variableName 都以 `global` 开头（如 `globalColorBlack`, `globalSpacingBase`, `globalBoderRadiiBase`）
- 可以通过检查 `variableName.startsWith('global')` 来过滤

### 实现方案

在 `SingleTokenTransformer.process` 方法中添加过滤逻辑：

```dart
@override
void process(Token token) {
  // 跳过 global 层的 token（标记为 source，只用于被引用，不需要生成代码）
  if (_isGlobalToken(token)) {
    return;
  }
  
  if (matcher(token)) {
    // ... 处理逻辑
  }
}

/// 检查 token 是否为 global 层的 token（标记为 source）
bool _isGlobalToken(Token token) {
  return token.variableName.startsWith('global');
}
```

在 `MaterialColorTransformer.process` 方法中也添加相同的过滤逻辑。

**优点：**
- 简单直接，只需修改基类
- 减少生成的代码量（约 629 个 global token）
- 保持代码简洁
- 符合 Design Tokens 规范中 `source` 的含义
- 所有 transformer 自动继承此行为

**缺点：**
- 如果确实需要直接访问 global token，会无法使用（但根据分析，没有直接使用的场景）

## 验证结果

1. ✅ 检查生成的代码：没有找到直接使用 `tokens.color.globalColor*` 的代码
2. ✅ 检查测试代码：没有找到依赖 global token 的测试
3. ✅ 确认所有 global token 都只被引用，不直接使用

## 结论

**建议不生成 global 层的 token**，因为：
1. 它们标记为 `source`，表示只用于被引用
2. 没有代码直接使用它们
3. 可以减少约 629 行生成的代码
4. 符合 Design Tokens 规范的最佳实践
