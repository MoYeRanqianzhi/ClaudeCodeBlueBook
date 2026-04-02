# 安全恢复词法仲裁速查表：surface、role、lexical authority与conflict winner-loser

## 1. 这一页服务于什么

这一页服务于 [62-安全恢复词法仲裁：当通知、卡片、摘要与footer同时说话时，谁有资格代表当前真相](../62-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E8%AF%8D%E6%B3%95%E4%BB%B2%E8%A3%81%EF%BC%9A%E5%BD%93%E9%80%9A%E7%9F%A5%E3%80%81%E5%8D%A1%E7%89%87%E3%80%81%E6%91%98%E8%A6%81%E4%B8%8Efooter%E5%90%8C%E6%97%B6%E8%AF%B4%E8%AF%9D%E6%97%B6%EF%BC%8C%E8%B0%81%E6%9C%89%E8%B5%84%E6%A0%BC%E4%BB%A3%E8%A1%A8%E5%BD%93%E5%89%8D%E7%9C%9F%E7%9B%B8.md)。

如果 `62` 的长文解释的是：

`为什么多个 surface 同时描述同一恢复事实时必须仲裁谁算数，`

那么这一页只做一件事：

`把不同 surface 的 role、lexical authority level 与 conflict winner / loser 压成一张跨面仲裁矩阵。`

## 2. 词法仲裁矩阵

| surface | role | lexical authority level | 典型词法 | 冲突时赢谁 | 冲突时输给谁 | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| notification current | 抢注意力、提示下一步动作 | 中，擅长风险显化，不擅长终局解释 | `failed`、`needs auth`、`disconnected`、`install failed` | footer、平缓 summary、弱绿色 pill | authoritative writer / higher signer 的更高层解释 | `notifications.tsx:78-212`、`useIDEStatusIndicator.tsx:78-154`、`useMcpConnectivityStatus.tsx:24-74` |
| `/status` summary | 盘点、总览、计数压缩 | 中低，只配做 inventory，不配做 resolved | `Connected to ...`、`Installed ...`、`n connected / n failed` | 纯装饰性低占位文案 | notification 风险词、authoritative/higher signer 的更高层结论 | `status.tsx:38-114` |
| footer pill | 持续低占位状态提醒 | 低，只配保留裁剪后的窄词法 | `Remote Control reconnecting`、`Remote Control active` | 很少主动赢；仅在无更高风险词时保留弱状态 | notification current、dialog 细节面、更高层 signer | `PromptInputFooter.tsx:173-189` |
| dialog / card detail | 局部解释补全、细节展开 | 中，可解释当前局部状态，但不配单独宣布 resolved | `statusLabel`、`footerText`、局部 URL/上下文说明 | footer、过度压缩的 badge | notification 风险词、authoritative/higher signer 的最终解释 | `BridgeDialog.tsx:137-210` |
| authoritative writer / higher signer | 账本真相与解释闭环 | 最高 | `cleared` 的账本事实、`resolved` 的最终解释 | 所有 lower surfaces | 无 | `sessionState.ts:92-130`、`ccrClient.ts:476-520`、`49`-`62` 主线归纳 |

## 3. 最短判断公式

面对多个入口同时发声时，先问四句：

1. 当前哪个 surface 只是抢注意力，哪个 surface 更接近账本
2. 当前有没有高风险否定词正在压制弱绿色词
3. 当前哪一句只是盘点摘要，哪一句已经越级替高层 signer 说满
4. 如果 authoritative writer 还没给出 cleared / resolved 依据，绿色词是否必须让位

## 4. 最常见的四类仲裁错误

| 仲裁错误 | 会造成什么问题 |
| --- | --- |
| 让 footer 的 `active` 盖过 notification 的 `failed` | 低占位弱词冒充当前真相 |
| 让 `/status` 的聚合盘点压过单点高风险提示 | summary layer 稀释具体恢复问题 |
| 让 dialog 局部解释越级宣布 resolved | 细节面板替高层 signer 签字 |
| 把“谁先看到”误当成“谁更接近真相” | 注意力优先级冒充真值优先级 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
最危险的不是多个 surface 同时存在，  
而是：

`低主权 surface 在词法冲突中没有让位，仍被允许代表当前真相。`
