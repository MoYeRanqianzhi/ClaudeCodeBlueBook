# `BridgePointer.environmentId`、`getBridgeSession.environment_id`、`reuseEnvironmentId` 与 `registerBridgeEnvironment`：为什么 pointer 里的 env hint、server session env 与 registered env 不是同一种 truth

## 用户目标

172 已经把 bridge reconnect family 继续拆成：

- pointer-led continuity authority
- explicit original-session authority

但如果正文停在这里，读者还是很容易把另一个更细的对象重新写平：

- pointer 里不是已经有 `environmentId` 吗？
- `getBridgeSession(...).environment_id` 不也是环境 ID 吗？
- `reuseEnvironmentId` 不也只是把同一个环境 ID 再发回注册接口吗？
- 既然最后注册结果里也会返回 `environment_id`，那是不是只是同一个环境值在不同函数里传来传去？

这句还不稳。

从当前源码看，bridge resume family 至少还分成三种不同厚度的 environment truth：

1. local continuity hint
2. server session truth
3. backend-issued registered env result

如果这三层 thickness 不先拆开，后面就会把：

- pointer 中的 `environmentId`
- `getBridgeSession(...).environment_id`
- `reuseEnvironmentId`
- `registerBridgeEnvironment(...)` 返回的新 `environment_id`

重新压成同一种“原环境 ID”。

## 第一性原理

更稳的提问不是：

- “这些 environment 字段是不是都在说同一个环境？”

而是先问五个更底层的问题：

1. 当前 env 字段来自 local continuity artifact、server session record，还是 backend 的当前注册结果？
2. 当前字段服务的是 prior-state hint、requested reattach target，还是最终注册后的 live environment？
3. 当前 host 是 perpetual REPL，还是 standalone `remote-control --continue`？
4. 当前字段如果被后端否定，系统是保留它、升级它，还是直接回退 fresh session？
5. 如果字段来源、消费宿主和被否定后的政策都不同，为什么还要把它们写成同一种 environment truth？

只要这五轴不先拆开，后面就会把：

- pointer breadcrumb
- original-environment truth
- registered live env

混成一句模糊的“恢复原环境”。

## 第一层：pointer 里的 `environmentId` 先是 local continuity hint，不是最终 truth

`bridgePointer.ts` 的 schema 很直接：

- `sessionId`
- `environmentId`
- `source`

而 `bridgeMain.ts` 与 `replBridge.ts` 在写 pointer 时也都会带上：

- 当前 `environmentId`

这说明 pointer 里的 env 字段不是不存在，

但更准确的理解不是：

- “pointer 已经携带了最终恢复真相”

而是：

- 系统把当时那一跳的 environment 也写成了 continuity breadcrumb

它首先回答的问题是：

- “这条恢复轨迹原来挂在哪个 env 上”

不是：

- “下次任何宿主都必须无条件相信它”

所以 pointer 里的 env 更像：

- local continuity hint

不是：

- final original-environment truth

`bridgePointer.ts` 的注释里虽然会把它写成：

- resume reconnects to the right env

但这句更稳的理解应是：

- pointer abstraction 保留了 env breadcrumb
- 至于具体宿主是否直接信它，要看后面的 host-specific upgrade policy

## 第二层：perpetual REPL 会把 pointer env 当作 prior-state input，但这仍不等于最终真相

这层最容易被忽略。

`replBridge.ts` 在 perpetual mode 初始化时会：

- `readBridgePointer(dir)`
- 只接受 `source: 'repl'` 的 prior pointer
- 然后把 `prior.environmentId` 放进 `bridgeConfig.reuseEnvironmentId`
- 并在 `tryReconnectInPlace(prior.environmentId, prior.sessionId)` 里把它当作 requested env

这说明对 perpetual REPL 而言，

pointer env 的厚度确实比 standalone `--continue` 更厚：

- 它不是只拿来做展示
- 而是真被当作 prior-state input 送进 reconnect-in-place Strategy 1

