# 168-179 headless source、bridge authority 与 create-context 子树 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/218-headless source、bridge authority 与 create-context 子树：为什么 168-179 不是线性十二连.md`
- `05-控制面深挖/168-StructuredIO、RemoteIO、setInternalEventReader、setInternalEventWriter 与 flushInternalEvents：为什么 headless transport 的协议宿主不等于同一种恢复厚度.md`
- `05-控制面深挖/169-resume、--continue、print --resume 与 remote-control --continue：为什么 stable conversation resume、headless remote hydrate 与 bridge continuity 不是同一种接续来源.md`
- `05-控制面深挖/170-print --continue、print --resume session-id、print --resume url 与 loadConversationForResume：为什么同属 headless resume，也不是同一种 source certainty.md`
- `05-控制面深挖/171-loadMessagesFromJsonlPath、parseSessionIdentifier、loadConversationForResume 与 sessionId：为什么 print --resume .jsonl 与 print --resume session-id 不是同一种 local artifact provenance.md`
- `05-控制面深挖/172-readBridgePointerAcrossWorktrees、getBridgeSession、reconnectSession 与 environment_id：为什么 remote-control --continue 与 remote-control --session-id 不是同一种 bridge authority.md`
- `05-控制面深挖/173-BridgePointer.environmentId、getBridgeSession.environment_id、reuseEnvironmentId 与 registerBridgeEnvironment：为什么 pointer 里的 env hint、server session env 与 registered env 不是同一种 truth.md`
- `05-控制面深挖/174-BridgeConfig.environmentId、reuseEnvironmentId、registerBridgeEnvironment.environment_id 与 createBridgeSession：为什么本地 env key、reuse claim、live env 与 session attach target 不是同一种环境主权.md`
- `05-控制面深挖/175-BridgeWorkerType、metadata.worker_type、BridgePointer.source 与 environment_id：为什么环境来源标签、prior-state 域与环境身份不是同一种 provenance.md`
- `05-控制面深挖/176-createBridgeSession.environment_id、source、session_context 与 permission_mode：为什么 session attach target、来源声明、上下文载荷与默认策略不是同一种会话归属.md`
- `05-控制面深挖/177-createBridgeSession.source、metadata.worker_type、BridgeWorkerType 与 claude_code_assistant：为什么 session origin declaration 与 environment origin label 不是同一种 remote provenance.md`
- `05-控制面深挖/178-session_context.sources、session_context.outcomes、session_context.model 与 getBranchFromSession：为什么 repo source、branch outcome 与 model stamp 不是同一种上下文主语.md`
- `05-控制面深挖/179-session_context.sources、session_context.outcomes、parseGitRemote、parseGitHubRepository 与 getBranchFromSession：为什么 repo declaration 与 branch projection 不是同一种 git context.md`

边界先说清：

- 这页不是 `168-179` 的细节证明总集。
- 这页不替代 218 的结构长文。
- 这页只抓 `168` 这条邻接厚度轴、`169` 这条 source root、`170->171` 这条 headless source 分支，以及 `172 -> ... -> 179` 这棵 bridge create-context 子树。
- 这页保护的是 thickness、source、authority、provenance、createSession field 与 `session_context` payload 的主语切换，不把某个 helper、某个变量名或某个 request 字段直接升级成稳定公共合同。

## 1. 结构总表

