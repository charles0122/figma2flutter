# 四个 TextStyleTokens 类的差异分析

## 类列表
1. `IosChTextStyleTokens` - iOS 中文
2. `IosEngTextStyleTokens` - iOS 英文
3. `AndroidChTextStyleTokens` - Android 中文
4. `AndroidEngTextStyleTokens` - Android 英文

## 差异分析

### 1. 字体家族（fontFamily）差异

#### IosChTextStyleTokens
- **文本字体**: `PingFang SC` (用于 Label/Body/Title/Display/NumberText 系列)
- **数字字体**: `SF Pro` (用于 Number 系列)

#### IosEngTextStyleTokens
- **文本字体**: `Inter` (用于 Label/Body/Title/Display/NumberText 系列)
- **数字字体**: `SF Pro` (用于 Number 系列)

#### AndroidChTextStyleTokens
- **文本字体**: `HarmonyOS Sans SC` (用于 Label/Body/Title/Display/NumberText 系列)
- **数字字体**: 
  - `Inter` (用于 Number12/20/24/28)
  - `SF Pro` (用于 Number32/56)

#### AndroidEngTextStyleTokens
- **所有字体**: `SF Pro` (全部使用)

### 2. 行高（height）差异

#### semanticTypographyTitle16
- `IosEngTextStyleTokens`: `1.5`
- 其他三个类: `1.6`

#### semanticTypographyNumberText 系列 (12/14/16)
- `IosChTextStyleTokens`: `1.7`
- `AndroidChTextStyleTokens`: `1.7`
- `IosEngTextStyleTokens`: `1.6`
- `AndroidEngTextStyleTokens`: `1.6`

### 3. 其他属性
- `fontSize`: **完全相同**
- `fontWeight`: **完全相同**

## 总结

**主要差异**：
1. ✅ **字体家族（fontFamily）** - 这是最主要的差异
2. ⚠️ **行高（height）** - 有2个属性的行高存在细微差异：
   - `semanticTypographyTitle16`: IosEng 是 1.5，其他是 1.6
   - `semanticTypographyNumberText*`: 中文版本是 1.7，英文版本是 1.6

**可以优化的点**：
- 四个类除了字体和少量行高差异外，其他属性完全相同
- 可以通过参数化字体家族来合并为一个类
- 行高的差异可以通过条件判断或配置来处理

## 优化建议

### 方案1: 使用抽象方法获取字体
创建一个基类，通过抽象方法获取字体家族，子类只需实现字体获取逻辑。

### 方案2: 使用构造函数参数
创建一个统一的类，通过构造函数传入字体配置。

### 方案3: 使用工厂方法
创建一个工厂类，根据平台和语言返回对应的 TextStyleTokens 实例。
