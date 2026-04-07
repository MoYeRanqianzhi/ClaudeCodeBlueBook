# `REMOTE_SAFE_COMMANDS`、`filterCommandsForRemoteMode`、`handleRemoteInit`、`session` 与 `mobile`：为什么 remote-safe 命令面不是 runtime readiness proof

## 用户目标

146 已经把 assistant viewer 与 `--remote` TUI 拆成了两种不同厚度的 remote 合同。

但如果停在那一页，读者还是很容易在另一个地方重新压扁：

- 既然两条路径都先走 `filterCommandsForRemoteMode(commands)`，又都保留 `REMOTE_SAFE_COMMANDS`，那是不是只要命令还在，当前 remote runtime 就已经 ready？

这句不稳。

这轮要补的不是：

- “safe 命令有哪些”

而是：

- “为什么 remote-safe command surface 回答的是 affordance 问题，而不是 runtime readiness 问题”

## 第一性原理

更稳的提问不是：

- “命令还在不就在说明系统准备好了？”

而是先问四个更底层的问题：

1. 这个 allowlist 是在回答“命令是否安全保留在本地壳里”，还是在回答“远端运行时是否已经准备好这些命令需要的状态”？
2. 同一个 safe 集合里，是否本来就混着不同主权、不同数据来源、不同 readiness 依赖的命令？
3. REPL 在 remote init 后保留命令时，到底是在证明 readiness，还是只是在做第二次 affordance 合并？
4. 如果 `/session`、`/mobile`、`/cost` 都在同一个 safe 集合里，它们真的能被看作同一种“ready command”吗？

只要这四问先拆开，`REMOTE_SAFE_COMMANDS` 就不会再被误写成：

- “当前 remote runtime readiness 的可见证明”

## 第一层：`REMOTE_SAFE_COMMANDS` 从定义上就是 local-safe allowlist，不是 readiness 表

`commands.ts` 的注释已经把这层写得很清楚：

- 这些命令在 remote mode 下是 safe to use
- 它们只影响 local TUI state
- 不依赖 local filesystem、git、shell、IDE、MCP 或其他本地执行上下文

这个定义回答的是：

- 本地壳里哪些命令可以继续保留

而不是：

- 远端 runtime 当前准备好了哪些语义对象

所以从定义上说，`REMOTE_SAFE_COMMANDS` 更像：

- affordance allowlist

不是：

- readiness registry

## 第二层：同一个 safe 集合里，本来就混着完全不同语义的命令

只要把里面的成员摆开，就能看出这不是一张 readiness 表。

### `/session`

- `local-jsx`
- 目标是展示 remote session URL / QR
- 它的实际内容依赖 `remoteSessionUrl`

### `/mobile`

- `local-jsx`
- 目标是展示 Claude mobile app 的下载二维码
- 它依赖的是固定 app store / play store URL，与 remote runtime readiness 无关

### `/cost`

- `local`
- 目标是展示当前 session 的 cost / duration
- 它依赖本地 `cost-tracker` 与订阅身份判断，不是远端会话 presence

### `/usage`

- `local-jsx`
- 目标是打开本地 Settings 的 Usage tab
- 它也不是 remote session state probe

### `/exit`

- `local-jsx`
- 目标只是退出当前 REPL

这些命令能共存于同一 safe 集合，恰好说明：

- safe 集合在按“本地保留是否安全”分组

不是在按：

- “它们是否都依赖同一种 runtime readiness”

## 第三层：`filterCommandsForRemoteMode` 只是第一次粗筛，不是 runtime proof

`filterCommandsForRemoteMode(commands)` 的实现非常薄：

- 直接 `commands.filter(cmd => REMOTE_SAFE_COMMANDS.has(cmd))`

注释也写的是：

- pre-filter commands
- 防止在 CCR init 之前本地 local-only commands 短暂露出来

它在回答的是：

- 初始 REPL 壳里先留哪些命令，避免显而易见的不安全项闪现

它没有检查：

- backend 有没有给出 slash_commands
- `remoteSessionUrl` 有没有
- 当前 viewerOnly / operator contract 有多厚
- 这些命令依赖的具体数据对象是否已准备好

所以这一步本质上是：

