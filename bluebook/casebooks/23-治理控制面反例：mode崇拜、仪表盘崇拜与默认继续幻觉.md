# 治理控制面反例：mode崇拜、仪表盘崇拜与免费续租幻觉

这一章不再回答“怎样验证治理控制面仍然成立”，而是回答：

- 为什么治理控制面明明已经被写成 `governance key + externalized truth chain + decision window + continuation pricing + durable-vs-transient cleanup`，团队却仍会重新退回 mode、弹窗、token 面板与默认继续。

它主要回答五个问题：

1. 为什么治理机制最危险的失败方式不是“没有门禁”，而是“门禁还在，但对象判断已经碎掉”。
2. 为什么 mode 崇拜最容易把 `governance key` 退回局部状态。
3. 为什么审批出现过、阈值显示过、颜色亮起来，都不等于治理对象真的成立。
4. 为什么 continuation 最容易在“先继续看看”里变回免费时间。
5. 怎样用苏格拉底式追问避免把这些反例读成“治理流程没走完”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-260`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:464-519`
- `claude-code-source-code/src/cli/structuredIO.ts:149-657`
- `claude-code-source-code/src/utils/permissions/permissions.ts:593-984`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`

这些锚点共同说明：

- 治理控制面真正脆弱的地方，不在于有没有审批，而在于 `governance key`、`externalized truth chain`、window、continuation 与 cleanup 是否仍由同一个对象统一解释。

## 1. 第一性原理

治理控制面最危险的，不是：

- 没有 mode
- 没有 token 统计

而是：

- mode、审批、统计与继续各自成立，却不再围绕同一个治理对象工作

一旦如此，团队就会重新回到：

1. 看 mode 名字
2. 看弹窗是否出现
3. 看 token 百分比
4. 看这轮还能不能继续跑

而不再围绕：

- 同一个 `governance key + externalized truth chain`

最容易被偷换成五种替身的是同一条对象链：

1. `mode`
   - 只是假 `governance key`
2. 审批历史
   - 只是假 `typed ask + externalized truth chain`
3. token 条
   - 只是假 `decision window`
4. 默认继续
   - 只是假 `continuation pricing`
5. 文件 / commit 回退
   - 只是假 `durable assets vs transient authority cleanup`

## 2. mode 崇拜 vs governance key

### 坏解法

- 宿主、CLI、bridge、外部元数据各自宣布当前 mode，默认把 mode 名字当成全部治理真相。

### 为什么坏

- mode 只是外化投影，不是完整 `governance key`。
- 一旦 `governance key` 被 mode 替代，后来者就会失去 settings merge、policy winner 与 host sync 的判断链。
- 系统会重新退回“哪个面板显示了什么模式”的局部真相竞争。

### Claude Code 式正解

- mode 变更必须继续经过单一 choke point，对外先 externalize，再向不同消费者同步。
- `governance key` 应始终包含 source、policy、host 与当前状态，不得退回单一 mode 字段。

## 2.1 投影替身对照表

遇到下面这些说法时，应直接追问同一条治理对象链还在不在：

1. “mode 对了”
   - 追问：`governance key` 是否仍唯一
2. “审批做完了”
   - 追问：`typed ask` 与 `externalized truth chain` 是否仍同源
3. “token 降下来了”
   - 追问：`decision window` 是否仍自洽
4. “还没被拦，所以能继续”
   - 追问：`continuation pricing` 是否仍在正式计价
5. “回滚文件就行”
   - 追问：`durable assets` 与 `transient authority` 是否已分清

## 3. 审批出现过就算治理完成 vs typed ask

### 坏解法

- 只要弹窗出现、approve 被点击、classifier 跑过，就把这一轮视为治理成功。

### 为什么坏

- 审批事件只是交互现象，不是 typed ask 本身。
- 一旦 deny / ask / allow / reason 不再被当成正式对象，治理就会退回“有没有人看过”的流程幻觉。
- later fail-open、fail-closed、headless hook 等差异都会被抹平。

### Claude Code 式正解

- 治理对象必须继续围绕正式 typed ask、decision reason 与 winner source 成立。
- “审批发生过”只能是证据的一部分，不能替代决策对象。

## 4. Context Usage 退回仪表盘崇拜 vs decision window

### 坏解法

- Context Usage 只剩 token 百分比、颜色与曲线，不再解释 deferred visibility、tools、agents、memory 与当前继续条件。

### 为什么坏

- 这会把治理窗口退回成本面板。
- 团队会知道“变贵了”，却不知道为什么贵、贵在哪些对象、还能不能继续。
- 安全与省 token 会重新被讲成两套孤立问题。

### Claude Code 式正解

- decision window 必须同时解释当前对象、当前成本、当前可见面与当前继续边界。
- token 百分比只能是 projection，不能替代 window。

## 5. 默认继续幻觉 vs continuation pricing

### 坏解法

- 只要预算还没完全耗尽、用户没明确叫停、异步上下文没法弹窗，就默认继续。

### 为什么坏

- 时间会重新变成免费资源。
- `checkTokenBudget()` 里的 diminishing returns、headless deny 与 stop 条件都会被局部“再来一轮看看”淹没。
- later continuation 不再是治理对象升级，而只是惯性推进。

### Claude Code 式正解

- continuation 必须继续由正式 pricing gate 决定，而不是由“暂时还能跑”决定。
- gate 应同时考虑 agent/headless 语义、decision gain 与时间预算，而不只是剩余 token。

## 6. 恢复动作冒充治理恢复 vs durable-vs-transient cleanup

### 坏解法

- 治理失败时，只谈回退哪些文件、回退哪个 commit、重试多少次，不再点名 `durable assets` 与 `transient authority`。

### 为什么坏

- 这会把治理退回运维动作，而不是对象级恢复。
- 后来者会知道“要回滚”，却不知道应该保留哪些资产、清退哪些旧主权。
- rewind、cancel、resume 等动作会被误当成治理本体。

### Claude Code 式正解

- 恢复必须继续指向当前治理对象的失败边界，并显式区分 `durable assets after` 与 `transient authority cleared`。
- 所有恢复动作都应服务对象回退，而不是替代对象回退。

## 7. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在消费的是 `governance key`，还是 mode 的替身。
2. 我看到的是 typed ask，还是“有人点过批准”的流程幻觉。
3. Context Usage 在解释 decision window，还是只在展示 token 条。
4. continuation 是正式 pricing gate，还是默认继续。
5. 失败时我能否立刻指出 `durable assets` 与 `transient authority` 的边界，而不是先想到文件和 commit。
