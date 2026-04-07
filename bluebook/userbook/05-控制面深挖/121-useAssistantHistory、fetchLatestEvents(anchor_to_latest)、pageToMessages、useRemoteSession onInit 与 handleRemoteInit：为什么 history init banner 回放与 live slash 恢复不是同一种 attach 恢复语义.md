# `useAssistantHistory`、`fetchLatestEvents(anchor_to_latest)`、`pageToMessages`、`useRemoteSession onInit` 与 `handleRemoteInit`：为什么 history init banner 回放与 live slash 恢复不是同一种 attach 恢复语义

## 用户目标

120 已经把 init 拆成了不同厚度：

- full payload
- bridge redacted payload
- internal hidden thickness
- transcript model-only banner

但继续往下读时，读者又很容易把另一组相邻概念压成一句：

- attach 时 history latest page 里会带回 `system.init`
- `pageToMessages(...)` 会把它转成一条 init banner
- live 远端流里又会收到 `system.init`
- `onInit(slash_commands)` 还会更新本地命令可见集

于是正文就会滑成一句看起来很顺、其实错误的话：

- “viewer attach 时，history replay 里的 init banner 基本就等于把 live 初始化状态恢复了一遍。”

从当前源码看，这也不成立。

这里至少有两种不同恢复语义：

1. transcript-visible 的 init banner replay
2. command/bootstrap-level 的 live init restore

它们都与 attach 恢复有关，但不是同一种 attach 恢复语义。

## 第一性原理

更稳的提问不是：

- “attach 后是不是看到了 init？”

而是先问五个更底层的问题：

1. 当前恢复的是 transcript 文本，还是本地可交互能力面？
2. 当前消费的是 history page 里的 replayed event，还是 live raw sdkMessage？
3. 当前路径有没有执行 callback side effect，还是只做 message 物化？
4. 当前恢复的是一条提示文案，还是一组 `slash_commands` 对本地 command set 的约束？
5. 当前 attach 之后看到的“初始化痕迹”，是 source-blind banner，还是 live bootstrap effect？

只要这五轴先拆开，下面几件事就不会再被写成同一条 attach restore。

## 第一层：history attach 先恢复的是 transcript message，不是 command bootstrap

`useAssistantHistory.ts` 的职责很清楚：

- 只在 `viewerOnly` 下启用
- mount 时 `fetchLatestEvents(anchor_to_latest)`
- 把 page 经过 `pageToMessages(page)`
- 然后 `prepend(page, true)` 到 transcript 前部

`pageToMessages(page)` 又只是：

- 遍历 `page.events`
- `convertSDKMessage(ev, { convertUserTextMessages: true, convertToolResults: true })`
- 如果 `c.type === 'message'` 就 push

这意味着 history attach 路径回答的是：

- “把历史事件物化成当前 transcript 要显示的 Message[]”

不是：

- “重跑 live init 的 callback 副作用”

所以 attach 恢复的第一层主语其实是：

- transcript replay restore

不是：

- full interactive bootstrap restore

## 第二层：`system.init` 进 history path 后只会变成 banner

`convertSDKMessage(...)` 对 `system/init` 的规则很稳定：

- `{ type: 'message', message: convertInitMessage(msg) }`

而 `convertInitMessage(...)` 本身只会生成一句：

- `Remote session initialized (model: ${msg.model})`

这就意味着，当 history latest page 里包含 `system.init` 时，attach 后恢复出来的是：

- 一条 transcript-visible init banner

不是：

- 原始 `slash_commands`
- 也不是任何本地 command set mutation

换句话说：

- history 路径只能恢复 banner footprint

不能自动恢复：

- live init bootstrap effect

## 第三层：live `useRemoteSession` 在 raw init 上直接做 `onInit(slash_commands)`

和 history 路径形成鲜明对照的是 `useRemoteSession.ts`。

它在收到 raw `sdkMessage` 时，会先检查：

- `sdkMessage.type === 'system'`
- `sdkMessage.subtype === 'init'`
- `onInit` 存在

然后立刻：

- `onInit(sdkMessage.slash_commands)`

注意这一步发生在：

- adapter 转换之前
- `setMessages(...converted.message)` 之前

所以 live `system.init` 的一个关键主语是：

- raw init bootstrap consumer

而不是：

- transcript message replay

这和 history path 的 `pageToMessages(...)` 逻辑完全不同。

## 第四层：`handleRemoteInit` 真正恢复的是本地 command surface，不是 banner

REPL 里 `handleRemoteInit` 的实现非常具体：

- 把 `remoteSlashCommands` 变成 `Set`
- `setLocalCommands(prev => prev.filter(...))`
- 只保留 CCR 列出的命令，或 `REMOTE_SAFE_COMMANDS`

同时 `useRemoteSession({... onInit: handleRemoteInit ...})` 把这条 callback 接进 live remote session。

所以 live init 真正恢复的不是：

- “用户看到了初始化成功”

而是：

- 当前本地命令可见集被远端可调用命令面重新约束了一次

这和 history replay 回放出一条 init banner 完全不是一回事。

banner 只改变 transcript。

`handleRemoteInit(...)` 改的是：

- local command surface

