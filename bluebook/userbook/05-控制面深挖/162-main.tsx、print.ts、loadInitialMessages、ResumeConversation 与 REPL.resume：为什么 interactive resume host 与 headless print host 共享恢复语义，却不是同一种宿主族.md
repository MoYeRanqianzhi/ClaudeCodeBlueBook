# `main.tsx`、`print.ts`、`loadInitialMessages`、`ResumeConversation` 与 `REPL.resume`：为什么 interactive resume host 与 headless print host 共享恢复语义，却不是同一种宿主族

## 用户目标

161 已经把：

- `--continue`
- startup picker
- 会内 `/resume`

拆成了三种不同 entry host。

但如果正文停在这里，读者还是很容易再把 interactive TUI 路径和 `print.ts` / headless 路径压成一句：

- “它们都能恢复旧会话，只是一个有界面，一个没界面。”

这句还不稳。

从当前源码看，这两边确实共享：

- `loadConversationForResume()`
- `restoreSessionStateFromLog()`
- `restoreSessionMetadata()`
- `switchSession()` 的一部分恢复语义

但它们并不共享：

- 宿主壳
- 恢复结果的消费方式
- 是否存在 live REPL / chooser / Ink root
- 后续执行循环是 REPL 交互，还是 `StructuredIO` / print pipeline

所以更准确的写法应该是：

- shared resume semantics

不等于：

- shared host family

## 第一性原理

比起直接问：

- “print 模式的 resume 不就是无 UI 版 REPL resume 吗？”

更稳的问法是先拆五个更底层的问题：

1. 当前恢复结果是交给 `<REPL />` 去消费，还是交给 `LoadInitialMessagesResult` / `StructuredIO` 去消费？
2. 当前路径有没有 Ink root、chooser、render loop，还是只是在 headless 管线里先准备好初始消息？
3. 当前宿主需要处理 live REPL 的 session 切换吗，还是只需要给后续 print query 提供初始状态？
4. 当前路径会不会进入 `launchRepl()`，还是只返回 `{ messages, turnInterruptionState, agentSetting }`？
5. 如果下游消费器不同，只因为恢复语义重合，就能把它们写成同一种宿主吗？

这五问不先拆开，interactive resume 和 print resume 很容易被误写成：

- “同一恢复器的两个皮肤”

而当前源码更接近：

- 两边共享恢复合同
- 但分别挂在 interactive host family 和 headless print host family 上

## 第一层：interactive TUI 路径的宿主终点是 `launchRepl()` / `<REPL />`

`main.tsx` 的 interactive 路径，不管是：

- `--continue`
- 已确定目标的 `--resume`
- startup picker

最后都会收敛到：

- `launchRepl(root, appProps, replProps, renderAndRun)`

`replLauncher.tsx` 又明确说明：

- 它会 import `App`
- import `REPL`
- 再 `renderAndRun(root, <App><REPL ... /></App>)`

所以 interactive resume host family 的核心宿主责任是：

- 把恢复结果挂进一个长期运行的 Ink / REPL 交互壳

它不是单纯“恢复完消息就结束”，而是：

- 恢复后继续进入 live terminal session

## 第二层：startup picker 仍然属于 interactive host family，因为它最终要切进 `<REPL />`

`launchResumeChooser()` 和 `ResumeConversation.tsx` 虽然不是直接 `launchRepl()`，

但它们的宿主族仍是 interactive。

原因很简单：

- `launchResumeChooser()` 用 `renderAndRun()` 挂 chooser UI
- `ResumeConversation` 在选中会话之后会把 `resumeData` 直接喂给 `<REPL />`

所以 startup picker 和 interactive 直达恢复的差异只是：

- 是否先挂 chooser host

不是：

- 是否属于 REPL host family

这点很关键，因为它说明 161 的三种入口虽然彼此不同，但仍都属于：

- interactive TUI resume hosts

## 第三层：`print.ts` 的宿主终点不是 `<REPL />`，而是 `LoadInitialMessagesResult`

`cli/print.ts` 的 resume 路径则完全不同。

这里不会：

- `launchRepl()`
- `renderAndRun()`
- `ResumeConversation`
- `REPL.resume()`

它的主入口是：

- `loadInitialMessages(...)`

这个函数在：

- `options.continue`
- `options.resume`

分支里，同样会做：

- `loadConversationForResume(...)`
- `switchSession(...)` 的一部分逻辑
- `restoreSessionStateFromLog(...)`
- `restoreSessionMetadata(...)`

但最后返回的是：

