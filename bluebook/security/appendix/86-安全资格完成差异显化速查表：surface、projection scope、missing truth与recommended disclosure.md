# 安全资格完成差异显化速查表：surface、projection scope、missing truth与recommended disclosure

## 1. 这一页服务于什么

这一页服务于 [102-安全资格完成差异显化：为什么系统不应让用户自己猜某个surface漏看了什么，而应显式提示投影盲区](../102-%E5%AE%89%E5%85%A8%E8%B5%84%E6%A0%BC%E5%AE%8C%E6%88%90%E5%B7%AE%E5%BC%82%E6%98%BE%E5%8C%96%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E7%B3%BB%E7%BB%9F%E4%B8%8D%E5%BA%94%E8%AE%A9%E7%94%A8%E6%88%B7%E8%87%AA%E5%B7%B1%E7%8C%9C%E6%9F%90%E4%B8%AAsurface%E6%BC%8F%E7%9C%8B%E4%BA%86%E4%BB%80%E4%B9%88%EF%BC%8C%E8%80%8C%E5%BA%94%E6%98%BE%E5%BC%8F%E6%8F%90%E7%A4%BA%E6%8A%95%E5%BD%B1%E7%9B%B2%E5%8C%BA.md)。

如果 `102` 的长文解释的是：

`为什么投影差异不仅要存在，还要被显式说明，`

那么这一页只做一件事：

`把不同 surface 的 projection scope、缺失真相与建议显化方式压成一张差异矩阵。`

## 2. 安全资格完成差异显化矩阵

| surface | projection scope | missing truth | recommended disclosure | 关键证据 |
| --- | --- | --- | --- | --- |
| PromptInputFooter | narrow bridge subset | failed truth、implicit remote 其他状态 | 说明失败已转通知层 / 此处仅显示 reconnecting | `PromptInputFooter.tsx:173-185` |
| bridge failure notification | only failure projection | success / reconnecting / connecting 全貌 | 标明这是问题面，不是全量状态面 | `useReplBridge.tsx:102-112` |
| `/status` MCP summary | aggregate counts | 单 server 明细、tools 可用性、auth 细节 | 标明 summary only，并 handoff `/mcp` | `status.tsx:96-114` |
| MCP notifications | only failed / needs-auth issues | connected 成功态、per-server completion detail | 标明这里只显示需要动作的问题 | `useMcpConnectivityStatus.tsx:30-63` |
| BridgeDialog | richer bridge bundle | 更深 completion signer 时序与别的 surface 差异 | 标明这是较完整 control view | `BridgeDialog.tsx:152-170` |
| MCPRemoteServerMenu | per-server strong local view | 全局其他 server 与通知聚合问题 | 标明 local detailed view，不是全局 summary | `MCPRemoteServerMenu.tsx:88-100` |

## 3. 最短判断公式

看到一个 surface 时，先问五句：

1. 它当前投影 scope 是什么
2. 它没有告诉用户的那部分真相是什么
3. 用户是否会把缺失误读为不存在
4. 当前有没有显式 disclosure 告诉用户这只是子集
5. 是否提供了去更强 surface 的 handoff

## 4. 最常见的五类差异未显化问题

| 问题方式 | 会造成什么问题 |
| --- | --- |
| footer 不说明 failed 已转通知层 | 用户误以为没有 failed |
| `/status` 不说明自己只是 summary | 用户误把聚合结果当全貌 |
| notification 不说明自己只报问题 | 用户误把无通知当全局正常 |
| 局部 menu 不说明自己只看单 server | 用户误把局部成功当全局成功 |
| 强/弱 surface 不说明层级差异 | 用户把投影差异误读成系统矛盾 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
真正成熟的不是：

`把投影差异默默藏在实现里，`

而是：

`把每个界面能看到多少、看不到什么、该去哪里看更多，也一起显式告诉用户。`
