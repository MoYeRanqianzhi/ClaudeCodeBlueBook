# `/remote-control`、`--remote-control`、`claude remote-control` 与 Remote Callout：为什么 remote-control 的会内开桥、启动带桥与 standalone host 不是同一种入口

## 用户目标

不是只知道 Claude Code “既有 `/remote-control`，又有 `--rc`，还能跑 `claude remote-control`”，而是先分清四类不同入口对象：

- `/remote-control`，回答的是“当前这条已进入 REPL 的会话，现在要不要显式开桥”。
- `--remote-control` / `--rc`，回答的是“启动这次交互 REPL 时，要不要一开始就带着远控进入”。
- `claude remote-control`，回答的是“要不要直接把本机作为 standalone remote-control host 启起来”。
- `Remote Callout`，回答的是“第一次从 REPL 里显式开桥时，是否先给一个一次性的远控说明与确认”。

如果不先拆开，读者最容易把下面这些东西压成同一个“远控入口”：

- REPL 里的 `/remote-control`
- 启动参数 `--remote-control` / `--rc`
- `claude remote-control`
- `claude rc`
- `claude remote`
- `claude sync`
- `claude bridge`
- REPL 里的 first-run Remote Callout
- standalone host 的 spawn mode 选择

## 第一性原理

在 Claude Code 里，“进入 remote-control”至少沿着四条轴线分化：

1. `Host Shape`：它是在当前 REPL 会话里开桥，还是直接启动一个 standalone host。
2. `Activation Time`：它发生在会话已经运行中，还是发生在 CLI 启动时。
3. `Consent Surface`：它是直接执行，还是先走一次性的 callout / choice。
4. `Persistence Scope`：它只影响本轮会话，还是会把某种项目级选择持久化下来。

因此更稳的提问不是：

- “remote-control 到底应该用哪个入口？”

而是：

- “我现在是要在当前 REPL 里显式开桥、要让这次启动一开始就带桥、还是要直接起一个 standalone remote-control host？”

只要这四条轴线没先拆开，正文就会把 `/remote-control`、`--rc`、`claude remote-control` 全写成同一种入口。

## 第一层：`/remote-control` 是会内入口，作用对象是当前已运行的 REPL 会话

### `/remote-control` 的对象是“当前这条 REPL 会话”

`commands/bridge/bridge.tsx` 的注释已经把它写透：

- `/remote-control command — manages the bidirectional bridge connection`
- 设置 `replBridgeEnabled`
- 由 `useReplBridge` 在 REPL 内初始化桥接

这说明它回答的问题不是：

- “要不要新起一个独立的 remote-control host”

而是：

- “当前这条已经运行中的 REPL 会话，现在要不要显式接入 bidirectional bridge”

### 它先做的是当前会话 preflight，不是 CLI 启动期解析

`/remote-control` 执行路径里会：

- 看当前 `replBridgeConnected` / `replBridgeEnabled`
- 必要时弹 disconnect dialog
- 否则跑 `checkBridgePrerequisites()`
- 再把 `replBridgeEnabled = true`
- `replBridgeExplicit = true`

这说明它本质上是：

- 会内控制动作

而不是：

- CLI 启动期的参数分流

### 所以 `/remote-control` 的第一性原理是“对当前 REPL 的显式开桥”

更稳的理解是：

- 它依赖当前 REPL 已经存在
- 它改的是当前 `AppState`
- 它让当前 conversation 被远端继续

而不是：

- 脱离当前 REPL 再新起一种宿主

## 第二层：`--remote-control` / `--rc` 是启动期入口，作用对象是“这次交互 REPL 的初始状态”

### `--remote-control` 不是 REPL 内命令，而是启动参数

`main.tsx` 会在参数解析阶段提取：

- `remoteControlOption = options.remoteControl ?? options.rc`

随后保留：

- `remoteControlName`

并在 setup screens 之后再去 resolve entitlement gate。

这说明 `--remote-control` / `--rc` 的对象不是：

- 已经进入 REPL 之后的那条会话控制动作

