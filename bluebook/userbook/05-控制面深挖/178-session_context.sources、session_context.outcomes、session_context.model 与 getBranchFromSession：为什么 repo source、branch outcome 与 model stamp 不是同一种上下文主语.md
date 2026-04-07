# `session_context.sources`、`session_context.outcomes`、`session_context.model` 与 `getBranchFromSession`：为什么 repo source、branch outcome 与 model stamp 不是同一种上下文主语

## 用户目标

177 已经把 remote provenance 继续拆成：

- session provenance family
- environment origin label

但如果正文停在这里，读者还是很容易把 `createBridgeSession(...)` 里的 `session_context` 再写平：

- `sources` 不就是上下文吗？
- `outcomes` 不也还是上下文吗？
- `model` 不也只是上下文里的另一个字段吗？
- 既然都在 `session_context` 里，它们是不是只差载荷形状不同？

这句还不稳。

从当前源码看，`session_context` 这个 bag 里至少还分成三种不同主语：

1. repo source declaration
2. branch outcome projection
3. model stamp

如果这三层不先拆开，后面就会把：

- `session_context.sources`
- `session_context.outcomes`
- `session_context.model`

重新压成同一种“创建 session 时附带的上下文”。

## 第一性原理

更稳的提问不是：

- “这些字段是不是都属于 session context？”

而是先问五个更底层的问题：

1. 当前字段在回答 repo 从哪来、branch 走向如何，还是模型戳记是什么？
2. 当前字段是 source-side declaration，还是 outcome-side projection？
3. 当前字段会被哪个消费面继续读取，是 repo 投影、branch helper，还是当前 helper 面里还没同层消费？
4. 当前字段如果改动，影响的是 repo 显示、branch 推断，还是模型说明？
5. 如果它们虽然同在一个 bag 里，却回答不同对象层的问题，为什么还要把它们写成同一种上下文主语？

只要这五轴不先拆开，后面就会把：

- repo source
- branch outcome
- model stamp

混成一句模糊的“session context”。

## 第一层：`sources` 先回答 repo 从哪来，不是 branch outcome

`createSession.ts` 构造 `session_context` 时，先建立：

- `gitSource`
- 类型是 `git_repository`
- 含 `url`
- 可选 `revision`

然后把它放进：

- `session_context.sources`

而 `utils/teleport/api.ts` 在 `listSessions` 的 transform 里，真正先读的也是：

- `session.session_context.sources.find(...)`

随后才从这个 git source 里继续解析：

- repo owner/name
- `default_branch`

这说明 `sources` 回答的问题不是：

- 当前最终落成了哪条 branch outcome

而是：

- 这条 session 的 repo context 是从哪个 repository source 声明出来的

所以它的厚度更像：

- repo source declaration

不是：

- branch outcome projection

## 第二层：`outcomes` 先回答 branch/projected result，不是 repo source 的重复写法

同一个 `createSession.ts` 里，还会构造：

- `gitOutcome`
- 内含 `git_info.repo`
- `git_info.branches`

然后把它放进：

- `session_context.outcomes`

而 `utils/teleport/api.ts` 里专门还有一条单独 helper：

- `getBranchFromSession(session)`

它读取的不是：

- `session_context.sources`

而是：

- `session_context.outcomes?.find(...)`

并返回：

- `git_info.branches[0]`

这说明更准确的理解不是：

- `outcomes` 只是把 `sources` 再写一遍

而是：

- `sources` 负责 repo 输入声明
- `outcomes` 负责 branch 结果投影

因此它们虽然都在 git 语义附近，

但回答的问题已经不同。

## 第三层：`model` 在当前 bag 里更像 stamp，不等于 repo 或 branch 任一层

`createSession.ts` 在 `session_context` 里还会写：

- `model: getMainLoopModel()`

这说明它首先回答的问题不是：

- repo 是哪个
- branch 是哪个

而是：

- 创建这条 session 时，当前 main loop model 戳记是什么

更关键的一点是：

- 在当前 `utils/teleport/api.ts` 这套 helper/readback surface 里
- `listSessions` 用的是 `sources`
- `getBranchFromSession` 用的是 `outcomes`
- 并没有与之平行的一条 helper 在这里消费 `session_context.model`