- startup affordance coarse filter

不是：

- runtime readiness validation

## 第四层：`handleRemoteInit` 也只是在做第二次命令面合并，不是在出 readiness verdict

`REPL.tsx` 里的 `handleRemoteInit(...)` 会做：

- `remoteSlashCommands ∪ REMOTE_SAFE_COMMANDS`

也就是：

- 保留 backend 明确列出的命令
- 同时继续保留本地 safe 集合

这一步同样不是在说：

- “只要命令还在，就说明 backend 对应语义已经 fully ready”

它只是在做第二次命令面合并：

1. backend 命令面
2. local-safe 命令面

所以到这里，命令 surface 更像：

- local-safe affordance 与 backend-published affordance 的并集

而不是：

- 某种 authoritative readiness proof

## 第五层：`/session` 正好证明“命令还在”与“依赖状态 ready”不是一回事

这一页最值钱的例子还是 `/session`。

它会因为 `REMOTE_SAFE_COMMANDS` 被：

- `filterCommandsForRemoteMode(...)` 保留下来
- `handleRemoteInit(...)` 再次保留下来

而且自己的 `index.ts` 只看：

- `getIsRemoteMode()`

来决定命令显隐。

但真正进入 `SessionInfo` 后，

它又会看：

- `remoteSessionUrl`

没有 URL 时，它直接走 fallback warning。

这说明“safe 命令还在”只说明：

- 这个命令作为本地壳 affordance 还能露出来

不说明：

- 这个命令需要的数据对象已经 ready

所以 `/session` 是最强的反例：

- command surface survived
- runtime dependency not ready

## 第六层：`/mobile` 与 `/cost` 则证明 safe 集合里很多命令根本不在回答 remote readiness

如果只用 `/session` 举例，读者仍可能误解成：

- “只是 `/session` 比较特殊。”

所以还要把另外两类 safe 命令拉进来。

### `/mobile`

`mobile/index.ts` 和 `mobile.tsx` 表明它只是：

- 本地生成下载 Claude mobile app 的二维码

它回答的问题是：

- 用户要不要拿手机扫 app 下载链接

它与 remote runtime readiness 没有直接关系。

### `/cost`

`cost/index.ts` 与 `cost.ts` 表明它只是：

- 读取本地 cost tracker
- 再根据是否 subscriber 决定文案

它回答的问题是：

- 当前 session 花了多少钱 / 持续多久

而且这里还有一层更细的分叉：

- `/cost` 在 `REMOTE_SAFE_COMMANDS` 里
- 但在 CCR remote mode 下，REPL 只让 `local-jsx` slash 留在本地；像 `/cost` 这样的 `local` 命令会走远端发送路径
- 反过来，在 bridge/mobile 那条路径里，`/cost` 又被 `isBridgeSafeCommand()` 明确允许

这说明同一个命令的“safe”本身就会随入口 policy 变化，

它更不是某种统一的 runtime readiness 证明。

于是 safe 集合内部至少已经有三种完全不同的命令来源：

1. 依赖 remote URL/presence 的 `/session`
2. 依赖固定本地展示数据的 `/mobile`
3. 依赖本地 cost/accounting 的 `/cost`

这已经足够证明：

- 同在 `REMOTE_SAFE_COMMANDS`

并不意味着：

- 它们共享同一种 ready contract

## 第七层：`BRIDGE_SAFE_COMMANDS` 的并列存在，更说明“命令安全”是 policy 分类，不是 readiness 分类

`commands.ts` 里除了 `REMOTE_SAFE_COMMANDS`，

还单独定义了：

- `BRIDGE_SAFE_COMMANDS`

并用 `isBridgeSafeCommand(...)` 去回答：

- 从 Remote Control bridge 进来的 slash command，哪些是 safe to execute

这进一步说明：

- “command safe” 本来就是按入口 policy 分类的

而不是按：

- runtime ready/ not ready 分类的

也就是说，命令 safety 更像：

- transport / shell policy

不是：

- semantic readiness proof

再说得更尖一点：

- CCR remote TUI 里的 `REMOTE_SAFE_COMMANDS` 更像“哪些命令仍要在本地壳里保留可见”
- bridge/mobile 里的 `isBridgeSafeCommand()` 则更接近“哪些命令真的允许从这个入口执行”