| 节点 | 作用 | 在图上的位置 |
| --- | --- | --- |
| 218 | 解释 `168-179` 的“邻接前置轴 + 两条接续分支 + create-context 子树” | 结构收束页 |
| 168 | 先分 headless protocol family 为什么不等于同一种恢复厚度 | 邻接前置轴 |
| 169 | 再分 stable conversation、headless remote-hydrated transcript 与 bridge continuity 为什么不是同一种接续来源 | source 根页 |
| 170 | 先分同属 `print` host 为什么不等于同一种 source certainty | headless-source 根页 |
| 171 | 继续分 explicit local artifact family 为什么也不是同一种 provenance | local-artifact zoom |
| 172 | 先分 `remote-control --continue` 与 `--session-id` 为什么不是同一种 bridge authority | bridge-authority 根页 |
| 173 | 继续分 pointer env、server session env 与 registered env 为什么不是同一种 truth | env-truth 根页 |
| 174 | 再追 register chain 内部的 environment authority split | register-authority 主干 |
| 175 | 并列分 provenance label、trust-domain 与 identity | `174` 区域下的 sibling zoom |
| 176 | 并列分 `createBridgeSession` 内部的 attach / source / context / policy | `174` 区域下的 sibling zoom / 子根页 |
| 177 | 继续分 session origin declaration 与 environment origin label | `175 × 176` 交叉 zoom |
| 178 | 继续分 `session_context.sources/outcomes/model` | `176` 下的 `session_context` 子根页 |
| 179 | 再把 `sources/outcomes` 里的 git declaration / branch projection 拆开 | git-context zoom |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `168-179` 顺着编号就是一条 headless/bridge 十二连 | 更稳的是 `168` 邻接厚度轴、`169` source root、`170->171` 与 `172->...->179` 两条分支 |
| `169` 只是 `168` 的一个工作流例子 | `168` 先钉 thickness，`169` 再换成 continuation source 主语 |
| `print --continue`、`print --resume session-id`、`print --resume url` 只是自动/手动差别 | `170/171` 更稳是 source certainty 与 local artifact provenance |
| `remote-control --continue` 只是 `--session-id` 的语法糖 | `172` 更稳是 pointer-led continuity authority 与 explicit original-session authority |
| `173/174/175` 都只是在说 environment id | `173/174` 守 env truth / register authority，`175` 守 provenance label / trust-domain / identity |
| `176/177/178/179` 只是 request body 从粗到细的线性展开 | `176` 是 createSession 子根页，下面分 `177` 与 `178->179` 两条子分支 |
| `179` 只是给 `177` 补一点 git 信息 | `179` 更稳是 `178` 的 git-context zoom，不是 `source` field appendix |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `168` = 邻接前置厚度轴；`169` = continuation-source 根页；`170->171` = headless source 分支；`172` = bridge-authority 根页；`173->174` = env-truth / register-authority 主干；`175` 与 `176` = `174` 区域下的 sibling zoom；`177` = 交叉 zoom；`178->179` = `176` 下的 `session_context` / git-context 分支 |
| 条件公开 | `print --resume url` 的 remote materialization、CCR v2 internal-event thickness、`remote-control --continue` 的 pointer continuity、`.jsonl` 的 transcript-file provenance、assistant-mode `worker_type` label |
| 内部/灰度层 | internal-event flush cadence、pointer fanout / cleanup heuristic、env mismatch fallback、`claude/${branch || 'task'}` 命名与部分 typed readback 面的具体暴露 |

## 4. 六个检查问题

- 我现在写的是 thickness、source、bridge authority，还是 `createBridgeSession/session_context`？
- 当前 shared helper / shared variable 是否只说明 downstream machinery 相同，而不是 upstream authority 相同？
- 我是不是把 `170/171` 的 headless source certainty 偷换成了 `172` 的 bridge continuity authority？
- 我是不是把 `173/174` 的 env truth / authority 又压回 `175` 的 provenance taxonomy？
- 我是不是把 `177` 的 session `source` field 与 `175` 的 environment label / pointer domain 写成了同一种 provenance？
- 我有没有把 `178/179` 又写回 env truth，而没有先分 `session_context` payload 与 git-context projection？

## 5. 源码锚点

- `claude-code-source-code/src/cli/structuredIO.ts`
- `claude-code-source-code/src/cli/remoteIO.ts`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/utils/sessionUrl.ts`
- `claude-code-source-code/src/utils/conversationRecovery.ts`
- `claude-code-source-code/src/utils/sessionStorage.ts`
- `claude-code-source-code/src/bridge/bridgeMain.ts`
- `claude-code-source-code/src/bridge/bridgePointer.ts`
- `claude-code-source-code/src/bridge/bridgeApi.ts`
- `claude-code-source-code/src/bridge/createSession.ts`
- `claude-code-source-code/src/bridge/replBridge.ts`
- `claude-code-source-code/src/bridge/types.ts`
- `claude-code-source-code/src/utils/teleport/api.ts`
- `claude-code-source-code/src/utils/detectRepository.ts`
