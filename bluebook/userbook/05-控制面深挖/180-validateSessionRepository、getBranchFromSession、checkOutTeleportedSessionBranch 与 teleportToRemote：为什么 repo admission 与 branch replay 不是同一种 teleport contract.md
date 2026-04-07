# `validateSessionRepository`、`getBranchFromSession`、`checkOutTeleportedSessionBranch` 与 `teleportToRemote`：为什么 repo admission 与 branch replay 不是同一种 teleport contract

## 用户目标

179 已经把 git 语义继续拆成：

- repository declaration
- branch projection

但如果正文停在这里，读者还是很容易把 teleport runtime 再写平：

- 既然 session 里同时有 repo 和 branch，resume 不就是“切回那条 repo/branch”吗？
- `validateSessionRepository(...)` 不也还是在帮 branch checkout 做前置吗？
- `getBranchFromSession(...)` 不也还是在读取同一份 git context 吗？
- 如果 `sources` 已经存在，`outcomes` 不也只是默认跟着来吗？

这句还不稳。

从当前源码看，teleport 至少还分成两种不同 runtime contract：

1. repo admission
2. branch replay

如果这两层不先拆开，后面就会把：

- `validateSessionRepository(...)`
- `getBranchFromSession(...)`
- `checkOutTeleportedSessionBranch(...)`
- `teleportToRemote(...)`

重新压成同一种“teleport 恢复合同”。

## 第一性原理

更稳的提问不是：

- “teleport 恢复是不是就是把 repo 和 branch 一起恢复回来？”

而是先问五个更底层的问题：

1. 当前逻辑在回答“我能不能从这个 checkout 进入 session”，还是“进入后要不要切 branch”？
2. 当前 helper 读的是 `session_context.sources`，还是 `session_context.outcomes`？
3. 当前失败会直接阻止 teleport，还是只在恢复后追加一条 branch notice？
4. 当前 create path 是否允许 repo basis 存在，而 outcome branch 故意留空？
5. 如果同在一条 session 上，却承担不同阶段的 gate，为什么还要把它们写成同一种 teleport contract？

只要这五轴不先拆开，后面就会把：

- repo admission
- branch replay

混成一句模糊的“teleport 自动帮我回到原来的仓库和分支”。

## 第一层：`validateSessionRepository(...)` 先裁决 repo admission，不决定 branch replay

`utils/teleport.tsx` 里的 `validateSessionRepository(sessionData)` 先做的是：

- `detectCurrentRepositoryWithHost()`
- `sessionData.session_context.sources.find(...)`
- `parseGitRemote(gitSource.url)` / `parseGitHubRepository(gitSource.url)`
- owner/repo/host 对比

它回答的问题不是：

- 要切到哪条 branch

而是：

- 当前 shell 所在 checkout 是否有资格进入这条 session

更关键的是，它的返回值是：

- `match`
- `mismatch`
- `not_in_repo`
- `no_repo_required`
- `error`

这说明它首先是：

- repo admission gate

不是：

- branch replay helper

因为这里一旦判成：

- `not_in_repo`
- `mismatch`

`teleportResumeCodeSession(...)` 直接抛 `TeleportOperationError`，
teleport 根本不会继续下去。

所以更准确的理解不是：

- repo 校验只是 branch checkout 的一个准备步骤

而是：

- repo admission 本身就是一层独立的恢复门槛

## 第二层：`getBranchFromSession(...)` 与 `checkOutTeleportedSessionBranch(...)` 只处理 branch replay，不反向证明 repo 已可入

`utils/teleport/api.ts` 的 `getBranchFromSession(session)` 只读：

- `session.session_context.outcomes?.find(...)`
- `git_info.branches[0]`

它完全不看：

- `session_context.sources`

所以它回答的问题不是：

- 当前 repo 是否匹配这条 session

而是：

- 如果这条 session 暴露了 outcome branch，本地应该尝试 replay 到哪条 branch

后面的 `checkOutTeleportedSessionBranch(branch?)` 更直接：

- 有 `branch` 就 `fetchFromOrigin(branch)` + `checkoutBranch(branch)`
- 没有 `branch` 就明确记录 `No branch specified, staying on current branch`

这说明更准确的理解不是：

- 只要 branch helper 还能运行，就等于 repo admission 已经成立

而是：

- branch replay 只是 admission 之后的一层可选恢复动作

它处理的是：

- branch 要不要切
- branch 切换是否报错

不是：

- 当前 repo 有没有资格承载这条 session

## 第三层：调用链先过 admission，再做 replay，而且失败语义不同

这是这页最硬的一层。

`teleportResumeCodeSession(sessionId)` 的顺序是：

1. `fetchSession(sessionId)`
2. `validateSessionRepository(sessionData)`
3. switch `repoValidation.status`
4. 只有 admission 通过后，才调用 `teleportFromSessionsAPI(..., sessionData)`