但这里仍然不能写成：

- pointer env 已经等于最终 truth

因为 REPL 紧接着仍会：

- 调 `registerBridgeEnvironment(...)`
- 拿后端返回的 `environment_id`
- 比较它与 requested env 是否一致
- 不一致时回退 fresh session

所以更准确的说法应该是：

- perpetual REPL 把 pointer env 当作 stronger local prior
- 但它仍只是 requested reconnect target
- 不是无条件成功的最终 environment truth

## 第三层：standalone `remote-control --continue` 则故意不直接信 pointer env

和 REPL perpetual 相比，standalone 路径更值得单列。

`bridgeMain.ts` 在 `--continue` 路径上会：

- `readBridgePointerAcrossWorktrees(dir)`
- 取出 `pointer.sessionId`
- 记录 `resumePointerDir`

但它并不会直接把：

- `pointer.environmentId`

拿去作为 `reuseEnvironmentId`。

它真正做的是：

- 先把 `resumeSessionId = pointer.sessionId`
- 再调用 `getBridgeSession(resumeSessionId, ...)`
- 从 server-side session record 中读取 `session.environment_id`
- 把这一值放进 `reuseEnvironmentId`

这说明 standalone `--continue` 回答的问题不是：

- “pointer 里原来记的 env 是哪个”

而是：

- “这条 session 现在在 server 认定的 original environment 是谁”

所以对 standalone `--continue` 来说，

pointer env 的作用厚度明显更薄：

- continuity breadcrumb 可以存在
- 但真正被升级成 reattach target 的，是 server session record 的 `environment_id`

因此更准确的结论不是：

- pointer 里既然有 env，就已经足够恢复

而是：

- standalone `--continue` 只把 pointer 当成 session selection artifact
- environment truth 仍要向 server session record 升级

## 第四层：`getBridgeSession(...).environment_id` 比 pointer env 更厚，但仍不是最终 registered env

这层是本页的核心。

`createSession.ts` 对 `getBridgeSession(...)` 的注释写得很直接：

- Returns the session's `environment_id` for `--session-id` resume

`bridgeMain.ts` 也明确把这个值命名成：

- `reuseEnvironmentId`

而 `types.ts` 又继续说明：

- `reuseEnvironmentId` 是 backend-issued environment_id to reuse on re-register
- backend may still hand back a fresh ID if the old one expired
- callers must compare the response

这说明 `getBridgeSession(...).environment_id` 的厚度是：

- 它比 pointer env 更接近 original-environment truth
- 因为它来自 server session record
- 能被安全提升为 re-register 的请求目标

但它仍然不是：

- 当前这次启动已经真正拿到的 live environment

所以更稳的理解应是：

- pointer env = continuity hint
- session record env = authoritative requested target

而不是：

- 到 `reuseEnvironmentId` 这里就已经万事大吉

## 第五层：`registerBridgeEnvironment(...)` 返回的 env 才是这次启动真正落成的 live result

`bridgeApi.ts` 对 idempotent re-registration 的注释已经把意图说透：

- 如果给了 backend-issued `reuseEnvironmentId`
- backend 会尝试把注册视为 reconnect to the existing environment
- 但如果旧 env 已过期，仍可能 hand back a fresh ID

这说明同样是 environment ID，

`registerBridgeEnvironment(...)` 返回的：

- `reg.environment_id`

和 `reuseEnvironmentId` 的关系不是：

- 参数原样回显

而是：

- 这是后端在当前时刻重新裁定之后真正落成的 live environment

所以更准确的说法不是：

- `reuseEnvironmentId` 与注册结果只是同一个值的回流

而是：

- `reuseEnvironmentId` 是 request-side original-env claim
- `reg.environment_id` 是 response-side current live env result

## 第六层：env mismatch 证明三层 truth 不能被写平

`bridgeMain.ts` 在 resume 主链里专门有一条 hard evidence：

