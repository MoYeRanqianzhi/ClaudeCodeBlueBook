# 安全资格完成投影速查表：surface、visible completion subset、hidden truth与overclaim risk

## 1. 这一页服务于什么

这一页服务于 [101-安全资格完成投影：为什么completion-signer已经签字，不同surface仍只能看到完成真相的子集](../101-%E5%AE%89%E5%85%A8%E8%B5%84%E6%A0%BC%E5%AE%8C%E6%88%90%E6%8A%95%E5%BD%B1%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88completion-signer%E5%B7%B2%E7%BB%8F%E7%AD%BE%E5%AD%97%EF%BC%8C%E4%B8%8D%E5%90%8Csurface%E4%BB%8D%E5%8F%AA%E8%83%BD%E7%9C%8B%E5%88%B0%E5%AE%8C%E6%88%90%E7%9C%9F%E7%9B%B8%E7%9A%84%E5%AD%90%E9%9B%86.md)。

如果 `101` 的长文解释的是：

`为什么 completion 真相统一成立后，各 surface 仍只能看到不同子集，`

那么这一页只做一件事：

`把不同 surface 的可见完成子集、隐藏真相与过度承诺风险压成一张投影矩阵。`

## 2. 安全资格完成投影矩阵

| surface | visible completion subset | hidden truth | overclaim risk | 关键证据 |
| --- | --- | --- | --- | --- |
| BridgeDialog | failed / reconnecting / active / connecting 的较完整 bundle | 更底层 completion 细节与 signer 时序 | 冒充“唯一完整控制台” | `BridgeDialog.tsx:137-156` |
| PromptInputFooter | 仅 narrow bridge status；implicit remote 下只显 reconnecting | failed truth、其余 implicit 状态 | footer 过度承诺完整 bridge truth | `PromptInputFooter.tsx:173-185` |
| bridge failure notification | 只投影 failed + detail | success/connecting/reconnecting 全貌 | 把通知面误当全量状态面 | `useReplBridge.tsx:102-112,339-349` |
| MCP notifications | only failed / needs-auth counts + `/mcp` route | connected 成功态、单 server completion | 通知面被误读为 MCP 全貌 | `useMcpConnectivityStatus.tsx:30-63` |
| `/status` MCP summary | aggregated counts by state | 单 server 级 completion、tools 可用性 | summary 冒充 detailed control plane | `status.tsx:96-114` |
| MCPRemoteServerMenu | connected 之上再收紧到 effectively authenticated | 其他 server 全局状态、通知层问题汇总 | 局部 server menu 冒充全局授权面 | `MCPRemoteServerMenu.tsx:88-100` |

## 3. 最短判断公式

看到某个 surface 在说“已经完成”时，先问五句：

1. 它到底能看到 completion 真相的哪一部分
2. 它看不到的那部分是什么
3. 它是否只承担 narrow/aggregate/notification 责任
4. 它有没有把自己的子集误说成全貌
5. 当前用户会不会因此误以为其他隐藏断点也已完成

## 4. 最常见的五类投影误读

| 误读方式 | 会造成什么问题 |
| --- | --- |
| 把 footer 当完整 bridge 控制台 | 忽略 failed 已被路由到 notification |
| 把 notification 当全量状态面 | 只看到问题，不知道成功子集 |
| 把 `/status` count 当 detailed truth | 聚合面误冒充明细面 |
| 把 connected 当 effectively authenticated | 工具/能力可用性被说过头 |
| 把局部 surface 的 success 当全局成功 | 隐藏断点被系统性忽略 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
真正成熟的不是：

`所有界面都说同一句完成文案，`

而是：

`所有界面都只投影自己真实看见的那部分完成真相。`