而 `teleportFromSessionsAPI(...)` 返回的 branch，
只是：

- `sessionData ? getBranchFromSession(sessionData) : undefined`

也就是说：

- repo admission 先决定 teleport 能不能成立
- branch replay 只是成立之后返回给调用方的一段 branch hint

再往下看 `print.ts` 与 `main.tsx` 的消费顺序：

- 先 `const teleportResult = await teleportResumeCodeSession(...)`
- 再 `await checkOutTeleportedSessionBranch(teleportResult.branch)`
- 最后 `processMessagesForTeleportResume(teleportResult.log, branchError)`

这说明更准确的结论不是：

- repo mismatch 和 branch checkout 失败都属于同一种 teleport failure

而是：

- repo admission 失败会阻止 teleport result 产生
- branch replay 失败则被降级成 `branchError`，作为恢复后的 notice 继续带进 transcript

所以两者连失败语义都不在同一层。

## 第四层：`teleportToRemote({ environmentId })` 证明 repo basis 可以存在，而 outcome branch 可以故意为空

这层能直接防止最常见的偷换：

- “既然 session 有 repo source，就应该天然也有 branch replay”

`teleportToRemote(...)` 走显式 `environmentId` 分支时：

- 仍可能探测当前 repo，生成 `gitSource`
- 或者上传 `seed_bundle_file_id`
- 但 request body 明确写的是 `outcomes: []`

也就是说，显式环境 attach 这条路径允许：

- `sources` 存在
- repo basis 存在
- container seed 也可能存在

同时却故意不承诺：

- outcome branch replay

而标准 teleport 路径才会在另一条分支里：

- 生成 `sessionBranch`
- 组装 `gitOutcome`
- 把 `outcomes: gitOutcome ? [gitOutcome] : []` 写进去

这说明更准确的理解不是：

- `sources` 一旦出现，`outcomes` 就只是默认伴生物

而是：

- repo admission contract 可以单独成立
- branch replay contract 可以单独缺席

因此二者从 create-time 就已经不是同一种 teleport 承诺。

## 第五层：`branchError` 被写进 teleport notice，本身就说明 replay 不是 admission verdict

如果 branch replay 和 repo admission 真是同一种恢复合同，
那么 branch checkout 失败理应和 repo mismatch 一样，
直接把 teleport 终止掉。

但当前实现不是这样：

- `checkOutTeleportedSessionBranch(...)` 捕获错误后仍返回 `branchName`
- `branchError` 被传给 `processMessagesForTeleportResume(...)`
- `createTeleportResumeSystemMessage(error)` 会把它写进 teleport notice

也就是说系统承认的是：

- transcript 取回
- session 恢复
- branch replay 提示

这三件事可以错位发生。

所以更准确的说法不是：

- branch replay 失败 = teleport 没有恢复

而是：

- session 已经被 admission 并拉回本地消息面
- branch replay 只是后续补偿动作，失败后要告知，而不是回滚 admission

## 第六层：为什么这页不是 179、176 或 174 的附录

### 不是 179 的附录

179 讲的是：

- `sources` / `outcomes` 在 git 语义上为什么是 declaration / projection

180 讲的是：

- 这两层在 teleport runtime 里为什么对应 admission / replay 两张不同合同

179 更像字段语义页，
180 更像运行时 gate 页。

### 不是 176 的附录

176 讲的是：

- `createBridgeSession(...)` request body 顶层字段的 authority split

180 讲的是：

- teleport create/resume 流里，repo basis 与 branch replay 如何被不同阶段消费

176 的主语是 request body 顶层分层，
180 的主语是 teleport runtime contract。

### 不是 174 的附录

174 讲的是：

- `environmentId` 在本地 key / reuse claim / live env / attach target 之间的主权分层

180 虽然借用了显式 `environmentId` 路径作旁证，
但要证明的不是环境主权，
而是：

- repo admission 可以独立存在
- branch replay 可以故意留空

所以它不能回写成环境页的一个脚注。

## 第七层：这页真正保护的 stable 面与 gray 面

本页真正稳定的判断只有三句：

1. `validateSessionRepository(...)` 读 `sources`，先裁决 repo admission。
2. `getBranchFromSession(...)` / `checkOutTeleportedSessionBranch(...)` 读 `outcomes`，只负责 branch replay。
3. 显式 `environmentId` 路径允许 `sources` 存在而 `outcomes` 为空。

而不该在正文里继续放大的灰度细节包括：

- environment 选择策略
- bundle gate 与 GitHub preflight 的全套分支
- `reuse_outcome_branches`
- `environment_variables`
- `github_pr`

这些都可以改变，
但不会推翻本页那句更硬的 runtime 判断：

- repo admission 与 branch replay 不是同一种 teleport contract
