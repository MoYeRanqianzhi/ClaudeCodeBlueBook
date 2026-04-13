# Services 二级目录地图：API、Compact、Memory、MCP、LSP 与 Observability 子系统的权威入口

这一章回答五个问题：

1. `services/` 往二级目录拆开后，到底分成了哪些正式子系统。
2. 每个子系统的权威入口在哪里，主要消费者是谁。
3. 哪些目录是核心控制平面，哪些只是壳层、投影层或辅助消费者。
4. 哪些目录最容易被误读，从而把 Prompt、安全、恢复或治理写坏。
5. 平台设计者该按什么顺序阅读 `services/`。

## 0. 代表性锚点与证据梯度

更稳的证据梯度应先看：

1. `contract`
2. `registry`
3. `current-truth claim state`
4. `consumer subset`
5. `hotspot kernel`
6. `mirror gap discipline`

代表性源码锚点：

- `claude-code-source-code/src/services/api/claude.ts:1-80`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-186`
- `claude-code-source-code/src/services/compact/compact.ts:766-899`
- `claude-code-source-code/src/services/SessionMemory/sessionMemory.ts:302-375`
- `claude-code-source-code/src/services/PromptSuggestion/promptSuggestion.ts:184-244`
- `claude-code-source-code/src/services/mcp/config.ts:888-980`
- `claude-code-source-code/src/services/mcp/MCPConnectionManager.tsx:1-120`
- `claude-code-source-code/src/services/lsp/LSPServerManager.ts:1-120`
- `claude-code-source-code/src/services/analytics/index.ts:1-80`
- `claude-code-source-code/src/services/tools/toolOrchestration.ts:19-80`

这页不再先靠目录数量解释自己，而是先给一条证据梯度：

1. `api/sessionIngress`、`claude.ts`
2. `compact/compact.ts`
3. `SessionMemory/sessionMemory.ts`、`PromptSuggestion/promptSuggestion.ts`
4. `mcp/config.ts`、`remoteManagedSettings`
5. `analytics/index.ts`、`internalLogging.ts`

## 1. 先说结论

`services/` 不是“剩余杂项”目录，而是统一扩张定价秩序落成对象层的地方。

这张源码地图最关键的意义不是：

- 目录更多

而是：

- 不同子系统暴露了不同的权威入口、不同的消费者，以及不同的危险改动面

也就是说，读 `services/` 的顺序首先是证据更硬不更硬，而不是目录拆得更细不更细。每个子系统都至少要先回答六件事：

1. `contract`
2. `registry`
3. `current-truth claim state`
4. `consumer subset`
5. `hotspot kernel`
6. `mirror gap discipline`

再往上收一层，`services/` 也不是模块清单，而是 runtime 对请求进入、上下文续存、继续资产、外部能力、桥接暴露与观测追责逐项收费的对象层：

- `api` 守请求真相
- `compact` 与 budget 子系统守上下文与时间边界
- `SessionMemory` 与 `PromptSuggestion` 守 continuation 资产
- `mcp` 与 `remoteManagedSettings` 守外部能力边界
- `analytics / logging / recovery evidence` 守执行后的结算、追责与连续性重绑

最值得先记住的 evidence object 原型至少有四个：

1. append-chain transcript
2. prompt / cache drift ledger
3. diagnostic / internal logs
4. signer / readback / recovery outputs

如果不先看到这条主线，读者就会重新把 `services/` 误读成后台杂项集合。

## 2. API / Transport 子系统

- `contract`：
  - `claude.ts`、`sessionIngress.ts`
- `registry`：
  - `client.ts`、transport assembly、append-chain 入口
- `current-truth claim state`：
  - append-chain ingress、session ingress、host writeback
- `consumer subset`：
  - 远程恢复路径、host projection、client shell 只消费部分请求与恢复真相
- `hotspot kernel`：
  - append-chain 恢复对象、prompt/cache 漂移账本、retry / ingress 乱序最容易把请求真相写坏
- `mirror gap discipline`：
  - 一旦请求或恢复行为开始可疑，先回 `claude.ts` 与 `sessionIngress.ts`，不要先在 client shell 或 host projection 层补丁

## 3. Compact / Budget / Context Maintenance 子系统

- `contract`：
  - `compact/compact.ts`、`compact/postCompactCleanup.ts`
- `registry`：
  - compact pipeline、budget hookup、cleanup registration
- `续接定价 / cleanup 状态`：
  - 当前 compact 结果、post-compact state 与 continuation pricing 结算状态
- `consumer subset`：
  - `claudeAiLimits.ts`、`rateLimitMessages.ts` 更多是消费者可见投影，不是 budget authority
- `hotspot kernel`：
  - compact 后 cleanup、policy limit、continuation pricing 一旦失真，就会同时破坏上下文与时间边界
- `mirror gap discipline`：
  - 一旦 compact 看起来像普通摘要，先回 `compact.ts` 与 post-compact cleanup，而不是先改 UI summary

## 4. Memory / Suggestion / Summary 子系统

- `contract`：
  - `SessionMemory/sessionMemory.ts`、`PromptSuggestion/promptSuggestion.ts`
- `registry`：
  - memory extraction、prompt suggestion、summary/dream/fork wiring
- `续接资产 / 读回面`：
  - 当前可被读回的 session memory、suggestion output 与 continuation asset
- `consumer subset`：
  - `AgentSummary`、`toolUseSummary`、team 记忆同步更像 continuation 投影
- `hotspot kernel`：
  - 把聊天纪要误当继续资产、把 UI suggestion 误当 authority，最容易让 handoff truth 漂移
- `mirror gap discipline`：
  - 一旦 compact 后世界变形，先回 `SessionMemory` 与 `PromptSuggestion` 的 contract / registry 重建 continuation

## 5. MCP / Plugin / Settings Sync 子系统

- `contract`：
  - `mcp/config.ts`、`MCPConnectionManager.tsx`、`PluginInstallationManager.ts`
- `registry`：
  - config merge、connection registry、plugin lifecycle registration
- `当前准入能力状态`：
  - 当前已被准入、批准并对外暴露的外部能力状态
- `consumer subset`：
  - `commands/mcp`、`commands/plugin`、host / bridge / channel 路径只是控制壳层
- `hotspot kernel`：
  - scope 合并、approval、policy、settings sync 与 remote managed settings 一旦漂移，就会直接改写外部能力边界
- `mirror gap discipline`：
  - 一旦外部能力看起来像默认主路径，先回 `mcp/config.ts` 和插件生命周期 contract / registry，而不是先在 command shell 改词

## 6. IDE / LSP / Voice / Docs 子系统

- `contract`：
  - `lsp/LSPServerManager.ts`、`voice.ts`
- `registry`：
  - LSP bridge registration、voice integration wiring
- `桥接能力子集`：
  - 当前 bridge 已承接的 capability 子集与 host handoff 状态
- `consumer subset`：
  - `LSPTool`、mobile / desktop / voice 前台只拿桥接投影
- `hotspot kernel`：
  - 把 capability bridge 误写成 UI 装饰，最容易让 host / tool / service 边界一起失真
- `mirror gap discipline`：
  - 一旦 `lsp`、voice 或 docs 看起来像独立插件层，先回 `LSPServerManager` 与 `voice.ts`

## 7. Observability / Logging / Recovery Evidence 子系统

- `contract`：
  - `analytics/index.ts`、`internalLogging.ts`
- `registry`：
  - diagnostic / logging / recovery evidence registration
- `诊断 / 恢复读回面`：
  - 当前可被读回的 diagnostic ledger、internal logs 与 recovery evidence
- `consumer subset`：
  - notifier、tips、部分前台通知只拿用户可见辅助投影
- `hotspot kernel`：
  - 观察面、恢复证据面与 signer 结算一旦缺失，系统就会出现执行后无责扩张与无法回绑连续性
- `mirror gap discipline`：
  - 一旦观测又被写成“附属统计”，先回 `analytics`、`internalLogging` 与 recovery evidence 这一侧

## 8. Services 里的特殊目录：`services/tools`

这组目录最容易被忽略，因为名字看起来像重复：

- `services/tools/toolOrchestration.ts`
- `services/tools/toolExecution.ts`
- `services/tools/toolHooks.ts`

它真正代表的是：

- tool runtime orchestration，而不是 tool definition

也就是说：

1. `src/tools/` 负责定义工具族群与 prompt surface
2. `src/services/tools/` 负责真正编排执行、并发、安全上下文与 hook

这是一个典型的：

- definition plane / runtime plane 分离

## 9. Reject 顺序

更稳的 `services/` reject 顺序是：

1. 先回 `api / compact`
2. 再回 `memory`
3. 再回 `mcp / plugins / managed settings`
4. 最后才看 `services/tools` 与观测投影层

## 10. 一句话总结

这页真正值钱的，不是把 `services/` 二级目录再排成一张更细的地图，而是把 later maintainer 拉回：每个长期子系统究竟沿 `contract -> registry -> 当前暴露层 -> consumer subset -> hotspot kernel -> mirror gap discipline` 的哪一段暴露正式入口；services 页只做 bridge，不代签对象级 verdict。
