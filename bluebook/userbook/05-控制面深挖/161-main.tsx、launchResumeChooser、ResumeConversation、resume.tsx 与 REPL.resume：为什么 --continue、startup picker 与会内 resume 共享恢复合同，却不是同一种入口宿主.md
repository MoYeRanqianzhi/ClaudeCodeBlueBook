# `main.tsx`、`launchResumeChooser`、`ResumeConversation`、`resume.tsx` 与 `REPL.resume`：为什么 `--continue`、startup picker 与会内 `resume` 共享恢复合同，却不是同一种入口宿主

## 用户目标

160 已经把：

- transcript
- plan
- file-history
- resume hooks

拆成了四种不同 payload。

但如果正文停在这里，读者还是很容易把三种入口压成一句：

- “反正最后都是恢复旧会话，所以 `--continue`、启动 picker 和会内 `/resume` 本质上是同一个入口。”

这句并不稳。

从当前源码看，这三条路径确实共享：

- `loadConversationForResume()`
- `processResumedConversation()` 或 `REPL.resume()`
- 最终进入 REPL 的恢复语义

但它们并不共享：

- 入口宿主
- 当前是否已有 REPL
- 谁负责选择会话
- 谁负责退出当前会话、切换到新会话

所以更准确的写法应该是：

- shared restore contract

不等于：

- shared entry host

## 第一性原理

比起直接问：

- “它们不都是 resume 吗？”

更稳的问法是先拆五个更底层的问题：

1. 当前路径发生时，REPL 是还没创建，还是已经在运行？
2. 当前路径需要先挑一条会话，还是已经确定目标 session？
3. 当前恢复逻辑是在主启动流程里跑完后再进 REPL，还是在现有 REPL 里原地切换？
4. 当前宿主要不要自己管理 chooser 生命周期，还是只把控制权交给一个 command callback？
5. 如果三个入口的宿主责任完全不同，仅仅因为最后都能恢复成功，就能把它们写成同一种入口吗？

这五问不先拆开，三种 resume 很容易被误写成：

- “三个按钮通向同一页”

而当前源码更接近：

- 它们通向相近的恢复合同
- 但站在三个不同宿主时机上

## 第一层：`--continue` 是启动期直达恢复宿主，不需要 chooser

`main.tsx` 的 `options.continue` 分支是最“直达”的一条。

它会在主启动流程里直接做：

- `clearSessionCaches()`
- `loadConversationForResume(undefined, undefined)`
- `processResumedConversation(result, ...)`
- `launchRepl(...)`

这条路径回答的问题是：

- “启动时直接继续最近一条会话，不需要用户再挑”

所以它的宿主责任是：

- 启动期 pre-REPL 恢复
- 恢复完成后再挂 REPL

它不是：

- chooser host

也不是：

- in-REPL command host

所以 `--continue` 的主语不是“打开一个恢复器”，而更像：

- startup direct restore host

## 第二层：启动 picker 是 startup chooser host，不是直达恢复宿主

`main.tsx` 在：

- `options.resume` 但还没有唯一目标 session
- 或者只是拿到一个 search term

时，不会直接恢复，而是走：

- `launchResumeChooser(...)`

`dialogLaunchers.tsx` 明确写着：

- `launchResumeChooser` 用的是 `renderAndRun`
- 它挂载 `<App><KeybindingSetup><ResumeConversation ... /></App>`

这说明 startup picker 的宿主责任是：

- 在 startup 阶段先跑一个交互选择壳
- 让用户在 chooser 里挑中目标后，再继续恢复

`ResumeConversation.tsx` 本身又会负责：

- 加载 logs
- 处理筛选
- `loadConversationForResume(log, undefined)`
- 然后在组件内部切进 `<REPL />`

所以 startup picker 和 `--continue` 的区别不是“恢复真假”，而是：

- `--continue` 在进入 REPL 前就已确定目标
- startup picker 需要先挂一个 chooser host 再决定目标

## 第三层：会内 `/resume` 是 live REPL command host，不是 startup host

`resume.tsx` 的 `call()` 路径又是第三种宿主。

这里系统已经有一个活着的 REPL，所以它做的不是：

- 在主启动流程里构造新的 REPL 壳

而是：

- 以 `LocalJSXCommandCall` 的身份，在当前 REPL 里弹出 `ResumeCommand`

`ResumeCommand` 会：

- 读取 logs
- 渲染 `<LogSelector ... />`
- 通过 `onResume(sessionId, log, entrypoint)` 把控制权交回 `context.resume`