而是：

- “本次启动的交互 REPL，要不要以 remote-control enabled 的初始状态进入”

### 它会等 trust / setup / gate 之后再决定是否生效

`main.tsx` 明确写了：

- 等 `showSetupScreens()` 完成
- trust established
- GrowthBook has auth headers

之后才去检查：

- `getBridgeDisabledReason()`

若失败则输出：

- `--rc flag ignored.`

这说明它的真实语义是：

- 启动期请求“请带桥进入”

而不是：

- 无条件强制打开远控

### 它仍然落到当前交互 REPL，而不是 standalone host

初始化 `AppState` 时，`main.tsx` 会把：

- `replBridgeExplicit: remoteControl`
- `replBridgeInitialName: remoteControlName`

种进当前 REPL 的初始状态。

因此它最终仍然属于：

- 当前交互 REPL 的 bridge 初始态

而不是：

- `claude remote-control` 那条 standalone host 运行链

### 所以 `--remote-control` 的第一性原理是“启动即带桥进入当前 REPL”

更稳的区分是：

- `/remote-control`：REPL 运行后再显式开桥
- `--remote-control` / `--rc`：REPL 启动时就把桥种进初始态

两者都会落到 bridge-enabled REPL，但 activation time 不同。

## 第三层：`claude remote-control` 是 standalone host 入口，不是“另一种写法的 /remote-control”

### `claude remote-control` 在 CLI fast-path 就被分流掉了

`entrypoints/cli.tsx` 写得非常直白：

- Fast-path for `claude remote-control`
- 也接受 `rc`、`remote`、`sync`、`bridge`
- serve local machine as bridge environment

这说明它的对象不是：

- 当前 main REPL 会话里的 bridge toggle

而是：

- 直接把本机作为 bridge environment host 启起来

### main.tsx 里的同名 subcommand 只是兜底，不是主路径

`main.tsx` 里虽然也注册了：

- `program.command('remote-control').alias('rc')`

但注释已经说明：

- Unreachable
- cli.tsx fast-path handles this command before main.tsx loads

这意味着用户心智上看到的是同一个命令名，但实现层对象其实已经分流成：

- standalone host path

而不是：

- REPL 命令系统里那个 `/remote-control`

### legacy aliases 更应被保护在边界说明里

`entrypoints/cli.tsx` 还接受：

- `claude remote`
- `claude sync`
- `claude bridge`

这些说明产品做了兼容，但正文不应把它们抬成与主线入口同等权重。

更稳的写法是：

- `claude remote-control` / `claude rc` 是用户更该记住的主线名字
- `remote` / `sync` / `bridge` 属于 legacy / compatibility surface

### 所以 standalone `claude remote-control` 的第一性原理是“起一个 host，不是切当前 REPL”

更稳的区分是：

- `/remote-control`：在当前 REPL 里开桥
- `--remote-control`：让当前 REPL 启动即带桥
- `claude remote-control`：直接起 standalone bridge host

三者都会通向 remote-control，但 host shape 根本不同。

## 第四层：Remote Callout 是 REPL `/remote-control` 的 first-run consent surface，不是所有远控入口都会出现的总闸门

### callout 只在 `/remote-control` 路径里判定

`commands/bridge/bridge.tsx` 里：

- 先跑 preflight
- 再看 `shouldShowRemoteCallout()`
- 若需要则只把 `showRemoteCallout = true`
- 暂不直接开桥

这说明 Remote Callout 的对象不是：

- 所有 remote-control 入口的统一前置页

而是：

- REPL 内首次显式 `/remote-control` 的说明与确认面

### callout 本身也是 session-first 的措辞

`RemoteCallout.tsx` 的主选项写的是：

- `Enable Remote Control for this session`

并且说明：

- 以后也可以再用 `/remote-control`

这说明它本来就在强调：

- 当前 session 级动作

而不是：

- standalone host 模式
- 项目级默认策略

### 它只显示一次，并且受资格前提约束

`shouldShowRemoteCallout()` 会检查：

