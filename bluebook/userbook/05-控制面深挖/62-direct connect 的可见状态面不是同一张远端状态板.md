# `Connected to server`、`Remote session initialized`、`busy/waiting/idle`、`PermissionRequest` 与 `stderr disconnect`：为什么 direct connect 的可见状态面不是同一张远端状态板

## 用户目标

不是只知道 direct connect 里会同时出现：

- `Connected to server at ...`
- `Remote session initialized ...`
- `Status: ...`
- 终端 tab 的 `busy / waiting / idle`
- 权限确认弹层
- `Server disconnected.`

而是先拆开六类不同状态面：

- 哪些是在说 main 启动时注入的本地连接提示。
- 哪些是在说远端事件被投影成 transcript 里的 system message。
- 哪些是在说 REPL 本地派生出来的 `busy / waiting / idle`。
- 哪些是在说当前正在等用户批准，所以进入 overlay waiting 面。
- 哪些是在说 fatal 连接失败只走 stderr，不进 transcript。
- 哪些只是共享了“像状态”的外观，但并不属于同一张远端状态板。

如果这些对象不先拆开，读者最容易把下面这些东西压成同一种“远端状态”：

- `Connected to server at ...`
- `Remote session initialized (model: ...)`
- `Status: compacting`
- `busy`
- `waiting`
- `PermissionRequest`
- `Failed to connect to server at ...`
- `Server disconnected.`

## 第一性原理

direct connect 的“我现在在看什么状态”至少沿着五条轴线分化：

1. `Source`：这条状态来自 main 本地注入、远端事件投影，还是 REPL 本地派生。
2. `Surface`：它落在 transcript、tab status、overlay，还是 stderr。
3. `Lifetime`：它是一条一次性提示、离散事件、持续派生态，还是致命收口。
4. `Authority`：它描述的是远端事件、当前本地交互阻塞，还是本地连接存活性判断。
5. `Update Mode`：它按消息追加、按状态派生，还是按错误直接终止。

因此更稳的提问不是：

- “direct connect 现在是什么状态？”

而是：

- “我当前看到的是一条本地启动提示、远端 transcript 事件、本地派生的 busy/waiting/idle、等待批准 overlay，还是 fatal stderr；这条信息到底描述的是远端工作、当前本地交互，还是连接存活？”

只要这五条轴线没先拆开，正文就会把 direct connect 写成一张持续更新的远端状态板。

这里也要主动卡住几个边界：

- 这页讲的是 direct connect 的可见状态面。
- 不重复 59 页对 session factory 与 `ws_url` 的拆分。
- 不重复 60 页对 control subset / shutdown semantics 的拆分。
- 不重复 61 页对 message filtering 与 transcript surface 的拆分。

## 第一层：`Connected to server at ...` 是本地启动提示，不是远端状态事件

### 这条消息来自 `main.tsx`，不是远端 `init`

交互态 direct connect 在 `launchRepl(...)` 之前，`main.tsx` 会主动塞一条：

- `Connected to server at ${url}\nSession: ${sessionId}`

作为本地 system message。

这说明它回答的问题不是：

- “远端刚刚上报了什么运行态”

而是：

- “本地 CLI 已经完成 connect 入口的启动交接”

### 所以连接成功提示不应和 `Remote session initialized` 写成同一来源

更准确的理解应是：

- `Connected to server at ...`：本地启动时注入
- `Remote session initialized ...`：远端 `init` 被投影后的 transcript 消息

只要这一层没拆开，正文就会把所有开场状态都写成远端原样回显。

## 第二层：`Remote session initialized`、`Status: ...` 属于 transcript 状态消息，不等于本地派生态

### 这些是远端消息经过 adapter 转写后的正文

`sdkMessageAdapter.ts` 会把：

- `system.init`
- `system.status`
- `system.compact_boundary`
- `tool_progress`

转成 system message，最终落进 transcript。

这说明它们回答的问题不是：

- “终端 tab 当前应处于 busy 还是 waiting”

而是：

- “远端有一条值得显示给用户的离散事件”

### 它们是追加到 transcript 的，不是覆盖当前总状态

例如：

- `Status: compacting`
- `Conversation compacted`

是作为一条条 message 出现，而不是替换当前 REPL 的总状态词。

只要这一层没拆开，正文就会把远端 status event 写成 REPL 的全局状态栏。

## 第三层：`busy / waiting / idle` 是本地派生状态，不是远端状态词

### REPL 的 sessionStatus 只看本地 loading / waiting 条件

`REPL.tsx` 里：

- `isLoading = isQueryActive || isExternalLoading`
- `isWaitingForApproval = ...`
- `sessionStatus = waiting ? 'waiting' : isLoading ? 'busy' : 'idle'`

这说明 `busy / waiting / idle` 回答的问题不是：

