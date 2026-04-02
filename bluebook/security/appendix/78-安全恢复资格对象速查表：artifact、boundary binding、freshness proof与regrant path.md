# 安全恢复资格对象速查表：artifact、boundary binding、freshness proof与regrant path

## 1. 这一页服务于什么

这一页服务于 [94-安全恢复资格对象：为什么系统真正保护的不是pointer、插件文件或MCP client，而是同一边界的继续行动权](../94-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E8%B5%84%E6%A0%BC%E5%AF%B9%E8%B1%A1%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E7%B3%BB%E7%BB%9F%E7%9C%9F%E6%AD%A3%E4%BF%9D%E6%8A%A4%E7%9A%84%E4%B8%8D%E6%98%AFpointer%E3%80%81%E6%8F%92%E4%BB%B6%E6%96%87%E4%BB%B6%E6%88%96MCP%20client%EF%BC%8C%E8%80%8C%E6%98%AF%E5%90%8C%E4%B8%80%E8%BE%B9%E7%95%8C%E7%9A%84%E7%BB%A7%E7%BB%AD%E8%A1%8C%E5%8A%A8%E6%9D%83.md)。

如果 `94` 的长文解释的是：

`为什么安全控制面真正保护的是恢复资格而不是恢复工件，`

那么这一页只做一件事：

`把不同工件背后真正被保护的资格对象压成一张对象矩阵。`

## 2. 安全恢复资格对象矩阵

| artifact | boundary binding | freshness proof | revocation gate | regrant path | forbidden shortcut | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- |
| crash-recovery pointer | session + environment | schema valid + `mtime` 未超 TTL | schema invalid / stale / dead session | `--continue` + server truth check | 文件还在就算可恢复 | `bridgePointer.ts:22-40,76-113`; `bridgeMain.ts:2380-2407` |
| resumed bridge session | 原 session 对原 environment 的继续权 | session 仍存在且 env 未换届 | missing session / missing env / env mismatch | reconnect in place 或 fresh session | 只要还能连上某个 env 就算恢复成功 | `bridgeMain.ts:2473-2489`; `replBridge.ts:684-747` |
| active plugin capability set | 当前 AppState 对 commands/agents/hooks/MCP/LSP 的拥有权 | Layer-3 refresh 完成 | `needsRefresh=true` / stale caches / 未完成 full swap | `/reload-plugins` -> `refreshActivePlugins()` | 文件落盘就算插件已生效 | `useManagePlugins.ts:287-303`; `refresh.ts:1-18,59-71,72-138` |
| MCP server capability set | 当前 config / scope 对 tools/commands/resources 的签发权 | config 仍存在且 hash 未变 | config removed / config changed / stale dynamic client | stale cleanup -> pending -> reconnect | client 还在内存就算工具仍合法 | `utils.ts:171-204`; `useManageMCPConnections.ts:765-820` |
| reconnecting bridge transport | 当前边界对 transport 的承认 | generation 未过期且 poll loop 未抢先恢复 | stale handshake / old transport / archived old session | current generation transport reconnect | 旧 transport 晚到也能回写 current | `replBridge.ts:617-747` |

## 3. 最短判断公式

看到一个“还在”的对象时，先问五句：

1. 它绑定的是哪个边界
2. 它靠什么证明自己仍新鲜
3. 现在是谁有权撤销它
4. 如果它已失效，应该走哪条 regrant path
5. 当前看到的是 artifact 还在，还是 entitlement 仍在

## 4. 最常见的五类本体误判

| 误判方式 | 会造成什么问题 |
| --- | --- |
| 把 pointer existence 当 resume legality | 旧会话残留继续误导恢复流程 |
| 把 env 替换当会话延续 | 新边界冒充旧边界 |
| 把 plugin 落盘当运行时激活 | 未完成 full swap 的能力提前发布 |
| 把 MCP client 存活当工具合法性 | ghost tools 继续暴露给当前会话 |
| 把 stale cleanup 当普通 housekeeping | 已失效资格未被正式撤销 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
真正成熟的不是：

`尽量保住所有工件，`

而是：

`只保住仍有资格的对象，并把失效对象送回正确的 regrant 或 revocation 流程。`