这并不等于：

- `model` 不重要

而是更准确地说明：

- 它与 repo source、branch outcome 不在同一个当前消费面里

所以它的厚度更像：

- model stamp

不是：

- repo source
- 也不是 branch outcome

## 第四层：同属 `session_context`，不等于同一张 readback 表

`utils/teleport/api.ts` 当前把 `SessionResource.session_context` typed 出来之后，

本地继续读取它时已经出现分叉：

### `sources`

- 被 `listSessions` transform 用来生成 repo owner/name/default_branch 投影

### `outcomes`

- 被 `getBranchFromSession(...)` 单独读成 branch helper

### `model`

- 至少在这套 helper surface 里，没有平行的 repo/branch 那种同层 read helper

这说明更准确的结论不是：

- `session_context` 一旦被 typed 出来，本地就会整体同层消费

而是：

- bag 被 typed 出来
- 不等于其中所有字段共享同一种消费宿主

## 第五层：`sources` 与 `outcomes` 还分属 declaration / projection 两侧

这是最容易被写错的一层。

`createSession.ts` 构造二者时：

- `sources` 侧更接近 repo URL / revision
- `outcomes` 侧更接近 repo 名称与 branch 列表

即使两者都由 git context 推出，

它们也不是同一种对象：

- 一个更像输入侧声明
- 一个更像结果侧投影

所以更准确的说法不是：

- `sources` / `outcomes` 都只是 repository metadata

而是：

- `sources` = source-side declaration
- `outcomes` = outcome-side projection

## 第六层：这页为什么不是 39、152、167 或 176 的附录

### 不是 39 的附录

39 讲的是：

- `--name`
- `permission_mode`
- `sandbox`
- title 回填

那里虽然顺手提到 `session_context`，

但只是为了说明：

- sandbox 不进入 request body

178 讲的是：

- `session_context` 内部字段本身也不是同一种上下文主语

所以它不是 39 的附注。

### 不是 152 的附录

152 讲的是：

- durable session metadata
- live system-init
- foreground external-metadata

178 讲的是：

- createSession 阶段写进去的 `session_context` 子字段

152 的主语是 ledger/source family，
178 的主语是 context payload 内部分裂。

### 不是 167 的附录

167 讲的是：

- CCR v2 metadata readback
- observer metadata 的本地消费合同

178 讲的是：

- SessionResource.session_context 的 repo/branch/model 三种不同主语

167 的主语是 remote metadata readback，
178 的主语是 session create context bag。

### 不是 176 的附录

176 已经说过：

- `session_context` 不是来源声明，也不是附着目标

但 178 继续往里切的是：

- `session_context` 自己内部也不是单一主语

所以 178 不是重复 176，而是它的下一刀。

## 第七层：专题内 stable / gray 也要分开

### 专题内更稳定的不变量

- `sources` 负责 repo source declaration。
- `outcomes` 负责 branch outcome projection。
- `model` 负责 model stamp。
- `SessionContext` 被 typed 出来，不等于三者共享同一消费宿主。

### 更脆弱、应后置的细节

- `cwd`
- `custom_system_prompt`
- `append_system_prompt`
- `seed_bundle_file_id`
- `github_pr`
- `reuse_outcome_branches`
- git remote 解析 fallback 细节

更准确的写法不是：

- 这页在枚举 `SessionContext` 的全部字段

而是：

- 这页只抓当前 `createBridgeSession` 真正写入的 `sources/outcomes/model` 三分

## 苏格拉底式自审

### 问：如果删掉 `outcomes`，这页还成立吗？

答：不成立。因为只有 `sources` 与 `outcomes` 同时出现，才能直接证明输入声明与结果投影已经分裂。

### 问：为什么 `model` 不能被写成 repo/branch 的同类上下文字段？

答：因为它回答的是模型戳记，而不是 repository / branch 语义；并且在当前 helper surface 里也没有 repo/branch 那样的同层消费路径。

### 问：为什么这页不是 176 的重复？

答：176 只证明 `session_context` 不是 attach/source/policy；178 继续证明 `session_context` 自己内部也不是单一主语。
