# 治理宿主消费反例：mode 投影崇拜、窗口失语与 cleanup 文件化

这一章不再回答“宿主该怎样消费统一定价治理支持面”，而是回答：

- 为什么宿主、SDK、CI 与交接系统明明已经拿到了治理主键源槽、窗口证据、继续定价 verdict 与 cleanup carrier，仍会重新退回 mode 崇拜、仪表盘崇拜、文案化 pending action 与文件级回退。

它主要回答五个问题：

1. 为什么治理宿主消费最危险的失败方式不是“没接 control request”，而是“把对象级治理重新消费成界面投影和流程幻觉”。
2. 为什么 mode 投影崇拜最容易把 `governance key` 退回单一显示字段。
3. 为什么 `pending_action` 一旦被降格成文案，宿主就会同时失去 `typed ask` 与 `decision window`。
4. 为什么 continuation 一旦默认化，安全设计与省 token 设计会一起退回免费继续。
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

- 治理宿主消费真正最容易退化的地方，不在控制请求有没有接上，而在宿主是否仍围绕同一个 `governance key -> externalized truth chain -> typed ask -> decision window -> continuation pricing -> durable-transient cleanup` 判断链消费当前世界。

## 1. 第一性原理

治理宿主消费最危险的，不是：

- 没有 mode
- 没有审批

而是：

- 已经有了治理对象链，宿主却继续围绕 mode、弹窗、状态色和 token 条工作

一旦如此，宿主就会重新回到：

1. 看当前 mode 名字
2. 看弹窗出现没有
3. 看 token 百分比
4. 看这轮能不能继续跑

而不再围绕：

1. 谁在声明边界
2. 当前 ask 是什么事务
3. 当前窗口里发生了什么
4. 为什么这轮继续或停止仍值这个价格
5. 坏了以后要清掉哪些 transient authority

## 2. mode 投影崇拜：`governance key` 被偷换

### 坏解法

- 宿主把 `permission_mode` 当成全部治理真相，只围绕 mode 投影做面板和逻辑分叉。

### 为什么坏

- `permission_mode` 只是外化投影，不是完整 `governance key`。
- 一旦治理主语被 mode 替代，宿主就会丢掉 `sources / effective / applied` 这些真正决定边界的对象。
- later settings 漂移或 host sync 变化发生时，宿主只能看到 mode 变没变，却看不到谁改了边界。

### Claude Code 式正解

- 宿主应围绕 `settings.sources / effective / applied + permission_mode` 一起消费 `governance key`。
- mode 是投影，治理主键才是对象。

## 3. `pending_action` 文案化：`typed ask` 与 `decision window` 一起失语

### 坏解法

- 宿主把 `pending_action` 只消费成一段“当前卡住了”的说明文案，不消费其对象字段。

### 为什么坏

- `pending_action` 真正回答的是当前卡在哪、等谁动作、tool_use_id 是谁、当前输入面是什么。
- 一旦它被降格成文案，宿主就会失去 `typed ask` 的事务边界，也会失去 `decision window` 的关键组成部分。
- later 交接与 CI 会只知道“卡住了”，却不知道卡在什么对象、为什么卡、谁来解。

### Claude Code 式正解

- 宿主应围绕 `pending_action` 的对象字段消费 ask transaction 与当前 decision window。
- `pending_action` 是 ask / window 的 witness，不是 later 用来安抚用户的一句话。

## 4. `Context Usage` 仪表盘化：`decision window` 被偷换成成本观感

### 坏解法

- 宿主只消费 `percentage` 或 token 条，不消费 `systemPromptSections`、`messageBreakdown`、`apiUsage`、`autoCompactThreshold` 等窗口对象。

### 为什么坏

- 这样会把 `decision window` 重新退回成本仪表盘。
- 宿主知道“变贵了”，却不知道为什么贵、贵在哪一层、是否还值得继续。
- later governance 面板会重新退回“看起来快满了”的直觉治理。

### Claude Code 式正解

- `Context Usage` 必须继续与 state、pending action 一起消费成 `decision window`。
- token 条只是结果投影，不是治理对象本身。

## 5. continuation 默认化：`continuation pricing` 被偷换成免费时间

### 坏解法

- 宿主只要没看到硬错误、token 还没满、用户没明确叫停，就默认继续。

### 为什么坏

- 这会把时间重新变成免费资源。
- `diminishing returns`、`continuationCount`、`durationMs` 与 headless deny 这些正式时间边界都会被“再来一轮看看”淹没。
- 安全边界与 token 边界会一起退化，因为同一收费链被拆成了“风险还行”和“成本还能扛”两种直觉。

### Claude Code 式正解

- 宿主应围绕 `continuation pricing` 判断，而不是围绕“暂时还能跑”。
- `Context Usage + state + pending action + stop/continue outcome` 才是当前时间边界的正式消费面。

## 6. cleanup 文件化：`durable-transient cleanup` 被偷换成文件列表

### 坏解法

- 宿主只把 `rewind_files` 理解成文件列表或补丁回退 API，不围绕 cleanup carrier 消费回退边界。

### 为什么坏

- 这会把对象级治理回退退化成文件级补救动作。
- later 交接者会知道“要回退哪些文件”，却不知道为什么回退、回退到哪个治理对象。
- rewind 会被误读成治理本体，而不是治理对象的一种执行实现。

### Claude Code 式正解

- 宿主应把 `rewind_files` 放在 `durable-transient cleanup` 语义下消费，而不是当成文件工具。
- cleanup 恢复的是对象边界，文件回退只是其实现路径之一。

## 7. 这类反例真正偷走了什么

这类治理宿主消费反例，最常见的偷换只有三类：

1. `projection_usurpation`
   - mode、弹窗、仪表盘越位成治理主语。
2. `decision_window_collapse`
   - `pending_action`、状态与 `Context Usage` 不再被并排解释。
3. `free_expansion_relapse`
   - continuation 被重新读成默认继续。

只要这三类偷换没有被命名出来，团队就会误以为问题只是“界面解释还不够好”。

## 8. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在消费的是 `governance key`，还是只是 mode 投影。
2. `pending_action` 在我的宿主里还是对象，还是已经退化成文案。
3. `Context Usage` 在解释 decision window，还是只在充当仪表盘。
4. continuation 是正式时间定价，还是默认继续。
5. cleanup 在我的系统里还是对象，还是已经退化成文件列表。
6. 如果把 modal 和 dashboard 藏起来，我还能不能说清当前 ask、当前窗口与 cleanup 边界。

## 9. 一句话总结

真正危险的治理宿主消费失败，不是没接 control surface，而是把对象级治理重新消费成 mode 崇拜、窗口失语与 cleanup 文件化。
