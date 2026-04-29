# Design Tokens Format Module 2025.10 功能分析

基于 [Design Tokens Format Module 2025.10](https://www.designtokens.org/tr/2025.10/format/) 规范，本文档分析了哪些功能值得在 figma2flutter 中实现。

## 📊 当前实现状态

### ✅ 已实现的功能

1. **基础 Token 属性**
   - ✅ `$value` / `value` 支持
   - ✅ `$type` / `type` 支持
   - ✅ `$description` / `description` 支持
   - ✅ `$deprecated` / `deprecated` 支持（刚实现）
   - ✅ `$extensions` 支持

2. **Groups（组）**
   - ✅ 基本组结构支持
   - ✅ 嵌套组支持
   - ✅ 组类型继承（`$type` 在组级别）

3. **引用/别名（References）**
   - ✅ 花括号语法 `{group.token}` 支持
   - ✅ 链式引用支持
   - ✅ 循环引用检测
   - ✅ 复合类型中的引用支持

4. **类型支持**
   - ✅ `color` - 完整支持（hex, rgb, rgba, hsl, hsla）
   - ✅ `dimension` - 支持（px, rem）
   - ✅ `typography` - 完整支持
   - ✅ `border` - 基本支持
   - ✅ `shadow` - 支持（单个和数组）
   - ✅ `gradient` - 支持
   - ✅ `fontFamily` - 支持
   - ✅ `fontWeight` - 支持
   - ✅ `sizing` - 支持
   - ✅ `spacing` - 支持
   - ✅ `borderRadius` - 支持

5. **其他功能**
   - ✅ 数学表达式（+、-、*、/）
   - ✅ 颜色修饰符（lighten, darken, mix, alpha）
   - ✅ 主题（Themes）支持
   - ✅ Sets 支持

---

## 🎯 值得实现的功能（按优先级排序）

### 🔴 高优先级 - 规范要求必须支持

#### 1. **JSON Pointer 支持** ⭐⭐⭐⭐⭐
**规范要求：** `MUST` 支持（必须）

**当前状态：** ❌ 未实现

**实现价值：**
- 规范要求必须支持，这是合规性问题
- 支持属性级引用（property-level references）
- 可以访问复合类型中的特定属性
- 更灵活的引用方式

**实现难度：** 中等

**示例：**
```json
{
  "colors": {
    "blue": {
      "$value": {
        "colorSpace": "srgb",
        "components": [0.2, 0.4, 0.9],
        "hex": "#3366e6"
      }
    }
  },
  "semantic": {
    "primary": {
      "$ref": "#/colors/blue/$value",
      "$type": "color"
    },
    "primaryHue": {
      "$ref": "#/colors/blue/$value/components/0",
      "$type": "number"
    }
  }
}
```

**实现建议：**
- 在 `Token` 类中添加 `$ref` 属性检测
- 实现 JSON Pointer 解析器（RFC 6901）
- 在 `resolveAllReferences` 中处理 `$ref`
- 支持转义字符（`~0`, `~1`）

---

#### 2. **Group Extension ($extends)** ⭐⭐⭐⭐⭐
**规范要求：** `MAY` 支持（推荐）

**当前状态：** ❌ 未实现

**实现价值：**
- 支持组继承，减少重复代码
- 支持覆盖继承的属性
- 符合 DRY 原则
- 语义上等同于 JSON Schema `$ref`

**实现难度：** 高

**示例：**
```json
{
  "button": {
    "$type": "color",
    "background": {
      "$value": {"colorSpace": "srgb", "components": [0, 0.4, 0.8]}
    },
    "text": {
      "$value": {"colorSpace": "srgb", "components": [1, 1, 1]}
    }
  },
  "button-primary": {
    "$extends": "{button}",
    "background": {
      "$value": {"colorSpace": "srgb", "components": [0.8, 0, 0.4]}
    }
  }
}
```

**实现建议：**
- 在 `TokenParser` 中检测 `$extends` 属性
- 实现深度合并（deep merge）逻辑
- 处理循环引用检测
- 支持多级继承

---

#### 3. **Root Tokens ($root)** ⭐⭐⭐⭐
**规范要求：** `MAY` 支持（推荐）

**当前状态：** ❌ 未实现

**实现价值：**
- 允许组有根 token，提供基础值
- 支持变体和扩展模式
- 更清晰的语义结构

**实现难度：** 低-中等

**示例：**
```json
{
  "color": {
    "accent": {
      "$root": {
        "$type": "color",
        "$value": {"colorSpace": "srgb", "components": [0.867, 0, 0]}
      },
      "light": {
        "$type": "color",
        "$value": {"colorSpace": "srgb", "components": [1, 0.133, 0.133]}
      }
    }
  }
}
```

**实现建议：**
- 在 `findTokens` 中特殊处理 `$root` 键
- 路径构造时包含 `$root`
- 确保 `{color.accent.$root}` 可以正确解析

---

### 🟡 中优先级 - 增强功能

#### 4. **Property-Level References（属性级引用）** ⭐⭐⭐⭐
**规范要求：** 通过 JSON Pointer 实现

**当前状态：** ❌ 未实现（依赖 JSON Pointer）

**实现价值：**
- 可以引用复合类型中的特定属性
- 支持细粒度的值复用
- 例如：只复用颜色的某个组件

**实现难度：** 中等（需要先实现 JSON Pointer）

**示例：**
```json
{
  "base": {
    "blue": {
      "$value": {
        "colorSpace": "srgb",
        "components": [0.2, 0.4, 0.9]
      }
    }
  },
  "semantic": {
    "primary": {
      "$value": {
        "colorSpace": "srgb",
        "components": [
          {"$ref": "#/base/blue/$value/components/0"},
          {"$ref": "#/base/blue/$value/components/1"},
          0.7
        ]
      }
    }
  }
}
```

---

#### 5. **Duration 类型** ⭐⭐⭐
**规范要求：** 标准类型

**当前状态：** ❌ 未实现

**实现价值：**
- 支持动画时长 token
- Flutter 中对应 `Duration` 类型
- 相对简单，容易实现

**实现难度：** 低

**示例：**
```json
{
  "duration-quick": {
    "$value": {"value": 100, "unit": "ms"},
    "$type": "duration"
  }
}
```

**Flutter 输出：**
```dart
Duration get durationQuick => const Duration(milliseconds: 100);
```

---

#### 6. **Cubic Bézier 类型** ⭐⭐⭐
**规范要求：** 标准类型

**当前状态：** ❌ 未实现

**实现价值：**
- 支持动画曲线 token
- Flutter 中对应 `Curves` 或自定义 `Cubic`
- 对动画设计很有用

**实现难度：** 低-中等

**示例：**
```json
{
  "ease-in": {
    "$value": [0.5, 0, 1, 1],
    "$type": "cubicBezier"
  }
}
```

**Flutter 输出：**
```dart
Cubic get easeIn => const Cubic(0.5, 0, 1, 1);
```

---

#### 7. **Stroke Style 增强** ⭐⭐⭐
**规范要求：** 标准复合类型

**当前状态：** ⚠️ 部分支持（仅支持 `solid`）

**实现价值：**
- 支持虚线、点线等样式
- 支持自定义 dashArray
- 对边框设计很重要

**实现难度：** 中等

**需要实现：**
- `dashed`、`dotted` 等字符串值
- 对象值：`dashArray` + `lineCap`
- Flutter 中对应 `BorderStyle` 和自定义绘制

---

#### 8. **Transition 复合类型** ⭐⭐⭐
**规范要求：** 标准复合类型

**当前状态：** ❌ 未实现

**实现价值：**
- 完整的动画过渡定义
- 包含 duration、delay、timingFunction
- 对 Flutter 动画很有用

**实现难度：** 低-中等

**示例：**
```json
{
  "transition-emphasis": {
    "$type": "transition",
    "$value": {
      "duration": {"value": 200, "unit": "ms"},
      "delay": {"value": 0, "unit": "ms"},
      "timingFunction": [0.5, 0, 1, 1]
    }
  }
}
```

---

### 🟢 低优先级 - 可选功能

#### 9. **Number 类型** ⭐⭐
**规范要求：** 标准类型

**当前状态：** ⚠️ 可能已支持（需要确认）

**实现价值：**
- 无单位数字（如行高倍数）
- 相对简单

**实现难度：** 低

---

#### 10. **Group $deprecated 支持** ⭐⭐
**规范要求：** 组级别支持

**当前状态：** ❌ 未实现（仅 token 级别支持）

**实现价值：**
- 可以标记整个组为废弃
- 子 token 继承废弃状态（除非覆盖）

**实现难度：** 低

---

#### 11. **Empty Groups 支持** ⭐
**规范要求：** `MAY` 支持

**当前状态：** ⚠️ 可能已支持（需要测试）

**实现价值：**
- 支持占位组
- 工作进度中的组织

**实现难度：** 低

---

#### 12. **文件类型（Asset）** ⭐
**规范要求：** 待定义

**当前状态：** ❌ 未实现

**实现价值：**
- 支持图片、字体等资源引用
- Flutter 中对应 `AssetImage` 等

**实现难度：** 中等

**注意：** 规范中此类型还在讨论中

---

## 📋 实现路线图建议

### Phase 1: 规范合规性（必须）
1. ✅ JSON Pointer 支持
2. ✅ Group Extension ($extends)
3. ✅ Root Tokens ($root)

### Phase 2: 类型完善（推荐）
4. ✅ Duration 类型
5. ✅ Cubic Bézier 类型
6. ✅ Transition 复合类型
7. ✅ Stroke Style 增强

### Phase 3: 增强功能（可选）
8. ✅ Property-Level References（依赖 JSON Pointer）
9. ✅ Group $deprecated
10. ✅ Number 类型确认

---

## 🔍 技术实现注意事项

### JSON Pointer 实现
- 需要遵循 RFC 6901 规范
- 支持转义字符：`~0` (tilde), `~1` (slash)
- 支持数组索引和对象属性访问
- 错误处理：无效路径、循环引用

### Group Extension 实现
- 深度合并算法
- 循环引用检测（与 token 引用类似）
- 类型继承处理
- 性能考虑（大文件）

### Root Tokens 实现
- 特殊键名处理
- 路径构造包含 `$root`
- 与普通 token 的区别处理

---

## 📚 参考资源

- [Design Tokens Format Module 2025.10](https://www.designtokens.org/tr/2025.10/format/)
- [RFC 6901 - JSON Pointer](https://www.rfc-editor.org/rfc/rfc6901)
- [JSON Schema 2020-12](https://json-schema.org/draft/2020-12/json-schema-core.html)

---

## 💡 总结

**最值得优先实现的功能：**

1. **JSON Pointer** - 规范要求必须支持，且是其他功能的基础
2. **Group Extension** - 强大的代码复用能力
3. **Root Tokens** - 相对简单但很有用
4. **Duration & Cubic Bézier** - 完善动画支持
5. **Property-Level References** - 细粒度控制

这些功能的实现将使 figma2flutter 完全符合 Design Tokens Format Module 2025.10 规范，并提供更强大的设计 token 管理能力。
