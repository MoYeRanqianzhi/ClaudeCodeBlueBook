# `loadMessagesFromJsonlPath`、`parseSessionIdentifier`、`loadConversationForResume` 与 `sessionId`：为什么 `print --resume .jsonl` 与 `print --resume session-id` 不是同一种 local artifact provenance

## 用户目标

169 已经把更宽的接续来源拆成：

- stable conversation resume
- headless remote hydrate
- bridge continuity

170 又把 `print` 这条 headless 分支内部继续拆成：

- implicit recent local
- explicit local artifact
- conditional remote materialization

但如果正文停在这里，读者还是很容易把 explicit local artifact 这一层继续写平：

- `print --resume <session-id>` 不是显式恢复本地 artifact 吗？
- `print --resume <file>.jsonl` 不也是显式恢复本地 artifact 吗？
- 既然最后都进 `loadConversationForResume(...)`，那差别是不是只剩一个给 ID、一个给文件路径？

这句还不稳。

从当前源码看，即使只留在 `print` / headless host 内部，

它也至少还分成两种不同的 local artifact provenance：

1. session-registry-backed local artifact
2. transcript-file-backed local artifact

如果这两种 provenance 不先拆开，后面就会把：

- `print --resume session-id`
- `print --resume .jsonl`

重新压成同一种 explicit local resume。

## 第一性原理

更稳的提问不是：

- “它们是不是都能在 print 模式下恢复本地内容？”

而是先问五个更底层的问题：

1. 当前 artifact 的 provenance 是当前项目的 session registry，还是某个显式 transcript 文件？
2. 当前 `sessionId` 来自用户给定的 ID，还是来自 `.jsonl` 文件中最后叶子的 embedded `sessionId`？
3. 当前 source certainty 来自“这个项目里就有这条 session”，还是“先把这个文件解析成一条 conversation chain”？
4. 当前 resume 的主语是“按 ID 找本地会话”，还是“按路径读取 transcript 并推断会话身份”？
5. 如果 artifact provenance、`sessionId` 来源和 chain-building 过程都不同，为什么还要把它们写成同一种 local artifact resume？

只要这五轴不先拆开，后面就会把：

- registry-backed local resume
- file-backed local resume

混成一句模糊的“显式恢复本地会话”。

## 第一层：`print --resume session-id` 先消费的是 session-registry-backed local artifact

`parseSessionIdentifier(...)` 遇到 plain UUID 时会直接返回：

- `sessionId = provided UUID`
- `jsonlFile = null`
- `isUrl = false`

随后 `print.ts` 会把它送进：

- `loadConversationForResume(parsedSessionId.sessionId, undefined)`

而 `conversationRecovery.ts` 在 `typeof source === 'string'` 分支里继续做的是：

- `getLastSessionLog(source as UUID)`

这说明 `print --resume <session-id>` 回答的问题不是：

- “这个文件路径能不能被解析成一段对话链”

而是：

- “当前项目的本地 session registry 里，这个显式 session id 对应的会话还能不能被正式恢复”

所以它的 provenance 来自：

- session-registry-backed local artifact

不是：

- transcript-file-backed local artifact

## 第二层：`print --resume .jsonl` 先消费的是 transcript-file-backed local artifact

`parseSessionIdentifier(...)` 遇到 `.jsonl` 路径时会先返回：

- 随机生成的 `sessionId`
- `jsonlFile = provided path`
- `isJsonlFile = true`

这里最值钱的一点是：

- 这个随机 `sessionId` 不是最终 provenance
- 它只是为了让 `print` 的统一 resume 载体先成立

随后 `loadConversationForResume(..., sourceJsonlFile)` 在 `sourceJsonlFile` 分支里做的是：

- `loadMessagesFromJsonlPath(sourceJsonlFile)`
- 读取 transcript file
- 找到 leaf tip
- `buildConversationChain(byUuid, tip)`
- 再从 `tip.sessionId` 推断真正的 `sessionId`

这说明 `.jsonl` 路径回答的问题不是：

- “registry 里有没有这条 session”

而是：

- “这个显式文件里能不能构出一条 conversation chain，并从其叶子推断会话身份”

所以它的 provenance 是：

- transcript-file-backed local artifact

## 第三层：两者虽然都汇入 `loadConversationForResume(...)`，但 upstream provenance 不同

这是最容易被写错的一层。

两条路径都能进入：

- `loadConversationForResume(...)`
- `deserializeMessagesWithInterruptDetection(...)`
- `processSessionStartHooks('resume')`

所以如果只看 downstream，

确实很容易得到一个错误结论：

- `session-id` 与 `.jsonl` 只是输入形状不同的同一个 explicit resume

但更准确的说法应该是：

- downstream formal restore contract 相同
- upstream local artifact provenance 不同

不共享的是：

