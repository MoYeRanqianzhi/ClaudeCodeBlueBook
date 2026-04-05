# 治理宿主消费反例：mode投影崇拜、pending action降格与rollback object文件化

这一章不再回答“宿主该怎样消费统一定价治理支持面”，而是回答：

- 为什么宿主、SDK、CI 与交接系统明明已经拿到了 `authority source`、`decision window`、`pending action`、`continuation gate` 与 `rollback object` 的正式支持面，仍会重新退回 mode 崇拜、仪表盘崇拜、文案化 pending action 与文件级回退。

它主要回答五个问题：

1. 为什么治理宿主消费最危险的失败方式不是“没接 control request”，而是“把对象级治理重新消费成界面投影和流程幻觉”。
2. 为什么 mode 投影崇拜最容易把 authority source 退回单一字段。
3. 为什么 pending action 一旦被降格成一段文案，宿主就会失去当前 decision window。
4. 为什么 continuation gate 一旦被默认化，治理就会重新回到免费继续。
5. 怎样用苏格拉底式追问避免把这些反例读成“再多补一个弹窗就好了”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-260`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:308-328`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:475-519`
- `claude-code-source-code/src/cli/structuredIO.ts:470-639`
- `claude-code-source-code/src/utils/sessionState.ts:15-45`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/cli/print.ts:2961-3010`

这些锚点共同说明：

- 治理宿主消费真正最容易退化的地方，不在控制请求有没有接上，而在宿主是否仍围绕同一个治理对象消费权威源、判断窗口、继续边界与回退对象。

## 1. 第一性原理

治理宿主消费最危险的，不是：

- 没有 mode
- 没有审批

而是：

- 已经有了 authority source、pending action、Context Usage 与回退 contract，宿主却仍然只消费 mode、弹窗、状态色和 token 条

一旦如此，宿主就会重新回到：

1. 看当前 mode 名字
2. 看弹窗出现没有
3. 看 token 百分比
4. 看这轮能不能继续跑

而不再围绕：

- 同一个 `governance control plane object`

## 2. mode 投影崇拜 vs authority source

### 坏解法

- 宿主把 `permission_mode` 当成全部治理真相，只围绕 mode 投影做面板和逻辑分叉。

### 为什么坏

- `permission_mode` 只是外化投影，不是完整 authority source。
- 一旦 authority source 被 mode 替代，宿主就会丢掉 `sources / effective / applied` 这些真正决定边界的对象。
- later settings 漂移或 host sync 变化发生时，宿主只能看到 mode 变没变，却看不到谁改了边界。

### Claude Code 式正解

- 宿主应围绕 `get_settings.sources / effective / applied + permission_mode` 一起消费 authority source。
- mode 是投影，authority source 才是对象。

### 改写路径

1. 把 `permission_mode` 降为 authority source 的外化字段。
2. 把 settings 源与 applied runtime 结果提到主视图。
3. 任何只围绕 mode 做治理判断的宿主都判为 drift。

## 3. pending action 降格成文案 vs decision window

### 坏解法

- 宿主把 `pending_action` 只消费成一段“当前卡住了”的说明文案，不消费其对象字段。

### 为什么坏

- `pending_action` 真正回答的是当前卡在哪、等谁动作、tool_use_id 是谁、当前输入面是什么。
- 一旦它被降格成文案，宿主就会失去 decision window 的关键组成部分。
- later 交接与 CI 会只知道“卡住了”，却不知道卡在什么对象、为什么卡、谁来解。

### Claude Code 式正解

- 宿主应围绕 `pending_action` 的对象字段消费当前 decision window，而不是只展示一句提示。
- 这也是为什么 `pending_action` 要进入 external metadata，而不是只留在 UI。

### 改写路径

1. 把 `pending_action` 的结构字段显式显示或传递。
2. 让交接包和 CI 都引用同一个 pending action 对象。
3. 任何把 pending action 消费成文案提示的宿主都判为 drift。

## 4. Context Usage 仪表盘化 vs decision window

### 坏解法

- 宿主只消费 `percentage` 或 token 条，不消费 `systemPromptSections`、`messageBreakdown`、`apiUsage`、`autoCompactThreshold` 等窗口对象。

### 为什么坏

- 这样会把 decision window 重新退回成本仪表盘。
- 宿主知道“变贵了”，却不知道为什么贵、贵在哪一层、是否还值得继续。
- later governance 面板会重新退回“看起来快满了”的直觉治理。

### Claude Code 式正解

- Context Usage 必须继续与 state、pending action 一起消费成 decision window。
- token 条只是结果投影，不是治理对象本身。

### 改写路径

1. 把 `Context Usage + pending_action + state` 固定成同一视图。
2. 把 `percentage` 从主判断对象降为辅助指标。
3. 任何只看 token 条的治理宿主都判为 drift。

## 5. continuation gate 默认化 vs时间定价

### 坏解法

- 宿主只要没看到硬错误、token 还没满、用户没明确叫停，就默认继续。

### 为什么坏

- 这会把时间重新变成免费资源。
- `diminishing returns`、`continuationCount`、`durationMs` 与 headless deny 这些正式时间边界都会被“再来一轮看看”淹没。
- later CI、交接与宿主只知道系统还在跑，却不知道它是否还配继续。

### Claude Code 式正解

- 宿主应围绕 continuation gate 的投影判断，而不是围绕“暂时还能跑”。
- `Context Usage + state + pending action + stop/continue outcome` 才是当前时间边界的正式消费面。

### 改写路径

1. 禁止默认继续成为宿主策略。
2. 把 continuation gate 显式写进交接和 CI。
3. 任何不区分“可继续”和“应继续”的宿主都判为 drift。

## 6. rollback object 文件化 vs对象回退

### 坏解法

- 宿主只把 `rewind_files` 理解成文件列表或补丁回退 API，不围绕 rollback object 消费回退边界。

### 为什么坏

- 这会把对象级治理回退退化成文件级补救动作。
- later 交接者会知道“要回退哪些文件”，却不知道为什么回退、回退到哪个治理对象。
- rewind 会被误读成治理本体，而不是治理对象的一种执行实现。

### Claude Code 式正解

- 宿主应把 `rewind_files` 放在 rollback object 语义下消费，而不是当成文件工具。
- rollback object 是治理对象，文件回退只是其实现路径之一。

### 改写路径

1. 在宿主里显式标出 rollback object。
2. 把 file rewind 结果链接回当前 governance object。
3. 任何把 rollback 退回文件列表的宿主都判为 drift。

## 7. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在消费的是 authority source，还是只是 mode 投影。
2. `pending_action` 在我的宿主里还是对象，还是已经退化成文案。
3. Context Usage 在解释 decision window，还是只在充当仪表盘。
4. continuation 是正式时间边界，还是默认继续。
5. rollback 在我的系统里还是对象，还是已经退化成文件列表。
