# 安全资格生命周期账本速查表：subsystem、current snapshot、missing temporal basis与recommended ledger record

## 1. 这一页服务于什么

这一页服务于 [108-安全资格生命周期账本：为什么统一控制台不能只保存当前结果，还必须保存字段为何升级、为何留场、为何退场的时间性依据](../108-%E5%AE%89%E5%85%A8%E8%B5%84%E6%A0%BC%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F%E8%B4%A6%E6%9C%AC%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E7%BB%9F%E4%B8%80%E6%8E%A7%E5%88%B6%E5%8F%B0%E4%B8%8D%E8%83%BD%E5%8F%AA%E4%BF%9D%E5%AD%98%E5%BD%93%E5%89%8D%E7%BB%93%E6%9E%9C%EF%BC%8C%E8%BF%98%E5%BF%85%E9%A1%BB%E4%BF%9D%E5%AD%98%E5%AD%97%E6%AE%B5%E4%B8%BA%E4%BD%95%E5%8D%87%E7%BA%A7%E3%80%81%E4%B8%BA%E4%BD%95%E7%95%99%E5%9C%BA%E3%80%81%E4%B8%BA%E4%BD%95%E9%80%80%E5%9C%BA%E7%9A%84%E6%97%B6%E9%97%B4%E6%80%A7%E4%BE%9D%E6%8D%AE.md)。

如果 `108` 的长文解释的是：

`快照足以渲染当前，账本才足以解释当前，`

那么这一页只做一件事：

`把关键 subsystem 当前保存了什么快照、缺了什么时间性依据、以及最该补什么 ledger record 压成一张矩阵。`

## 2. 生命周期账本矩阵

| subsystem | current snapshot | missing temporal basis | recommended ledger record | 直接收益 | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| notifications | `current/queue` + `priority/timeoutMs/invalidates/fold` | 何时升级、谁允许升级、为何仍留场、谁触发退场 | `notification_transition` with `threshold_kind/evidence_bundle/retire_owner/expires_at` | 能解释通知为何出现与为何消失 | `AppStateStore.ts:222-225`; `notifications.tsx:5-33,45-212` |
| bridge status | `connected/sessionActive/reconnecting/error/...` + `label/color` | 当前 label 的证据来源、留场法理、退场原因 | `bridge_status_transition` with `from/to/reason_code/freshness_basis/retire_semantics` | footer/dialog/status 共享同一时序解释 | `AppStateStore.ts:133-157`; `bridgeStatusUtil.ts:113-140` |
| plugin refresh | `needsRefresh` + `pluginReconnectKey` | 为什么 pending 已成立、谁配清掉它、是否 full swap 已完成 | `plugin_refresh_transition` with `stale_basis/completion_verifier/retire_owner` | 防止 false clear 和 review 误判 | `AppStateStore.ts:173-215`; `useManagePlugins.ts:287-303`; `refresh.ts:59-67,123-138` |
| pointer / resume | pointer file + current branch logic | keep/clear 的具体法理：stale、fatal、transient、clean-shutdown、resume-eligible | `pointer_lifecycle_transition` with `resume_eligibility/retire_reason/freshness_basis/transition_owner` | 用户和系统都能解释 pointer 为何还合法 | `bridgePointer.ts:77-112`; `bridgeMain.ts:1515-1577,2316-2325,2384-2403,2473-2534` |
| MCP stale cleanup | current clients array + stale cleanup logic | 旧 client 为什么该退、新 client 为什么该接管、退场顺序是什么 | `mcp_client_transition` with `stale_basis/retire_sequence/replacement_mode/retire_owner` | 避免 stale closure 规则只能靠注释理解 | `useManageMCPConnections.ts:791-825` |
| store foundation | generic `setState(prev=>next)` | 这次更新属于什么 lifecycle event | `global_lifecycle_dispatch` or typed transition envelope | 从“写结果”升级到“写有原因的结果” | `store.ts:10-33`; `AppState.tsx:165-178` |
| cross-cutting sync | `onChangeAppState` diff callbacks | 哪些安全字段的 transition 需要统一审计 | `audited_lifecycle_onChange` with typed event families | 把安全 lifecycle 接入统一 diff choke point | `onChangeAppState.ts:43-170` |

## 3. 最短判断公式

看到某个 subsystem 当前只保存快照时，先问五句：

1. 它现在保存的是结果，还是保存了结果的时间依据
2. 如果字段现在还在，系统能不能回答它为何仍在
3. 如果字段刚消失，系统能不能回答是谁让它消失
4. 这条 transition 以后能不能被 UI、日志和 review 同时复用
5. 这一层信息应放在 snapshot，还是应放在 ledger

## 4. 最常见的五类无账本风险

| 风险方式 | 会造成什么问题 |
| --- | --- |
| 只有当前值，没有 transition record | 无法解释状态为何成立 |
| 只有 timeout，没有 cause record | 无法区分自然退场与被驱逐 |
| 只有 clear 结果，没有 retire owner | 无法追责谁撤掉了字段 |
| 只有布尔位，没有 evidence bundle | 无法判断 upgrade 是否越权 |
| 只有局部逻辑，没有统一 ledger | 无法做跨 surface 审计与解释 |

## 5. 一条硬结论

对安全控制面来说，  
真正需要被保存的不是：

`当前字段值本身，`

而是：

`当前字段值背后那条让它升级、留场、退场的时间性依据链。`
