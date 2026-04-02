# 如何用资源定价设计Agent Runtime：mode、visibility、externalization与continuation

这一章回答五个问题：

1. 为什么真正强的 agent runtime 不该只做权限开关，而要做资源定价。
2. 怎样把 permission mode、审批竞速、deferred tools、结果外置和 token continuation 理解成同一秩序。
3. 为什么高行动力来自统一定价，而不是统一放权。
4. 怎样把“最大原始自由”改写成“最大有效自由”。
5. 怎样用苏格拉底式追问避免把“该定价”误判成“该一路放开”。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/permissions/PermissionMode.ts:42-90`
- `claude-code-source-code/src/utils/permissions/permissions.ts:503-640`
- `claude-code-source-code/src/utils/permissions/permissions.ts:1238-1280`
- `claude-code-source-code/src/hooks/toolPermission/handlers/interactiveHandler.ts:244-380`
- `claude-code-source-code/src/utils/toolSearch.ts:646-704`
- `claude-code-source-code/src/utils/toolResultStorage.ts:739-860`
- `claude-code-source-code/src/query/tokenBudget.ts:1-93`

这些锚点共同说明：

- Claude Code 真正在统一安排的，不是若干“能不能用”的开关，而是动作、能力、上下文席位和时间该以什么价格被使用。

## 1. 先说结论

更成熟的 runtime 设计法，不是：

- 一上来把所有权力都放开

而是：

1. 先给动作分级定价。
2. 再给审批设计低延迟协商协议。
3. 再给能力可见性定价。
4. 再给结果占用上下文的成本定价。
5. 最后再给长回合是否继续支付时间预算做停损。

所以 Claude Code 真正强的，不是约束更少，而是：

- 高行动力来自统一定价

## 2. 第一步：把 permission mode 当成价格表，而不是情绪按钮

`permissions.ts` 明确在末端做 mode 变换：

1. `dontAsk` 会把 `ask` 直接改成 `deny`。
2. `auto` 会把一部分 `ask` 送去 classifier 重新定价。
3. `acceptEdits` 会给低风险编辑动作走更低摩擦通道。
4. `bypassPermissions` 也不会绕过 content-specific ask 和 safety check。

这说明 mode 真正决定的不是“是否自由”，而是：

- 某类动作默认该付出多高协商成本

实践上：

1. 用 `plan` 压低误动作空间。
2. 用 `default` 保持协商弹性。
3. 用 `acceptEdits` 给边界清楚的小步编辑走低价通道。
4. 不要把 `bypassPermissions` 当成万能解，它只是更高通行级别，不是取消高价动作。

## 3. 第二步：把审批做成竞速协商，而不是线性排队

`interactiveHandler.ts` 里，本地 UI、bridge、channel relay、hook、classifier 围绕同一请求并行竞速，谁先给出合法决定，谁就结束等待，剩余路径随即撤销。

这说明成熟 runtime 的审批目标不是：

- 让系统停下来等人点按钮

而是：

- 在保留治理的同时，尽量缩短高价动作的等待时间

实践上：

1. 不要只有一个审批入口。
2. 尽量让本地、宿主、远程协商面共享同一请求 ID 和收口逻辑。
3. 让“批准”是正式协议消息，而不是模糊聊天文本。

## 4. 第三步：给能力可见性定价，而不是默认全量暴露

`toolSearch.ts` 和 deferred tools 机制说明，工具目录不是天然该全部进入当前上下文。

更成熟的做法是：

1. 先让常用主路径能力进入当前 tool pool。
2. 让冷门或体积大的能力延迟暴露。
3. 用 ToolSearch 先发现，再按需加载 schema。

这意味着能力本身也有上下文成本。

实践上：

1. 不要要求模型一开始记住所有工具。
2. 不要把“全都看见”误当成“更自由”。
3. 真正该追求的是：当前回合只看当前真正用得上的能力。

## 5. 第四步：给结果占用上下文的成本定价

`enforceToolResultBudget(...)` 会把超预算的大工具结果持久化到磁盘，并替换成稳定 preview；一旦某个 `tool_use_id` 的命运确定，后续回合就固定重放同一 preview，避免 prompt cache 漂移。

这说明 Claude Code 对输出的态度不是：

- 结果天然应该完整留在主上下文里

而是：

- 大结果只有在值得占据昂贵席位时才留在主上下文里

实践上：

1. 大输出优先外置，主线程只保留索引和 preview。
2. 不要把“还原全部输出”当成默认最优解。
3. 稳定 preview 比每轮重新裁剪更重要，因为它能保护 cache 和连续性。

## 6. 第五步：给长回合的继续权定价

`checkTokenBudget(...)` 会综合：

- 当前 budget 百分比
- continuation 次数
- 边际收益是否递减

来决定继续还是停止。

这说明 Claude Code 把“继续工作”本身也当成一种需要支付的资源。

实践上：

1. 当 continuation 已经多次触发时，先考虑 compact、task 化或 worktree 化。
2. 当边际收益明显下降时，不要靠“再多给一点权限”或“再多给一点上下文”硬续。
3. 高行动力依赖的是合适地停，而不是永远不停。

## 7. 第六步：把统一放权改成统一定价

统一放权的问题在于，它会把：

- 低风险动作
- 高风险动作
- 冷门能力
- 高频能力
- 短结果
- 大结果
- 高收益继续
- 低收益继续

全部按同一种价格处理。

Claude Code 的更成熟之处在于：

- 让低风险动作走快道
- 让高风险动作付更高协商成本
- 让大结果转去更便宜的存储面
- 让低收益长回合及时停损

这才是“有效自由”的工程含义。

## 8. 苏格拉底式检查清单

在准备继续提权、放大能力或延长回合前，先问自己：

1. 我缺的是更大权限，还是更合理的动作定价。
2. 我缺的是更多能力，还是更小的能力可见面。
3. 我缺的是更多上下文，还是该把大结果外置。
4. 我缺的是继续这轮，还是该换承载对象。
5. 我追求的是最大原始自由，还是最大有效自由。

如果这五问答不清，系统很快就会从“高行动力”滑向“高失控”。

## 9. 一句话总结

Claude Code 真正成熟的地方，不是把一切都放开，而是把动作、能力、上下文和时间统一放进定价秩序，让高行动力尽可能长时间地成立。