而 `context.resume` 的实际实现是在：

- `REPL.resume`

也就是说，会内 `/resume` 的宿主责任是：

- 在一个已经存在的 live REPL 里原地完成 chooser / restore 切换

这和 startup 的两种路径都不同，因为它不是：

- 先恢复再 mount REPL

而是：

- 在现有 REPL 内部重写当前会话

## 第四层：`REPL.resume()` 比 `processResumedConversation()` 多了一层“退出当前活会话”的宿主责任

这条分水岭是这页最关键的部分。

`main.tsx` 的 startup 直达恢复和 startup picker，最终都会在 REPL 创建前用：

- `processResumedConversation(...)`

因为那时还没有一个正在跑的会话要收尾。

但会内 `/resume` 不一样。

`REPL.resume()` 在真正恢复前，还得额外处理：

- `executeSessionEndHooks("resume", ...)`
- 清理当前 loading / abort controller
- 保存当前 session 的 cost
- 再 `switchSession(...)`

也就是说，会内 `/resume` 的宿主首先要回答：

- “我怎么从一个活着的旧会话安全切到另一个会话”

而 startup 路径只需要回答：

- “我在进入 REPL 前如何准备好初始恢复状态”

所以这两者共享恢复合同，但不共享宿主责任。

## 第五层：三条路径最终都收敛到 REPL，但收敛方式不同

把这三条链放在一起，差异会非常清楚。

### `--continue`

- `main.tsx`
- `loadConversationForResume(undefined, ...)`
- `processResumedConversation(...)`
- `launchRepl(...)`

### startup picker

- `main.tsx`
- `launchResumeChooser(...)`
- `ResumeConversation`
- `loadConversationForResume(log, ...)`
- 组件内部切到 `<REPL />`

### 会内 `/resume`

- `resume.tsx`
- `ResumeCommand`
- `context.resume`
- `REPL.resume()`
- 在 live REPL 内部完成切换

三条路径最后都能落到：

- restored REPL state

但三者对应的宿主问题分别是：

- 启动直达
- 启动选择
- 会内切换

这已经不是同一种入口。

## 第六层：155 已经讲过 host family，但这一页讲的是 resume host role

155 已经证明：

- `showSetupDialog`
- `renderAndRun`

不是同一种 interactive host。

但这页的主语不是再重复：

- “它们底层用哪个 helper”

而是更窄地回答：

- 为什么同样都是 resume，`--continue`、startup picker、会内 `/resume` 却分属三种不同入口宿主角色

也就是说：

- 155 讲 host family
- 161 讲 resume host role

如果把这两页混起来写，读者会重新把：

- helper implementation choice
- resume lifecycle role

压成一层。

## 第七层：因此 resume 至少应拆成“三类入口宿主”

更稳的分类应该是：

1. startup direct restore host  
   `--continue` 或已确定目标的 CLI `--resume`
2. startup chooser host  
   `launchResumeChooser -> ResumeConversation`
3. live command host  
   会内 `/resume -> ResumeCommand -> REPL.resume`

所以更准确的结论不是：

- 三个入口只是不同 UI

而是：

- 三个入口站在不同生命周期位置上，负责不同宿主责任，但共享一部分恢复合同

## 苏格拉底式自审

### 问：为什么这页不是 155 的附录？

答：因为 155 的主语是 interactive helper family。

161 的主语是 resume lifecycle 里的入口宿主角色。

### 问：为什么这页不是 158 的附录？

答：因为 158 只讲 preview 与 formal restore 的边界。

161 继续往外拆的是：相同 formal restore 合同可以从哪些不同宿主进入。

### 问：为什么一定要写 `REPL.resume()`？

答：因为只有它能把会内 `/resume` 与 startup 路径的最大差异钉死：会内路径必须先处理“退出当前活会话”的责任。

### 问：为什么一定要写 `launchResumeChooser()`？

答：因为 startup picker 最大的特征就是“先挂 chooser host，再决定目标”，不把它写出来，startup picker 会被误压成 `--continue` 的视觉版。

## 边界收束

这页只回答：

- 为什么 `--continue`、startup picker 与会内 `resume` 共享恢复合同，却不是同一种入口宿主

它不重复：

- 155 的 host helper family
- 158 的 preview vs formal restore
- 160 的 payload taxonomy
- CLI 根入口总论或 `remote-control --continue` 的其他宿主族

更稳的连续写法应该是：

- preview 不是 restore
- restore 不等于 fork
- restore 自己内部不是同一种 payload
- 同一 restore 合同也不等于同一种入口宿主
