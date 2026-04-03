# 安全写权撤销速查表：stale writer、revocation trigger、revocation mechanism与risk prevented

## 1. 这一页服务于什么

这一页服务于 [133-安全写权撤销协议：为什么Claude Code一旦认定旧上下文失效，就会撤销旧snapshot、旧timer、旧closure、旧credential与旧promise的写权](../133-%E5%AE%89%E5%85%A8%E5%86%99%E6%9D%83%E6%92%A4%E9%94%80%E5%8D%8F%E8%AE%AE%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88Claude%20Code%E4%B8%80%E6%97%A6%E8%AE%A4%E5%AE%9A%E6%97%A7%E4%B8%8A%E4%B8%8B%E6%96%87%E5%A4%B1%E6%95%88%EF%BC%8C%E5%B0%B1%E4%BC%9A%E6%92%A4%E9%94%80%E6%97%A7snapshot%E3%80%81%E6%97%A7timer%E3%80%81%E6%97%A7closure%E3%80%81%E6%97%A7credential%E4%B8%8E%E6%97%A7promise%E7%9A%84%E5%86%99%E6%9D%83.md)。

如果 `133` 的长文解释的是：

`为什么真正的运行时安全必须主动撤销失效对象的写权，`

那么这一页只做一件事：

`把主要 stale writer 的 revocation trigger、revocation mechanism 与阻止的风险压成一张矩阵。`

## 2. 撤权矩阵

| stale writer | revocation trigger | revocation mechanism | risk prevented | 关键证据 |
| --- | --- | --- | --- | --- |
| stale snapshot context | async await 后 current mode 可能已变化 | 不返回旧 context；返回 `updateContext(ctx)` transform | 旧快照覆盖新 mode | `permissionSetup.ts:1035-1041` |
| stale sticky fast-mode view | circuit breaker 要基于 current state 决策 | 读取 current AppState.fastMode，而非 stale settings snapshot | 旧配置快照错误支配当前 gate | `permissionSetup.ts:1078-1090` |
| stale reconnect timer | config changed、manual reconnect、disable、stale client cleanup | `clearTimeout` + 从 `reconnectTimersRef` 删除 | 旧时序在新世界里继续写状态 | `useManageMCPConnections.ts:803-807,1055-1060,1086-1090` |
| stale `onclose` closure | client config 已 stale，fresh connection 即将建立 | `s.client.onclose = undefined` | 旧 config closure 抢回 writer 权，`last updateServer wins` | `useManageMCPConnections.ts:794-810` |
| stale trusted-device credential | 新登录开始，上一账号 token 仍在本地缓存 | 删除 secure storage token + 清 memo cache | 前一账号 token 越界写入新 enrollment 流程 | `trustedDevice.ts:65-87` |
| stale bridge pointer | session 已在 server 侧消失 | `clearBridgePointer(...)` | 旧恢复承诺继续支配下一次启动 | `bridgeMain.ts:2384-2392` |
| stale resume promise | fatal exit / env expired / auth failed | 跳过 resume hint / 跳过 misleading promise | 对用户发布无法兑现的恢复路径 | `bridgeMain.ts:1515-1522` |

## 3. 最短判断公式

判断一段逻辑是否已经具备“撤权协议”意识，先问四句：

1. 它识别的 stale writer 到底是什么
2. 它何时被判定失效
3. 失效后系统用什么动作收回写权
4. 若不撤权，这个旧对象会以何种方式继续篡改当前真相

## 4. 最常见的四类误读

| 误读 | 实际问题 |
| --- | --- |
| “这只是清理资源” | 忽略它其实在回收作者资格 |
| “稳定 callback 就该绑死旧对象” | 忽略 stable identity 与 fresh authority 是两回事 |
| “旧 token 反正很快会过期” | 忽略过期前已经足够污染新流程 |
| “旧 pointer 只是多一个提示” | 忽略提示本身也会错误路由用户行为 |

## 5. 一条硬结论

Claude Code 的运行时安全比普通系统更成熟，不是因为：

`它更会保存状态，`

而是因为：

`它更会在状态失效后，收回旧对象继续改写现实的资格。`

