# `No recent session found`、`Session not found`、`environment_id` 与 `try running the same command again`：为什么 bridge 的 stale pointer、过期环境与瞬态重试不是同一种恢复失败

## 用户目标

不是只知道 Claude Code 里“`claude remote-control --continue` 有时能恢复，有时会报 `No recent session found`、有时又说 `Session not found`、有时让你 `try running the same command again`”，而是先分清四类不同对象：

- 哪些是 pointer 本身已经不存在或失效。
- 哪些是 session 还在名字上可见，但已经不能再作为 bridge 恢复源。
- 哪些是环境已经过期，只能回退到 fresh session。
- 哪些只是瞬态 reconnect 失败，仍应保留 retry 轨迹。

如果这些对象不先拆开，读者最容易把下面这些错误压成同一种“恢复失败”：

- `No recent session found in this directory or its worktrees`
- `Session ... not found`
- `Session ... has no environment_id`
- `Warning: Could not resume session ... its environment has expired`
- `The session may still be resumable — try running the same command again`
- stale pointer 被清掉
- pointer 被故意保留以便重试

## 第一性原理

bridge 的恢复失败至少沿着四条轴线分化：

1. `Artifact Validity`：当前失败是因为 pointer 已失效，还是因为 pointer 指向的 server-side 资产已失效。
2. `Server Survivability`：session / environment 是已经不存在、没有 bridge 绑定，还是仍可能恢复。
3. `Retry Policy`：系统当前应该清理旧轨迹，还是保留它作为下次 retry 入口。
4. `User Remedy`：当前更合理的动作是重新启动一条新 bridge、重新登录，还是简单再试一次。

因此更稳的提问不是：

- “为什么 `--continue` 又失败了？”

而是：

- “这次失败是恢复轨迹本身坏了、server 侧资产没了、环境换代了，还是只是一种瞬态重连失败；系统因此决定清理还是保留哪条轨迹？”

只要这四条轴线没先拆开，正文就会把 stale pointer、session expired、env mismatch 与 transient retry 写成一种恢复失败。

## 第一层：`No recent session found` 先回答的是“恢复轨迹不存在”，不是“server 拒绝了你”

### `--continue` 的第一步不是连 server，而是先找 pointer

`bridgeMain.ts` 在 `--continue` 路径上，先调用：

- `readBridgePointerAcrossWorktrees(dir)`

它会：

- 先看当前目录
- 再 fan out 到 worktree siblings
- 取 freshest pointer

如果根本找不到，就直接报：

- `No recent session found in this directory or its worktrees.`

这说明这里回答的问题不是：

- “server 上的 session 现在还有没有活着”

而是：

- “本地当前还有没有一条可消费的恢复轨迹”

### stale / invalid pointer 也会被当场清掉

`bridgePointer.ts` 里，read path 会在下面这些情况下直接清 pointer：

- JSON / schema 无效
- mtime 过旧

所以更稳的理解应是：

- `No recent session found`

经常不是“你从没开过 bridge”，而是：

- 本地恢复轨迹已经被判定为 stale / invalid，并在读取时被清掉

### 因而这是 artifact validity 问题，不是 resume 协议问题

只要这一层没拆开，正文就会把：

- 没找到轨迹
- 找到轨迹但 server 已不认

误写成同一种失败。

## 第二层：`Session not found` 与 `has no environment_id` 是确定性无效恢复源

### `Session not found` 说明 pointer 指向的 session 已经不能再恢复

`bridgeMain.ts` 在读到 pointer 后，会先去：

- `getBridgeSession(resumeSessionId, ...)`

如果拿不到 session，就会：

- 清掉 `resumePointerDir` 对应的 pointer
- 报 `Session ... not found. It may have been archived or expired, or your login may have lapsed`

这说明这里的心智不是：

- “你再试一次也许就好了”

而是：

- “当前 pointer 指向的 session 已不再是有效恢复源”

### `has no environment_id` 说明它甚至不具备 bridge resume 所需绑定

同一条路径里，如果 session 存在但：

- 没有 `environment_id`

系统也会：

- 清掉 pointer
- 报 `It may never have been attached to a bridge`

这说明这里失败的不是：

- OAuth token 一时失效

而是：

- 这条 session 本来就不满足 bridge resume 的必要结构

### 所以这两类都是 deterministic failure

更稳的区分是：

- `Session not found`
- `has no environment_id`

都属于：

- 应立即清理错误轨迹、不要反复重试的确定性失败

## 第三层：env mismatch 不是“恢复成功”，而是“回退到 fresh session”

### backend 返回不同 `environment_id` 时，系统不会把它当作同一条 resume 成功

`bridgeMain.ts` 在 `--session-id` / `--continue` 恢复流中，会先拿旧的：

- `reuseEnvironmentId`

再去注册环境。

如果 backend 返回了不同的：

- `environment_id`

代码会直接告警：

- `Could not resume session ... its environment has expired. Creating a fresh session instead.`

