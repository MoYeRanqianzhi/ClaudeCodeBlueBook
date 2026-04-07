# `initialHistoryCap`、`isEligibleBridgeMessage`、`toSDKMessages` 与 `local_command`：为什么 bridge 的 eligible history replay 不是 model prompt authority

## 用户目标

181 已经把 bridge 继续拆成：

- session birth
- history hydrate

183 又把初始历史相关对象继续拆成：

- wire slot
- local dedup seed
- real delivery ledger

但如果正文停在这里，读者还是很容易把 initial flush 再写平：

- 既然 bridge 会在连上后把 `initialMessages` flush 出去，那不就是把聊天记录重新喂给模型吗？
- `initialHistoryCap` 既然会截断消息数，那不就是另一种 model context 裁剪吗？
- `isEligibleBridgeMessage(...)` 和 `toSDKMessages(...)` 不都只是在做“历史转发”吗？
- `replBridge.ts` 说 full history 是 UI-only，可 `local_command` 又能在别处进模型，这两句是不是矛盾？

这句还不稳。

从当前源码看，至少还要继续拆开三层不同对象：

1. bridge eligible history projection
2. remote UI consumer projection
3. model prompt authority

如果这三层不先拆开，后面就会把：

- `initialHistoryCap`
- `isEligibleBridgeMessage(...)`
- `toSDKMessages(...)`
- `local_command`

重新压成一句模糊的“历史 prompt replay”。

## 第一性原理

更稳的提问不是：

- “bridge 初始历史是不是把整段聊天重新发给模型？”

而是先问六个更底层的问题：

1. 当前路径在回答“remote bridge / web UI 应该看到什么”，还是“模型下一轮应该读到什么”？
2. 当前过滤的是 source `Message` 家族，还是最终 SDK / wire payload？
3. 当前 cap 控制的是 remote persistence 成本，还是 model token budget？
4. 某类 source message 能在别处进入模型，是否就代表它在 bridge replay 里也承担同一种 authority？
5. 当前分析的是 bridge continuity contract，还是 prompt compiler contract？
6. 如果同样都涉及历史消息，为什么系统还要把 replay projection 与 model prompt authority 分成两条链？

只要这六轴不先拆开，后面就会把：

- bridge history replay
- remote UI payload
- model-visible context

混成一张“历史回放表”。

## 第一层：`isEligibleBridgeMessage(...)` 先定义 bridgeable history family，不定义模型可见上下文

`bridgeMessaging.ts` 的注释写得很硬：

- server 只想要 user / assistant turns
- 以及 slash-command system events
- `tool_result`、progress 等都属于 internal REPL chatter

函数本体进一步把边界钉死为：

- `user`
- `assistant`
- `system.local_command`

同时排除：

- virtual `user` / `assistant`

这说明 `isEligibleBridgeMessage(...)` 回答的问题首先是：

- 哪些本地 `Message` 家族有资格进入 bridge 初始历史 replay

它不是在回答：

- 哪些消息最终会进入模型上下文

更准确地说：

- 它是 bridge projection gate
- 不是 prompt compiler gate

所以不能把它写成：

- “模型历史的第一道过滤器”

## 第二层：`toSDKMessages(...)` 又把 eligible history 再收窄成 remote consumer payload

即便消息已经通过 `isEligibleBridgeMessage(...)`，
也不等于它会原样进入 remote consumer。

`mappers.ts` 继续做了第二次收窄：

- `tool_use_result` 走 protobuf catchall，目的是让 web viewer 能读 structured output
- 但注释明确说这是 “without polluting model context”
- `system.local_command` 也不是全量导出
- 只有包含 stdout / stderr 的 command output 才会变成 SDK assistant message
- 纯 command-input metadata 不会泄到 RC web UI

这说明 `toSDKMessages(...)` 回答的问题不是：

- 哪些 source history 有资格被 bridge 看见

而是：

- 那些已经 eligible 的消息，最后要以什么 remote-consumer payload 形式被看见

所以更准确的理解不是：

- eligible replay = final remote payload

而是：

- eligible family
- 和 consumer projection

仍然是两层。

## 第三层：`initialHistoryCap` 限的是 UI-only history replay，不是 model token budget

`replBridge.ts` 对初始 flush 的注释非常关键：

- full history is UI-only
- model doesn't see it
- large replays 会带来 session-ingress persistence 变慢
- 每条 event 都是 threadstore write
- 还会抬高 Firestore pressure

随后代码才做：

- 先 `filter(isEligibleBridgeMessage)`
- 再按 `initialHistoryCap` 取尾部

这说明 `initialHistoryCap` 回答的问题首先是：

- remote UI continuity 这条 replay 最多要持久化多少 eligible history

它不是在回答：

- 模型上下文这轮最多保留多少 token / message

更准确地说：

- 这是 remote persistence / UI replay budget
- 不是 model prompt budget

