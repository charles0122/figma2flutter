# 分支策略说明

## 📋 分支结构

### `main` 分支
**用途：** 插件通用代码，适用于所有项目

**包含内容：**
- ✅ 插件通用优化（source set 过滤、无空格数学表达式等）
- ✅ 核心功能代码
- ❌ 不包含项目特定代码

### `feature/rc_design_tokens` 分支
**用途：** 项目特定代码，针对当前 example 项目

**包含内容：**
- ✅ 所有插件通用优化
- ✅ 项目特定代码：
  * 字体主题过滤 (`_isFontTheme`)
  * 文本样式自定义代码生成 (`_buildTextStyleCustomCode`)
  * MaterialColor 生成禁用
  * TextStyle 特定生成策略

## 🔄 使用方式

### 对于插件维护者
- 在 `main` 分支进行通用优化
- 保持 `main` 分支的通用性

### 对于项目使用者
- 如果需要项目特定功能，使用 `feature/rc_design_tokens` 分支
- 或者基于 `main` 分支创建自己的项目特定分支

## 📝 提交历史

- `8f36a1d` - 完整功能存档（在 `feature/rc_design_tokens` 分支）
- `9fb9820` - 支持无空格数学表达式（在 `main` 分支）
- `d17b87e` - 添加基于 source set 的 token 过滤机制（在 `main` 分支）
