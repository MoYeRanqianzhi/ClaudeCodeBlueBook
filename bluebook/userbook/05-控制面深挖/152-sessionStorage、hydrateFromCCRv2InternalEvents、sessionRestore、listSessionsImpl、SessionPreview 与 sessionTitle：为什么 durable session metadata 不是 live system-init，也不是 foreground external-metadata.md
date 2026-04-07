# `sessionStorage`、`hydrateFromCCRv2InternalEvents`、`sessionRestore`、`listSessionsImpl`、`SessionPreview` 与 `sessionTitle`：为什么 durable session metadata 不是 live `system/init`，也不是 foreground `external_metadata`

## 用户目标

117 已经把：

- callback-visible init
- transcript init 提示
- slash bootstrap

拆成不同的初始化可见性。

120 又把：

- full init payload
- bridge redacted init
- model-only banner

拆成不同的 payload thickness。

133 继续说明：

- schema/store 里有账

不等于：

- 当前 CLI 前台已经消费

但如果停在这里，正文还会留下另一种常见误写：

- “既然 `system/init`、`external_metadata`、resume/history 都叫 metadata，那它们本质还是同一张 metadata 表，只是不同前台读得多或少。”

这句也不稳。

这轮要补的不是：

- “metadata 又多了哪些字段”

而是：

- “为什么 `system/init` 负责启动时公开什么，`external_metadata` 负责当前运行态在说什么，而 transcript/sessionStorage 尾部那套 durable metadata 负责 EOF、history、resume 之后还要被谁读回来”

## 第一性原理

比起直接问：

- “这些 metadata 到底谁最真？”

更稳的提问是先拆五个更底层的问题：

1. 当前 metadata 是启动时广播、运行时镜像，还是 durable ledger？
2. 当前 consumer 读的是前台 live state，还是 transcript 尾部可回放信息？
3. 当前字段是为了“现在显示”，还是为了“下次还能读到”？
4. 当前写入是否会在 EOF、compaction、resume 时被重新盖到尾部？
5. 如果某字段前台根本没消费，但 `listSessionsImpl` / `SessionPreview` / `resume` 仍会读它，它还能被写成前台 metadata 吗？

这五问不先拆开，后面很容易把：

- `system/init`
- `external_metadata`
- transcript 尾部 metadata

重新压回成一张表。

## 第一层：`system/init` 先回答“这一轮启动时愿意公开什么”

`system/init` 的主语在 117 和 120 已经拆得很清楚。

它回答的是：

- 当前会话启动时对 consumer 公开哪些 session metadata / capability metadata

比如：

- `cwd`
- `session_id`
- `model`
- `permissionMode`
- `slash_commands`

但这层 metadata 并不回答：

- 这些字段会不会在 EOF 之后继续被 transcript 尾部保全
- `--resume` / history / preview 下次会从哪里把它们读回来

所以更稳的写法应是：

- `system/init` 是 live startup publish ledger

不是：

- durable session ledger

## 第二层：`external_metadata` 回答的是“当前运行态在说什么”

`sessionState.ts` 里的 `SessionExternalMetadata` 也很清楚。

这里的对象包括：

- `permission_mode`
- `is_ultraplan_mode`
- `model`
- `pending_action`
- `post_turn_summary`
- `task_summary`

而 `notifySessionStateChanged(...)` / `notifySessionMetadataChanged(...)` 的主语同样很窄：

- 当前 authoritative runtime writer 把 live session state 镜像到 `external_metadata`

它回答的是：

- 当前 blocked on 什么
- 当前 mid-turn summary 是什么
- 当前 permission/model 等运行态是什么

它不回答：

- transcript EOF 要不要重写这些字段
- `listSessionsImpl` / `SessionPreview` 会不会拿这套 live metadata 来列表化或预览

所以 `external_metadata` 更像：

- foreground / live runtime ledger

不是：

- durable session ledger

