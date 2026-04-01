# 单一真相入口：mode、tool pool、state与metadata的权威面

这一章回答五个问题：

1. 为什么 Claude Code 会反复把复杂性压到少数权威状态面，而不是让各 feature 各自维护局部真相。
2. `mode`、tool pool、schema、transcript path、worktree state 分别是怎样被做成 authoritative surface 的。
3. 为什么 chokepoint 与 leaf module 必须配套出现，单独存在都不够。
4. 这套结构为什么直接关系到 prompt 稳定性、宿主同步、恢复正确性与策略治理。
5. 对 Agent runtime 构建者来说，这种“权威面”结构最值得迁移的地方是什么。

## 0. 代表性源码锚点

- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/utils/sessionState.ts:27-146`
- `claude-code-source-code/src/tools.ts:188-367`
- `claude-code-source-code/src/utils/toolPool.ts:20-79`
- `claude-code-source-code/src/utils/api.ts:119-259`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1-8`
- `claude-code-source-code/src/entrypoints/sandboxTypes.ts:1-6`
- `claude-code-source-code/src/utils/sessionStorage.ts:203-258`
- `claude-code-source-code/src/utils/sessionStorage.ts:533-822`
- `claude-code-source-code/src/utils/plugins/pluginPolicy.ts:1-20`

## 1. 先说结论

Claude Code 有一个很成熟的底盘习惯：

- 关键真相必须有一个权威面

这里的“关键真相”不是随便什么内部变量，而是那些一旦漂移，就会同时污染多条链路的对象，例如：

- permission mode
- 工具可见性
- API / settings schema
- transcript / subagent transcript 路径
- worktree 恢复状态
- policy blocking 决策

所以它的结构方法不是简单的：

- 多写几层 abstraction

而是更具体的：

1. 找出真正跨平面的不变量。
2. 把这些不变量收口到少数权威面。
3. 再用 leaf module 保护这些权威面，不让依赖图把它们拖脏。

换一种更抽象但更稳的表述：

- 名词真相尽量进入 schema / pure leaf
- 动词真相尽量进入 chokepoint / state machine

Claude Code 正在反复按这个方式组织自己的底盘。

## 2. `mode` 权威面：不要修八个调用点，要修一个状态面

`onChangeAppState(...)` 几乎是这套写法最标准的教材。

源码把问题写得很清楚：

1. 原来有 8+ 条 mode mutation path。
2. 其中只有极少数路径会同步到 CCR。
3. 结果是 CLI 真实 mode 已经变了，但 `external_metadata.permission_mode` 还是旧值。

这类问题最容易出现一种错误修法：

- 哪条路径漏了通知，就在哪条路径补一个 notify

Claude Code 选择的是另一种修法：

- 把所有 mode 同步都统一放到 AppState diff 上

这说明作者在意的不是：

- 让这次 bug 消失

而是：

- 让未来新增 mode 变更路径时，默认也不会再漏

所以 `onChangeAppState(...)` 的价值不只是 mode sync，而是它示范了：

- 真正的权威面应该位于全局不变量天然成立的位置

## 3. tool pool 权威面：能力暴露、策略裁剪与缓存稳定性必须共用入口

`tools.ts` 和 `toolPool.ts` 这一组也很典型。

### 3.1 `getAllBaseTools()`：能力全集的权威入口

作者没有让 REPL、headless、worker、SDK adapter 各自写一份“可用工具列表”。
相反，基础工具全集被统一收口到 `getAllBaseTools()`。

这里首先保证的是：

- 能力全集的一致性

### 3.2 `assembleToolPool(...)`：运行时可见工具的权威入口

但基础全集还不够，因为模型真正看见的不是“所有能存在的工具”，而是：

- 当前 permission context 下的 built-in tools
- deny-rule 过滤后的 MCP tools
- built-in 优先去重后的组合结果

于是 `assembleToolPool(...)` 继续成为第二层权威面。

它的重要性在于它统一维护了三种不变量：

1. 工具可见性
2. 策略裁剪
3. prompt-cache-stable 排序

第三点尤其重要。
源码明确解释 built-in 必须保持连续前缀，否则 MCP 工具插入会把下游 cache key 全打乱。

这说明 Claude Code 对工具池的理解不是：

- 一个功能目录

而是：

- prompt prefix 的一部分

### 3.3 `mergeAndFilterTools(...)`：让不同运行路径共享同一权威逻辑

`toolPool.ts` 被刻意放在 React-free 文件里，让 REPL 与 headless 路径共用。

