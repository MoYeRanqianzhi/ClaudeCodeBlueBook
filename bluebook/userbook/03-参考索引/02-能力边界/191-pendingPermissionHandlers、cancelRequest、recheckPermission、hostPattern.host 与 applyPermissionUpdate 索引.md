# `pendingPermissionHandlers`、`cancelRequest`、`recheckPermission`、`hostPattern.host` 与 `applyPermissionUpdate` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/203-pendingPermissionHandlers、cancelRequest、recheckPermission、hostPattern.host 与 applyPermissionUpdate：为什么 permission tail 的 196、198、199、201、202 不是并列尾页，而是从 verdict ledger 分叉出去的四种后继问题.md`
- `05-控制面深挖/196-pendingPermissionHandlers、BridgePermissionCallbacks、request_id、handlePermissionResponse 与 isBridgePermissionResponse：为什么 bridge permission race 的 verdict ledger 不是 generic control callback ownership.md`
- `05-控制面深挖/198-cancelRequest、onResponse unsubscribe、pendingPermissionHandlers.delete 与 leader queue recheck：为什么 bridge permission race 的 prompt 撤场、订阅退役、响应消费与策略重判不是同一种收口合同.md`
- `05-控制面深挖/199-onSetPermissionMode、getLeaderToolUseConfirmQueue、recheckPermission、useRemoteSession 与 useInboxPoller：为什么 permission context 变更后的本地重判广播不是同一种 permission re-evaluation surface.md`
- `05-控制面深挖/201-hostPattern.host、sandboxBridgeCleanupRef、sandboxPermissionRequestQueue filter、onResponse unsubscribe 与 cancelRequest：为什么 sandbox network bridge 的同 host sibling cleanup 不是同一种 tool-level permission closeout.md`
- `05-控制面深挖/202-applyPermissionUpdate、persistPermissionUpdate、SandboxManager.refreshConfig 与 localSettings：为什么 sandbox permission 的 persist-to-settings 不是一次单层 permission 写入.md`

边界先说清：

- 这页不是新的运行时合同正文。
- 这页不是 `00-阅读路径.md` 的简单复制。
- 这页只抓 permission tail 的根页与四个后继问题之间的分叉关系。

## 1. 五层分叉图

| 层次 | 先问什么 | 对应页 |
| --- | --- | --- |
| 根页 | permission verdict 在本地到底记在哪张账上 | `196` |
| 分叉一 | verdict 已判后，request-level closeout 还要分别收哪些尾 | `198` |
| 分叉二 | permission context 变化后，leader-local ask 为什么会收到重判广播 | `199` |
| 分叉三 | sandbox network 分支里，为什么会按 `hostPattern.host` 做 same-host sibling sweep | `201` |
| 分叉四 | 本地选择 persist 后，为什么会继续分裂成 context / settings / runtime 三层写面 | `202` |

## 2. 最常见的误读顺序

| 误读顺序 | 更稳的顺序 |
| --- | --- |
| 把 198、199、201、202 当成四篇并列尾页 | 先回到 196，再按“closeout / re-eval / host sweep / persist surfaces”分叉 |
| 把 201 写成 sandbox 版 198 | 先分 request-level closeout，再分 host-level settle |
| 把 202 写成 repo-wide generic persist family | 先承认它只属于 sandbox local response 的后继问题 |
| 把 199 视为 198 的一个 cleanup 子项 | 先分 re-evaluation，再分 closeout |

## 3. 六个检查问题

- 我现在卡住的是 verdict ledger、request closeout、local re-evaluation、same-host sweep，还是 persist write surfaces？
- 我是不是把 `request_id`、leader queue、`hostPattern.host` 与 `localSettings` 写成了同一主语？
- 我是不是把 “判后收口” 和 “context 改变后的重判” 混成一件事了？
- 我是不是把 sandbox network 分支误当成 generic bridge permission 尾部？
- 我是不是把 `202` 夸大成了 repo-wide governor family？
- 我是不是又用目录路径替代了局部子系统的 anti-overlap map？
