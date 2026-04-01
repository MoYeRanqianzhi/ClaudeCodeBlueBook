# 让依赖图说真话：Leaf Module、Anti-Cycle Seam与Single-Source File

这一章回答五个问题：

1. Claude Code 如何通过 leaf modules、anti-cycle seams 与 single-source files 保持依赖图诚实。
2. 为什么“共享真相”应该收束成极薄文件，而不是任意挂在某个业务模块上。
3. 为什么 `queryContext` 这类非 leaf 小文件反而体现了成熟的反环意识。
4. 为什么依赖图治理不是代码洁癖，而是 runtime 正确性工程。
5. 这对 agent runtime 的源码结构设计有什么迁移价值。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/queryContext.ts:1-40`
- `claude-code-source-code/src/services/analytics/index.ts:1-40`
- `claude-code-source-code/src/utils/plugins/pluginPolicy.ts:1-18`
- `claude-code-source-code/src/services/mcp/normalization.ts:1-20`
- `claude-code-source-code/src/utils/systemPromptType.ts:1-12`
- `claude-code-source-code/src/types/permissions.ts:1-36`
- `claude-code-source-code/src/skills/mcpSkillBuilders.ts:1-40`
- `claude-code-source-code/src/state/teammateViewHelpers.ts:1-20`

## 1. 先说结论

Claude Code 保持依赖图诚实的方法，不是：

- 把所有文件都拆小

而是把跨层共享内容刻意分成三类并分别约束：

1. 高扇入公共面：
   - 做成 zero/low-dep leaf module
2. 不可避免的高位共享依赖：
   - 隔离成只给少数入口层使用的 anti-cycle seam
3. 共享判定 / 归一化 / 类型合同：
   - 收束成 tiny single-source file

所以更准确的说法不是：

- 哪里顺手就从哪里 import

而是：

- import 边应该表达真实责任

这就是“让依赖图说真话”。

## 2. Leaf module：高扇入共享面必须极薄

Claude Code 很多最关键的共享入口都不是大模块，而是：

- 极薄的 leaf module

### 2.1 `analytics/index.ts`

这个文件最典型的信号是注释直接写明：

- NO dependencies to avoid import cycles

它承担的是：

- analytics public API

而不反向拖入：

- datadog
- exporter
- backend 初始化

这说明 Claude Code 的设计原则不是：

- 共享入口功能越全越好

而是：

- 越多人依赖的入口，越不能带来额外依赖负担

### 2.2 `pluginPolicy.ts`

这个文件更极致：

- only imports settings
- single source of truth for policy blocking

也就是说，安装 chokepoint、enable op、UI filters 需要共用同一政策判断时，Claude Code 不会让它们各自写一版“差不多”的逻辑，而是：

- 共同依赖一个极薄判定文件

### 2.3 `mcp/normalization.ts`

名字归一化看起来很小，但一旦它横跨：

- client
- string utils
- tool execution

就必须保持无依赖纯函数。

所以这个文件的价值不在“代码少”，而在：

- 它把跨模块共识固定成零依赖规则

## 3. Single-source file：共享真相不该散落在功能层

Claude Code 反复把“共享真相”收束成 very small files。

### 3.1 `systemPromptType.ts`

它只做一件事：

- 定义 `SystemPrompt` brand 与 `asSystemPrompt`

这说明作者知道：

- prompt 内容构建器可能很重
- 但 prompt contract 本身必须很轻

### 3.2 `types/permissions.ts`

这里也是同样思路：

- 先把 permission types / modes / decisions 抽成 type hub
- 再让实现层回头依赖它

这比“大家都从具体实现里 import 一点类型”更成熟，因为它能主动减少：

- runtime cycles
- 类型层与实现层互咬

## 4. Anti-cycle seam：有些“脏边”不该消失，而该被关进小房间

Claude Code 最成熟的一点，不只是会做 leaf module，还会做：

- anti-cycle seam

`queryContext.ts` 就是典型。

它并不是 leaf。

相反，它明确承认自己需要：

- `context.ts`
- `constants/prompts.ts`

这些高位依赖。

但它又通过单独建文件，把这段“脏边”关起来，并且明确限制：

- 只给入口层使用

这是一种非常诚实的做法，因为它承认：

- 有些跨层依赖不可避免

问题不在于完全消灭它们，而在于：

- 不要让它们无控制地扩散

## 5. 反环意识为什么是仓库级习惯，而不是个别注释

从 `mcpSkillBuilders.ts` 与 `teammateViewHelpers.ts` 可以看出，这不是一次性修补，而是仓库级纪律。

### 5.1 `mcpSkillBuilders.ts`

这里直接讨论：

- bun bundling
- literal dynamic import
- dependency-cruiser cycle diff

然后选择：

- write-once registry leaf

这说明作者处理的不是“能不能跑”，而是：

- 依赖图在长期演化中是否仍然诚实

### 5.2 `teammateViewHelpers.ts`

这里甚至连一个类型判断都宁可内联，只为切断：

- runtime edge

这表明 Claude Code 在依赖图问题上的偏好不是：

- 抽象优先

而是：

- 图健康优先

## 6. 为什么这不是洁癖，而是正确性工程

如果共享判定不收口、共享类型不抽离、反环 seam 不被显式命名，最终坏掉的不是代码风格，而是：

1. 真相被多处复制
2. 模块图被无形拉深
3. 某个 innocuous import 开始触发大范围初始化
4. runtime edge 随手闭合成循环

所以依赖图治理的价值不在“看起来干净”，而在：

- 降低全局脆弱性

## 7. 一句话总结

Claude Code 的源码先进性，不只在于它有 chokepoint 与 kernel，还在于它知道哪些共享面必须薄到零依赖，哪些脏边必须被显式隔离成 anti-cycle seam，哪些规则必须收束成 single-source file，让依赖图本身尽量说真话。
