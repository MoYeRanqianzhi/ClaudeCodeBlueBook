# `getIsRemoteMode`、`commands/session`、`remoteSessionUrl`、`SessionInfo`、`PromptInputFooterLeftSide` 与 `StatusLine`：为什么 `/session` 的命令显隐与 pane 内容不是同一种 remote mode

## 用户目标

143 已经把 `getIsRemoteMode()` 从 remote presence truth 里拆出来了。

但如果停在那一页，读者还是会立刻追问一个更尖的问题：

- 既然 `/session` 的显隐看 `getIsRemoteMode()`，为什么真正点进去之后，`SessionInfo` 还会再看一次 `remoteSessionUrl`？
- 既然两边都在谈 remote mode，为什么同一个功能里还要保留两套 gate？

这轮要补的不是：

- “`/session` 的实现细节”

而是：

- “为什么 `/session` 的命令显隐与 pane 内容，回答的根本不是同一个 remote 问题”

## 第一性原理

更稳的提问不是：

- “系统到底谁才是真 remote mode？”

而是先问四个更底层的问题：

1. 用户现在需要回答的是“这个命令该不该露出来”，还是“这个 pane 现在有没有东西可展示”？
2. 当前 consumer 需要的是 coarse remote latch，还是 presence field？
3. 同一个 UI 组件里，有没有已经并排使用 `getIsRemoteMode()` 与 `remoteSessionUrl` 的证据？
4. 如果一个分支只负责防止本地 UI 误导，它是不是就不该被误写成 remote presence contract？

只要这四问先拆开，`/session` 就不会再被压成一句过快的话：

- “命令显出来了，所以当前一定已经有 remote session presence”

## 第一层：`commands/session/index.ts` 只回答“命令要不要露出来”

`commands/session/index.ts` 的 gate 很薄：

- `isEnabled: () => getIsRemoteMode()`
- `isHidden: () => !getIsRemoteMode()`

它回答的是：

- 当前 slash surface 要不要把 `/session` 露给用户

而不是：

- 当前 AppState 里有没有可展示的 session URL

这层更像：

- command affordance gate

不是：

- presence content gate

这也解释了为什么 `/session` 会被放进 `REMOTE_SAFE_COMMANDS`：

- 它先被系统当成 remote-safe 的本地命令面成员保留下来
- 但保留下来，不等于内容已经就绪

再往下看 `filterCommandsForRemoteMode(...)` 与 `REPL.tsx` 里的 `handleRemoteInit(...)` 也会发现：

- `/session` 会在 remote 预过滤阶段被保留下来
- CCR init 之后重算本地命令时，也仍会保留 local-safe set

所以“命令可见但内容还没就绪”不是纸面矛盾，

而是系统明确接受的 surface 形态。

## 第二层：`SessionInfo` 只回答“pane 里有没有可展示的 remote-session presence”

真正的 pane 逻辑在 `commands/session/session.tsx`。

这里 `SessionInfo` 读的是：

- `useAppState(s => s.remoteSessionUrl)`

然后分成两层：

### 有 URL

- 生成 QR code
- 展示 `Open in browser`
- 把 `remoteSessionUrl` 当成真实可展示对象

### 没 URL

- 直接返回 warning pane
- 文案是：`Not in remote mode. Start with \`claude --remote\` to use this command.`

这一层回答的已经不是：

- “命令该不该露出来”

而是：

- “当前有没有可展示的 remote-session presence object”

所以 `/session` 从代码上就是双门控：

1. 命令显隐 gate：`getIsRemoteMode()`
2. pane 内容 gate：`remoteSessionUrl`

## 第三层：这个双门控不是纯防御性空分支，启动路径本身就把两层拆开了

如果只是看到 `SessionInfo` 的 fallback 文案，仍然可以怀疑：

- “这只是作者随手留的 defensive branch，运行时未必真的会遇到。”

但 `main.tsx` 已经给了更硬的证据。

### `claude assistant` attach / viewer 路径

这条路径会：

- `setIsRemoteMode(true)`

但初始化的 `assistantInitialState` 里并没有种下：

- `remoteSessionUrl`

### `claude --remote` TUI 路径

这条路径也会：

- `setIsRemoteMode(true)`

但同时又额外把：

- `remoteSessionUrl`

写进 `remoteInitialState`

这意味着同样是 remote-mode latch，

系统已经把两种启动语境区分开了：

1. coarse remote behavior 已成立
2. QR / browser URL 这种 remote-session presence 载荷是否已经成立，要另看

再结合上一层的 `REMOTE_SAFE_COMMANDS`，可以把 reachability 说得更具体：

- assistant attach / viewer 路径里，`/session` 的可见性是稳定可达的
- 但同一路径是否同时拿到可展示 URL，不能由 `getIsRemoteMode()` 直接推出

所以 `/session` 的双门控不是多余重复，

而是在承认：

- “remote-mode latch 成立” 与 “session URL presence 成立” 并不是同一个时刻、也不是同一种事实

## 第四层：同一个 footer 已经把两种 remote state 并排消费了

`PromptInputFooterLeftSide.tsx` 是这轮最值钱的旁证之一。

同一个组件里，它同时做了两件事：

### 远端 presence link

它从 store 里抓：

- `remoteSessionUrl`

然后只有 URL 存在时才渲染：

- `remote` link pill

### 本地 mode 抑制

它又用：

- `!getIsRemoteMode()`

来决定本地 permission mode part 还要不要显示。

这两个判断在同一组件里并排出现，已经足够说明：

