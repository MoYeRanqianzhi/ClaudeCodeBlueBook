# 安全能力声明主权速查表：surface、visible inputs、max allowed lexicon与forbidden stronger claim

## 1. 这一页服务于什么

这一页服务于 [74-安全能力声明主权：为什么不是任何层都配把能力状态说成enabled、pending、connected、active](../74-%E5%AE%89%E5%85%A8%E8%83%BD%E5%8A%9B%E5%A3%B0%E6%98%8E%E4%B8%BB%E6%9D%83%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E4%B8%8D%E6%98%AF%E4%BB%BB%E4%BD%95%E5%B1%82%E9%83%BD%E9%85%8D%E6%8A%8A%E8%83%BD%E5%8A%9B%E7%8A%B6%E6%80%81%E8%AF%B4%E6%88%90enabled%E3%80%81pending%E3%80%81connected%E3%80%81active.md)。

如果 `74` 的长文解释的是：

`为什么不同表面对能力状态只有不同的声明 ceiling，`

那么这一页只做一件事：

`把不同 surface 的 visible inputs、max allowed lexicon 与 forbidden stronger claim 压成一张声明矩阵。`

## 2. 能力声明主权矩阵

| surface | visible inputs | max allowed lexicon | forbidden stronger claim | 为什么不能说得更满 | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| MCP type layer | 真实连接类型本身 | `connected / failed / needs-auth / pending / disabled` | 自造 `almost ready`、`kind of connected` 之类额外词 | 类型层负责给出受约束状态集，不负责随意扩写语义 | `mcp/types.ts:179-220` |
| IDE 基础 hook | `ideClient.type` + `ideName` | `connected / pending / disconnected / null` | 直接说 `Installed`、`failed install`、`active` | hook 只掌握基础连接真相，不掌握安装/通知/摘要上下文 | `useIdeConnectionStatus.ts:4-32` |
| `/status` IDE / MCP 摘要 | 安装信息、连接状态、server counts | `Connected to ...`、`Installed ...`、`Not connected ...`、`n connected / need auth / pending / failed` | 把摘要面说成 per-server 完整因果解释 | `/status` 有更完整盘点权，但仍是摘要面，不该冒充全链解释 | `status.tsx:38-114` |
| bridge footer pill | `connected / sessionActive / reconnecting` 的压缩组合 | `Remote Control active / reconnecting / connecting…` | 对 implicit remote 继续说满，或在 footer 承担完整 failed 解释 | footer 空间最窄，只配输出最保守的短词 | `bridgeStatusUtil.ts:113-140`、`PromptInputFooter.tsx:173-189` |
| IDE 通知层 | IDE disconnected / install error / JetBrains plugin 情况 | `${ideName} disconnected`、`IDE plugin not connected · /status for info`、`install failed (see /status ...)` | 把通知层说成 authoritative status 面 | 通知层只有提醒权，应把用户转介到 `/status` | `useIDEStatusIndicator.tsx:83-152` |
| MCP 通知层 | failed / needs-auth 的粗粒度计数与分类 | `n MCP servers failed · /mcp`、`n need auth · /mcp`、`n claude.ai connectors unavailable · /mcp` | 逐 server 给出完整 capability 结论 | 通知层只掌握异常聚合，不掌握完整连接账本 | `useMcpConnectivityStatus.tsx:29-63` |

## 3. 最短判断公式

看到任一能力状态词时，先问四句：

1. 这个表面掌握了哪些 visible inputs
2. 它当前配说到哪一个 lexical ceiling
3. 如果它再说满一步，会越权冒充谁
4. 用户下一步该去哪个更高主权表面确认

## 4. 最常见的六类声明越权

| 声明越权 | 会造成什么问题 |
| --- | --- |
| hook 直接输出满文案 | 基础层越权替上层总结全局 |
| footer pill 说完整失败原因 | 窄空间表面制造过度压缩误导 |
| notification 层说成 authoritative truth | 把提醒面误包装成状态账本 |
| 摘要面逐 server 下完整结论 | 让盘点摘要越权承担解释责任 |
| 局部断连提示被误读成全面不可用 | 用局部事实冒充完整真相 |
| 正向词 `connected / active / installed` 说得过满 | 让用户误以为能力边界已被完整证明 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
真正重要的不是“有没有状态词”，  
而是：

`哪个表面当前配说哪一个词。`
