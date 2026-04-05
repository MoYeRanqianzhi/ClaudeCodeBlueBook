# 安全恢复资产续保协议速查表：asset、freshness signal、refresh cadence与stale consequence

## 1. 这一页服务于什么

这一页服务于 [92-安全恢复资产续保协议：为什么恢复资产不是保住就够了，还必须持续刷新时效证明以避免活边界被时间性误杀](../92-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E8%B5%84%E4%BA%A7%E7%BB%AD%E4%BF%9D%E5%8D%8F%E8%AE%AE%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E6%81%A2%E5%A4%8D%E8%B5%84%E4%BA%A7%E4%B8%8D%E6%98%AF%E4%BF%9D%E4%BD%8F%E5%B0%B1%E5%A4%9F%E4%BA%86%EF%BC%8C%E8%BF%98%E5%BF%85%E9%A1%BB%E6%8C%81%E7%BB%AD%E5%88%B7%E6%96%B0%E6%97%B6%E6%95%88%E8%AF%81%E6%98%8E%E4%BB%A5%E9%81%BF%E5%85%8D%E6%B4%BB%E8%BE%B9%E7%95%8C%E8%A2%AB%E6%97%B6%E9%97%B4%E6%80%A7%E8%AF%AF%E6%9D%80.md)。

如果 `92` 的长文解释的是：

`为什么恢复资产必须持续续保 freshness proof，`

那么这一页只做一件事：

`把不同恢复资产靠什么续保、多久续保一次、失去续保后会造成什么后果压成一张续保矩阵。`

## 2. 恢复资产续保协议矩阵

| asset | freshness signal | refresh cadence | freshness owner | stale consequence | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| crash-recovery pointer | file `mtime` | 写入即刷新 | pointer writer | 超过 4h 被清，恢复资格失效 | `bridgePointer.ts:22-40,56-74,76-113` |
| high-activity REPL pointer | work dispatch | 按用户消息节奏 | `onWorkReceived` path | 活跃会话 crash 后若不刷新，会被误判 stale | `replBridge.ts:1101-1109` |
| idle perpetual REPL pointer | hourly timer | 1h | perpetual pointer refresh timer | idle >4h 的活边界在下次启动时被清成 fresh session | `replBridge.ts:1505-1524` |
| suspend checkpoint pointer | suspend transition write | 生命周期切换时补写 | perpetual teardown owner | 切入 suspend 时带着旧 freshness 进入下一阶段 | `replBridge.ts:1605-1611` |
| standalone crash-recovery pointer | hourly timer + initial write | 初写 + 1h | standalone bridge main | 5h+ 会话 crash 后 pointer 失鲜 | `bridgeMain.ts:2700-2728` |
| multi-worktree candidate set | `ageMs` 最低者胜 | 每次 `--continue` 时计算 | worktree-aware resolver | 较旧资产错误赢得仲裁 | `bridgePointer.ts:166-181` |
| backend-aligned liveness proof | rolling 4h TTL | 与 backend rolling TTL 同构 | pointer freshness design | 本地与远端对“仍可恢复”判断分裂 | `bridgePointer.ts:30-34`; `pollConfigDefaults.ts:20-29` |

## 3. 最短判断公式

看到一个恢复资产时，先问五句：

1. 它靠什么证明自己仍然新鲜
2. 这个证明多久刷新一次
3. 当前是谁在负责续保
4. 一旦不续保，最先坏掉的是资格真假，还是候选优先级
5. 现在这是活资产，还是已经时间性退化成伪资产

## 4. 最常见的五类续保失守

| 失守方式 | 会造成什么问题 |
| --- | --- |
| 只保留 pointer，不刷新 mtime | 活边界被时间误杀 |
| 只靠用户 prompt 续保 idle 边界 | 长时后台桥接会话失鲜 |
| suspend 前不补写 freshness proof | 刚挂起就带着陈旧资格进入下一阶段 |
| 不按 freshest 选 worktree pointer | 较旧资产错误赢得仲裁 |
| freshness 规则与 backend TTL 脱钩 | 本地与服务端对资产真假判断分裂 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
真正成熟的不是：

`恢复资产还在磁盘上，`

而是：

`恢复资产仍在持续获得足够新的时效证明。`
