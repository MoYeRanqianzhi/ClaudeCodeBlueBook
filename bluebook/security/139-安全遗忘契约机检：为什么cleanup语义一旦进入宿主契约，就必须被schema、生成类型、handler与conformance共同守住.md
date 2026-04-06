# 安全遗忘契约机检：为什么cleanup语义一旦进入宿主契约，就必须被schema、生成类型、handler与conformance共同守住

## 1. 为什么在 `138` 之后还必须继续写“契约机检”

`138-安全遗忘宿主契约` 已经回答了：

`cleanup 语义若不进入 SDK 和 host contract，宿主就永远只能看到结果变了，却看不见结果为何足以合法遗忘旧痕迹。`

但如果继续追问，  
还会碰到一个更硬的工程问题：

`cleanup 语义即便真的进入 contract，怎样才能确保它不会在后续演进中再次退化成注释、文案或局部实现细节？`

答案只能是：

`它必须被机检。`

而且不是单点机检，  
而是至少要被四层东西一起守住：

1. schema
2. 生成类型
3. handler
4. conformance

所以 `138` 之后必须继续补出的下一层就是：

`安全遗忘契约机检`

也就是：

`cleanup 语义若要真正成为宿主能力，就必须从“可以加字段”继续推进到“字段被 schema、types、handler 与兼容约束共同守住”。`

## 2. 最短结论

Claude Code 当前已经具备非常强的“契约机检地基”：

1. `coreSchemas.ts` 直接声明 SDK data types 的 single source of truth  
   `src/entrypoints/sdk/coreSchemas.ts:1-8`
2. `coreTypes.ts` 明确写出类型是从 Zod schemas 生成的，且修改流程是“先改 schema，再跑生成脚本”  
   `src/entrypoints/sdk/coreTypes.ts:1-9`
3. `controlSchemas.ts` 又把 SDK builders 与 CLI 的 control protocol 正式 schema 化  
   `src/entrypoints/sdk/controlSchemas.ts:1-8`
4. `print.ts` 则是真正执行 `mcp_status`、`reload_plugins`、`mcp_reconnect`、`mcp_toggle` 等 contract 的 handler 层  
   `src/cli/print.ts:2957-3225`

但同样必须严格指出：

1. cleanup 字段当前根本不在这些 schema 中
2. 当前可见提取树里也没有对应的生成脚本与生成产物
3. 因此我们只能说：

`Claude Code 已经有 cleanup contract machine-check 的架构路径，`

不能说：

`cleanup contract machine-check 已经被工程化完成。`

所以这一章的最短结论是：

`Claude Code 已拥有把 cleanup 语义做成可机检契约的骨架，但 cleanup 目前还没有进入这条骨架。`

再压成一句：

`cleanup 语义现在离“正式契约”只差一步，离“被机检的正式契约”还差两步。`

## 3. 第一性原理：为什么真正的契约不是“加字段”，而是“加了字段以后谁也绕不过它”

如果一个系统说：

`这里有个新字段。`

这并不等于它已经拥有了这个契约。

真正的契约至少要满足四件事：

1. schema 必须承认它
2. 类型系统必须承认它
3. handler 必须真的生产/消费它
4. 兼容与 conformance 必须限制它不能被随意删改

缺任意一层，  
cleanup 语义就会再次退回：

1. 注释
2. 本地实现细节
3. 弱 surface 的二次推断
4. 宿主自己的猜测

所以从第一性原理看：

`加字段只是语法动作，机检才是宪法动作。`

## 4. Claude Code 已经把“single source of truth”这套骨架搭好了

### 4.1 `coreSchemas.ts` 明确把 schema 提升成源头

`src/entrypoints/sdk/coreSchemas.ts:1-8` 写得非常明确：

1. 这是 serializable SDK data types 的 Zod schemas
2. 这些 schemas 是 single source of truth
3. TypeScript types 由这些 schemas 生成

这说明团队的哲学并不是：

`接口先写类型，schema 只是辅助`

而是：

`schema 才是根。`

这为 cleanup 语义未来进入 contract 打下了最关键的基础。

### 4.2 `coreTypes.ts` 又把修改流程写成了制度

`src/entrypoints/sdk/coreTypes.ts:1-9` 进一步说明：

1. types 来自 `coreSchemas.ts`
2. 想修改 types
3. 第一步先改 schema
4. 第二步跑 `bun scripts/generate-sdk-types.ts`

这意味着在正确的工程闭环里，  
cleanup 字段一旦进入 schema，  
它就不该只停在 runtime validation，  
而应同步进入 generated types。

### 4.3 `controlSchemas.ts` 说明 control protocol 也已经在 schema 化

`src/entrypoints/sdk/controlSchemas.ts:1-8` 说明：

1. 这不是内部注释
2. 这是真正的 control protocol schema
3. 是 SDK builders 和 CLI 之间的正式接口

因此 cleanup 语义若要进入 `reload_plugins`、`mcp_status`、`mcp_reconnect`、`mcp_toggle`，  
它的自然落点也不是 print.ts 注释，  
而是：

`controlSchemas.ts`

## 5. handler 层说明：contract 不只要被声明，还要被真正生产/消费

这一点在 `src/cli/print.ts:2957-3225` 看得很清楚。

这里 handler 明确做了：

1. `mcp_status` -> `sendControlResponseSuccess(..., { mcpServers: ... })`
2. `reload_plugins` -> 返回 commands / agents / plugins / `mcpServers` / `error_count`
3. `mcp_reconnect` -> 根据 `result.client.type` 决定 success 还是 error
4. `mcp_toggle` -> 走 enable/disable path