- 谁在提供 authoritative local artifact
- `sessionId` 是怎么来的
- conversation 是怎么被拿到的

## 第四层：`.jsonl` 的 `sessionId` 还是从文件里推断出来的，不等于 CLI 参数本身

这里是二者差异最硬的证据。

`loadMessagesFromJsonlPath(...)` 在返回值里明确写：

- `sessionId: tip.sessionId`

而注释还专门强调：

- leaf's sessionId

这意味着 `.jsonl` 这条路径并不是：

- “CLI 参数里本来就给了 session id”

而是：

- CLI 只给了一个文件路径
- 真正的会话身份来自该文件内最后叶子消息携带的 sessionId

这和 plain UUID 路径是完全不同的 provenance。

所以更稳的写法不是：

- `.jsonl` 只是另一种写法的 session-id

而是：

- `.jsonl` 通过 transcript content 推断 session identity
- session-id 则直接以用户给定 UUID 作为 identity anchor

## 第五层：`.jsonl` 恢复出来的 payload 也更薄，不等于 log-backed session restore

这层差别更容易被忽略。

`loadConversationForResume(...)` 最终返回的：

- `fileHistorySnapshots`
- `contentReplacements`
- `contextCollapseSnapshot`
- `fullPath`

这些 sidecar 都来自：

- `log?.xxx`

也就是说，只有走 registry / log 路径时，

这些 log-backed sidecar 才天然更厚。

`.jsonl` 分支虽然能构出：

- messages
- turnInterruptionState
- `sessionId`

但它并不天然拥有同样厚度的 log-backed sidecars。

这也解释了为什么 `print.ts` 后面在复用 resumed session id 时，会看：

- `result.fullPath ? dirname(result.fullPath) : null`

`.jsonl` 这条路径的 provenance 更像：

- file-backed transcript reconstruction

不是：

- full log-backed session restore

所以更准确的结论不是：

- `.jsonl` 与 session-id 只是两种等价的显式本地输入

而是：

- 它们同属 explicit local branch，但 restore payload thickness 也不同

## 第六层：因此 explicit local branch 至少还要再分 provenance

把前面几层合起来，更稳的写法应该是：

### registry-backed explicit local resume

- `print --resume <session-id>`
- identity anchor = provided UUID
- artifact source = current project's session registry
- restore payload 更接近 full log-backed session

### file-backed explicit local resume

- `print --resume <file>.jsonl`
- identity anchor = transcript tip's embedded sessionId
- artifact source = explicit transcript file path
- restore payload 更接近 transcript reconstruction

所以更准确的结论不是：

- `.jsonl` 与 `session-id` 只是两种等价的显式本地输入

而是：

- 它们同属 explicit local branch，但 local artifact provenance 与 restore payload 厚度不同

## 第七层：为什么这页不是 163、169 或 170 的附录

### 不是 163 的附录

163 讲的是 `print --resume` 内部的：

- parse
- hydrate
- restore
- fallback

这些 stage 为什么不是同一步。

171 不再讲 stage，而讲：

- 同属 explicit local artifact，为什么 provenance 仍然不同

### 不是 169 的附录

169 讲的是更宽的 source family：

- conversation history
- remote-hydrated transcript
- bridge continuity

171 则继续留在 local-explicit family 内部，比较：

- session registry
- transcript file path

### 不是 170 的附录

170 讲的是 certainty：

- implicit recent
- explicit local
- remote materialization

171 则继续往 explicit local 这一层内部压缩 provenance，

所以层级又比 170 更窄。

## 第八层：稳定、条件与灰度边界

### 稳定可见

- `print --resume <session-id>`
- `print --resume <file>.jsonl`

这两条都属于普通用户可以理解和依赖的 explicit local artifact path。

### 条件公开

- 无。

### 内部/灰度层

- transcript tip 选取
- random UUID 作为 `.jsonl` parse 占位符的实现
- `loadTranscriptFile / buildConversationChain / leafUuids` 的细节

## 苏格拉底式自审

### 问：为什么一定要把 `loadMessagesFromJsonlPath(...)` 拉出来？

答：因为只有把这条函数拉出来，才能直接证明 `.jsonl` 不是 registry lookup，而是 transcript chain reconstruction。

### 问：为什么一定要点名 `.jsonl` 的 `sessionId` 来自 tip？

答：因为这正是它和 plain UUID 路径最硬的 provenance 差异。

### 问：为什么一定要写 sidecar thickness？

答：因为如果不把 `log?.fileHistorySnapshots / contentReplacements / fullPath` 这层写出来，读者仍会以为 `.jsonl` 与 session-id 恢复得到的是同厚度 payload。

### 问：这页会不会重复 170？

答：不会。170 讲 certainty；171 讲 explicit local artifact 里的 provenance 与 payload thickness。