## 第三层：`sessionStorage` 的 durable metadata 关心的是“EOF 之后还能不能被 tail 读回”

真正不同的一张账，在 `sessionStorage.ts` 里写得很明确。

这里 `Project` 缓存的对象包括：

- `currentSessionTitle`
- `currentSessionTag`
- `currentSessionAgentName`
- `currentSessionAgentColor`
- `currentSessionLastPrompt`
- `currentSessionAgentSetting`
- `currentSessionMode`
- `currentSessionWorktree`
- PR 元数据

这组对象的特点不是：

- 当前前台正拿它们渲染什么

而是：

- 它们要在 transcript 尾部 stay within tail window

`reAppendSessionMetadata()` 的注释把这点写得非常直白：

- metadata 要被 re-append 到 EOF
- 这样 progressive loading / `readLiteMetadata` 才能继续在尾部窗口里读到它
- 否则 `--resume` 会回退到 first prompt 或旧 summary

所以这里的第一性原理已经完全变了：

- 不是 live metadata visibility
- 而是 durable audit envelope 保全

## 第四层：EOF / compaction 的 re-append 不是重复写，而是 durable ledger 的保全机制

如果不把这一层单独拆出来，最容易把 `reAppendSessionMetadata()` 误写成：

- “同样的 metadata 又多写一次”

当前源码不支持这种轻写法。

注释已经明确分了两个上下文：

1. compaction 前重写 metadata
2. session exit 时在 EOF 再写一次

这样做的目的不是：

- 多一个副本看起来保险些

而是：

- 让 tail-window consumer 永远还能在靠近 EOF 的位置读到会话元数据

这和前台 consumer 是不同的问题。

更直接地说：

- `system/init` 被 callback / transcript / slash bootstrap 消费
- `external_metadata` 被 foreground runtime writer 推送
- durable session metadata 则被 EOF / compaction 重新压到 transcript 尾部，保证后读消费者还能读到

## 第五层：resume 恢复读的是 durable ledger，不是当时前台是否已经消费过

`sessionRestore.ts` 里的 `restoreSessionMetadata(...)` 又把这层合同钉死了一遍。

这里在 resume / continue 路径上会：

- `switchSession(...)`
- `restoreSessionMetadata(...)`
- `adoptResumedSessionFile()`

注释明确说：

- metadata 需要恢复到 in-memory cache
- `/status` 等 display 要能看到
- session exit 时还要继续 re-append

这说明 resume 的主语不是：

- “把前台当时已经渲染过的东西再放一遍”

而是：

- “把 transcript durable ledger 重新 hydrate 成本地 cache，并确保之后还能继续写回”

换句话说：

- 能在 resume 后恢复看到

不等于：

- 当时 foreground 一定已经消费过

## 第六层：history / session list / preview 这些 consumer 更依赖 durable metadata，而不是 live runtime metadata

`listSessionsImpl.ts` 把 durable ledger 的 consumer 面暴露得非常明显。

`parseSessionInfoFromLite(...)` 读的不是：

- `external_metadata.pending_action`
- 实时 `system/init` object

它读的是：

- `customTitle`
- `aiTitle`
- `lastPrompt`
- `summary`
- `gitBranch`
- `tag`
- `cwd`

而且它是从：

- head / tail / stat

这种 lite session read 里抽字段。

这说明 session list 的第一性原理是：

- 尾部窗口里还能不能抽出稳定 durable metadata

不是：

- 现在 foreground live state 是否完整

`SessionPreview.tsx` 也一样。

它先：

- `loadFullLog(log)`
- `getSessionIdFromLog(displayLog)`

再去做 transcript 预览。

这依赖的是：

- durable log / transcript ledger

不是：

- 当前 live `external_metadata`

## 第七层：`sessionTitle` 是单独的 durable/title writer，不等于 init banner 或 runtime projection

`sessionTitle.ts` 又补了一层容易被误写的错位。