这说明这里不是：

- “已经恢复好了，只是换了个 env”

而是：

- 原环境已过期 / 被回收，只能回退到一条 fresh session 轨迹

### env mismatch 的对象是“continuity 被打断，但不必把当前启动也判死”

更稳的理解是：

- 老环境没了
- 旧 continuity 断了
- 但当前命令仍可继续在新环境上启动

所以它既不同于：

- deterministic hard failure

也不同于：

- 真正 resume 成功

### 因而 env mismatch 应写成 fallback，不应写成 reconnect success

只要这一层没拆开，正文就会把：

- “仍然跑起来了”

偷换成：

- “原 session 已成功恢复”

## 第四层：fatal reconnect failure 与 transient reconnect failure 的 retry policy 相反

### reconnect 失败时，系统先分 fatal 与 transient

`bridgeMain.ts` 在 `reconnectSession(...)` 全部候选都失败后，会看：

- `err instanceof BridgeFatalError`

然后分两条政策：

- fatal：清 pointer
- transient：保留 pointer

### fatal failure 应清轨迹，transient failure 则保留轨迹供重试

源码注释写得非常直白：

- fatal reconnect failure 才清 `resumePointerDir`
- transient failure 要保留 pointer
- 因为“再跑一遍同样命令”本身就是 retry 机制

所以更准确的理解是：

- fatal = 当前恢复轨迹已经不值得保留
- transient = 当前恢复轨迹仍可能成功，系统故意不把它删掉

### `The session may still be resumable — try running the same command again` 不是客套话

这条文案的真实含义是：

- 系统已经决定保留 pointer
- 下一次同样的 `--continue` 仍然应该命中这条轨迹

因此它不是：

- 一个低信息量安慰句

而是：

- retry policy 的 reader-facing 投影

## 第五层：REPL/perpetual 的恢复失败与 root `--continue` 也不是同一种入口语义

### perpetual init 只复用 `source:'repl'` 的 prior pointer

`replBridge.ts` 的 perpetual init 会：

- 先 `readBridgePointer(dir)`
- 然后只接受 `source === 'repl'`

所以它解决的问题是：

- REPL continuity 自己能不能延续

而不是：

- 统一 bridge pointer 中最新的一条都能拿来复用

### `remote-control --continue` 则先消费统一 bridge pointer，再进 server 校验链

root command 侧的 `--continue` 路径并没有做同一层 reader-facing source 过滤，而是：

- 先取 freshest bridge pointer
- 再去做 session / environment 校验

这说明更稳的区分是：

- perpetual：REPL continuity 的内部续接
- `--continue`：bridge pointer 恢复入口

### 因而“两边都依赖 pointer”不等于“两边读取的是同一套 prior state”

只要这一层没拆开，正文就会把：

- perpetual continuity
- root resume entry

误写成一条完全相同的恢复线。

## 第六层：稳定主线、条件面与内部面要继续保护

### 稳定可见或相对稳定可见的

- `No recent session found` 属于恢复轨迹缺失
- `Session not found` / `has no environment_id` 属于确定性无效恢复源
- env mismatch 表示 fallback 到 fresh session，而不是 resume 成功
- transient reconnect failure 会故意保留 pointer 并建议重试
- fatal reconnect failure 会清 pointer

这些都适合进入 reader-facing 正文。

### 条件公开或应降权写入边界说明的

- pointer across worktrees 的 freshest 选择
- perpetual 只复用 `source:'repl'` 的 prior pointer
- OAuth token 过期可能制造“看起来像 not found”的前置噪音

### 更应留在实现边界说明的

- pointer TTL / mtime 的具体数值
- worktree fanout cap
- `session_*` 到 `cse_*` 的兼容转换细节
- reconnect candidate 的完整枚举与错误类型实现

这些内容只保留为作者判断依据，不回流正文主线。

## 最后的判断公式

当你看到 `No recent session found`、`Session not found`、`environment_id` 缺失、env mismatch 或 “try running the same command again” 时，先问七个问题：

1. 这次失败是 pointer 本身没了，还是 pointer 指向的 server-side 资产没了？
2. 当前是 deterministic invalid source，还是 transient retry？
3. 系统这次是在清轨迹，还是故意保留轨迹？
4. 当前只是 continuity 断了，还是连 fresh fallback 也不成立？
5. 这次应该新开 bridge、重新登录，还是简单再试一次？
6. 当前是 perpetual 内部续接，还是 root `--continue` 恢复入口？
7. 我是不是又把 stale pointer、过期环境与瞬态重试压成了同一种恢复失败？

只要这七问先答清，就不会把 bridge 的恢复失败语义写糊。

## 源码锚点

- `claude-code-source-code/src/bridge/bridgeMain.ts`
- `claude-code-source-code/src/bridge/bridgePointer.ts`
- `claude-code-source-code/src/bridge/bridgeApi.ts`
- `claude-code-source-code/src/bridge/replBridge.ts`