这一步很关键，因为如果权威逻辑只能在某个 UI hook 内复用，那么一旦离开这个 hook，系统就会重新退回：

- 各路径各写一份近似实现

所以真正的权威面不仅要正确，还要：

- 足够可复用

## 4. schema 权威面：类型定义必须和运行时校验共源

`coreSchemas.ts` 与 `sandboxTypes.ts` 的注释都直接把自己声明为：

- single source of truth

这代表 Claude Code 认定下面三件事不该分裂：

1. IDE 里看到的类型
2. 运行时接受的 shape
3. settings / SDK / consumer 使用的 schema

如果这三层各写一份，早晚会出现：

- IDE 说可以
- runtime 说不行
- settings 又接受了第三种形状

所以 schema 权威面并不是“类型系统洁癖”，而是：

- API 认知一致性的前提

## 5. session / metadata 权威面：恢复系统最怕半真相

`sessionStorage.ts` 这里最值得学的，不是“怎么写 JSONL”，而是作者如何防恢复系统出现 split-brain。

### 5.1 transcript path 必须服从 session-aware 权威路径

`getTranscriptPathForSession(...)` 的注释明确记录了一个典型错误：

- hooks 用 `originalCwd` 推导 transcript path
- 实际写文件却用 `sessionProjectDir`
- 结果两边都“看起来有道理”，但拿到的是不同文件

这正是半真相最危险的地方：

- 每个局部实现都像对的
- 全局却错了

Claude Code 的修法不是“让 hook 多知道一点内部细节”，而是：

- 统一回到 session-aware 的权威路径入口

### 5.2 worktree state 用 tri-state 保存恢复语义

`currentSessionWorktree` 不是简单布尔量，而是：

1. `undefined`
2. `null`
3. `object`

这说明作者明确知道恢复系统关心的不是“是不是 worktree”，而是：

- 从未进入
- 已经退出
- 仍在其中或异常中断

这类状态如果被压扁，恢复系统就只能猜。

### 5.3 `notifySessionStateChanged(...)` 继续外化权威当前态

`sessionState.ts` 把 `requires_action`、`pending_action`、`task_summary`、`idle/running` 继续镜像到 metadata 与 SDK event stream。

这说明 Claude Code 对状态权威面的要求不是：

- 写完 transcript 就算了

而是：

- 当前真相还必须再被宿主消费到

## 6. policy 权威面与 leaf module：权威入口也要被依赖图保护

`pluginPolicy.ts` 非常小，却很重要。

它同时具备三个特点：

1. 只依赖 settings
2. 明确是 leaf module
3. 明确承担 policy blocking 的 single source of truth

这说明 Claude Code 的结构方法不是只会“集中”。
它同样知道：

- 如果一个权威入口依赖太多东西，它迟早会因为循环依赖或模块图污染而失去可信度

所以成熟结构不是：

- 一个超大 central file 负责一切

而是：

- 少数厚权威面
- 外围大量薄 leaf module

两者配合。

## 7. 为什么这直接影响 prompt、宿主与恢复

如果没有这些权威面，会立刻出现三类后果。

### 7.1 prompt 会失去稳定前缀

工具池一旦各路径排序不同、过滤不同，模型看到的 prefix 就不同，cache 也会更频繁失稳。

### 7.2 宿主会消费到漂移状态

mode 变化如果不是统一外化，宿主 UI 会和 CLI 真实 mode 分裂。

### 7.3 恢复会落到错误文件或错误工作树语义

session path、subagent path、worktree state 只要有一层用局部推断，就会产生 resume / hook / bridge 的 split-brain。

所以“单一真相入口”并不是架构审美，而是：

- prompt correctness
- host correctness
- recovery correctness

三者共同的底盘。

## 8. 苏格拉底式追问

### 8.1 为什么不能每个 feature 维护自己的局部真相

因为跨平面的不变量一旦分散维护，就会默认不同步。

### 8.2 为什么不把所有权威面继续拆碎

因为有些真相天然就是全局性的。

比如：

- mode sync
- tool pool ordering
- transcript path

这些一旦拆到过细，就会重新回到多处半真相。

### 8.3 为什么 leaf module 也同样重要

因为如果权威面没有被低耦合模块保护，它很快会被模块图反向污染，最后又失去“权威”资格。

## 9. 一句话总结

Claude Code 的底盘先进性之一，在于它不断把跨平面不变量收口成少数权威面，再用 leaf module 保护这些权威面不被依赖图拖成多处半真相。
