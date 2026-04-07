# `/resume`、`--continue`、`print --resume` 与 `remote-control --continue`：为什么 stable conversation resume、headless remote hydrate 与 bridge continuity 不是同一种接续来源

## 用户目标

161 已经把：

- `--continue`
- startup picker
- 会内 `/resume`

拆成了不同入口宿主。

162 又把：

- interactive resume host
- `print.ts` / headless print host

拆成了不同宿主族。

163 到 168 则继续把 `print` remote resume 内部的：

- parse
- hydrate
- restore
- metadata readback
- transport thickness

一步步拆开。

但如果正文停在这里，读者还是很容易把另一个更靠用户工作流的关键问题写平：

- `/resume` 和 `--continue` 不是都叫“继续旧会话”吗？
- `print --resume` 不也只是同一个 resume 的 headless 版本吗？
- `remote-control --continue` 看起来也叫 continue，那它是不是只是远端版继续上次对话？

这句还不稳。

从当前源码和既有切片看，至少还有三种不同的接续来源：

1. stable conversation history source
2. conditional remote-hydrated transcript source
3. bridge pointer continuity source

如果这三种来源不先拆开，后面就会把：

- `/resume`
- generic `--continue`
- `print --resume`
- `remote-control --continue`

重新压成同一种“恢复旧会话”。

## 第一性原理

更稳的提问不是：

- “这些入口是不是都能继续之前的工作？”

而是先问五个更底层的问题：

1. 当前继续的是 conversation history、remote transcript materialization，还是 bridge pointer continuity？
2. 当前 source 是普通用户默认稳定入口，还是受 remote / bridge 条件限制的补充入口？
3. 当前恢复目标是“把旧对话重新读出来”，还是“回到原来的远端环境 / pointer 轨迹”？
4. 当前 host 是 selector / REPL / print pipeline，还是 standalone bridge host？
5. 如果接续来源、前提条件和失败语义都不同，为什么还要把它们写成同一种 continue？

只要这五轴不先拆开，后面就会把：

- stable conversation resume
- headless remote hydrate
- bridge continuity

混成一条“上次状态继续回来”的模糊链。

## 第一层：`/resume` 与 generic `--continue` 先消费的是 stable conversation history source

对普通用户主线来说，最稳定的接续来源仍然是：

- 本地 conversation history

这条链的证据很硬：

- `commands/resume/index.ts` 先把 `/resume` 注册成公开命令
- 任务矩阵把“恢复旧会话”写成 `/resume`，稳定
- `main.tsx` 把 `-c, --continue` 写成 “Continue the most recent conversation in the current directory”
- `conversationRecovery.ts` 还明确写：
  `--continue: most recent session`

这说明 generic `--continue` 回答的问题不是：

- “回到某条 remote-control continuity”

而是：

- “在当前目录下找到最近那条可继续的对话历史”

同理，startup picker 的 `ResumeConversation` 也只是：

- 先让人挑哪条 conversation history
- 再进入同一类 formal restore 合同

所以更稳的第一句应该是：

- `/resume` 与 generic `--continue` 的默认 source 是 conversation history

而不是：

- 广义上所有“接续能力”的并列表达

## 第二层：`print --continue` 仍站在 stable conversation source 上，但 `print --resume` 已经开始混入条件来源

`print.ts` 的 `loadInitialMessages(...)` 很值钱，因为它把两个不同来源放在同一个 headless host 里：

### `options.continue`

- 直接 `loadConversationForResume(undefined, undefined)`
- 也就是继续最近那条 conversation history

这说明 `print --continue` 虽然宿主变成了 headless，

但 source 仍然是：

- stable conversation history

### `options.resume`

这里就完全不同了。

`print --resume` 不是单一 source，而是一个能消费多种 source 的 host：

1. 可以是显式 session id / `.jsonl`
2. 也可以在条件满足时先走：
   - `parseSessionIdentifier(...)`
   - `hydrateFromCCRv2InternalEvents(...)`
   - 或 `hydrateRemoteSession(...)`

然后才进入：

- `loadConversationForResume(...)`

所以 `print --resume` 的关键不是：

- “它也是 continue”

而是：

- 它是 headless host，既能吃 stable conversation source，也能在条件路径下吃 remote-hydrated transcript source

这也是为什么 163 到 168 必须一路把：

- parse
- hydrate
- metadata
- transport thickness

继续拆下去。

## 第三层：remote-hydrated transcript source 不是默认 stable source，而是 headless 条件补充路径

当 `print --resume` 进入：

- URL
- `CLAUDE_CODE_USE_CCR_V2`
- remote hydrate

这些分支时，当前 source 已经不再是：

- “直接从本地最近对话继续”

而是：

- 先把远端 transcript materialize 回本地
- 再用 formal restore 去读它

这条链回答的问题是：

- “当前 headless host 能不能借 remote / CCR 条件，把另一条 transcript source 先落地再恢复”

不是：

- “普通用户默认该怎样继续之前的对话”

所以这条 source 在写作层级上应该始终落在：

- 条件公开 / 内部实现更厚

不能和：

- `/resume`
- generic `--continue`

并列写成一个默认工作流。

