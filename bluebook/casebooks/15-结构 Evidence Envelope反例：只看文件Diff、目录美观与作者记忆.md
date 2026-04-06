# 结构 Evidence Envelope反例：authority object 被文件、目录与作者记忆拆散

这一章不再收集“结构本身设计错”的反例，而是收集结构证据明明已经存在，却被不同消费者拆成不同替身之后最常见的失真样本。

它主要回答五个问题：

1. 为什么结构升级明明已经有 `authority object`、`per-host authority width` 与 `event-stream-vs-state-writeback`，团队仍然会退回文件级回退与目录审美。
2. 为什么结构的 shared evidence envelope 最容易被拆成“文件 diff”“目录图”“恢复成功率”“作者记忆”四份材料。
3. 哪些坏解法最容易把源码先进性退回到静态美观和作者权威。
4. 怎样把这些坏解法改写回 Claude Code 式共享证据消费。
5. 怎样用苏格拉底式追问避免把这一章读成“作者偏好某种代码审美”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/utils/task/framework.ts:77-248`
- `claude-code-source-code/src/utils/sessionRestore.ts:435-490`
- `claude-code-source-code/src/utils/conversationRecovery.ts:186-400`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-211`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-184`
- `claude-code-source-code/src/cli/transports/WorkerStateUploader.ts:3-112`
- `claude-code-source-code/src/utils/sessionState.ts:1-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/utils/worktree.ts:1046-1172`

这些锚点共同说明：

- 结构线真正值钱的，不是目录更整洁，而是同一个 `authority object` 是否仍只被一个正式写回面宣布，不被 pointer、event stream、telemetry 与作者口述偷走。
- Claude Code 源码先进性的根，不在“模块更像样”，而在 `per-host authority width`、`event-stream-vs-state-writeback`、`freshness gate`、`stale worldview` 与 `ghost capability eviction` 被提前编码进结构纪律。

## 1. 第一性原理

结构线最危险的，不是：

- 没有图

而是：

- 图很多、提交很多、总结很多，却没有一份 shared envelope 能让不同消费者围绕同一对象与同一 present-truth 纪律判断

这样一来，系统虽然已经能描述：

- `authority object`
- `per-host authority width`
- `event-stream-vs-state-writeback`
- `freshness gate`
- `stale worldview`
- `ghost capability eviction`

团队却仍然回到：

- 改了哪些文件
- 目录是不是更清爽
- 作者说哪里危险

最容易篡位的一组结构替身是：

1. 文件 diff
   - 冒充 `authority object`
2. 目录美观
   - 冒充 `per-host authority width`
3. 恢复成功率
   - 冒充 `event-stream-vs-state-writeback + freshness gate`
4. 作者记忆
   - 冒充 `stale worldview / ghost capability` 驱逐证据

## 2. 只看文件 Diff vs authority object

### 坏解法

- 宿主、评审或交接先看文件 diff，默认结构升级的核心证据就是改了哪些文件、删了哪些模块、挪了哪些目录。

### 为什么坏

- 结构真相是按对象成立的，不是按文件成立的。
- 一个 session object、task object、bridge object 往往跨越多个文件和多个持久化资产；文件只是对象变更的落点，不是对象本体。
- 只看文件 diff，会让 later 团队知道“哪几行动过”，却不知道“现在哪个 authority object 仍在宣布 current truth”。

### Claude Code 式正解

- 先点名 `authority object` 与 `rollback boundary`，再看文件 diff。
- 文件变更只作为执行痕迹，不能替代对象真相。

## 3. 只看目录美观 vs per-host authority width

### 坏解法

- CI 或评审只看模块边界、目录层次、解耦程度，默认结构更清爽就更先进。

### 为什么坏

- 目录美观不等于 authority 收口。
- 真正难的是：不同 host 是否都在消费同一个 authority object 的合法 width，而不是各自拿一份局部 projection 充当主权。
- 团队会把结构进步误读成视觉整洁，而忽略 present truth 是否仍唯一。

### Claude Code 式正解

- 先问 authority width，再看目录。
- 目录只是说明方式，`per-host authority width` 才是 later consumer 真正该继承的结构纪律。

## 4. 只看恢复成功率 vs event-stream-vs-state-writeback / freshness gate

### 坏解法

- 宿主、CI 或评审只看 resume / reconnect 成功率，默认恢复指标不错就说明结构升级成立。

### 为什么坏

- 恢复成功率只说明“这次看起来恢复了”，不说明 `event stream` 有没有越权冒充 `state writeback`，也不说明 `freshness gate` 有没有阻止旧对象写坏现在。
- 如果没有 writeback 主路径、generation guard 与 stale suppression 证据，恢复只会变成黑盒结果。
- 这会把源码先进性重新退回“恢复挺强”而不是“结构真的 fail-closed”。

### Claude Code 式正解

- 恢复指标必须和 `event-stream-vs-state-writeback`、`freshness gate` 一起消费。
- 只有既知道恢复结果，也知道 current truth 仍由谁正式写回，结构判断才成立。

## 5. 只靠作者记忆 vs stale worldview / ghost capability 证据

### 坏解法

- 交接或评审遇到复杂结构时，默认去问作者：“哪里危险、哪里别碰、回退时注意什么。”

### 为什么坏

- 这会把 shared envelope 重新退回作者权威。
- `stale worldview`、`ghost capability`、anti-zombie evidence、danger path 与 return boundary 全部被口头记忆替代。
- 作者一旦离开，later 维护者就失去驱逐旧认知、旧能力与旧入口的正式证据。

### Claude Code 式正解

- 让 `stale worldview`、`ghost capability eviction`、danger path 与 reopen boundary 写进 envelope，而不是写在作者脑中。
- 作者说明只能补充，不得替代结构证据。

## 6. 分裂消费 vs shared structure envelope

### 坏解法

- 宿主看文件，CI 看指标，评审看结构图，交接听作者说明，默认四者合起来就等于结构证据。

### 为什么坏

- 四组材料描述的是同一升级的不同投影，却没有共享同一 authority / writeback / freshness / eviction 骨架。
- 它们各自都可能局部正确，却合不成同一份结构真相。
- 最终团队会重新退回“作者最懂”和“目录更好看”的判断模式。

### Claude Code 式正解

- 所有消费者先共享同一套结构 envelope：
  - `authority object`
  - `per-host authority width`
  - `event-stream-vs-state-writeback`
  - `freshness gate`
  - `stale worldview`
  - `ghost capability eviction`

## 7. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在消费的是同一个 `authority object`，还是只是在看文件和目录。
2. `per-host authority width` 与 present-truth writer 是否已经点名。
3. `event stream` 与 `state writeback` 的分工是否已经被正式外化。
4. `freshness gate`、`stale worldview` 与 `ghost capability` 的驱逐证据是否已经写出来。
5. 我是在共享同一套结构证据骨架，还是在共享几份彼此相关但互不约束的材料。
