# 如何在约束中保持高行动力：permission mode、反馈式审批与渐进能力暴露

这一章回答五个问题：

1. 为什么更高行动力不等于更少约束。
2. 怎样利用 Claude Code 的 mode、审批反馈、deferred tools 与输出外置，在秩序中保持速度。
3. 什么时候该用 `default`、`plan`、`acceptEdits`，什么时候才该考虑更高权限。
4. 怎样把 ask / deny 变成协商，而不是纯阻塞。
5. 怎样用苏格拉底式追问避免把“该缩世界”误判成“该放大权限”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/permissions/PermissionMode.ts:1-108`
- `claude-code-source-code/src/components/permissions/PermissionPrompt.tsx:1-180`
- `claude-code-source-code/src/utils/permissions/permissions.ts:520-620`
- `claude-code-source-code/src/hooks/toolPermission/handlers/interactiveHandler.ts:301-360`
- `claude-code-source-code/src/utils/toolSearch.ts:646-704`
- `claude-code-source-code/src/utils/toolResultStorage.ts:367-430`
- `claude-code-source-code/src/query/tokenBudget.ts:1-84`

这些锚点共同说明：

- Claude Code 的约束系统不是为了“少做事”，而是为了让行动力在更稳定的秩序内持续存在。

## 1. 先说结论

更稳的高行动力使用法，不是：

- 一上来给最大自由

而是：

1. 先选合适 mode。
2. 再让审批变成反馈。
3. 再让能力按需出现。
4. 再让大负担对象退出主工作集。

这比“全放开然后祈祷别失控”更快，也更稳。

## 2. 第一步：把 mode 当成行动力挡位，而不是权限情绪

最实用的经验：

1. `default`
   - 适合探索、验证、混合读写
2. `plan`
   - 适合先压缩方案、先减少误动作
3. `acceptEdits`
   - 适合明确改动范围的小步实施

更稳的顺序通常是：

- 先 `plan`
- 再 `default`
- 再看是否需要 `acceptEdits`

而不是：

- 一上来最大权限

如果任务本身边界还没清楚，先放大自由只会放大返工。

## 3. 第二步：把 ask / deny 用成“协商”，不要只当开关

Permission Prompt 支持 accept / reject 时附带反馈，这一点很值钱。

实践上：

1. `accept` 时别只点通过，补一句“只改哪些文件 / 只验证哪些内容”。
2. `reject` 时别只拒绝，补一句“先改成读、先给 patch、先缩范围、先写计划”。
3. 不要让模型在 deny 后原样重试；要显式给它一条新的可行路径。

这样 ask 就不是纯停顿，而是：

- 把阻断转换成新的行动约束

## 4. 第三步：不要让模型一开始就背全部能力

Deferred tools 的正确用法不是“嫌麻烦就关闭”。

更成熟的做法是：

1. 允许系统先用 ToolSearch 缩小当前真正需要的能力面。
2. 不强迫模型一开始记住全部冷门工具名。
3. 发现某类任务经常要用同一批能力时，再考虑把它们稳定化到更高层。

也就是说：

- 能力没必要先全给
- 先让能力按需出现，往往更快

## 5. 第四步：把大输出外置，不要让历史拖住新行动

当 Bash/read/搜索结果开始很大时，不要直觉反应成“该开更大预算”。

先做这几步：

1. 让系统外置长输出，只保留 preview。
2. 用 task / worktree / 文件引用承载大块证据。
3. 让主线程只继续消费当前动作真正需要的部分。

这不是在削弱能力，而是在保护：

- 当前回合继续行动的空间

## 6. 第五步：时间预算也要被治理，而不是无限续借

`checkTokenBudget(...)` 已经说明，Claude Code 允许继续，但会看：

- 百分比
- continuation 次数
- 边际收益

实践上：

1. 当 continuation 已经多次触发时，先考虑换对象，而不是硬续。
2. 当增量收益明显下降时，优先 `compact`、task 化或暂停回写，而不是继续冲。
3. 真正高行动力依赖的是“每轮仍然有效”，不是“同一轮永不结束”。

## 7. 苏格拉底式检查清单

在准备放大自由前，先问自己：

1. 我是真的缺权限，还是只是缺更清晰的边界。
2. 我是真的缺能力，还是只是没让能力按需出现。
3. 我是真的缺上下文，还是只是大输出没外置。
4. 我是真的需要继续当前轮，还是该换对象承载。
5. 我现在追求的是原始自由，还是有效自由。

如果这五问没答清，放大自由通常只会放大失控。

## 8. 一句话总结

Claude Code 更成熟的高行动力方法，不是不断减少约束，而是让 mode、反馈式审批、渐进能力暴露和输出外置一起工作，使约束不再破坏行动。