- `remoteSessionUrl` 负责 presence/link surface
- `getIsRemoteMode()` 负责 UI correctness / local-mode suppression

更进一步看实现细节，这里还埋着一个对目录结构很有价值的限定：

- `AppStateStore` 自己就把 `remoteSessionUrl` 注释成 “for --remote mode / shown in footer indicator”
- footer 读取它时也不是订阅式消费，而是在 mount 时从 initial state snapshot 一次

所以 footer remote pill 当前更像：

- `--remote` path 的展示型投影

而不是：

- 所有 remote mode 的通用 presence subscriber

所以如果把它们重新写成同一层 remote mode，

等于把：

- “有没有 URL”

和：

- “本地 mode 标签会不会误导”

压成了一个问题。

这不稳。

## 第五层：`StatusLine` 再给出第三种 consumer 角色，它消费的是 schema，不是 pane presence

`StatusLine.tsx` 在 `getIsRemoteMode()` 为真时，会把：

- `remote.session_id`

塞进 status line command input。

这一步和 `/session` pane 也不是一回事。

它消费 `getIsRemoteMode()` 时要解决的是：

- 当前 status line schema 要不要对下游 hook 声明“我处于 remote 环境”

所以到这里，同一个 `getIsRemoteMode()` 至少已经被三类 consumer 使用：

1. `/session` 显隐：command affordance
2. footer mode 抑制：UI 防误导
3. status line remote 字段：schema export

三者都不是：

- “pane 里有没有 QR/URL”

于是 143 和 144 的分工就更清楚了：

- 143 说明 `getIsRemoteMode()` 不是 presence truth
- 144 继续说明，就连同一功能族里的 `/session`，命令显隐和 pane 内容也不是同一种 remote mode

## 第六层：`activeRemote` 仍然是第三层语义，不能回卷到 `/session` 双门控里

`REPL.tsx` 里真正负责 send / cancel / permission shell 的是：

- `activeRemote`

它来自：

- `useRemoteSession`
- `useDirectConnect`
- `useSSHSession`

并且 direct connect / ssh 自己都有各自的：

- `isRemoteMode`

这再次提醒我们：

- turn-level remote interaction
- global remote behavior latch
- remote-session URL presence

至少是三层不同语义。

所以这页不能又退回一句偷换：

- “既然都 remote，那 `/session` 的 gate、footer 的 gate、status line 的 gate 本质一样。”

不一样。

## stable / conditional / gray

| 类型 | 结论 |
| --- | --- |
| 稳定可见 | `/session` 的命令显隐直接看 `getIsRemoteMode()`；`SessionInfo` 的 pane 内容直接看 `remoteSessionUrl`；footer 同时用 `remoteSessionUrl` 渲染 link、用 `getIsRemoteMode()` 压掉本地 mode；`StatusLine` 用 `getIsRemoteMode()` 输出 `remote.session_id`；assistant attach / viewer 路径会稳定产生“remote bit 为真，但 URL 初始态未被种下”的分叉 |
| 条件公开 | `claude assistant` attach 与 `claude --remote` TUI 都会写 `setIsRemoteMode(true)`，但只有后者会在初始 AppState 里显式种下 `remoteSessionUrl`；因此同一 latch 进入不同启动路径时，presence 载荷厚度并不一致；footer remote pill 目前又只拿 mount-time snapshot，不承诺后续 store 写入自动恢复 |
| 灰度/实现层 | `SessionInfo` 的 warning 文案现在仍写成 “Not in remote mode”，这更像用户解释口径而不是精密术语；未来文案可能会改，但双门控本身的结构事实已经成立 |

## 苏格拉底式自审

### 问：如果 `getIsRemoteMode()` 已经足够 authoritative，为什么 `SessionInfo` 不直接信它？

答：因为 `SessionInfo` 要解决的是 QR / URL 可展示性，而不是 slash affordance。

### 问：如果 `remoteSessionUrl` 才是真正 presence，为什么 `/session` 还不直接按它显隐？

答：因为命令 surface 要先决定“是否进入 remote-safe 命令面”，这是 affordance 先行，不是 pane 内容先行。

### 问：为什么一定要把 footer 和 status line 也一起写进这页？

答：因为只有把 schema、affordance、UI correctness、presence link 四类 consumer 摆在一起，才能看清它们并没有消费同一层 remote truth。

### 问：这页是不是在否定 `getIsRemoteMode()` 的价值？

答：不是。它对行为切换、schema 导出、UI 防误导都很有价值；只是它不负责替代 `remoteSessionUrl` 这类 presence field。

## 结论

对 `/session` 来说，当前源码已经明确区分了两件事：

1. 这个命令是否属于当前 remote-safe command surface
2. 当前 pane 是否真的拿到了可展示的 remote-session URL

前者看：

- `getIsRemoteMode()`

后者看：

- `remoteSessionUrl`

所以 `/session` 的命令显隐与 pane 内容不是同一种 remote mode。

更准确的写法应该是：

- `getIsRemoteMode()` 决定 affordance / schema / UI correctness
- `remoteSessionUrl` 决定 `/session` pane 的 presence content

## 源码锚点

- `claude-code-source-code/src/commands.ts`
- `claude-code-source-code/src/commands/session/index.ts`
- `claude-code-source-code/src/commands/session/session.tsx`
- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/bootstrap/state.ts`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooterLeftSide.tsx`
- `claude-code-source-code/src/components/StatusLine.tsx`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/hooks/useDirectConnect.ts`
- `claude-code-source-code/src/hooks/useSSHSession.ts`