- `{ messages, turnInterruptionState, agentSetting }`

而不是：

- 一个 mounted REPL

这说明 print 路径的宿主责任是：

- 为 headless query / structured output 准备初始恢复状态

不是：

- 进入 live terminal session

## 第四层：`StructuredIO` 说明 print host 的后续循环根本不是 REPL 循环

`print.ts` 在 `loadInitialMessages(...)` 之后会继续进入：

- `getStructuredIO(...)`

这里返回的是：

- `StructuredIO`
- 或 `RemoteIO`

而不是任何 Ink / REPL 组件。

这意味着 print host 的恢复结果之后要喂给的是：

- headless IO protocol
- structured stream
- print mode query pipeline

所以 print resume 宿主在恢复完成后的下游问题是：

- “怎样把初始消息送进 headless execution pipeline”

interactive 宿主对应的问题则是：

- “怎样把初始消息送进 live REPL interaction loop”

这已经不是“有 UI / 没 UI”的差异，而是：

- downstream runtime family 的差异

## 第五层：interactive 路径里 `/resume` 还要处理 live session unwind，而 print 路径没有这个宿主责任

161 已经证明，会内 `/resume` 的 `REPL.resume()` 比 startup 路径多一层：

- `executeSessionEndHooks("resume", ...)`
- 清理 loading / abort controller
- 保存当前 session cost
- 然后才 `switchSession(...)`

这是因为 interactive live REPL 已经有一个正在运行的旧会话要退出。

而 `print.ts` 的 `loadInitialMessages(...)` 不存在这种宿主责任。

它没有一个正在运行的 interactive REPL 要收尾，

因此它只需要：

- 准备恢复结果
- 回传初始消息和中断状态

所以即使两边共享一部分恢复步骤，

它们面对的宿主前提仍然不同：

- one has live interactive state to unwind
- one does not

## 第六层：`processResumedConversation()` 与 `loadInitialMessages()` 说明两边共享恢复合同，但不是同一入口族

把两边放在一起会更清楚。

### interactive startup host

- `main.tsx`
- `loadConversationForResume(...)`
- `processResumedConversation(...)`
- `launchRepl(...)`

### interactive live host

- `resume.tsx`
- `ResumeCommand`
- `context.resume`
- `REPL.resume()`

### headless print host

- `print.ts`
- `loadInitialMessages(...)`
- `loadConversationForResume(...)`
- `restoreSessionStateFromLog(...)`
- 返回 `LoadInitialMessagesResult`
- 再进入 `StructuredIO`

所以共享的是：

- formal restore semantics

不共享的是：

- host family

这页最重要的结论就是这一句。

## 第七层：因此 resume 至少要先分 interactive host family 和 headless print host family

更稳的写法应该是：

### interactive TUI resume hosts

- startup direct restore
- startup chooser
- live `/resume`
- 共同目标是进入或重写 `<REPL />`

### headless print resume hosts

- `print.ts` 的 `--continue`
- `print.ts` 的 `--resume`
- 共同目标是生成 `LoadInitialMessagesResult` 并喂给 `StructuredIO`

所以更准确的结论不是：

- print resume 是无 UI 版 interactive resume

而是：

- print resume 是另一种宿主族里对同一恢复合同的消费

## 苏格拉底式自审

### 问：为什么这页不是 161 的附录？

答：因为 161 还完全停留在 interactive TUI 宿主内部。

162 是第一次明确把 interactive 宿主族和 headless print 宿主族分开。

### 问：为什么一定要写 `StructuredIO`？

答：因为这能直接暴露 print resume 的下游消费者不是 REPL，而是 protocol pipeline。

### 问：为什么一定要写 `loadInitialMessages()`？

答：因为它是 print host 的真正恢复宿主，不把它写出来，print resume 很容易被误画成 `main.tsx` 里的另一个 `launchRepl()` 分支。

### 问：为什么一定要避开 `remote-control --continue`？

答：因为那会把这页重新写回 CLI 根入口或 remote host taxonomy，稀释掉“interactive vs print host family”这个主轴。

## 边界收束

这页只回答：

- 为什么 interactive TUI resume host 与 `print.ts` / headless print host 共享恢复语义，却不是同一种宿主族

它不重复：

- 155 的 helper host family
- 161 的 interactive entry host segmentation
- 160 的 payload taxonomy
- CLI 根入口总论或 remote-control host 体系

更稳的连续写法应该是：

- 同一恢复合同不等于同一种入口宿主
- 同一入口宿主也不等于同一种宿主族
