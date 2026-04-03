# 安全能力协商与版本地板速查表：surface、declared capability-version artifact、current gate与cleanup migration implication

## 1. 这一页服务于什么

这一页服务于 [141-安全能力协商与版本地板：为什么cleanup语义不能只靠optional fields，还必须由initialize、capability surface、minimal reply与min_version共同约束](../141-%E5%AE%89%E5%85%A8%E8%83%BD%E5%8A%9B%E5%8D%8F%E5%95%86%E4%B8%8E%E7%89%88%E6%9C%AC%E5%9C%B0%E6%9D%BF%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88cleanup%E8%AF%AD%E4%B9%89%E4%B8%8D%E8%83%BD%E5%8F%AA%E9%9D%A0optional%20fields%EF%BC%8C%E8%BF%98%E5%BF%85%E9%A1%BB%E7%94%B1initialize%E3%80%81capability%20surface%E3%80%81minimal%20reply%E4%B8%8Emin_version%E5%85%B1%E5%90%8C%E7%BA%A6%E6%9D%9F.md)。

如果 `141` 的长文解释的是：

`为什么安全语义升级不只要兼容迁移，还要先完成资格协商，`

那么这一页只做一件事：

`把不同 surface / path 上的 capability/version artifact、current gate 与 cleanup migration implication 压成一张矩阵。`

## 2. 能力协商矩阵

| surface / path | declared capability-version artifact | current gate | cleanup migration implication | 关键证据 |
| --- | --- | --- | --- | --- |
| SDK `initialize` request/response | request 声明 hooks / agents / jsonSchema / promptSuggestions；response 声明 commands / models / output styles / account | 会话开始时显式协商，不假定天然同构 | cleanup capability / contract version 最适合进入 formal init negotiation | `controlSchemas.ts:57-95`; `print.ts:4339-4508` |
| `initialize` idempotence | 已初始化再次协商直接 error | 单次宪法时刻，不接受无限重写 | cleanup semantic admission 不应靠会话中途的隐式漂移 | `print.ts:4355-4366` |
| outbound-only bridge init | success 但只回 minimal capabilities | 当前上下文只能承诺子集，就只回子集 | 旧 host 可拿 minimal cleanup surface，但不能假装 full support | `bridgeMessaging.ts:265-304` |
| MCP server status surface | `serverInfo.version`、`capabilities.experimental`、`tools` | 能力和版本被正式暴露为状态对象 | cleanup 不应只靠状态词，应有 formal capability/version artifact | `coreSchemas.ts:168-218` |
| capabilities passthrough | `experimental['claude/channel']` 先 allowlist 过滤再下发 | 只暴露当前真正可消费的 capability，避免 dead button | cleanup UI 也应只展示当前已协商成功的动作与解释力 | `print.ts:1666-1699` |
| elicitation registration | 未声明 elicitation capability 就不注册 handler | capability not declared => no semantic admission | cleanup ack / interactive cleanup 未来也应显式 capability-gated | `print.ts:1277-1385` |
| v1 / v2 bridge min version | v1 / v2 各自独立 `min_version` | 版本过低直接 skip path | 高风险 cleanup semantics 可能需要 dedicated min-version gate | `envLessBridgeConfig.ts:34-37,139-153`; `bridgeEnabled.ts:150-173`; `initReplBridge.ts:410-420,456-460` |
| work secret grammar | `version === 1` 才接受 | grammar version mismatch => hard reject | 某些 cleanup signer / audit grammar 若错配，也不应 best-effort 兼容 | `workSecret.ts:5-18` |
| `system:init` runtime truth | `claude_code_version` 已进入 system message | 宿主已有正式版本真相通道 | cleanup contract version 可在既有 version truth 旁协商，而非完全另起炉灶 | `coreSchemas.ts:1457-1493` |

## 3. 最短判断公式

判断某条新安全语义是否已经从“字段存在”升级到“资格已协商”，先问四句：

1. 它有没有 formal negotiation surface
2. 当前上下文拿到的是 full capability 还是 minimal subset
3. 不支持时是否显式降级或拒绝
4. 版本过低时是否仍被错误放行

## 4. 最常见的四类误读

| 误读 | 实际问题 |
| --- | --- |
| “字段能 parse 就算支持” | parse 不等于资格已协商 |
| “initialize success 就等于 full capability” | 也可能只是 minimal reply |
| “version floor 只是升级提示” | 在这些路径里它其实是 admission gate |
| “capability 没声明也可以先试试” | Claude Code 在多处明确选择不注册、不透传或直接拒绝 |

## 5. 一条硬结论

对高价值安全语义来说，  
真正危险的不是字段暂时没上线，  
而是：

`系统还没正式宣布“你已经具备理解它的资格”，宿主却先开始按自己想象消费它。`