- “远端刚上报了哪个 status subtype”

而是：

- “当前这整个 REPL，从本地交互与运行角度看，应该呈现成哪种 tab status”

### 所以 `Status: compacting` 与 `busy` 不是同一种状态

更准确的理解应是：

- `Status: ...`：远端事件文本，落在 transcript
- `busy`：本地派生总状态，落在 tab status / activity

只要这一层没拆开，正文就会把 transcript 事件词和 tab status 词混写成一张面。

## 第四层：`waiting` 很多时候不是远端停住，而是本地正在等你批准

### `PermissionRequest` overlay 会把当前会话切到 waiting 面

`REPL.tsx` 里：

- `toolPermissionOverlay = <PermissionRequest ... />`

同时：

- `toolUseConfirmQueue.length > 0` 会让 `isWaitingForApproval = true`
- 进而让 `sessionStatus = 'waiting'`

这说明它回答的问题不是：

- “远端此刻发来了一条新的 status 消息”

而是：

- “当前本地 UI 被用户批准动作阻塞住了”

### 所以 approval overlay 不是 transcript 里的另一种状态消息

更准确的理解应是：

- transcript：继续保留远端离散事件
- overlay：当前本地输入焦点被权限确认接管
- waiting：tab status 对这种本地阻塞的派生结果

只要这一层没拆开，正文就会把“等待批准”和“远端 status 更新”写成同一层等待。

## 第五层：fatal 连接失败走 stderr，不加入这张状态板

### `Failed to connect...` 与 `Server disconnected.` 都不走 transcript

`useDirectConnect.ts` 的 `onDisconnected` 只会：

- `process.stderr.write(...)`
- `gracefulShutdown(1)`
- `setIsLoading(false)`

不会把这两句作为正文 system message 追加进去。

这说明它回答的问题不是：

- “当前 transcript 要不要再多一条状态事件”

而是：

- “当前连接已经死亡，应立即走致命收口”

### 所以 fatal stderr 文案与 transcript status event 不属于同一张面

更准确的理解应是：

- transcript status：离散可读事件
- stderr disconnect：致命故障收口

只要这一层没拆开，正文就会把 disconnect 文案误写成另一条普通状态消息。

## 第六层：`waiting`、`busy`、transcript status 与 stderr failure 四层应分开看

### 当前 direct connect 至少存在四个并行状态面

这条线至少有：

- 启动提示面：`Connected to server at ...`
- transcript 状态面：`Remote session initialized` / `Status: ...` / `Tool ... running ...`
- 本地派生态：`busy / waiting / idle`
- 故障收口面：stderr disconnect 文案

这说明本页真正回答的问题不是：

- “direct connect 当前唯一状态是什么”

而是：

- “这些看上去都像状态，但它们分别描述的是哪一个层次”

只要这一层没拆开，正文就会把 direct connect 写成单一状态机，而不是多投影并存。

## 第七层：stable、conditional 与 internal 三层要分开保护

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | direct connect 同时存在本地启动提示、transcript 状态消息、本地 busy/waiting/idle 与 fatal stderr 收口；它们不是同一张状态面 |
| 条件公开 | waiting 取决于本地 approval/dialog 阻塞； `busy` 取决于 local query 与 external loading；远端 `init/status/tool_progress` 是否出现取决于远端是否发出对应事件 |
| 内部/实现层 | `hasReceivedInitRef` 去重、`waitingFor` 的具体拼接文案、prevent sleep 与 tab status gate、disconnect 文案使用 `wsUrl` 而非 connect URL |

## 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `Connected to server at ...` = 远端初始化状态 | 这是 main 注入的本地启动提示 |
| `Remote session initialized` = 当前 REPL 总状态 | 这是 transcript 中的一条离散远端事件 |
| `Status: compacting` = tab 现在应该显示 `waiting` 或 `busy` | 一个是 transcript 事件，一个是本地派生态 |
| `waiting` = 远端卡住了 | 很多时候只是本地正在等批准 |
| 权限弹层 = transcript 里的状态消息 | 它属于 overlay 面 |
| `Server disconnected.` = 另一条普通状态消息 | 这是 fatal stderr 收口 |

## 七个检查问题

- 当前这条状态来自 main 本地注入、远端 transcript 投影，还是 REPL 本地派生？
- 它落在 transcript、tab status、overlay，还是 stderr？
- 它描述的是远端事件、本地交互阻塞，还是连接存活性？
- 这是一次性提示、离散事件，还是持续派生态？
- 当前 `waiting` 是因为 approval/dialog，还是我误把远端 status 当等待态了？
- 这条 disconnect 文案是不是被我错当成普通状态消息了？
- 我是不是又把 direct connect 写成单一远端状态板了？

## 源码锚点

- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/remote/sdkMessageAdapter.ts`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/hooks/useDirectConnect.ts`