- `remoteDialogSeen`
- `isBridgeEnabled()`
- Claude OAuth token

而 `RemoteCallout` 挂载时会把：

- `remoteDialogSeen = true`

持久化。

这说明它的真实语义是：

- 一次性的 first-run consent / explanation

不是：

- 每次 remote-control 都必须经过的总入口

### 用户选择 enable 后，仍然只是把当前 REPL 显式开桥

`REPL.tsx` 处理 callout 结果时，`selection === 'enable'` 只会把：

- `replBridgeEnabled = true`
- `replBridgeExplicit = true`
- `replBridgeOutboundOnly = false`

写回当前 `AppState`。

这进一步说明：

- callout 仍然属于 `/remote-control` 的 session-first 开桥链

而不是独立入口。

## 第五层：spawn mode 只属于 standalone host 路径，不属于 `/remote-control` 或 `--rc`

### spawn mode 的 first-run 选择发生在 `bridgeMain`

`bridgeMain.ts` 的 first-run logic 只在这些条件下触发：

- multi-session enabled
- worktree available
- 没有 saved spawn mode
- 没有显式 override
- 不是 resume
- TTY 可交互

然后会提示：

- `same-dir`
- `worktree`

并保存到：

- `ProjectConfig.remoteControlSpawnMode`

### 这说明 spawn mode 的对象是“standalone host 如何为远端新会话分配目录”

它回答的问题不是：

- 当前 REPL 要不要开桥

而是：

- standalone remote-control host 以后为这个项目新建会话时，使用 same-dir 还是 worktree

### 因而它不能再被写成“remote-control 共有设置”

更稳的区分是：

- `/remote-control`：当前 REPL 开桥，不谈 spawn mode
- `--remote-control`：当前 REPL 启动即带桥，不谈 spawn mode
- `claude remote-control`：standalone host，才会出现 multi-session / spawn mode 这组问题

## 第六层：稳定主线、条件面与内部面要继续保护

### 稳定可见或相对稳定可见的

- `/remote-control`
- `claude remote-control`
- REPL 内的 Remote Callout

这些都属于 reader-facing 主线，适合进入正文。

### 条件公开或需要降权处理的

- `--remote-control` / `--rc` 是 hidden startup flags
- `claude rc` 是 alias
- `claude remote` / `sync` / `bridge` 是 legacy compatibility aliases
- standalone host 的 spawn mode 依赖 multi-session / worktree 条件

这些也真实存在，但正文应继续标注：

- 隐藏
- 兼容
- 灰度或条件开放

而不是把它们写成同等主入口。

### 更应留在实现边界说明的

- cli fast-path 具体加载顺序
- dead code elimination / build-time inline 细节
- 所有 analytics 事件与 rollout 判断
- spawn mode 的全部底层 runner 细节

这些只作为作者判断依据，不回流正文主线。

## 最后的判断公式

当你看到多个 remote-control 入口时，先问七个问题：

1. 我现在是在当前 REPL 里开桥，还是要在启动时带桥进入？
2. 我是要继续当前交互会话，还是要直接起一个 standalone host？
3. 这个入口改的是当前 `AppState`，还是根本走了另一条 CLI fast-path？
4. 这个提示页是所有入口的总闸门，还是只属于 `/remote-control` 的 first-run callout？
5. 现在谈的是 session-first 开桥，还是 standalone host 的 spawn mode？
6. 这个名字是稳定主线入口，还是 hidden / alias / legacy surface？
7. 我是不是把 `/remote-control`、`--remote-control`、`claude remote-control` 又压成了同一种入口？

只要这七问先答清，就不会把不同入口误写成一种 remote-control 动作。

## 源码锚点

- `claude-code-source-code/src/commands/bridge/bridge.tsx`
- `claude-code-source-code/src/components/RemoteCallout.tsx`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/entrypoints/cli.tsx`
- `claude-code-source-code/src/bridge/bridgeMain.ts`
- `claude-code-source-code/src/commands.ts`
- `claude-code-source-code/src/utils/config.ts`
