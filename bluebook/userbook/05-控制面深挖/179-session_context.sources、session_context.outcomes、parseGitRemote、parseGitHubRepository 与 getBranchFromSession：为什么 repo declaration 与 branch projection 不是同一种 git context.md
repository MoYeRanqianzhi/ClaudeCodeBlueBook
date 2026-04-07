# `session_context.sources`、`session_context.outcomes`、`parseGitRemote`、`parseGitHubRepository` 与 `getBranchFromSession`：为什么 repo declaration 与 branch projection 不是同一种 git context

## 用户目标

178 已经把 `session_context` 继续拆成：

- repo source declaration
- branch outcome projection
- model stamp

但如果正文停在这里，读者还是很容易把 git 这两层重新写平：

- `sources` 不就是 repo 信息吗？
- `outcomes` 不也还是 repo 信息吗？
- 反正最后都指向同一个 owner/repo，那它们是不是只差一个字段嵌套更深？

这句还不稳。

从当前源码看，git 语义至少还分成两种不同主语：

1. repository declaration
2. branch projection

如果这两层不先拆开，后面就会把：

- `session_context.sources`
- `session_context.outcomes`
- `parseGitRemote(...)`
- `parseGitHubRepository(...)`
- `getBranchFromSession(...)`

重新压成同一种“repo 上下文”。

## 第一性原理

更稳的提问不是：

- “这些字段是不是都在告诉我当前 repo 是什么？”

而是先问五个更底层的问题：

1. 当前字段在回答 repository 从哪来，还是 branch 最终往哪投影？
2. 当前字段是 source-side declaration，还是 outcome-side projection？
3. 当前字段在本地被继续消费时，是给 repo owner/name/default branch 用，还是给 branch helper 用？
4. 当前字段如果变化，影响的是 repository identity，还是 outcome branch 命名？
5. 如果字段都挂在同一个 `session_context` 里，却服务不同 git 主语，为什么还要把它们写成同一种 git context？

只要这五轴不先拆开，后面就会把：

- repo declaration
- branch projection

混成一句模糊的“session 携带的 git 信息”。

## 第一层：`sources` 先回答 repo 从哪来，不是最终 branch 投影

`createSession.ts` 构造 `gitSource` 时，会先试：

- `parseGitRemote(gitRepoUrl)`

失败后才 fallback 到：

- `parseGitHubRepository(gitRepoUrl)`

最终写入 `session_context.sources` 的是：

- `type: 'git_repository'`
- `url`
- `revision`

这里的 `revision` 还是：

- `branch || getDefaultBranch() || undefined`

这说明 `sources` 回答的问题不是：

- 这条 session 最终会产出什么 branch

而是：

- 它的 repo declaration 是哪一个 repository
- 并且当前 source-side revision anchor 是什么

所以它的厚度更像：

- repository declaration

不是：

- branch projection

## 第二层：`outcomes` 先回答 projected branch，不是 source 的另一种写法

同一段 `createSession.ts` 里，`gitOutcome` 被构造成：

- `git_info.repo = owner/name`
- `git_info.branches = [\`claude/${branch || 'task'}\`]`

这说明 `outcomes` 回答的问题已经从：

- repository 从哪来

切到了：

- 当前 session 在结果面上要把 branch 投影成什么名字

尤其关键的是：

- `sources.revision` 默认可能是 `branch` 或 repo `defaultBranch`
- `outcomes.branches[0]` 则直接投成 `claude/${branch || 'task'}`

这说明更准确的理解不是：

- `outcomes` 只是把 `sources` 再包一层

而是：

- `sources` 描述 source-side repo/revision
- `outcomes` 描述 outcome-side branch projection

## 第三层：本地消费面已经把二者拆成不同 helper

`utils/teleport/api.ts` 当前的 readback/transform 已经直接把这两层分开消费：

### repo 投影

`listSessions` transform 会：

