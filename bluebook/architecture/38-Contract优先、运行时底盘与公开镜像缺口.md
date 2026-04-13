# Contract优先、运行时底盘与公开镜像缺口

这一章回答五个问题：

1. 为什么公开源码镜像仍足以证明 Claude Code 的工程先进性。
2. 哪些模块边界最能体现 contract-first 与 runtime-first。
3. 为什么热点大文件与成熟架构可以同时成立。
4. 公开镜像有哪些明确缺口，哪些判断必须克制。
5. 公开镜像下研究源码质量时，最稳的判断顺序是什么。

## 0. 代表性源码锚点

- `claude-code-source-code/README.md:70-74`
- `claude-code-source-code/README.md:250-290`
- `claude-code-source-code/README.md:908-923`
- `claude-code-source-code/src/Task.ts:6-124`
- `claude-code-source-code/src/tasks.ts:1-39`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:57-240`
- `claude-code-source-code/src/query.ts:369-560`
- `claude-code-source-code/src/query.ts:1065-1255`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:28-279`

## 1. 先说结论

Claude Code 公开镜像最先进的地方，不在“模块很多”，而在三件事：

1. 关键边界被写成显式 contract。
2. 复杂恢复逻辑被收进运行时底盘，而不是散落到产品层。
3. 即使公开树不完整，仍能清楚看到作者在主动维护 invariants。

但同样必须承认三件事：

1. 公开镜像明确不完整，缺失大量 feature-gated 模块。
2. `query.ts`、`main.tsx`、`attachments.ts` 等热点文件仍然很大。
3. 公开树里没有清晰可见的测试面，因此“先进性”应主要落在结构判断，而不是测试闭环判断。

## 2. 第一类边界：对象合同先行

`Task.ts` 与 `tasks.ts` 最能体现 Claude Code 的成熟度。

因为作者没有把任务系统写成一堆 if/else，而是先定义：

- `TaskType`
- `TaskStatus`
- `TaskStateBase`
- `getAllTasks()`
- `getTaskByType()`

这意味着新任务进入系统时，必须先进入正式对象联合类型。

同样的做法也出现在 `controlSchemas.ts`：

- `initialize`
- `can_use_tool`
- `set_permission_mode`
- `get_context_usage`
- `mcp_status`

这些控制动作都不是临时 JSON，而是显式 schema。

这就是 contract-first 的核心好处：

- 能力扩展先改协议边界
- 再改实现

## 3. 第二类边界：运行时底盘先行

`query.ts` 的大，不只是代码量大，而是它承担了真正的 turn runtime kernel 职责：

- 预算收缩
- compaction
- overflow recovery
- max_output_tokens recovery
- follow-up continuation

这类逻辑如果散落在产品层，会迅速变成不可维护的局部补丁。

`promptCacheBreakDetection.ts` 更进一步说明作者在主动保护底盘：

- 跟踪 system hash
- 跟踪 tool schema hash
- 跟踪 cache_control 变化
- 跟踪 beta headers、effort、extra body params

这不是“调试工具”那么简单，而是在把 prompt cache stability 提升为正式 invariant。

## 4. 热点文件为什么不自动等于坏架构

热点文件当然意味着阅读成本。
但 Claude Code 的热点文件并不是同一种坏味道：

- `query.ts` 更像 turn kernel
- `main.tsx` 更像装配总控层
- `attachments.ts` 更像动态状态晚绑定总入口

这三类文件都天然更容易聚集复杂性。

真正该问的问题不是“它是不是大文件”，而是：

1. 大文件里是否在维护统一 invariant。
2. 新能力是否沿着统一 contract 进入这些文件。
3. 失败、恢复、缓存与治理是否在这里被统一收口。

如果这些问题的答案是“是”，那热点文件更像是集中式 runtime 核，而不是简单的结构塌缩。

## 5. 公开镜像的明确缺口

`README.md` 已经直接说明：

- 108 个 feature-gated 模块未包含在 npm 包中

这意味着后续研究必须继续坚持三条纪律：

1. 可以判断当前可见 contract 的先进性。
2. 可以判断当前可见热点文件的真实职责。
3. 不能把缺失模块脑补成完整实现。

如果继续把“公开镜像缺口”写得更硬，还应再把证据 signer ladder 拆出来：

1. `npm / packaged artifact`
   - 只能签“哪些发布物、类型面、bundled binary 与公开 payload 存在”。
2. `GitHub repo tree / visible source files`
   - 只能签“当前可见 mechanism kernel 怎样写成 contract、registry、state machine 与 choke point”。
3. `README / docs / examples / marketplace manifest`
   - 只能签“作者愿意公开哪些 operator-governance contract、推荐哪些行为、哪些 surface 被视为 public”。
4. `bluebook mirror doctrine`
   - 只能在前三类证据之上做分层降格，不能反向把缺口补成 full implementation certainty。

更稳一点说，公开证据至少还应继续区分成两类交叉 evidence families：

1. `runtime-core evidence`
   - turn kernel、writeback seam、cache break、state machine、permission pipeline。
2. `operator-governance evidence`
   - `CLAUDE.md`、slash commands、hooks、subagents、plugin marketplace、README/example 所暴露的版本化治理工件。

前者在公开镜像里常常不完整；后者反而更公开、更制度化。它们共同影响 ladder 内部的 promotion / downgrade / gap handling，但不构成额外 rung，也不自动形成更高 signer class。后续如果把这两类证据混成一层，later maintainer 就会同时高估源码把握度、低估公开治理面的价值。

同样，README 还直接给出了目录参考与设计模式索引。
这进一步证明公开镜像的价值并不只在源码本体，也在：

- 作者愿意公开哪些结构抽象
- 作者希望外界如何理解这些抽象

## 6. 公开镜像下研究源码质量时的最小判断顺序

后续最稳的顺序不是：

- 先扫热点文件，再猜全貌

而应该是：

1. 先找对象合同。
2. 再找运行时底盘。
3. 再区分 `runtime-core evidence` 与 `operator-governance evidence`。
4. 再找热点文件里的 invariant。
5. 最后才写公开镜像缺口与技术债。

因为只有这样，源码质量分析才不会退化成：

- “这个文件很长”
- “那个模块可能很厉害”

而会回到真正可验证的结构问题。

## 7. 苏格拉底式追问

### 7.1 如果缺失这么多模块，为什么还敢谈先进性

因为我们谈的是：

- 当前可见 contract 和 runtime 底盘的质量

而不是：

- 对内部全貌的想象

### 7.2 为什么 cache break 检测能算源码先进性证据

因为它证明作者不只在写功能，还在维护：

- prompt 结构的稳定性
- 动态参数的边界
- cache key 为什么会碎

这属于更高一层的工程意识。

### 7.3 为什么蓝皮书必须先找 contract，再找热点

因为没有 contract，热点文件只是巨大的实现细节。
只有先找到 contract，热点文件才会显露出“它究竟在维护什么 invariant”。

## 8. 一句话总结

Claude Code 公开镜像的先进性，主要来自 contract-first 与 runtime-first；它的局限则来自热点文件与缺失模块。两者必须同时写，判断才稳。
