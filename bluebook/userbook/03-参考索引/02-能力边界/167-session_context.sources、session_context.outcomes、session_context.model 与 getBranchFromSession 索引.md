# `session_context.sources`、`session_context.outcomes`、`session_context.model` 与 `getBranchFromSession` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/178-session_context.sources、session_context.outcomes、session_context.model 与 getBranchFromSession：为什么 repo source、branch outcome 与 model stamp 不是同一种上下文主语.md`
- `05-控制面深挖/176-createBridgeSession.environment_id、source、session_context 与 permission_mode：为什么 session attach target、来源声明、上下文载荷与默认策略不是同一种会话归属.md`
- `05-控制面深挖/152-sessionStorage、hydrateFromCCRv2InternalEvents、sessionRestore、listSessionsImpl、SessionPreview 与 sessionTitle：为什么 durable session metadata 不是 live system-init，也不是 foreground external-metadata.md`

边界先说清：

- 这页不是完整 SessionContext 字段总表。
- 这页不是 durable metadata / CCR readback 页。
- 这页只抓当前 createSession 写入的 `sources/outcomes/model` 三分。

## 1. 三种主语

| 字段 | 当前更像什么 | 关键对象 |
| --- | --- | --- |
| `sources` | repo source declaration | git repo URL / revision |
| `outcomes` | branch outcome projection | `git_info.branches` |
| `model` | model stamp | `getMainLoopModel()` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `sources` 与 `outcomes` 只是同一份 repo metadata 的两种写法 | 一个偏输入声明，一个偏结果投影 |
| `model` 也是 repo/branch 同类上下文字段 | 它回答的是模型戳记 |
| 既然都在 `session_context` 里，就共享同一消费宿主 | 当前 helper surface 已经把它们分开消费 |
| `session_context` typed 出来以后就是整体读取 | typed bag 不等于 uniform consumer-path |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 专题内稳定不变量 | `sources` -> repo projection、`outcomes` -> branch helper、`model` -> 独立 stamp 语义 |
| 条件公开 | git source/outcome 的 repo 解析 fallback、default_branch 从 revision 推导 |
| 内部/灰度层 | `cwd`、system prompt、seed bundle、github_pr、reuse_outcome_branches 等未在本页展开的字段 |

## 4. 五个检查问题

- 当前字段在回答 repo 来源、branch 结果，还是模型戳记？
- 当前字段是 declaration，还是 projection？
- 当前字段在当前 helper surface 里有没有平行消费器？
- 我是不是把 `session_context` 又写回一个单一大袋子？
- 我是不是又把这页写回 152/167 那种 durable/readback 页面？

## 5. 源码锚点

- `claude-code-source-code/src/bridge/createSession.ts`
- `claude-code-source-code/src/utils/teleport/api.ts`
