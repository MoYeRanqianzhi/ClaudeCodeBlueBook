# 安全恢复清理权限速查表：artifact、cleanup owner、cleanup gate与forbidden premature clear

## 1. 这一页服务于什么

这一页服务于 [134-安全恢复清理权限边界：为什么Claude Code不允许任何局部成功信号随便抹掉失败痕迹，只有消费完整闭环的所有者才配清除](../134-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E6%B8%85%E7%90%86%E6%9D%83%E9%99%90%E8%BE%B9%E7%95%8C%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88Claude%20Code%E4%B8%8D%E5%85%81%E8%AE%B8%E4%BB%BB%E4%BD%95%E5%B1%80%E9%83%A8%E6%88%90%E5%8A%9F%E4%BF%A1%E5%8F%B7%E9%9A%8F%E4%BE%BF%E6%8A%B9%E6%8E%89%E5%A4%B1%E8%B4%A5%E7%97%95%E8%BF%B9%EF%BC%8C%E5%8F%AA%E6%9C%89%E6%B6%88%E8%B4%B9%E5%AE%8C%E6%95%B4%E9%97%AD%E7%8E%AF%E7%9A%84%E6%89%80%E6%9C%89%E8%80%85%E6%89%8D%E9%85%8D%E6%B8%85%E9%99%A4.md)。

如果 `134` 的长文解释的是：

`为什么失败痕迹的清理权必须被收紧，`

那么这一页只做一件事：

`把主要 artifact 的 cleanup owner、cleanup gate 与 forbidden premature clear 压成一张矩阵。`

## 2. 清理权限矩阵

| artifact | cleanup owner | cleanup gate | forbidden premature clear | 关键证据 |
| --- | --- | --- | --- | --- |
| notification current/queue item | notification queue controller | timeout / invalidation / explicit `removeNotification(key)` | 任意调用方直接把痕迹静默抹掉 | `notifications.tsx:45-75,78-116,193-213` |
| `plugins.needsRefresh` | `refreshActivePlugins()` | full Layer-3 swap 完成，并显式 `needsRefresh=false` | `useManagePlugins` 仅因提示已展示就 reset；局部刷新就假装已应用 | `useManagePlugins.ts:287-303`; `refresh.ts:59-71,123-138` |
| plugin auto-refresh failure path | `PluginInstallationManager` 退回人工 repair 路径 | auto-refresh 真实成功；否则 fallback `needsRefresh=true` | 后台安装部分成功就把 pending / refresh 痕迹清空 | `PluginInstallationManager.ts:135-165` |
| plugin updates-only path | user-triggered `/reload-plugins` path | 用户明确执行 refresh，闭环被消费 | background reconcile 自己宣布更新已生效 | `PluginInstallationManager.ts:166-179`; `refresh.ts:65-67` |
| MCP reconnect timers / pending trail | MCP connection manager | reconnect success / final failure / disable / unmount | 连接尚未终局就提前删 pending / timer 痕迹 | `useManageMCPConnections.ts:333-460,1026-1041` |
| bridge resume hint | bridge loop terminal authority | 非 fatal、确有可恢复 session | fatal exit 后继续给出 resume 承诺 | `bridgeMain.ts:1515-1523` |
| bridge pointer | archive+deregister / stale-session detector / resumable shutdown path | env gone、session stale、或真正归档完成；可恢复时故意保留 | resumable 时过早 clear；multi-session 场景乱签发 | `bridgeMain.ts:1573-1576,2384-2392,2700-2728` |

## 3. 最短判断公式

判断某条恢复痕迹是否被正确治理，先问四句：

1. 这个 artifact 到底归谁清
2. 需要什么 cleanup gate 才配清
3. 哪种局部成功信号最容易诱发 premature clear
4. 若太早清掉，用户会失去哪条 repair path 或哪段关键真相

## 4. 最常见的四类误读

| 误读 | 实际问题 |
| --- | --- |
| “显示层可以顺手把状态也清了” | 提示层不等于闭环消费层 |
| “后台改动已经完成，所以前台也算完成” | materialized 不等于 active |
| “有一点好转就先把红字去掉” | 局部回暖不等于正式恢复 |
| “pointer 留着碍事，先删掉再说” | 可恢复资产不是普通脏数据 |

## 5. 一条硬结论

Claude Code 的恢复治理之所以更成熟，不是因为：

`它更会显示错误，`

而是因为：

`它更清楚谁配把错误正式忘掉。`