所以更准确的写法应是：

- transcript restore
- command-surface restore

至少是两层不同的 attach 语义。

## 第五层：history 路径没有接 `onInit`，正是两种语义分离的硬证据

`REPL.tsx` 里：

- `useAssistantHistory({ config: remoteSessionConfig, setMessages, ... })`
- `useRemoteSession({ config: remoteSessionConfig, setMessages, onInit: handleRemoteInit, ... })`

这两个 hook 都共享：

- `setMessages`

但只有 live remote session 这一路：

- 接了 `onInit: handleRemoteInit`

history hook 则没有任何对应参数，也没有任何“把 replayed init 再喂给 onInit”的动作。

这说明当前架构的设计就是：

- history attach 恢复 transcript
- live init 恢复 bootstrap side effect

二者故意分开。

如果正文把它们写成同一种“attach 恢复”，就会把这一层设计意图压没。

## 第六层：所以 attach 之后“看见 init”不等于“恢复了初始化能力面”

把前面几层压实后，一个常见错觉就很好拆了。

attach 后用户可能看到：

- transcript 里出现 `Remote session initialized (model: ...)`

但这不自动意味着：

- 本地 slash commands 已按远端能力重算

因为后者只在：

- live raw init -> `onInit(slash_commands)` -> `handleRemoteInit(...)`

这条链上发生。

而 history replay 自身只会：

- `pageToMessages(...)`
- `prepend(...)`

它不会把 history page 中的 init 重新解释成 bootstrap callback。

所以这页真正要钉死的一句是：

- init banner replay != slash restore

## 第七层：这也解释了为什么 init/banner 重复不能直接当作 bootstrap 重复

118 已经把 replay duplication 拆成了不同来源问题。

到 121 这里，还要再加一句：

- history banner 重复

和：

- live `onInit(...)` 是否再次触发

也不是同一个问题。

即使 attach 时因为 latest page + live stream overlap，用户可能看到：

- 两条看起来相似的 init banner

也不能直接推出：

- `handleRemoteInit(...)` 就重复执行了两次

因为：

- banner 走 adapter -> transcript
- bootstrap 走 raw init -> onInit callback

source 和 path 都不同。

## 第八层：当前源码能稳定证明什么，不能稳定证明什么

从当前源码可以稳定证明的是：

- history attach 当前会把 latest page replay 成 transcript message
- init 在 history path 上会被压成 banner
- live remote session 当前会直接用 raw init 触发 `onInit(slash_commands)`
- `handleRemoteInit(...)` 的作用是收窄本地 commands 可见集
- history hook 本身没有 `onInit` 入口

从当前源码不能在这页稳定证明的是：

- history replay 是否永远不该补跑任何 bootstrap side effect
- attach 时 live init 是否一定还会再到一次
- 如果未来给 history 路径加 metadata hydration，会不会改变当前结论

所以这页最稳的结论必须停在：

- same init trace != same attach restore semantics

而不能滑到：

- attach fully restores the same init side effects as live connect

## 第九层：为什么 121 不能并回 120

120 的主语是：

- init 在 full payload、bridge redaction、banner collapse 三种厚度下不是同一层

121 的主语则已经换成：

- attach 时 history replay 出来的 banner，与 live raw init 触发的 bootstrap side effect 不是同一种恢复语义

120 讲：

- payload thickness

121 讲：

- restore semantics

不是一页。

## 第十层：为什么 121 也不能并回 118

118 的主语是：

- replay dedup surfaces

121 虽然也碰到 history/live 两条来源，但这里真正要讲的不是：

- 重不重复

而是：

- 即使都叫 init，它们分别恢复了什么

一个讲：

- provenance and dedup

一个讲：

- restore side effects

同样不该揉成一页。

## 第十一层：最常见的假等式

### 误判一：history replay 里出现 init banner，就说明 attach 已经把远端初始化恢复好了

错在漏掉：

- banner 只是一条 transcript message

### 误判二：`pageToMessages(...)` 和 live `onInit(...)` 都消费 init，所以作用相同

错在漏掉：

- 一个消费 adapter message
- 一个消费 raw init metadata

### 误判三：既然两条 hook 都共用 `setMessages`，那 attach 和 live restore 差别不大

错在漏掉：

- 只有 live hook 接了 `onInit`

### 误判四：init banner 重复，就等于 bootstrap callback 也重复

错在漏掉：

- transcript path 和 bootstrap path 是分开的

### 误判五：`handleRemoteInit` 只是显示层的小修小补

错在漏掉：

- 它直接重算了本地命令可见集

## 第十二层：苏格拉底式自审

### 问：我现在写的是 transcript restore，还是 command-surface restore？

答：如果答不出来，就说明又把 attach 恢复语义写平了。

### 问：我是不是把 init banner 写成了 init side effect？

答：如果是，就没把 message consumer 和 raw callback consumer 分开。

### 问：我是不是把 history hook 也默认成会触发 `onInit`？

答：如果是，就回到 REPL 的 hook wiring 看一眼。

### 问：我是不是把重复 banner 直接写成 bootstrap 重复？

答：如果是，就混淆了 replay provenance 和 restore semantics。
