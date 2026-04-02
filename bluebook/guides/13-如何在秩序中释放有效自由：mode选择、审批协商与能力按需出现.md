# 如何在秩序中释放有效自由：mode选择、审批协商与能力按需出现

这一章回答五个问题：

1. 为什么真正强的自由不是“没有约束”，而是“约束不再破坏行动”。
2. 怎样把 permission mode、审批反馈、能力延迟暴露和预算治理配合起来用。
3. 什么时候该用 `plan`、`default`、`acceptEdits`，什么时候才该考虑 `bypassPermissions`。
4. 为什么 ask / deny / channel approval 不该被看成纯阻塞，而应被看成协商接口。
5. 怎样用苏格拉底式追问避免把“该缩世界”误判成“该一路提权”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/permissions/PermissionMode.ts:1-140`
- `claude-code-source-code/src/components/permissions/PermissionPrompt.tsx:1-220`
- `claude-code-source-code/src/utils/permissions/permissions.ts:520-640`
- `claude-code-source-code/src/utils/permissions/permissions.ts:1160-1285`
- `claude-code-source-code/src/hooks/toolPermission/handlers/interactiveHandler.ts:301-380`
- `claude-code-source-code/src/services/mcp/channelPermissions.ts:1-240`
- `claude-code-source-code/src/utils/toolSearch.ts:646-704`
- `claude-code-source-code/src/utils/toolResultStorage.ts:367-445`
- `claude-code-source-code/src/query/tokenBudget.ts:1-84`

这些锚点共同说明：

- Claude Code 在追求的不是最大原始自由，而是可持续的有效自由。

## 1. 先说结论

更稳的高行动力，不是：

- 一上来给最大权限和全部能力

而是：

1. 先选合适挡位。
2. 再把审批变成协商。
3. 再让能力按需出现。
4. 再把大输出和长回合及时外置。

所以 Claude Code 真正强的地方不是“约束少”，而是：

- 约束被设计成不破坏行动

## 2. 第一步：把 permission mode 当成行动挡位，而不是权限情绪

`PermissionMode.ts` 把 mode 明确建成一组正式配置，而不是临时布尔开关。`default`、`plan`、`acceptEdits`、`bypassPermissions`、`dontAsk` 乃至特定构建下的 `auto`，对应的是不同的行动挡位。

更稳的用法通常是：

1. `plan`
   - 适合先压缩目标、边界和执行顺序
2. `default`
   - 适合探索、读写混合、需要持续协商的任务
3. `acceptEdits`
   - 适合边界已清楚的小步实现

`bypassPermissions` 的含义不是：

- “从此不需要思考边界”

而是：

- 你显式授予了更高自由，但系统仍会保留 ask rule 与 safety check 这类不可绕过的硬边界

## 3. 第二步：把审批当成反馈接口，不要只当 yes / no 开关

`PermissionPrompt.tsx` 支持 accept / reject 两边都附带反馈，默认占位符甚至直接写成：

- tell Claude what to do next
- tell Claude what to do differently

这已经说明作者希望审批被使用成：

- 纠偏接口

实践上：

1. `accept` 时别只点通过，补一句“只动哪些文件 / 先跑哪些验证 / 不要顺手改什么”。
2. `reject` 时别只拒绝，补一句“先缩范围 / 先给 patch / 先读不写 / 先解释风险”。
3. deny 之后不要期待模型自己推导出新边界；你最好显式给一条可执行替代路径。

真正成熟的审批不是停顿，而是：

- 把阻断转写成新的行动约束

而且在实现上，审批也不是单一路径。源码里本地 UI、SDK host、bridge、hook、channel relay、classifier 会围绕同一请求并行竞速，谁先给出合法决定，谁就拿走当前仲裁权，其余路径随后撤销或忽略。

这说明 Claude Code 把 ask / approve 设计成了：

- 正式协商协议

## 4. 第三步：理解高自由也仍受硬边界约束

`permissions.ts` 里有几个关键事实：

1. deny rule 优先返回。
2. ask rule 在满足条件时必须生效。
3. 内容级 ask rule 和 safety check 对 `bypassPermissions` 也免疫。
4. auto / classifier 路径也保留了某些 bypass-immune safety check。

这说明 Claude Code 的秩序不是装饰性的。它明确在区分：

- 可以放开的动作
- 必须协商的动作
- 不能靠模式覆盖掉的动作

实践上：

1. 只在目标、目录、风险面都已清楚时考虑更高权限。
2. 如果系统还在 ask，先问自己是不是边界定义得还不够窄。
3. 如果 safety check 还在触发，不要把它当成“系统太保守”，先检查是不是正在碰 `.git/`、配置面或高风险 shell 行为。

## 5. 第四步：让远程审批也是结构化协商，而不是聊天注水

`interactiveHandler.ts` 和 `channelPermissions.ts` 说明，channel permission relay 不是把“yes”当普通聊天消息转发回来，而是：

1. 生成独立 `request_id`
2. 通过结构化 notification 发给允许的 channel server
3. 只接受 server 发回的结构化 `{request_id, behavior}`
4. 本地 UI、bridge、hook、classifier、channel reply 之间用 race 取 first resolver

这意味着：

- 远程审批也被设计成正式控制面，不是随手拼出来的文本协议

实践上：

1. 需要离开终端也能审批时，用 channel relay，但前提是信任 allowlist 内的 server。
2. 不要把 channel 看成普通聊天窗口；它是远程协商面的一部分。
3. 如果你在做自己的 runtime，远程批准也应走结构化事件，而不是模糊的自然语言猜测。

## 6. 第五步：不要让模型一开始就背全部世界

`toolSearch.ts` 会根据历史里的 `deferred_tools_delta` 计算当前新增和移除的 deferred tools；`toolResultStorage.ts` 又会把超预算的长工具结果替换成稳定 preview，并保持跨回合 byte-identical 的重放结果。

这两件事放在一起看，结论很清楚：

- 更强的系统，不是让模型一次看见全部工具和全部输出，而是只让它看当前真正需要的能力与结果

实践上：

1. 接受 ToolSearch 先搜再用，而不是要求模型背全工具名。
2. 接受长输出外置和 preview 替换，而不是执着于把大结果永远留在主上下文里。
3. 真正该扩的是行动通路，不是模型瞬时可见世界。

## 7. 第六步：时间预算也属于秩序的一部分

`checkTokenBudget(...)` 会结合：

- 当前 budget 百分比
- continuation 次数
- 边际收益是否递减

来决定继续还是停止。

这说明真正高行动力的前提不是：

- 同一轮永远续下去

而是：

- 在收益还高时继续，在收益变差时换承载对象

实践上：

1. continuation 已经多次触发时，优先考虑 compact、task 化或 worktree 化。
2. 当增量产出明显变小，不要靠再放大权限去续命。
3. 让时间预算退出失控状态，本身就是释放有效自由的一部分。

## 8. 苏格拉底式检查清单

在准备进一步放大自由前，先问自己：

1. 我缺的到底是权限，还是更清晰的边界。
2. 我缺的是更多能力，还是更小的可见面。
3. 我缺的是更多上下文，还是应该把大输出外置。
4. 我现在该继续当前轮，还是该换承载对象。
5. 我追求的是原始自由，还是有效自由。

如果这五问没答清，提权通常只会放大返工和失控。

## 9. 一句话总结

Claude Code 真正成熟的高行动力，不在于取消秩序，而在于把 mode、审批反馈、延迟暴露、结果外置和预算停止条件一起编排好，让约束不再破坏行动。
