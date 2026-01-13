# 代码审查：项目特定代码 vs 插件通用优化

本文档区分了代码中哪些是**项目特定的**（针对当前 example 项目），哪些是**插件通用的优化**（适用于所有项目）。

## 📋 目录

1. [项目特定代码](#项目特定代码)
2. [插件通用优化](#插件通用优化)
3. [建议的改进](#建议的改进)

---

## 🎯 项目特定代码

这些代码是针对当前项目的特定需求，应该考虑提取为配置或移除硬编码。

### 1. 字体主题过滤 (`_isFontTheme`)

**位置：** `lib/generator.dart:782-789`

```dart
bool _isFontTheme(String themeName) {
  final lowerName = themeName.toLowerCase();
  return (lowerName.contains('ios_ch') || lowerName.contains('iosch')) ||
      (lowerName.contains('ios_eng') || lowerName.contains('ioseng')) ||
      (lowerName.contains('android_ch') || lowerName.contains('androidch')) ||
      (lowerName.contains('android_eng') || lowerName.contains('androideng'));
}
```

**问题：** 硬编码了特定的主题名称模式（`ios_ch`, `ios_eng`, `android_ch`, `android_eng`）

**影响：** 
- 在 `_buildThemeContentMap()` 中跳过字体主题
- 在 `_generateThemeClasses()` 中跳过字体主题
- 在 `_detectSharedClasses()` 中排除字体主题

**建议：** 
- 改为基于主题配置（如 `group: "fontTheme"`）或主题元数据来判断
- 或者提取为可配置的选项

---

### 2. 文本样式自定义代码生成 (`_buildTextStyleCustomCode`)

**位置：** `lib/generator.dart:70-381`

**问题：** 硬编码了特定的文本样式类实现：
- `BaseTextStyleTokens` - 包含硬编码的字体大小、行高等
- `IosChTextStyleTokens`, `IosEngTextStyleTokens`, `AndroidChTextStyleTokens`, `AndroidEngTextStyleTokens` - 硬编码的字体族
- `AdaptiveTextStyleTokens` - 硬编码的平台/地区检测逻辑

**影响：** 
- 这些类名和实现是项目特定的
- 字体族名称（`'PingFang SC'`, `'SF Pro'`, `'Inter'`）是硬编码的
- 文本样式属性（fontSize, fontWeight, height）是硬编码的

**建议：** 
- 将这些代码移到 `example/lib/generated/tokens_custom.dart`（手动维护）
- 或者从 JSON 配置中读取这些值
- 或者通过 transformer 的 `extraDeclaration()` 机制提供

---

### 3. MaterialColor 生成禁用

**位置：** `lib/generator.dart` 多处

**问题：** 完全禁用了 `MaterialColor` 的生成：
- `_buildInterfaces()`: 过滤掉 `materialColor`
- `_buildThemeContentMap()`: 跳过 `materialColor` transformer
- `_generateSharedClasses()`: 排除 `materialColor` 共享类生成
- `_generateThemeClasses()`: 跳过 `materialColor` transformer

**影响：** 所有项目都无法生成 `MaterialColor` 相关代码

**建议：** 
- 改为可配置选项（通过配置或命令行参数）
- 或者基于 transformer 的配置来决定是否生成

---

### 4. TextStyle 生成策略

**位置：** `lib/generator.dart` 多处

**问题：** 特定的生成策略：
- 只生成 `TextStyleTokens` 抽象类接口
- 不生成具体的实现类（除了自定义代码中的）
- 在 `ITokens` 接口中包含 `textStyle` getter
- 在实现类中使用 `AdaptiveTextStyleTokens()`

**影响：** 所有项目都必须使用这种策略

**建议：** 
- 改为可配置选项
- 或者基于 transformer 的配置来决定生成策略

---

## ✅ 插件通用优化

这些是通用的改进，适用于所有项目。

### 1. Source Set 过滤 (`_isSourceToken`)

**位置：** `lib/transformers/transformer.dart:28-45`

**功能：** 根据 token 的 `source` 状态过滤，而不是基于命名约定

**优点：** 
- 基于数据驱动（`sourceSets` 和 `tokenKeyToSet`）
- 不依赖命名约定
- 适用于所有项目

**实现：** 
- `TokenTheme` 跟踪 `sourceSets` 和 `tokenKeyToSet` 映射
- `Transformer` 基类提供 `_isSourceToken()` 方法
- `SingleTokenTransformer.process()` 自动过滤 source tokens

---

### 2. 无空格数学表达式支持

**位置：** 
- `lib/extensions/string.dart:34-39`
- `lib/models/token.dart:338-346`

**功能：** 支持不带空格的数学表达式（如 `{token}*0.25`）

**优点：** 
- 符合更多设计工具的导出格式
- 向后兼容（仍然支持带空格的表达式）

**改进：** 
- `isMathExpression`: 使用正则表达式 `\s*[*/+-]\s*` 而不是固定字符串
- `_resolveMathExpression`: 使用相同的正则表达式进行 split

---

### 3. Token Key 到 Set 映射 (`tokenKeyToSet`)

**位置：** `lib/token_parser.dart:51-113`, `lib/models/token_theme.dart:19`

**功能：** 跟踪每个 token 来自哪个 set，用于 source set 过滤

**优点：** 
- 数据驱动，不依赖命名约定
- 支持复杂的 set 结构
- 适用于所有项目

**实现：** 
- 在 `TokenParser.parse()` 中建立映射
- 在 `_postProcess` 前后建立对应关系
- 存储在 `TokenTheme.tokenKeyToSet` 中

---

### 4. 共享类生成优化

**位置：** `lib/generator.dart:553-625`

**功能：** 自动检测并生成共享的 transformer 类

**优点：** 
- 减少代码重复
- 适用于所有项目
- 基于内容签名自动检测

---

## 🔧 建议的改进

### 1. 提取项目特定配置

创建配置文件或选项来管理项目特定的行为：

```dart
class GeneratorConfig {
  // 字体主题识别模式（可配置）
  final List<String> fontThemePatterns;
  
  // 是否生成 MaterialColor
  final bool generateMaterialColor;
  
  // TextStyle 生成策略
  final TextStyleGenerationStrategy textStyleStrategy;
  
  // 自定义代码生成器
  final String? Function(List<TokenTheme>)? customCodeGenerator;
}
```

### 2. 使用 Transformer 配置

通过 transformer 的配置来决定生成策略，而不是硬编码：

```dart
// 在 transformer 中
bool get shouldGenerate => !config.disabled;
bool get generateInterfaceOnly => config.interfaceOnly;
```

### 3. 基于元数据判断

使用主题/集的元数据来判断，而不是硬编码名称：

```dart
// 基于 group 或 metadata
bool _isFontTheme(TokenTheme theme) {
  return theme.metadata?['group'] == 'fontTheme';
}
```

### 4. 自定义代码生成机制

提供更灵活的机制来注入自定义代码：

```dart
// 通过 extraDeclaration() 或配置
String? customCodeGenerator(List<TokenTheme> themes) {
  // 从配置文件或模板读取
}
```

---

## 📝 总结

### 项目特定代码（需要提取或配置化）：
1. ✅ `_isFontTheme()` - 硬编码主题名称模式
2. ✅ `_buildTextStyleCustomCode()` - 硬编码文本样式实现
3. ✅ MaterialColor 生成禁用 - 硬编码过滤逻辑
4. ✅ TextStyle 生成策略 - 硬编码策略

### 插件通用优化（保留）：
1. ✅ `_isSourceToken()` - 基于 source set 的过滤
2. ✅ 无空格数学表达式支持 - 通用改进
3. ✅ `tokenKeyToSet` 映射 - 数据驱动的跟踪
4. ✅ 共享类生成 - 通用优化

### 建议行动：
1. 🔄 将项目特定代码提取为配置
2. 🔄 使用元数据或配置来判断，而不是硬编码
3. 🔄 提供自定义代码生成机制
4. 🔄 保持通用优化不变
