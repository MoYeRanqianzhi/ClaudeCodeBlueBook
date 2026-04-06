# Services 二级目录 Atlas：API、Compact、Memory、MCP、LSP 与 Observability 子系统的权威入口

这一章回答五个问题：

1. `services/` 往二级目录拆开后，到底分成了哪些正式子系统。
2. 每个子系统的权威入口在哪里，主要消费者是谁。
3. 哪些目录是核心控制平面，哪些只是壳层、投影层或辅助消费者。
4. 哪些目录最容易被误读，从而把 Prompt、安全、恢复或治理写坏。
5. 平台设计者该按什么顺序阅读 `services/`。

## 0. 本地扫描与代表性锚点

本地扫描（`2026-04-02`，源码镜像）：

- `src/services/` 可见 `20` 个一级子目录
- `src/services/` 根目录可见 `16` 个根文件
- 文件数较高的目录包括：
  - `mcp`：约 `23` 个文件
  - `api`：约 `20` 个文件
  - `compact`：约 `11` 个文件
  - `analytics`：约 `9` 个文件
  - `lsp`：约 `7` 个文件

这些数字只用于定位热点，不构成成熟度评分。更稳的证据梯度应先看：

1. `contract truth`
2. `registry truth`
3. `authoritative surface`
4. `adapter subset`
5. `danger surface`

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

## 1. 先说结论

`services/` 不是“剩余杂项”目录。

更准确地说，它是 Claude Code 的长期子系统平面，至少可以拆成六组：

1. API / transport / retry 子系统
2. compact / budget / context maintenance 子系统
3. memory / suggestion / summary 子系统
4. MCP / plugin / settings sync 子系统
5. IDE / LSP / voice 等扩展能力子系统
6. analytics / logging / notifier / tips 等观测与辅助子系统

这张 atlas 最关键的意义不是：

- 目录更多

而是：

- 不同子系统暴露了不同的权威入口、不同的消费者，以及不同的危险改动面

也就是说，读 `services/` 的顺序首先是证据更硬不更硬，而不是目录拆得更细不更细。

如果再把入口判断压得更硬一点，`services/` 的每个子系统都至少要回答五个问题：

1. 谁在这里宣布真相
2. 哪些 consumer 只拿到子集
3. 哪个改动面最危险
4. 哪些 stale write / recovery object / projection 最容易在时间上撒谎
5. future maintainer 如果不同意当前实现，应先沿哪条入口链拒收它

再往上收一层，`services/` 也不是模块清单，而是统一定价秩序落成对象层的地方：

- `api` 守请求真相
- `compact` 与 budget 子系统守上下文与时间边界
- `SessionMemory` 与 `PromptSuggestion` 守 continuation 资产
- `mcp` 与 `remoteManagedSettings` 守外部能力边界

如果不先看到这条主线，读者就会重新把 `services/` 误读成后台杂项集合。

## 2. API / Transport 子系统

核心目录与文件：

- `services/api/`
- `services/api/claude.ts`
- `services/api/sessionIngress.ts`
- `services/api/client.ts`
- `services/api/promptCacheBreakDetection.ts`

主要职责：

1. 真正组装并发出模型请求
2. 维护 usage、retry、errors 与 session ingress
3. 在请求前后记录 prompt/cache 漂移

主要消费者：

- `query.ts`
- `QueryEngine.ts`
- 远程恢复与 host writeback 路径

最该当权威入口看的文件：

- `claude.ts`
- `sessionIngress.ts`

最容易误读的边界：

1. `sessionIngress.ts` 不是普通持久化 helper，而是 append-chain 恢复对象。
2. `promptCacheBreakDetection.ts` 不是 debug 插件，而是 prompt 漂移账本。
3. `client.ts` 不是 public API 总入口，真正的行为合同仍在 `claude.ts`。

## 3. Compact / Budget / Context Maintenance 子系统

核心目录与文件：

- `services/compact/`
- `services/tokenEstimation.ts`
- `services/claudeAiLimits.ts`
- `services/policyLimits/`
- `services/rateLimitMessages.ts`

主要职责：

1. 长会话 compact 与 microcompact
2. compact 前后 cache / summary / cleanup 的对象维护
3. budget、limit、rate-limit 相关解释

主要消费者：

- `QueryEngine.ts`
- `query.ts`
- Session memory / memory extraction 路径

最该当权威入口看的文件：

- `compact/compact.ts`
- `compact/postCompactCleanup.ts`

最容易误读的边界：

