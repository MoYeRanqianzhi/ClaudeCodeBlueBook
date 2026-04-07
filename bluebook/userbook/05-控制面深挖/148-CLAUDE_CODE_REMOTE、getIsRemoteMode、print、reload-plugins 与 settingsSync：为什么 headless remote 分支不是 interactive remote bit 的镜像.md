# `CLAUDE_CODE_REMOTE`、`getIsRemoteMode`、`print`、`reload-plugins` 与 `settingsSync`：为什么 headless remote 分支不是 interactive remote bit 的镜像

## 用户目标

147 已经把：

- `REMOTE_SAFE_COMMANDS`
- `filterCommandsForRemoteMode(...)`
- `handleRemoteInit(...)`

拆成了 remote-safe affordance shell，而不是 runtime readiness proof。

但如果停在这一步，正文还会留下另一种常见误写：

- “既然很多地方都写 `(CLAUDE_CODE_REMOTE || getIsRemoteMode())`，那 env remote 和 interactive remote bit 本质就是一回事。”

这句也不稳。

这轮要补的不是：

- “哪个分支里又出现了环境变量”

而是：

- “为什么 `CLAUDE_CODE_REMOTE` 代表的是 headless / container / env-driven remote 行为轴，而 `getIsRemoteMode()` 代表的是 interactive / bootstrap / UI-driven remote 行为轴”

## 第一性原理

更稳的提问不是：

- “两边都叫 remote，有什么区别？”

而是先问四个更底层的问题：

1. 当前 remote 行为是由 bootstrap state 驱动，还是由进程环境驱动？
2. 当前代码是在描述 interactive REPL 行为，还是 headless / subprocess / CCR container 行为？
3. 某个分支同时接受 env 与 bootstrap bit，是在说它们等价，还是在兼容两类入口？
4. 如果 `CLAUDE_CODE_REMOTE` 出现在 API timeout、proxy、plugin git URL、permission 默认值这类地方，它还能被写成 UI remote bit 的镜像吗？

只要这四问先拆开，`CLAUDE_CODE_REMOTE` 就不会再被压成：

- “另一种写法的 `getIsRemoteMode()`”

## 第一层：`getIsRemoteMode()` 是 bootstrap 布尔位，`CLAUDE_CODE_REMOTE` 是进程环境位

`bootstrap/state.ts` 里的：

- `getIsRemoteMode()`

本质上只是读：

- `STATE.isRemoteMode`

它属于：

- 当前进程内的 bootstrap state

而 `CLAUDE_CODE_REMOTE` 出现的位置，从一开始就明显更底层。

比如 `entrypoints/cli.tsx` 顶层会在：

- `process.env.CLAUDE_CODE_REMOTE === 'true'`

时调大 child process 的 heap。

这一步发生在：

- CLI 顶层入口
- 真正加载完整交互系统之前

所以它回答的不是：

- “当前 UI 是不是 remote mode”

而更像：

- “当前进程是否运行在 CCR/remote 容器语境里”

## 第二层：`getIsRemoteMode()` 主要收敛在 interactive/UI 分支

从全仓看，`getIsRemoteMode()` 的主要消费者仍集中在：

- `/session` 命令显隐
- status line remote block
- footer modePart 抑制
- startup notification / plugin / IDE / memory / settings watcher 这类 interactive 行为停用器

也就是说它更多回答：

- 当前交互 REPL 要不要切到 remote behavior

它是：

- interactive bootstrap remote bit

不是：

- 进程级 remote environment fact

## 第三层：`CLAUDE_CODE_REMOTE` 则主要收敛在 headless / env-dependent 分支

这一层是 148 最核心的增量。

### 1. `entrypoints/init.ts` 的 upstream proxy 初始化

这里只在：

- `isEnvTruthy(process.env.CLAUDE_CODE_REMOTE)`

时才初始化 upstream proxy。

这明显不是 UI 决策，

而是：

- CCR 环境能力分支

### 2. `context.ts` 的 git status 跳过

这里在 CCR 环境下直接跳过 git status，以减少 resume/remote overhead。

这也不是 interactive remote bit 的 UI 问题，

而是：

- 运行环境优化策略

### 3. `pluginLoader.ts` 的 Git URL 选路

在 `CLAUDE_CODE_REMOTE` 下：

- GitHub shorthand 会转成 `https://...`

否则：

- 走 `git@github.com:...`

这回答的是：

- 远端容器有没有 SSH key / 应该走什么 clone transport

不是：

- 当前 REPL 的 remote mode pill 要不要亮

### 4. `permissionSetup.ts` 的默认权限模式收窄

在 `CLAUDE_CODE_REMOTE` 下：

- `defaultMode` 只允许 `acceptEdits` / `plan` / `default`

这同样是：

- 远端环境的 permission policy

不是：

- interactive bootstrap state

### 5. `services/api/claude.ts` 的 fallback timeout 收窄

在 `CLAUDE_CODE_REMOTE` 下：

- nonstreaming fallback timeout 变成 120s

否则是：

- 300s

这依然是：

- headless/container/network behavior tuning

不是：

- UI remote bit

## 第四层：`print` 与 `/reload-plugins` 同时接受 env 与 bootstrap bit，不是在说两者等价

最容易误读的，就是：

- `isEnvTruthy(process.env.CLAUDE_CODE_REMOTE) || getIsRemoteMode()`

这种写法。

`print.ts` 和 `/reload-plugins` 都用了这类条件，去决定：

- 要不要先 re-pull / download user settings

这并不意味着：

- env remote 与 interactive remote bit 是同一个东西

更准确的理解是：

- 这两条分支想兼容两种 remote 入口

即：