这里它是：

- AI-generated session title 的单一真源

但这个模块回答的是：

- 标题怎么生成

而 durable ledger 里回答的是：

- 标题怎么缓存
- 何时 materialize
- 何时被 re-append 到 transcript EOF

所以就连 “title” 这一个对象，也至少分成两层：

1. title generation
2. durable title persistence

它们都不是：

- `system/init`
- `external_metadata`

## 稳定面与灰度面

### 稳定面

- `system/init` 是启动时公开账
- `external_metadata` 是 live runtime 账
- transcript/sessionStorage 尾部 metadata 是 durable ledger
- `reAppendSessionMetadata()` 是 tail-window durable 保全机制
- `resume` / `listSessionsImpl` / `SessionPreview` 更依赖 durable ledger

### 灰度面

- 哪些 metadata 字段未来会继续加入 durable tail set
- CCR v2 internal event hydrate 是否会继续扩大 durable rehydrate 面
- preview/list 对某些新字段是否会继续增补 consumer

## 为什么这页不是 117、120、130、133、151

### 不是 117

117 讲的是：

- init 的可见性分裂

152 讲的是：

- metadata 在 EOF/history/resume 后如何作为 durable ledger 存活

### 不是 120

120 讲的是：

- init payload 厚度

152 讲的是：

- durable metadata 生命周期

### 不是 130

130 讲的是：

- surface presence

152 讲的是：

- metadata ledger persistence

### 不是 133

133 讲的是：

- schema/store 有账，不等于当前前台已消费

152 继续往后拆的是：

- 即使前台没消费，某些 metadata 仍会被 durable tail ledger 保全，并在 resume/list/preview 时继续被读回

### 不是 151

151 讲的是：

- `remote.session_id` 的身份账与主权账

152 不谈 remote session ownership，

而谈：

- metadata 在会话关闭后为什么仍被 transcript ledger 保全

## 苏格拉底式自审

### 问：为什么不能把 transcript 尾部 metadata 写成“旧消息的一部分”？

答：因为 `reAppendSessionMetadata()` 的主语不是历史回放，而是让 tail-window consumer 在 EOF 后仍能继续读到会话元数据。

### 问：为什么一定要把 `listSessionsImpl` 和 `SessionPreview` 拉进来？

答：因为只有把这些 post-session consumer 摆出来，durable ledger 才会从“写盘细节”变成“真实被消费的合同”。

### 问：为什么一定要把 `external_metadata` 拉进来？

答：因为不把它并排写出来，读者就会继续把 live runtime metadata 和 durable session metadata 混成一张账。

### 问：这页的一句话 thesis 是什么？

答：`system/init` 负责发布“这一轮启动时愿意公开什么”，`external_metadata` 负责携带“当前运行态在说什么”，而 transcript/sessionStorage 尾部那套 durable session metadata 负责保全“这条会话在 EOF、history、resume 后还要被谁读回来”；三者同叫 metadata，但合同完全不同。

## 结论

对当前源码来说，更准确的写法应该是：

1. `system/init` 是 startup publish ledger
2. `external_metadata` 是 live runtime ledger
3. transcript/sessionStorage 尾部 metadata 是 durable session ledger
4. `reAppendSessionMetadata()` 是 durable tail-window 保全机制
5. `resume` / session list / preview 依赖的是 durable ledger，不是 foreground live state

所以：

- durable session metadata 不是 live `system/init`，也不是 foreground `external_metadata`

## 源码锚点

- `claude-code-source-code/src/utils/sessionStorage.ts`
- `claude-code-source-code/src/utils/sessionRestore.ts`
- `claude-code-source-code/src/utils/listSessionsImpl.ts`
- `claude-code-source-code/src/components/SessionPreview.tsx`
- `claude-code-source-code/src/utils/sessionTitle.ts`
- `claude-code-source-code/src/utils/sessionState.ts`