1. `compact` 不是摘要功能，而是 continuation 维护子系统。
2. `policyLimits` 不是产品文案配置，而是安全 / 成本边界的一部分。
3. `claudeAiLimits.ts` 与 `rateLimitMessages.ts` 解释的是消费者可见约束，不是模型内部预算真相。

## 4. Memory / Suggestion / Summary 子系统

核心目录与文件：

- `services/SessionMemory/`
- `services/PromptSuggestion/`
- `services/AgentSummary/`
- `services/extractMemories/`
- `services/teamMemorySync/`
- `services/toolUseSummary/`
- `services/autoDream/`

主要职责：

1. 压缩长期接手连续性
2. 复用 cache-safe prefix 生成 suggestion / memory
3. 把主线程状态沉淀成后续可继续行动的最小语义体

主要消费者：

- REPL 主线程
- compact 之后的继续路径
- team / subagent / suggestion 路径

最该当权威入口看的文件：

- `SessionMemory/sessionMemory.ts`
- `PromptSuggestion/promptSuggestion.ts`

最容易误读的边界：

1. Session memory 不是聊天纪要，而是 compact 之后的继续资产。
2. Prompt suggestion 不是 UI 小优化，而是 shared prefix 的旁路消费者。
3. `AgentSummary` / `toolUseSummary` 更接近 continuation 投影，而不是额外智能层。

## 5. MCP / Plugin / Settings Sync 子系统

核心目录与文件：

- `services/mcp/`
- `services/plugins/`
- `services/oauth/`
- `services/remoteManagedSettings/`
- `services/settingsSync/`
- `services/mcpServerApproval.tsx`

主要职责：

1. 装配外部能力边界
2. 处理 scope、policy、allowlist、approval 与连接管理
3. 管理 enterprise / user / local / project 多层真相

主要消费者：

- `commands/mcp`
- `commands/plugin`
- host / bridge / channel 路径

最该当权威入口看的文件：

- `mcp/config.ts`
- `mcp/MCPConnectionManager.tsx`
- `plugins/PluginInstallationManager.ts`

最容易误读的边界：

1. `mcp/config.ts` 是多 scope 合并与校验控制面，不只是 JSON 解析器。
2. `remoteManagedSettings/` 是输入边界治理，而不是同步便利层。
3. `plugins/` 是安装/生命周期/marketplace 平面，不等于 runtime tool pool 真相本身。

## 6. IDE / LSP / Voice / Docs 子系统

核心目录与文件：

- `services/lsp/`
- `services/voice.ts`
- `services/voiceStreamSTT.ts`
- `services/voiceKeyterms.ts`
- `services/MagicDocs/`

主要职责：

1. IDE / language intelligence
2. voice 输入与语音流
3. 文档辅助与说明生成

主要消费者：

- `LSPTool`
- voice / mobile / desktop 前台路径

最该当权威入口看的文件：

- `lsp/LSPServerManager.ts`
- `voice.ts`

最容易误读的边界：

1. `lsp/` 不是普通插件目录，而是 tool / service 之间的桥。
2. `voice*` 文件是 capability service，不是 UI 装饰。
3. `MagicDocs` 更接近 prompt/document service，而不是 markdown helper。

## 7. Observability / Logging / User Assist 子系统

核心目录与文件：

- `services/analytics/`
- `services/diagnosticTracking.ts`
- `services/internalLogging.ts`
- `services/notifier.ts`
- `services/tips/`
- `services/preventSleep.ts`

主要职责：

1. 记录 growth、performance 与 runtime 事件
2. 处理内部日志、通知与提示
3. 为长期运行保留观测与辅助面

主要消费者：

- REPL 前台
- debug / telemetry / feature flag 路径

最该当权威入口看的文件：

- `analytics/index.ts`
- `internalLogging.ts`

最容易误读的边界：

1. analytics 不是可有可无的外层统计，而是很多治理开关的观察面。
2. notifier / tips 是用户辅助子系统，不是产品 copy 存放区。
3. `preventSleep.ts` 这类文件虽小，但属于长生命周期运行维护面。

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

## 9. 推荐阅读顺序

更稳的 `services/` 阅读顺序是：

1. `api/`：先知道请求、retry、ingress 与 drift 记录怎么收口
2. `compact/`：再知道 continuation 为什么能维持
3. `SessionMemory` / `PromptSuggestion`：再知道谁在消费 shared prefix
4. `mcp/` / `plugins/`：再知道外部能力如何接入与被治理
5. `services/tools/`：最后看 tool runtime 真正怎么跑

## 10. 一句话总结

`services/` 二级目录 atlas 真正统一的，不是“后台功能一共有多少”，而是每个长期子系统的权威入口、主要消费者与危险改动面。