两者都在谈 safe，

但 safe 的语义已经不是同一层。

## 第八层：所以 remote-safe command surface 最好被写成“affordance shell”，而不是“ready shell”

把前面几层合起来，更稳的总写法应该是：

- `filterCommandsForRemoteMode(...)` 做 coarse affordance filter
- `handleRemoteInit(...)` 做 backend affordance 与 local-safe affordance merge
- `REMOTE_SAFE_COMMANDS` 则定义哪些命令可以继续留在本地壳里

它们共同形成的是：

- remote-safe command surface

不是：

- runtime readiness proof shell

“命令还在”最多只能推出：

- 这个命令还允许在当前本地壳里露出

不能推出：

- 它依赖的 state 已经 ready
- 它的主权与数据来源与别的 safe 命令相同
- 当前 remote 合同厚度足以兑现它的所有期待

## stable / conditional / gray

| 类型 | 结论 |
| --- | --- |
| 稳定可见 | `REMOTE_SAFE_COMMANDS` 的注释与实现都表明它是 local-safe allowlist；`filterCommandsForRemoteMode(...)` 只是 coarse pre-filter；`handleRemoteInit(...)` 只是 backend 命令面与 local-safe 命令面的并集保留；`/session`、`/mobile`、`/cost`、`/usage`、`/exit` 本来就混着不同主权与不同数据来源；CCR remote mode 里只有 `local-jsx` slash 会稳定留在本地 |
| 条件公开 | 某个 safe 命令能不能真正兑现自身需要的数据或状态，要看它自己的 runtime dependency；`/session` 取决于 `remoteSessionUrl`，`/cost` 取决于 accounting 文本来源与当前入口 policy，`usage` 取决于本地 settings UI，上层 safe surface 不替它们做 readiness 保证 |
| 灰度/实现层 | backend 最终下发哪些 `slash_commands` 仍取决于各自 remote backend 的 `system/init`；不同入口的 “safe” 语义也不同，CCR remote TUI 更像 affordance 保留，bridge/mobile 更像执行 gate，但“safe shell 不是 readiness proof”这个结构结论不受影响 |

## 苏格拉底式自审

### 问：为什么这页不继续写 viewerOnly / operator contract？

答：因为 146 已经回答合同厚度；147 继续回答“即使命令壳相似，也不能把它误写成 readiness 证明”。

### 问：为什么一定要把 `/mobile` 和 `/cost` 也拉进来？

答：因为只写 `/session` 容易被误解成个例；把 fixed QR 和本地 accounting 一起摆出来，才能证明 safe 集合天生异质。

### 问：为什么要把 `BRIDGE_SAFE_COMMANDS` 也提出来？

答：因为它能进一步证明“command safe”是入口 policy 分类，不是 runtime readiness 分类。

### 问：这页的一句话 thesis 是什么？

答：remote-safe command surface 只能证明“哪些命令还能留在本地壳里”，不能证明“这些命令依赖的 runtime 语义已经 ready”。

## 结论

对当前源码来说，更准确的写法应该是：

1. `REMOTE_SAFE_COMMANDS` 定义的是 local-safe affordance allowlist
2. `filterCommandsForRemoteMode(...)` 与 `handleRemoteInit(...)` 只是在搭 remote-safe command shell
3. `/session`、`/mobile`、`/cost` 这类 safe 命令本来就依赖不同主权、不同状态、不同数据来源

所以：

- 命令还在，不等于 runtime 已 ready

更稳的术语不是：

- ready shell

而是：

- remote-safe affordance shell

## 源码锚点

- `claude-code-source-code/src/commands.ts`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/commands/session/index.ts`
- `claude-code-source-code/src/commands/session/session.tsx`
- `claude-code-source-code/src/commands/mobile/index.ts`
- `claude-code-source-code/src/commands/mobile/mobile.tsx`
- `claude-code-source-code/src/commands/cost/index.ts`
- `claude-code-source-code/src/commands/cost/cost.ts`
- `claude-code-source-code/src/commands/usage/index.ts`
- `claude-code-source-code/src/commands/usage/usage.tsx`
