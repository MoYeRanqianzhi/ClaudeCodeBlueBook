# `validateSessionRepository`、`getBranchFromSession`、`checkOutTeleportedSessionBranch` 与 `teleportToRemote` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/180-validateSessionRepository、getBranchFromSession、checkOutTeleportedSessionBranch 与 teleportToRemote：为什么 repo admission 与 branch replay 不是同一种 teleport contract.md`
- `05-控制面深挖/179-session_context.sources、session_context.outcomes、parseGitRemote、parseGitHubRepository 与 getBranchFromSession：为什么 repo declaration 与 branch projection 不是同一种 git context.md`
- `05-控制面深挖/174-BridgeConfig.environmentId、reuseEnvironmentId、registerBridgeEnvironment.environment_id 与 createBridgeSession：为什么本地 env key、reuse claim、live env 与 session attach target 不是同一种环境主权.md`

边界先说清：

- 这页不是完整 teleport create/resume 总流程图。
- 这页不是 environment 选择策略页。
- 这页只抓 repo admission 与 branch replay 的 runtime 分裂。

## 1. 两种 teleport contract

| 对象 | 当前更像什么 | 关键消费面 |
| --- | --- | --- |
| `session_context.sources` | repo admission basis | `validateSessionRepository(...)` |
| `session_context.outcomes` | branch replay hint | `getBranchFromSession(...)` / `checkOutTeleportedSessionBranch(...)` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| repo mismatch 与 branch checkout 失败都是同一种 teleport 失败 | admission failure 会阻止 resume，branch failure 会变成 notice |
| 有 `sources` 就应天然有 `outcomes` | 显式 `environmentId` 路径可以写 `sources` 但保留 `outcomes: []` |
| `getBranchFromSession(...)` 也在做 repo 校验 | 它只读 `outcomes`，不裁决 repo eligibility |
| 同在 `session_context` 里，就属于同一种恢复阶段 | admission 与 replay 分属不同 runtime gate |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 专题内稳定不变量 | `validateSessionRepository(...)` 先读 `sources`；`getBranchFromSession(...)` 只读 `outcomes`；branch replay 失败不等于 admission 失败 |
| 条件公开 | `no_repo_required`、显式 `environmentId` attach、`outcomes: []` 的 create path |
| 内部/灰度层 | environment 选择启发式、bundle preflight、`reuse_outcome_branches`、其余 session_context 扩展字段 |

## 4. 五个检查问题

- 当前逻辑是在裁决 repo admission，还是在执行 branch replay？
- 当前 helper 读取的是 `sources` 还是 `outcomes`？
- 当前失败会中断 teleport，还是只生成一条 branch notice？
- 我是不是把显式 `environmentId` 路径误写成“天然带 branch outcome”？
- 我是不是又把这页写回 179 的字段语义页，而没有进入 runtime contract？

## 5. 源码锚点

- `claude-code-source-code/src/utils/teleport.tsx`
- `claude-code-source-code/src/utils/teleport/api.ts`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/main.tsx`
