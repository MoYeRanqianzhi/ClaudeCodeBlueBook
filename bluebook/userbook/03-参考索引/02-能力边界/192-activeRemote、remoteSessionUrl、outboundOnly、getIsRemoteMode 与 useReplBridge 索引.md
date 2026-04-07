# `activeRemote`、`remoteSessionUrl`、`outboundOnly`、`getIsRemoteMode` 与 `useReplBridge` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/204-activeRemote、remoteSessionUrl、outboundOnly、getIsRemoteMode 与 useReplBridge：为什么 remote surface 的 132、135、138、141、142、143 不是并列 remote 页，而是从 front-state consumer topology 分叉出去的五种后继问题.md`
- `05-控制面深挖/132-worker_status、external_metadata、AppState shadow 与 SDK event projection：为什么 bridge 能形成 transcript-footer-dialog-store 对齐，而 direct connect、remote session 更多只是前台事件投影.md`
- `05-控制面深挖/135-createDirectConnectSession、DirectConnectSessionManager、useDirectConnect、remoteSessionUrl 与 replBridgeConnected：为什么 direct connect 更像 foreground remote runtime，而不是 remote presence store.md`
- `05-控制面深挖/138-activeRemote、useDirectConnect、useSSHSession、useRemoteSession、remoteSessionUrl 与 directConnectServerUrl：为什么共用交互壳，不等于共用 remote presence ledger.md`
- `05-控制面深挖/141-remoteSessionUrl、remoteConnectionStatus、remoteBackgroundTaskCount、useRemoteSession、activeRemote 与 getIsRemoteMode：为什么 remote-session presence ledger 不会自动被 direct connect、ssh remote 复用.md`
- `05-控制面深挖/142-outboundOnly、useReplBridge、initBridgeCore、handleServerControlRequest、handleIngressMessage 与 createV2ReplTransport：为什么 hook 已经在 mirror，本体运行时却仍可能落成 gray runtime.md`
- `05-控制面深挖/143-getIsRemoteMode、setIsRemoteMode、activeRemote、remoteSessionUrl、commands-session 与 StatusLine：为什么全局 remote behavior 开关，不等于 remote presence truth.md`

边界先说清：

- 这页不是新的运行时合同正文。
- 这页不是 `00-阅读路径.md` 的简单复制。
- 这页只抓 remote surface 这条深线为什么不能把 132、135、138、141、142、143 当成并列 remote 页。

## 1. 六层阅读图

| 层次 | 先问什么 | 对应页 |
| --- | --- | --- |
| 根页 | 三条远端链路到底消费的是正式状态，还是前台事件投影 | `132` |
| 第二层 | 为什么 direct connect 只像 foreground remote runtime，不像 presence store | `135` |
| 第三层 | REPL 顶层的 `activeRemote` 为什么只是 shared interaction shell | `138` |
| 分叉一 | remote-session presence ledger 为什么不会自动被其他 remote 壳复用 | `141` |
| 分叉二 | bridge mirror 为什么会继续落成 gray runtime | `142` |
| 分叉三 | 全局 `getIsRemoteMode()` 为什么不是 remote presence truth | `143` |

## 2. 最常见的误读顺序

| 误读顺序 | 更稳的顺序 |
| --- | --- |
| 直接把 141、142、143 当成三篇平行 remote 细节页 | 先回到 132/135/138，再按 “presence / gray runtime / behavior bit” 分叉 |
| 把 138 写成对 132 的重复 | 先分 front-state consumer topology，再分 REPL shared interaction shell |
| 把 143 写成 141 的同义页 | 先分 global behavior bit，再分 authoritative presence ledger |
| 把 142 当成 bridge 版的 141 | 先分 presence 问题，再分 mirror runtime topology 问题 |

## 3. 六个检查问题

- 我现在卡住的是 front-state consumer topology、foreground runtime、shared interaction shell，还是更下游的 presence / gray runtime / behavior bit？
- 我是不是把 `activeRemote` 误写成了 remote truth？
- 我是不是把 `remoteSessionUrl` 和 `getIsRemoteMode()` 写成了同一层？
- 我是不是把 bridge mirror 的 gray runtime 写成了普通 presence 缺失？
- 我是不是把 direct connect 的 foreground runtime 写成了未完成的 presence store？
- 我是不是又用目录路径替代了局部子系统的 anti-overlap map？