所以如果把 `initialHistoryCap` 写成：

- “另一种上下文裁剪”

就已经越界了。

更硬的一层证据是：

- `QueryEngine` 仍然把本地 `messages` 送进 `query({ messages, ... })`
- `services/api/claude.ts` 仍然对这条本地消息链执行 `normalizeMessagesForAPI(messages, filteredTools)`

也就是说，bridge 初始历史的 capped replay，
并不会改写模型那条正常的 prompt assembly 输入。

## 第四层：`local_command` 在 bridge replay 里是 UI output 片段，在 prompt compiler 里却可能是用户消息来源

这里最容易产生假矛盾。

一边，`mappers.ts` 明确说：

- `local_command` 只有 stdout / stderr output 才能进 RC UI

另一边，`utils/messages.ts` 在 prompt 组装时又明确说：

- local_command system messages need to be included as user messages
- so the model can reference previous command output in later turns

这两句并不冲突。

它们只是分别回答两条不同问题：

1. bridge replay 给 remote UI 看什么
2. prompt assembly 给模型喂什么

所以更准确的结论不是：

- `local_command` 要么永远 UI-only，要么永远 model-visible

而是：

- 同一 source family
- 可以在不同 pipeline 里承担不同角色

这恰好证明：

- bridge replay 不是 model prompt authority

## 第五层：v1 / v2 都共享 eligible-then-cap 形态，但这页的稳定面不是 dedup 差异

`remoteBridgeCore.ts` 的 v2 `flushHistory(...)` 也重复了同样的骨架：

- `msgs.filter(isEligibleBridgeMessage)`
- 再按 `initialHistoryCap` 取尾部
- 再 `toSDKMessages(...)`

这说明这页真正要保护的稳定不变量是：

- eligible history projection
- 再进入 capped remote replay

而不是：

- 某一版 transport 的 dedup 实现细节

当然，v1 会再看 `previouslyFlushedUUIDs`，
v2 不会。

但那条差异更适合留在：

- history hydrate / delivery ledger 页面

不该反客为主吞掉本页的核心句子。

## 第六层：因此 bridge initial flush 更像 remote UI continuity projection，不是 prompt replay

到这里更稳的写法已经不是：

- bridge 会把历史回放给远端

而应该明确拆成：

1. `isEligibleBridgeMessage(...)`
   决定哪些 source family 可进入 bridge replay
2. `toSDKMessages(...)`
   决定 remote consumer 最终看到什么 payload
3. `initialHistoryCap`
   决定这条 UI-only replay 最多持久化多少 eligible history
4. `utils/messages.ts` prompt assembly
   另行决定哪些 source message 会变成模型上下文

所以更准确的结论不是：

- bridge initial flush = history prompt replay

而是：

- bridge initial flush = capped eligible remote UI projection

## 第七层：为什么这页不是 181、183 或 115 的附录

181 讲的是：

- session birth
- history hydrate

183 讲的是：

- local seed
- real delivery ledger

115 讲的是：

- UI consumer policy

186 这一页更窄地关心的是：

- bridge replay 为什么在对象层上不等于 model prompt authority

所以三页虽然共享：

- `initialMessages`
- `toSDKMessages(...)`
- `local_command`

但主语不同：

- 181 问 create vs hydrate
- 183 问 seed vs delivery ledger
- 186 问 eligible replay vs prompt authority

## 稳定面与灰度面

本页只保护稳定不变量：

- bridge initial flush 是 UI-only replay projection
- `isEligibleBridgeMessage(...)` 与 `toSDKMessages(...)` 不是同一层过滤
- `initialHistoryCap` 控的是 replay persistence budget，不是 prompt budget
- `local_command` 的 bridge 角色与 prompt 角色分属不同 pipeline

本页刻意不展开的灰度层包括：

- `initialHistoryCap` 的具体 flag 值
- Firestore / threadstore 调参细节
- v1 / v2 的所有 dedup 与 reconnect 实现
- `tool_result` 的完整 viewer policy 族谱

这些都相关，但不属于本页的单句主张。

## 苏格拉底式自审

### 问：为什么一定要把 `utils/messages.ts` 也拉进来？

答：因为如果没有 prompt assembly 的对照，读者会把 “model doesn't see it” 误听成 source message 永远不可能进入模型，而不是当前 bridge replay pipeline 不承担那条 authority。

### 问：为什么 `toSDKMessages(...)` 不能被并进 `isEligibleBridgeMessage(...)` 一起写？

答：因为前者在回答 remote consumer payload 形式，后者在回答 source family admission。两层压成一层，就又会把 eligibility boundary 和 consumer projection 混成同一张表。

### 问：为什么这页不再重讲 `previouslyFlushedUUIDs`？

答：因为那会把这页重新拖回 183 的 delivery ledger 主语，读者又会看不到真正新增的句子：bridge replay 的对象根本不是 prompt authority。