## 第四层：`remote-control --continue` 继续的不是对话历史，而是 bridge pointer continuity

`bridgeMain.ts` 对这件事写得非常直接：

- `--continue: resolve the most recent session from the crash-recovery pointer`
- 然后 chain into `--session-id` flow

`bridgePointer.ts` 又继续把 source 写得很清楚：

- worktree-aware read for `--continue`
- 读取的是 pointer across worktrees
- 目的是 reconnect 到 right env / session

这说明 `claude remote-control --continue` 回答的问题根本不是：

- “这条 conversation history 要不要继续”

而是：

- “最近那条 bridge continuity pointer 还能不能把我带回原来的环境 / session 轨迹”

所以更准确的说法不是：

- 这是 generic `--continue` 的 remote 版本

而是：

- 这是 bridge host 专用的 pointer continuity resume

这也解释了为什么它会跟：

- spawn flags
- `--session-id`

共享一套 single-session / original environment 约束，

而不是共享 generic conversation resume 的语义。

## 第五层：因此 `continue` 这个名字相同，不等于 source 相同

把前面几层合起来，更稳的写法应该是：

### stable conversation source

- `/resume`
- generic `--continue`
- `print --continue`
- `print --resume <local session / jsonl>`

它们的主语仍然是：

- 继续 conversation history

### conditional remote-hydrated transcript source

- `print --resume` 的 URL / CCR / remote hydrate 分支

它的主语是：

- 先把 remote transcript 落地，再 formal restore

### bridge pointer continuity source

- `remote-control --continue`

它的主语是：

- 继续 bridge pointer / original environment continuity

所以更准确的结论不是：

- `continue` 都是同一个接续功能，只是宿主不同

而是：

- 名字可以相似，但接续来源本来就分成不同账本

## 第六层：这也是 stable-first 写法必须单列的原因

如果按 userbook 的稳定/条件写作纪律去落笔，这页最该守住的一句是：

- 先写 stable conversation resume
- 再写 headless remote hydrate
- 最后写 bridge continuity

因为：

- `/resume` 是稳定主线
- `--continue` 是稳定主线
- `claude -p/--print` 是稳定公开，但其中 URL / CCR hydrate 不是默认主线
- `/remote-control` 本身就是条件/隐藏面，`remote-control --continue` 更不该挤进默认接续路径

所以这页的真正目的不是增加一个新 taxonomy，

而是防止文档把：

- 默认 conversation resume

和：

- 条件 remote continuation

重新并列写成主线。

## 第七层：为什么这页不是 161、163、24 或 33 的附录

### 不是 161 的附录

161 讲的是：

- `--continue`
- startup picker
- 会内 `/resume`

为什么不是同一种入口宿主。

169 讲的已经不是入口宿主，而是：

- 它们继续的到底是哪一种 source

### 不是 163 的附录

163 讲的是：

- `print --resume` 内部的 parse / hydrate / restore stage

169 讲的是：

- `print --resume` 放在整个 continue 家族里时，为什么 source 不等于 generic conversation resume

### 不是 24 的附录

24 讲的是：

- bridge 的 auto / mirror / perpetual / resume 为什么不是同一种重连

169 不再讲 bridge 内部的 continuity model，

而是把：

- generic continue
- headless remote hydrate
- bridge pointer continue

并列成三类不同接续来源。

### 不是 33 的附录

33 讲的是：

- disconnect / teardown / pointer 的 closeout 轨迹

169 讲的是：

- 下一次从哪里回来，以及这个“回来”消费的到底是不是同一种 source

## 第八层：稳定、条件与灰度边界

### 稳定可见

- `/resume` 是稳定恢复旧会话入口。
- generic `--continue` 继续的是当前目录最近 conversation history。
- `print --continue` 也仍然站在同一种 conversation source 上。

### 条件公开

- `print --resume` 可以在条件路径下消费 remote-hydrated transcript source。
- SSH / remote forwarding 下的 `--continue` 也可能转而作用于 remote session history，而不是本地 history。

### 内部/灰度层

- `remote-control --continue` 属于 bridge continuity source，不应默认纳入普通用户稳定工作流。
- pointer 的跨 worktree 搜索、清理和 deterministic failure handling 属于 bridge host 的更厚实现合同。

## 苏格拉底式自审

### 问：为什么一定要把 `print --continue` 和 `print --resume` 分开？

答：因为同在 `print` host 里，不等于它们消耗的是同一类 source；一个可以直接站在 stable conversation history 上，另一个还能混入 remote-hydrated transcript source。

### 问：为什么一定要把 `remote-control --continue` 单独点名？

答：因为名字相同最容易误导读者把它写成 generic `--continue` 的别名，但它实际读的是 bridge pointer。

### 问：这页会不会重复 24 的 bridge continuity？

答：不会。24 比较的是 bridge continuity 的不同模式；169 比较的是 bridge continuity source 与 conversation resume source 根本不是同一种来源。

### 问：为什么这一页值得单独成文？

答：因为前几页已经把恢复“怎么做”拆得很细，但还缺“到底从哪本账继续”的用户层主语。这个主语如果不补，稳定路径和条件路径就会再次混写。