1. headless/CCR env path
2. interactive remote REPL path

它们在这里共享的是：

- “都需要 remote-style settings sync”

不是：

- “remote 的根语义完全相同”

所以这里更像：

- dual acceptance gate

不是：

- identity proof

## 第五层：`CLAUDE_CODE_REMOTE` 更像 environment fact，`getIsRemoteMode()` 更像 behavior switch

把前面几层合起来，可以更稳地落一句最小结论：

### `CLAUDE_CODE_REMOTE`

更像：

- environment fact
- process/container fact
- headless/CCR runtime fact

### `getIsRemoteMode()`

更像：

- interactive behavior switch
- UI/REPL branch switch
- bootstrap-time front-state bit

这也是为什么前者会出现在：

- proxy
- permission defaults
- plugin git transport
- API timeout

而后者会出现在：

- `/session`
- `StatusLine`
- footer modePart
- startup notifications

## 第六层：这也解释了为什么某些代码只认 env，不认 bootstrap bit

如果两者真是镜像，理论上所有分支都应该写成：

- `(CLAUDE_CODE_REMOTE || getIsRemoteMode())`

但事实不是。

比如：

- upstream proxy 初始化只认 env
- plugin git URL 选路只认 env
- permission defaultMode 收窄只认 env
- API timeout 收窄只认 env

这正说明这些分支在意的是：

- 你是不是运行在 CCR/remote 环境里

而不是：

- 当前交互 REPL 是否切到了 remote UI 行为

换句话说，它们需要的是：

- environment truth

不是：

- interactive remote bit

## 第七层：所以 `(env || bit)` 这类代码应该读成“兼容双入口”，而不是“证明二者同义”

`print.ts` / `/reload-plugins` 已经给出最典型的模式：

- `CLAUDE_CODE_REMOTE` 负责 headless/CCR env path
- `getIsRemoteMode()` 负责 interactive remote path

当代码写成：

- `(env || bit)`

更稳的解读是：

- “无论从 headless remote 入口进来，还是从 interactive remote 入口进来，都要采取同一类后续行为”

它不是在说：

- “这两个信号从语义上已经完全等价”

## 第八层：这页最值得保留的一句，是“remote 不是一根轴”

经过 143-148 这一组切片，当前 repo 至少已经出现了多根不同的 remote 轴：

1. `getIsRemoteMode()` 这类 interactive behavior bit
2. `remoteSessionUrl` 这类 display affordance / presence field
3. `viewerOnly` 这类 contract thickness flag
4. `CLAUDE_CODE_REMOTE` 这类 environment fact
5. `REMOTE_SAFE_COMMANDS` 这类 command affordance shell

所以如果还把 remote 继续压成一个词，

正文就一定会重新塌回去。

## stable / conditional / gray

| 类型 | 结论 |
| --- | --- |
| 稳定可见 | `getIsRemoteMode()` 属于 bootstrap state；`CLAUDE_CODE_REMOTE` 属于 env-driven CCR/runtime fact；interactive/UI 分支主要看前者，headless/container/env 分支主要看后者；`print.ts` / `/reload-plugins` 的 `(env || bit)` 是兼容两类 remote 入口，不是证明两者同义 |
| 条件公开 | 某些行为会同时接受 env 与 bit，例如 settings sync 相关分支；这说明某些后续动作可在双入口上共享，但不说明所有 remote 行为都共享一根轴 |
| 灰度/实现层 | 哪些分支最终该落在 env-only、bit-only、还是 dual acceptance gate，上层仍可能随产品策略继续调整；但 “headless env axis ≠ interactive bit axis” 这个结构结论已经足够稳定 |

## 苏格拉底式自审

### 问：为什么这页不直接写“`CLAUDE_CODE_REMOTE` 是服务端 remote，`getIsRemoteMode()` 是客户端 remote”？

答：因为那样太快了。更稳的是按 consumer 类型来拆：env/runtime policy vs interactive/UI behavior。

### 问：为什么一定要把 `pluginLoader`、`permissionSetup`、`api timeout` 也一起写？

答：因为只有把 UI 之外的 environment branches 摆出来，才能看清 `CLAUDE_CODE_REMOTE` 根本不是 UI remote bit 的别名。

### 问：为什么要专门强调 `(env || bit)`？

答：因为这是最容易让人误读成“二者同义”的写法，而实际上它更像“双入口兼容”。

### 问：这页的一句话 thesis 是什么？

答：`CLAUDE_CODE_REMOTE` 是 headless/env-driven remote 轴，`getIsRemoteMode()` 是 interactive/bootstrap remote 轴；两者有时被并联接受，但并不互为镜像。

## 结论

对当前源码来说，更准确的写法应该是：

1. `CLAUDE_CODE_REMOTE` 描述的是 CCR/headless/container 运行环境
2. `getIsRemoteMode()` 描述的是 interactive REPL 的 remote 行为切换
3. 某些代码会同时接受两者，只是为了兼容双 remote 入口

所以：

- headless remote 分支不是 interactive remote bit 的镜像

## 源码锚点

- `claude-code-source-code/src/bootstrap/state.ts`
- `claude-code-source-code/src/entrypoints/cli.tsx`
- `claude-code-source-code/src/entrypoints/init.ts`
- `claude-code-source-code/src/context.ts`
- `claude-code-source-code/src/utils/queryHelpers.ts`
- `claude-code-source-code/src/utils/plugins/pluginLoader.ts`
- `claude-code-source-code/src/utils/permissions/permissionSetup.ts`
- `claude-code-source-code/src/services/api/claude.ts`
- `claude-code-source-code/src/upstreamproxy/upstreamproxy.ts`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/commands/reload-plugins/reload-plugins.ts`
