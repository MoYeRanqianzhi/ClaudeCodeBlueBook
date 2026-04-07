# Contract-First审读清单：如何系统读懂Agent Runtime的合同、current-truth surface与热点文件

这一章回答五个问题：

1. 如果你要读 Claude Code 或任意 agent runtime，怎样避免一上来就被热点文件淹没。
2. 怎样把“合同真相”“当前注册”“current-truth surface”“current-truth writeback”“adapter subset”分层看清。
3. 怎样判断某个大文件是在维护不变量，还是只是在堆实现噪音。
4. 怎样把 contract-first 写成 later maintainer 可复验的证据梯度。
5. 怎样用苏格拉底式追问防止自己继续脑补缺口。

## 0. 代表性源码锚点

- `claude-code-source-code/src/Task.ts:6-124`
- `claude-code-source-code/src/tasks.ts:1-39`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts:1-8`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-240`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:552-590`
- `claude-code-source-code/src/utils/plugins/pluginStartupCheck.ts:30-90`
- `claude-code-source-code/src/utils/QueryGuard.ts:1-106`
- `claude-code-source-code/src/screens/REPL.tsx:899-907`
- `claude-code-source-code/src/utils/sessionStorage.ts:128-162`
- `claude-code-source-code/src/state/AppStateStore.ts:113-120`
- `claude-code-source-code/src/bridge/bridgeMain.ts:2799-2810`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:28-120`

这些锚点共同说明：

- 关键真相早就写在 schema、type union、single-source 注释、current-truth surface 与 current-truth writeback 上，而不是藏在热点文件深处。

## 1. 先说结论：六层证据梯度（不跳关）

contract-first 的最小审读顺序是：

1. 对象合同（系统承认什么对象）。
2. 协议合同（系统承认什么交互）。
3. 当前 registry（当前 build 真能做什么）。
4. current-truth surface（当前真相由谁定义）。
5. current-truth writeback + adapter subset（谁可回写真相、入口只实现了协议哪一段）。
6. 热点 kernel（仅审不变量，不再猜定义）。

每一层都要留下“证据链接 + 通过/拒绝结论”；没有证据就不能晋级到下一层。

## 2. 合同优先审读流程（可执行版）

### 2.1 关卡A：对象合同

必收证据：

1. 类型/Schema 的正式入口（如 `Task.ts`、`coreSchemas.ts`）。
2. 对象的状态集合与合法迁移。

通过条件：

- 你能点名“对象、状态、动作”三件套，并给出源码锚点。

拒绝信号：

- 只能用“我印象里有这个状态”解释行为。

### 2.2 关卡B：协议合同

必收证据：

1. 控制面 request/response union（如 `SDKControlRequestInnerSchema`）。
2. 错误、取消、回写语义是否进入正式 schema。

通过条件：

- 新增能力先能落在协议项，再谈调用点实现。

拒绝信号：

- 先补 if/分支，再回头找“它对应哪条协议”。

### 2.3 关卡C：当前 registry

必收证据：

1. 实际注册点与 `feature()` gate。
2. “类型存在但当前未暴露”的清单。

通过条件：

- 能清楚区分“声明存在”与“当前可用”。

拒绝信号：

- 由类型空间直接脑补运行时暴露面。

### 2.4 关卡D：current-truth surface

必收证据：

1. enabled 的当前真相入口（如 `checkEnabledPlugins()`）。
2. in-flight 生命周期真相入口（如 `QueryGuard` 与对应 single-source 注释）。
3. transcript 边界判定入口与单一真相字段。

通过条件：

- 每个关键状态都有唯一 current-truth surface。

拒绝信号：

- UI 派生、补偿路径、缓存推断在“定义真相”。

### 2.5 关卡E：current-truth writeback + adapter subset

必收证据：

1. 谁有资格回写当前真相（writeback gate）。
2. 这个 adapter 是协议全集的哪个子集。
3. 子集差异属于产品策略还是入口裁剪。

通过条件：

- 能解释“谁能写回、谁只能读投影、为什么这个入口少一段协议”。

拒绝信号：

- 任意 consumer 都能改主状态，或子集边界只存在口头说明。

### 2.6 关卡F：热点 kernel

只在 A-E 通过后再读 `query.ts / main.tsx / sessionStorage.ts / promptCacheBreakDetection.ts`。

必问三题：

1. 这里维护了哪条前文已登记的不变量。
2. 这段复杂性属于 kernel 必需复杂性，还是边界未收口导致的散落复杂性。
3. 如果 later maintainer 要 reject，这里有无可执行理由。

## 3. 审读记录模板（later maintainer 可复验）

```text
审读对象:

A 对象合同（证据链接 / 通过或拒绝）:
B 协议合同（证据链接 / 通过或拒绝）:
C 当前 registry（证据链接 / 通过或拒绝）:
D current-truth surface（证据链接 / 通过或拒绝）:
E current-truth writeback + adapter subset（证据链接 / 通过或拒绝）:
F 热点 kernel 不变量（证据链接 / 通过或拒绝）:

当前拒绝理由:
- 若未通过，最小拒绝语句写在这里

下一步行动:
- 补证据 / 改合同 / 收 writeback gate / 重切 adapter 边界
```

## 4. 热点文件审读规则

热点文件不是“找灵感”，而是“验收前五关已定义的不变量”。

例如 `promptCacheBreakDetection.ts`：

- 在没有合同证据时，它看起来像调试工具；
- 在合同证据齐全后，它是 prompt 稳定性不变量的执行点。

## 5. 苏格拉底式检查清单（进热点前）

1. 我是否已经分别完成 A/B/C，而不是把“声明存在”和“当前可用”混在一起。
2. 我是否点名了每条关键状态的 current-truth surface。
3. 我是否写清了 current-truth writeback 的资格边界。
4. 我是否把 adapter subset 当成“正常子集”而不是“实现缺失”。
5. 我现在是在验证不变量，还是仍在猜系统到底承认什么。

任一题答不清，就不应该继续深挖热点文件。

## 6. 一句话总结

contract-first 的实用价值不在术语，而在证据梯度：先收合同、注册、current-truth surface 与 writeback 边界，再读热点 kernel，later maintainer 才有可执行的通过与拒绝依据。
