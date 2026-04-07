# `readBridgePointerAcrossWorktrees`、`getBridgeSession`、`reconnectSession` 与 `environment_id`：为什么 `remote-control --continue` 与 `remote-control --session-id` 不是同一种 bridge authority

## 用户目标

171 已经把 `print` / headless 分支里的 explicit local artifact 继续拆成：

- session-registry-backed local artifact
- transcript-file-backed local artifact

但如果正文停在这里，读者还是很容易把 bridge 这条条件分支重新写平：

- `remote-control --continue` 最后不也只是拿到一个 `resumeSessionId` 吗？
- `remote-control --session-id <id>` 不也还是去 reconnect 同一条原 session 吗？
- 既然两条路径都会共享 original environment、single-session 与 `reconnectSession(...)`，那差别是不是只剩“一个自动填 ID，一个手填 ID”？

这句还不稳。

从当前源码看，bridge reconnect family 内部至少还要再分两种不同的 authority：

1. pointer-led continuity authority
2. explicit original-session authority

如果这两种 authority 不先拆开，后面就会把：

- crash-recovery pointer
- 显式 `session-id`
- deterministic pointer cleanup
- shared reconnect machinery

重新压成同一种“恢复原 bridge session”。

## 第一性原理

更稳的提问不是：

- “这两条路径最后是不是都会 reconnect 到旧 session？”

而是先问五个更底层的问题：

1. 当前 reconnect target 是由 local crash-recovery pointer 授权，还是由用户显式给定的 `session-id` 授权？
2. 当前路径承诺的是“接上最近那条 continuity 轨迹”，还是“命中这条明确指定的原 session”？
3. 当前 deterministic failure 发生时，谁拥有清理恢复轨迹的责任？
4. 当前共享的是整个 authority，还是只共享 target 已确定之后的 downstream attach protocol？
5. 如果 authority artifact、cleanup 责任与 retry policy 都不同，为什么还要把它们写成同一种 bridge resume？

只要这五轴不先拆开，后面就会把：

- pointer-led resume
- explicit session targeting
- local artifact cleanup ownership

混成一句模糊的“bridge 继续上次会话”。

## 第一层：`remote-control --session-id` 先消费的是 explicit original-session authority

`parseArgs(...)` 对 `--session-id` / `--continue` 的注释很关键：

- 它们都要 `resume a specific session on its original environment`
- 因而和 `--spawn` / `--capacity` / `--create-session-in-dir` 互斥

但这只说明：

- 两条路径共享同一个 resume contract

不等于：

- 它们共享同一种 authority

对 `--session-id` 而言，upstream authority 很直接：

- 用户显式给出 `sessionId`
- `bridgeMain.ts` 将它放入 `parsedSessionId`
- 随后走 `validateBridgeId(...)`
- 再用 `getBridgeSession(resumeSessionId, ...)` 去拿 server-side session record
- 从这条 record 里读取 `environment_id`

这说明 `remote-control --session-id <id>` 回答的问题不是：

- “最近哪条 bridge continuity 该被接上”

而是：

- “这条被明确指定的原 session，还能不能在它原来的 environment 上被重新接回”

所以它的 authority 更像：

- explicit original-session authority

不是：

- pointer-led continuity authority

## 第二层：`remote-control --continue` 先消费的是 pointer-led continuity authority

`--continue` 的入口完全不同。

`bridgeMain.ts` 先做的不是：

- 直接把某个用户给定 ID 拿去 server 验证

而是：

- `readBridgePointerAcrossWorktrees(dir)`

这条读路径在 `bridgePointer.ts` 里又被写得很清楚：

- 先查当前目录
- 再 fan out 到 git worktree siblings
- 取 freshest pointer
- 返回 pointer 本体以及 pointer 所在目录

而 `bridgeMain.ts` 紧接着做的是：

- 打印 `Resuming session ...`
- `resumeSessionId = pointer.sessionId`
- `resumePointerDir = pointerDir`

这里最关键的一点是：

- `--continue` 不是“自动帮你补一个 session-id 参数”

而是：

- 先消费一条 local crash-recovery artifact
- 再把它规范化进后面的 resume flow

所以 `remote-control --continue` 回答的问题不是：

- “我要不要连接这条显式指定的 session”

而是：

- “当前目录或其 worktrees 里，最近那条 bridge continuity pointer 还能不能继续作为恢复入口”

因此它的 authority 是：

- pointer-led continuity authority

不是：

- explicit original-session authority

## 第三层：两条路径共享 `resumeSessionId` 变量，不等于共享同一种 authority

这是最容易被写错的一层。

`bridgeMain.ts` 在 `--continue` 分支之后，确实会把：

- `resumeSessionId`

喂给后面的 `--session-id` 恢复主链。

于是如果只看 downstream，确实很容易得到一个错误结论：

- `--continue` 只是 `--session-id` 的语法糖

但更准确的说法应该是：

- downstream normalization 相同
- upstream authority artifact 不同

它们共享的是：

- `getBridgeSession(...)`
- `reuseEnvironmentId`
- `registerBridgeEnvironment(...)`
- `reconnectSession(...)`
- single-session/original-environment 约束

不共享的是：

- target 是谁选出来的
- local artifact 是谁提供的
- deterministic failure 时该清理谁的轨迹

所以更稳的结论不是：

- `--continue` 与 `--session-id` 只是同一条 reconnect 的两种输入形状

