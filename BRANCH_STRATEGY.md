# 分支策略说明

## 📋 分支结构

### `main` 分支
**用途：** 插件通用代码，适用于所有项目

**包含内容：**
- ✅ 插件通用优化：
  * 基于 source set 的 token 过滤机制 (`_isSourceToken`, `tokenKeyToSet`)
  * 无空格数学表达式支持
  * 共享类生成优化
- ✅ 核心功能代码
- ❌ 不包含项目特定代码

**提交历史：**
- `9fb9820` - feat: 支持无空格数学表达式
- `d17b87e` - feat: 添加基于 source set 的 token 过滤机制

### `feature/project-specific-code` 分支
**用途：** 项目特定代码，针对当前 example 项目

**包含内容：**
- ✅ 所有插件通用优化（从 main 分支继承）
- ✅ 项目特定代码：
  * 字体主题过滤 (`_isFontTheme`) - 硬编码主题名称模式
  * 文本样式自定义代码生成 (`_buildTextStyleCustomCode`) - 硬编码文本样式实现
  * MaterialColor 生成禁用 - 硬编码过滤逻辑
  * TextStyle 特定生成策略 - 硬编码策略

**提交历史：**
- `c71fc61` - feat: 添加项目特定代码

## 🔄 使用方式

### 对于插件维护者
- 在 `main` 分支进行通用优化
- 保持 `main` 分支的通用性
- 项目特定需求放在 `feature/project-specific-code` 分支

### 对于项目使用者
- **推荐：** 使用 `main` 分支（通用版本）
- **如果需要项目特定功能：** 使用 `feature/project-specific-code` 分支
- **或者：** 基于 `main` 分支创建自己的项目特定分支

## 📝 代码分离说明

### 已分离到 main 分支（通用优化）
1. ✅ `_isSourceToken()` - 基于 source set 的过滤
2. ✅ 无空格数学表达式支持
3. ✅ `tokenKeyToSet` 映射机制

### 保留在 feature/project-specific-code 分支（项目特定）
1. ✅ `_isFontTheme()` - 字体主题过滤
2. ✅ `_buildTextStyleCustomCode()` - 文本样式自定义代码
3. ✅ MaterialColor 生成禁用
4. ✅ TextStyle 特定生成策略

## 🎯 后续计划

1. **配置化项目特定代码** - 将硬编码逻辑提取为配置
2. **基于元数据判断** - 使用 JSON 元数据而非硬编码名称
3. **提供自定义代码生成机制** - 更灵活的扩展点
