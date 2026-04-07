# `session_context.sources`、`session_context.outcomes`、`parseGitRemote`、`parseGitHubRepository` 与 `getBranchFromSession` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/179-session_context.sources、session_context.outcomes、parseGitRemote、parseGitHubRepository 与 getBranchFromSession：为什么 repo declaration 与 branch projection 不是同一种 git context.md`
- `05-控制面深挖/178-session_context.sources、session_context.outcomes、session_context.model 与 getBranchFromSession：为什么 repo source、branch outcome 与 model stamp 不是同一种上下文主语.md`
- `05-控制面深挖/152-sessionStorage、hydrateFromCCRv2InternalEvents、sessionRestore、listSessionsImpl、SessionPreview 与 sessionTitle：为什么 durable session metadata 不是 live system-init，也不是 foreground external-metadata.md`

边界先说清：

- 这页不是完整 SessionContext 字段总表。
- 这页不是 durable/readback ledger 页。
- 这页只抓 repo declaration 与 branch projection 的 git 语义分裂。

## 1. 两种 git 主语

| 字段 | 当前更像什么 | 关键对象 |
| --- | --- | --- |
| `sources` | repository declaration | `url`、`revision` |
| `outcomes` | branch projection | `git_info.repo`、`git_info.branches` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `sources` 与 `outcomes` 都是 repo metadata | 一个偏 declaration，一个偏 projection |
| `sources.revision` 与 `outcomes.branches[0]` 都只是 branch 名 | 一个是 source revision，一个是 outcome branch naming |
| 既然都能回到同一个 owner/repo，就说明主语相同 | 相同 repo 字符串不等于相同语义对象 |
| typed `session_context` 后，repo/branch 会整体同层消费 | repo helper 读 `sources`，branch helper 读 `outcomes` |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 专题内稳定不变量 | `sources` -> repo declaration、`outcomes` -> branch projection、helper 消费面已分开 |
| 条件公开 | `parseGitRemote` -> `parseGitHubRepository` fallback、`claude/${branch || 'task'}` 命名 |
| 内部/灰度层 | default_branch fallback、其余 SessionContext 字段、未来 branch naming 变化 |

## 4. 五个检查问题

- 当前字段在回答 repo declaration，还是 branch projection？
- 当前值域是 source revision，还是 outcome branch naming？
- 当前 helper 消费的是 `sources` 还是 `outcomes`？
- 我是不是把同一个 owner/repo 字符串误写成同一主语？
- 我是不是又把这页写回 178 的大类页而没继续切到 git 语义？

## 5. 源码锚点

- `claude-code-source-code/src/bridge/createSession.ts`
- `claude-code-source-code/src/utils/teleport/api.ts`
- `claude-code-source-code/src/utils/detectRepository.ts`