- 从 `session.session_context.sources.find(...)` 取 git source
- 用 `parseGitHubRepository(gitSource.url)` 拆出 owner/name
- 再把 `gitSource.revision` 作为 `default_branch`

### branch helper

`getBranchFromSession(session)` 则完全不看 `sources`，
只看：

- `session.session_context.outcomes?.find(...)`
- 返回 `git_info.branches[0]`

这说明更准确的结论不是：

- typed 出来的 `session_context` 会被整体同层读取

而是：

- repo 读取链依赖 `sources`
- branch 读取链依赖 `outcomes`

消费宿主已经不同。

## 第四层：因此 `sources.revision` 与 `outcomes.branches[0]` 不属于同一值域

这是最容易被写错的一层。

如果把二者都写成“分支信息”，会直接抹掉两个事实：

### `sources.revision`

- 更像 source-side revision anchor
- 可能是当前 branch
- 也可能退回 repo default branch

### `outcomes.branches[0]`

- 明确被投成 `claude/${branch || 'task'}`
- 更像 outcome-side branch naming

所以更准确的说法不是：

- 两边都只是 branch 名

而是：

- 一个在说 source revision
- 一个在说 outcome branch projection

## 第五层：repo owner/name 也不是二者共享同一主语的证据

`sources` 和 `outcomes` 最容易让人误判的点在于：

- 它们最后都可能含 `owner/name`

但这并不能推出：

- 它们是同一种 git context

因为同样的 repo 名在两层里承担的语义也不同：

- 在 `sources` 里，它是 repository declaration 的载体
- 在 `outcomes` 里，它是 outcome projection 所属 repo 的标识

这和：

- 相同字符串
- 不代表相同对象主语

是同一个问题。

## 第六层：为什么这页不是 178、152 或 167 的附录

### 不是 178 的附录

178 讲的是：

- sources
- outcomes
- model

三者为什么不是同一种上下文主语。

179 讲的是：

- sources 与 outcomes 在 git 语义上到底如何继续分裂

178 更像大类拆分，
179 更像 git 子类继续细分。

### 不是 152 的附录

152 讲的是：

- durable session metadata
- live system-init
- foreground external-metadata

179 讲的是：

- createSession 写进去的 git declaration / projection

152 的主语是 metadata ledger，
179 的主语是 git context semantics。

### 不是 167 的附录

167 讲的是：

- CCR v2 metadata readback
- local consumption contract

179 讲的是：

- `SessionResource.session_context` 里 repo/branch 两层的不同消费面

167 的主语是 remote metadata readback，
179 的主语是 git declaration vs projection。

## 第七层：专题内 stable / gray 也要分开

### 专题内更稳定的不变量

- `sources` 负责 repo declaration。
- `outcomes` 负责 branch projection。
- repo 读取 helper 当前依赖 `sources`。
- branch 读取 helper 当前依赖 `outcomes`。
- 二者即使都能落到同一个 owner/repo，也不是同一主语。

### 更脆弱、应后置的细节

- `parseGitRemote(...)` 与 `parseGitHubRepository(...)` 的 fallback 细节
- `claude/${branch || 'task'}` 的命名约定是否未来会改
- `default_branch` 的 fallback 规则
- 其余 `SessionContext` 字段

更准确的写法不是：

- 这页在穷举所有 git 相关实现

而是：

- 这页只抓 repo declaration 与 branch projection 的语义分裂

## 苏格拉底式自审

### 问：如果删掉 `getBranchFromSession(...)`，这页还成立吗？

答：不够稳。因为没有这条 helper，就少了一条“本地消费面已经分开”的硬证据。

### 问：为什么 `sources.revision` 不能直接写成 branch outcome？

答：因为它还承担 source-side revision anchor，而且可能回退到 repo default branch；它不是 outcome-side `claude/...` branch projection。

### 问：为什么这页不是 178 的重复？

答：178 只证明三种主语不同；179 进一步证明 sources/outcomes 在 git 语义和本地消费面上也不是同一种对象。
