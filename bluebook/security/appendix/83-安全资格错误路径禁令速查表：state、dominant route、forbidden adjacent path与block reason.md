# 安全资格错误路径禁令速查表：state、dominant route、forbidden adjacent path与block reason

## 1. 这一页服务于什么

这一页服务于 [99-安全资格错误路径禁令：为什么找到正确修复路径还不够，系统还必须主动封死那些看起来合理的近邻错路](../99-%E5%AE%89%E5%85%A8%E8%B5%84%E6%A0%BC%E9%94%99%E8%AF%AF%E8%B7%AF%E5%BE%84%E7%A6%81%E4%BB%A4%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E6%89%BE%E5%88%B0%E6%AD%A3%E7%A1%AE%E4%BF%AE%E5%A4%8D%E8%B7%AF%E5%BE%84%E8%BF%98%E4%B8%8D%E5%A4%9F%EF%BC%8C%E7%B3%BB%E7%BB%9F%E8%BF%98%E5%BF%85%E9%A1%BB%E4%B8%BB%E5%8A%A8%E5%B0%81%E6%AD%BB%E9%82%A3%E4%BA%9B%E7%9C%8B%E8%B5%B7%E6%9D%A5%E5%90%88%E7%90%86%E7%9A%84%E8%BF%91%E9%82%BB%E9%94%99%E8%B7%AF.md)。

如果 `99` 的长文解释的是：

`为什么正确动作旁边仍需显式封禁近邻错路，`

那么这一页只做一件事：

`把不同 state 的 dominant route、forbidden adjacent path 与禁止理由压成一张禁令矩阵。`

## 2. 安全资格错误路径禁令矩阵

| state | dominant route | forbidden adjacent path | block reason | 关键证据 |
| --- | --- | --- | --- | --- |
| retryable bridge resume | retry same command | `deregister` / premature `clear pointer` | 会直接抹掉 retry mechanism | `bridgeMain.ts:2524-2534` |
| plugin `needsRefresh` | `/reload-plugins` | auto-refresh / auto-reset `needsRefresh` | 会制造半刷新、半签发假完成 | `useManagePlugins.ts:287-303` |
| stale MCP cleanup | stale cleanup -> pending -> reconnect | 保留旧 timer / 旧 onclose / 旧 config reconnect | 旧配置会与新连接竞争 current | `useManageMCPConnections.ts:791-812` |
| never-connected stale MCP server | pending / disabled path | 一律 `clearServerCache` | 会触发无意义真实 connect attempt | `useManageMCPConnections.ts:798-801` |
| bridge no OAuth | `/login` | 先报 policy error / 直接 remote-control | 会把 auth prerequisite 缺失误说成 policy 问题 | `initReplBridge.ts:144-150` |
| CCR transient auth error | retry | `/login` | 当前 auth 由 infrastructure JWT 处理，/login 是错域动作 | `api/errors.ts:212-216` |
| channels auth gap | `/login` then restart | 只 `/login` 不 restart | 只补前提不完成生效路径 | `ChannelsNotice.tsx:73`; `channelNotification.ts:222-227` |

## 3. 最短判断公式

看到一个默认修复动作时，先问五句：

1. 它旁边最像但最危险的近邻错路是什么
2. 这条错路会破坏哪一种资格真相
3. 是不是因为太自动、太通用、太像成功才显得诱人
4. 当前系统是否已经把它显式阻断
5. 用户现在是否仍有机会误走这条路

## 4. 最常见的五类近邻错路

| 错路类型 | 会造成什么问题 |
| --- | --- |
| housekeeping 式过早清理 | 抹掉仍有价值的恢复资产 |
| 自动半刷新 | 伪装成已完成的半签发 |
| 旧异步残留继续回连 | 旧配置与新资格争夺 current |
| 通用 auth 路径滥用 | 把领域错配动作误当修复 |
| 只做前半步 | 制造半修复错觉 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
真正成熟的不是：

`总能指出一条正确路径，`

而是：

`能在正确路径旁边明确封住那些最容易被误选、也最容易破坏资格真相的错路径。`