- 如果 `reuseEnvironmentId && environmentId !== reuseEnvironmentId`
- 就说明 backend returned a different `environment_id`
- 系统警告 old environment expired
- 然后 fall back to fresh session

这说明一旦后端不同意，

系统承认的不是：

- “还是同一条环境，只是换了个值”

而是：

- old original environment truth 已经失效
- request-side claim 被后端否定
- 当前启动只能落到新的 registered env

因此 env mismatch 本身就证明：

- pointer env
- session record env
- registered env

绝不是同一种 truth thickness。

## 第七层：同一个 pointer env，在不同 host 下厚度也不同

这页如果只停在 standalone resume，还是不够稳。

因为源码里其实还同时保留了另一条消费方式：

### 在 perpetual REPL 里

- pointer env 会被当作 prior-state input
- 直接进入 `reuseEnvironmentId` / `tryReconnectInPlace(...)`

### 在 standalone `remote-control --continue` 里

- pointer env 不被直接提升
- 系统先向 `getBridgeSession(...).environment_id` 升级

这说明更准确的理解不是：

- `BridgePointer.environmentId` 固定属于某一种 authority

而是：

- 同一个字段的 authority thickness 取决于 host
- perpetual REPL 里更像 local-prior requested env
- standalone continue 里更像 breadcrumb hint

只要这一层没拆开，正文就会把：

- same field, different host, different trust policy

写成一条平的“environment id 到处都一样”。

## 第八层：为什么这页不是 34、35 或 172 的附录

### 不是 34 的附录

34 讲的是：

- stale pointer
- `has no environment_id`
- env mismatch
- transient retry

173 讲的是：

- 为什么这些 failure 能证明 env truth thickness 本来就不同

前者更像 failure taxonomy，
后者更像 environment authority layering。

### 不是 35 的附录

35 讲的是：

- restart
- fresh fallback
- retry

173 讲的是：

- 这些补救动作背后，系统到底在修哪一层 environment truth

前者更像 remedy policy，
后者更像 truth thickness。

### 不是 172 的附录

172 讲的是：

- `--continue` 与 `--session-id` 谁拥有 reconnect authority

173 讲的是：

- 即使 authority 已经确定，environment 字段内部还要再分 hint、requested truth 与 live result

所以 173 不是 172 的补句，而是它在 environment 对象内部的下一刀。

## 第九层：本专题里的 stable / gray 也要分开

### 专题内更稳定的不变量

- standalone `--continue` 不会直接把 pointer env 当 final truth。
- server session record 的 `environment_id` 才会被提升为 `reuseEnvironmentId`。
- 注册接口返回的新 `environment_id` 才是当前启动真正落成的 live result。
- env mismatch 不是恢复成功，而是 truth replacement 后的 fresh fallback。

### 更脆弱、应后置的细节

- worktree fanout
- pointer TTL / mtime
- `source: 'repl'` / `source: 'standalone'`
- compat session tag / infra session tag
- OAuth refresh 以避免假 `not found`

更准确的写法不是：

- 这页是在复述所有 bridge resume 细节

而是：

- 这页只抓 environment truth layering
- 其它系统细节都只是证据，不是正文主语

## 苏格拉底式自审

### 问：pointer 里既然已经有 `environmentId`，为什么 standalone `--continue` 还不直接复用它？

答：因为 standalone 路径把 pointer 用作 session selection breadcrumb，而不是 original-environment truth；真正被提升的是 server session record 的 `environment_id`。

### 问：既然 `getBridgeSession(...).environment_id` 都已经被叫做 `reuseEnvironmentId`，为什么还不能把它写成最终环境？

答：因为后端仍可能返回不同的 `reg.environment_id`；请求侧 truth 与响应侧 live result 不是同一层。

### 问：这页是不是又写回 172 的 authority split 了？

答：不是。172 讲的是谁拥有 reconnect authority；173 讲的是 environment 字段内部的 truth thickness，以及同一字段在不同 host 下的信任级别差异。