这说明 contract 真正生效的链条是：

1. schema 声明
2. handler 实现
3. response payload 发出

所以 cleanup 语义未来若只加到 schema，  
却不进这些 handler，  
它仍然不算完成。

反过来说，  
如果 cleanup 语义进入这些 handler，  
那就意味着：

`宿主终于能拿到“这次 cleanup 为何成立”的正式 payload。`

## 6. 当前 cleanup 语义为什么仍然不算“已机检契约”

这里必须保持严格。

### 6.1 schema 里没有 cleanup fields

我们已经确认：

1. `system:init` 没有 cleanup provenance
2. `system:status` 没有 cleanup summary
3. `reload_plugins` response 没有 `consumed_needs_refresh` 等 cleanup fields
4. `mcp_status` response 没有 cleanup replacement semantics

因此今天 cleanup 语义还没有进入 single source of truth。

### 6.2 handler 里也没有 cleanup payload

`print.ts` 的几个关键 handler 当前都只返回：

1. status
2. list
3. counts
4. error_count

而没有：

1. cleanup_owner
2. cleanup_reason
3. cleanup_gate
4. cleanup_replaced_by
5. residual_cleanup_debt

所以就算宿主拿到了 response，  
也仍然只能靠差分和文案猜。

### 6.3 当前可见提取树里连生成脚本和生成产物都不在位

这点非常重要，而且必须严格措辞。

源码注释明确提到：

1. `scripts/generate-sdk-types.ts`
2. `coreTypes.generated.*`

但在当前可见提取树里：

1. `src/entrypoints/sdk/` 只看见 `coreSchemas.ts`、`controlSchemas.ts`、`coreTypes.ts`
2. 未看到 `coreTypes.generated.*`
3. 也未看到注释里提到的生成脚本

这意味着：

`就当前可见源码提取树而言，我们只能证明契约机检路径被设计出来了，不能证明它在 cleanup 方向已经被完整落地。`

这正是前面一直坚持的结论上限。

## 7. 下一代 cleanup contract machine-check 最应该长成什么样

基于当前架构，  
最自然的推进路径至少应是四步。

### 7.1 先把 cleanup fields 写进 schema

例如进入：

1. `SDKSystemMessageSchema`
2. `SDKStatusMessageSchema`
3. `SDKControlReloadPluginsResponseSchema`
4. `SDKControlMcpStatusResponseSchema`

### 7.2 再让类型生成链把它们扩散到宿主类型面

也就是：

1. generated types 同步出现 cleanup fields
2. 宿主可以静态消费这些字段

### 7.3 再让 handler 真正产出这些字段

例如：

1. `reload_plugins` 返回 `consumed_needs_refresh`
2. `mcp_reconnect` 返回 replaced / residual semantics
3. `mcp_toggle` 返回 disable cleanup provenance

### 7.4 最后补 conformance 层

至少应包括：

1. schema snapshot / compatibility checks
2. handler contract tests
3. host-side decoding tests
4. downgrade / missing-field fallback tests

## 8. 技术先进性：Claude Code 最值得学的不是“有 schema”，而是“知道 schema 应成为契约宪法”

很多系统也有 schema，  
但它们仍把 schema 当：

1. 文档
2. 校验器
3. IDE 辅助

Claude Code 的结构更值得学的地方在于：

`它已经把 schema 摆在 single source of truth 的位置上。`

这意味着一旦 cleanup 语义决定进入这条链，  
它就天然有机会被推进到：

1. runtime validation
2. generated types
3. control response
4. host conformance

这是一条非常先进的宿主化路径。

## 9. 哲学本质：只有被机器共同守住的语义，才配叫“公共契约”

这一章真正的哲学核心是：

`公共契约不是大家都知道，而是大家都绕不过。`

只要 cleanup 语义还可以：

1. 不进 schema
2. 不进 types
3. 不进 handler
4. 不进 tests

那它就仍然可以被悄悄回退成内部经验。

所以真正成熟的公共契约必须满足：

`不是每个人都记得它，而是任何人想绕开它都会撞到机器。`

## 10. 苏格拉底式反思：如果要把 cleanup contract machine-check 再推进一代，还缺什么

继续追问，还能看到三个关键缺口。

### 10.1 缺 cleanup-specific conformance suite

当前可见提取树里，  
我们还没有看到专门围绕 cleanup contract 的测试面。

### 10.2 缺 cleanup backward-compat migration protocol

如果以后 SDK 增加 cleanup fields，  
还必须系统回答：

1. 老宿主忽略新字段怎么办
2. 新宿主面对旧 CLI 缺字段怎么办
3. projection fallback 如何降级

### 10.3 缺 cleanup contract versioning story

如果 cleanup event family 未来继续扩，  
必须开始考虑：

1. 版本
2. optional vs required
3. soft rollout vs hard enforcement

## 11. 本章结论

把 `138` 再推进一层后，  
Claude Code 安全性的下一步工程化方向就更清楚了：

`cleanup 语义不只要进宿主契约。`

它还必须继续被：

1. schema
2. generated types
3. handler
4. conformance

一起守住。

所以如果要真正学习 Claude Code 的安全设计启示，  
最值得学的不是“在 SDK 里多塞几个 cleanup 字段”，  
而是：

`让 cleanup 契约一旦进入协议，就再也不能只靠维护者记忆维持。`

