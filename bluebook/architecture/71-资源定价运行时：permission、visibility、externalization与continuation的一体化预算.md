# 资源定价运行时：permission、visibility、externalization与continuation的一体化预算

这一章回答五个问题：

1. 为什么 Claude Code 的安全与高行动力应被理解成同一套资源定价系统。
2. 为什么 permission mode、审批竞速、工具可见性、结果外置与 continuation 停损必须一起看。
3. 为什么真正高行动力来自统一定价，而不是统一放权。
4. 为什么 `bypass` 不是无限自由，而是受约束的高阶通道。
5. 这对 agent runtime 设计者意味着什么。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/permissions/PermissionMode.ts:42-90`
- `claude-code-source-code/src/utils/permissions/permissions.ts:503-640`
- `claude-code-source-code/src/utils/permissions/permissions.ts:1238-1280`
- `claude-code-source-code/src/hooks/toolPermission/handlers/interactiveHandler.ts:244-380`
- `claude-code-source-code/src/utils/toolSearch.ts:646-704`
- `claude-code-source-code/src/utils/toolResultStorage.ts:739-860`
- `claude-code-source-code/src/query/tokenBudget.ts:1-93`

## 1. 先说结论

Claude Code 真正管理的不是若干孤立开关，而是四类稀缺资源：

1. 动作
2. 能力
3. 上下文席位
4. 时间

它之所以看起来既安全又能干，不是因为：

- 某个权限系统更聪明

而是因为：

- 它把这四类资源都放进了一套统一定价秩序

## 2. mode transformation 说明动作一开始就被分级定价

`permissions.ts` 的末端变换很能说明这件事：

1. `dontAsk` 会把 `ask` 直接改成 `deny`。
2. `auto` 会把一部分 `ask` 交给 classifier 定价。
3. `acceptEdits` 能让一批低风险编辑动作走更低摩擦通道。
4. `bypassPermissions` 也不会绕过 content-specific ask 和 safety check。

这说明 mode 不只是 UI 栏上的状态，而是：

- 动作默认该以什么价格被允许

这也是为什么 Claude Code 的自由观不是二元，而是梯度授予：

- 不同动作默认有不同协商成本

## 3. `bypass` 不是豁免一切，而是更高通行级别

很多系统会把 bypass 理解成“从此不再受限”，但 Claude Code 不是这样做的。

在 `permissions.ts` 里，以下几类约束仍然保留高价位：

- content-specific ask
- `requiresUserInteraction`
- safety check

这意味着系统明确保留了一部分：

- 不可折价的风险位

所以 `bypassPermissions` 的真实语义是：

- 提高某些动作的通行级别

而不是：

- 取消一切成本

## 4. approval race 说明审批的目标是低延迟成交，而不是线性排队

`interactiveHandler.ts` 里，本地 UI、bridge、channel relay、hook、classifier 会围绕同一请求并行竞速，谁先给出合法决定，谁就结束等待，其余路径撤销。

这说明 Claude Code 对审批的看法不是：

- 审批 = 停下等待人点按钮

而是：

- 审批 = 高价动作的低延迟协商协议

这块设计的成熟点在于它既保留治理，又避免把所有高价动作都变成线性阻塞。

## 5. tools visibility 说明能力是否进入模型视野本身也有成本

`toolSearch.ts` 和 deferred tools 机制表明，Claude Code 不认为所有能力都应该免费进入当前上下文。

它更偏爱：

1. 主路径能力直接暴露。
2. 冷门或大体积能力延迟暴露。
3. 先 ToolSearch 再回填 schema。

这意味着工具是否可见，已经不是“有没有实现”的问题，而是：

- 当前回合是否值得为它支付可见性成本

这也是为什么它会持续追求：

- 最小可见面

而不是：

- 最大工具目录

## 6. tool result budget 说明上下文席位也在被统一定价

`enforceToolResultBudget(...)` 的注释非常直接：

1. 大结果超预算后会被持久化到磁盘。
2. 主上下文里只保留 preview。
3. 一旦某个 `tool_use_id` 被替换，后续回合必须字节级重放同一 preview，不能临时再改。

这说明 Claude Code 把上下文席位也当成一种昂贵资源。

它不是在问：

- 输出是不是存在

而是在问：

- 这份输出值不值得继续占据主上下文里最昂贵的位置

## 7. continuation stop logic 说明“继续执行权”也不是免费资源

`checkTokenBudget(...)` 会综合：

- 当前 budget 比例
- continuation 次数
- 边际收益是否递减

来决定继续还是停止。

这说明 Claude Code 不把“继续这轮”当成默认免费选项。

它把 continuation 也纳入预算：

- 收益高时继续
- 收益低时停损

这和权限、可见性、结果外置放在一起看，就会发现它们是同一类问题：

- 稀缺运行时资源该如何被继续占用

## 8. 为什么这是统一放权的反面

统一放权的问题在于，它会把：

- 低风险动作和高风险动作
- 高频能力和冷门能力
- 小结果和大结果
- 高收益继续和低收益继续

全部按同一种低价格处理。

Claude Code 则明确反过来做：

1. 低风险动作降价。
2. 高风险动作加价。
3. 大结果迁出主席位。
4. 低收益长回合及时停损。

因此它更像：

- 资源定价运行时

而不是：

- 权力统一放开的自动体

## 9. 一句话总结

Claude Code 的安全与高行动力并不是两套系统，而是同一套资源定价运行时：动作、能力、上下文席位和时间都要按价值与风险被统一收费，这就是它为什么能在秩序里仍保持高行动力。