而是：

- 二者共享 downstream attach protocol
- 但 upstream bridge authority 不同

## 第四层：pointer-led path 才拥有 pointer cleanup 责任，explicit path 不拥有

这是这页最硬的一层证据。

`bridgeMain.ts` 在 `--continue` 路径上专门留下：

- `resumePointerDir`

注释写得非常直接：

- deterministic failure 时清掉这一个 pointer 文件
- 否则 `--continue` 会一直撞到同一条 dead session

后面的几种分支都只在 `resumePointerDir` 存在时清理 pointer：

### `getBridgeSession(...)` 取不到 session

- 清 `resumePointerDir`
- 报 `Session ... not found`

### session 存在但没有 `environment_id`

- 清 `resumePointerDir`
- 报 `has no environment_id`

### `reconnectSession(...)` 全部候选失败且属于 fatal

- 清 `resumePointerDir`
- fatal failure 终止

### transient reconnect failure

- 不清 pointer
- 明确保留 “try running the same command again” 的 retry 机制

而 `--session-id` 路径的关键恰恰是：

- `resumePointerDir` 为 `undefined`

这说明系统一开始就承认：

- 显式 `session-id` 路径并不拥有那份 local pointer artifact
- 所以它也不该顺手去清 pointer

因此更准确的理解不是：

- 两条路径失败时都一样，只是一个多了一层自动查找

而是：

- pointer-led path 必须对 pointer lifecycle 负责
- explicit path 则只对显式目标负责

## 第五层：pointer 并没有被写成 environment truth，server session record 仍保留 original-environment authority

这层更容易被忽略。

`bridge-pointer.json` 本身其实带着：

- `sessionId`
- `environmentId`
- `source`

但 `bridgeMain.ts` 在 `--continue` 路径里并没有直接把：

- `pointer.environmentId`

当成最终 truth 去复用。

它真正做的是：

- 只先采用 `pointer.sessionId`
- 然后仍去 `getBridgeSession(resumeSessionId, ...)`
- 再从 server-side session record 中读取 `environment_id`
- 最后把它放进 `reuseEnvironmentId`

这说明更细一层的 authority 分工其实是：

- pointer 只负责提供 “最近哪条 continuity 候选该被尝试”
- server session record 继续负责提供 “这条 session 当前认定的 original environment 是谁”

所以更稳的说法不是：

- pointer 已经拥有全部恢复真相

而是：

- pointer 拥有 continuity selection authority
- server session record 仍保留 original-environment truth

这正是系统避免把 stale local pointer 直接写成绝对真相的方式。

## 第六层：共享的 stable 主链，与灰度/脆弱细节，也不是同一种层次

如果要保护这组功能不被写坏，最好把 stable invariant 与 gray detail 再拆一层。

### 应当前置、且更稳定的主链

- 这里说的“稳定”只指本专题内部不变量，不等于全产品默认公开面。
- 一旦 resume target 确定，两条路径都要回到 original environment 约束。
- 一旦进入 resume flow，两条路径都会被压到 single-session mode。
- 一旦 environment 成功复用，最终 attach 仍靠 `reconnectSession(...)` 完成。

### 应后置、且更脆弱的条件细节

- `--continue` / `--session-id` 本身仍受 gate 与 bridge eligibility 约束。
- `feature('KAIROS')` gate
- worktree-aware pointer fanout
- compat / infra session id 双候选重试
- fatal-only pointer cleanup
- env mismatch 时回退 fresh session

更准确的写法不是：

- 这整页都在讲某种统一的 reconnect 技巧

而是：

- 前半页讲 stable bridge resume invariant
- 后半页讲 authority、cleanup ownership 与 gray recovery detail

## 第七层：为什么这页不是 33、34 或 169 的附录

### 不是 33 的附录

33 讲的是：

- disconnect / teardown / pointer closeout

172 讲的是：

- `--continue` 与 `--session-id` 在 reconnect 入口上谁拥有 authority

前者更像收口语义，后者更像恢复主权。

### 不是 34 的附录

34 讲的是：

- stale pointer
- expired environment
- transient retry

172 讲的是：

- 为什么这些 cleanup / retry policy 会只落在 pointer-led path 上

前者更像 failure taxonomy，后者更像 authority split。

### 不是 169 的附录

169 讲的是更宽的 source family：

- stable conversation resume
- headless remote hydrate
- bridge continuity

172 讲的是 bridge continuity family 内部继续再分：

- pointer-led continuity authority
- explicit original-session authority

所以 172 不是 169 的补注，而是它在 bridge 分支里的下一刀。

## 苏格拉底式自审

### 问：既然 `--continue` 最后也只是得到一个 `resumeSessionId`，为什么还不能把它写成 `--session-id` 的语法糖？

答：因为 normalized variable 相同，不等于 authority artifact 相同；`resumePointerDir` 是否存在，直接决定 cleanup ownership 是否成立。

### 问：既然 pointer 文件里已经有 `environmentId`，为什么还要再去 `getBridgeSession(...)`？

答：因为 pointer 负责 continuity selection，不负责最终 original-environment truth；server session record 仍是更高一层的绑定来源。

### 问：这页是不是又写回“bridge 失败 taxonomy”了？

答：不是。这里只用失败分支证明 authority ownership；重心始终是 `--continue` 与 `--session-id` 为什么不是同一种 bridge authority。
