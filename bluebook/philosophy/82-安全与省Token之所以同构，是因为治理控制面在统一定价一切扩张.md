# 安全与省Token之所以同构，是因为治理控制面在统一定价一切扩张

这一章回答五个问题：

1. 为什么安全设计与省 token 设计表面不同，深层却在处理同一个问题。
2. 为什么 action、visibility、context 与 continuation 必须被放进同一治理对象。
3. 为什么 authority source、decision window 与 Context Usage 必须一起看，不能拆开讨论。
4. 为什么 continuation pricing 比“回答更短”更接近省 token 的真相。
5. 这对 agent runtime 设计者意味着什么。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/permissions/permissions.ts:593-984`
- `claude-code-source-code/src/cli/structuredIO.ts:149-657`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:106-260`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:464-519`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/utils/sessionState.ts:92-149`
- `claude-code-source-code/src/state/onChangeAppState.ts:43-92`
- `claude-code-source-code/src/utils/analyzeContext.ts:1098-1382`

这些锚点共同说明：

- Claude Code 的治理控制面并不是分别处理安全、成本与继续，而是在统一定价一切扩张。

## 1. 先说结论

安全与省 token 的深层共同点不是：

- 一个更严，一个更省

而是：

1. 未定价动作不该免费进入执行主路径。
2. 未定价能力不该免费暴露给模型。
3. 未定价上下文不该免费霸占主 prompt。
4. 未定价时间不该免费拖长 continuation。
5. 未定价失败不该免费退回“再试一次”。

从第一性原理看，治理控制面真正管理的不是：

- 某个 modal
- 某个 token 条

而是：

- 一切扩张的制度价格

## 2. 第一性原理：安全与省 token 共同反对免费扩张

如果一个系统把安全理解成：

- 多几层确认
- 多拦几次动作

把省 token 理解成：

- 回答更短
- 压缩更多上下文

那么它就仍停留在：

- 两套互相打架的补丁

Claude Code 更接近的真相是：

1. 能力是否暴露要被定价。
2. 动作是否执行要被定价。
3. 上下文是否进入模型要被定价。
4. continuation 是否继续要被定价。
5. 失败是否直接回跳也要被定价。

这也是为什么安全、成本与继续会在同一个治理对象里相遇。

## 3. 第一层：authority source 优于界面形态

很多系统把治理理解成：

- 能弹出批准框
- 能切换 mode

Claude Code 更成熟的地方在于，它先问：

- 当前谁有权宣布边界与决定

这意味着 mode、UI、host、bridge 都只是外化投影。

真正的治理对象必须先回答：

- 当前 authority source 是什么

否则系统很快会退回：

- 谁的界面看起来更像主语，谁就暂时说了算

也正因为如此，`permission_mode`、`session_state_changed` 与 host 可见状态链条的价值，不在于“宿主终于看见 mode 了”，而在于：

- authority 已经被外化成单一真相链，而不再只是界面形态

## 4. 第二层：可见世界本身就是成本与风险

如果系统允许模型先看见几乎全量世界，再谈要不要执行动作，那么：

- 风险已经先扩张了
- token 也已经先烧掉了

Claude Code 更成熟的地方在于，它同时治理：

1. 哪些工具可见。
2. 哪些 schema 可进入请求。
3. 哪些宿主状态会被外化给模型。
4. 哪些内容必须被 attachments 晚绑定，而不是提前塞进 stable prompt。

所以真正成熟的安全设计，不只是在动作时拦截，而是在可见世界上先定价。

## 5. 第三层：Context Usage 不是统计，而是 decision window

如果 token 面板只负责告诉你“已经用了多少”，那它只是统计层。

Claude Code 更接近的真相是：

- Context Usage 应同时解释当前对象、当前可见面、当前成本来源与当前继续边界

这会让安全与省 token 回到同一个问题：

- 哪些东西为什么被允许进入模型世界

所以真正成熟的 Context Usage 不是：

- 看起来很细的面板

而是：

- decision window 的可视化投影

这意味着成熟的 Context Usage 应同时解释：

1. 当前对象是什么。
2. 当前可见面为什么这样裁剪。
3. 当前成本是由哪些扩张产生的。
4. 当前继续资格还剩下什么正式条件。

只有当 `context usage + deferred categories + reserved buffer + api usage` 被继续当成同一个 decision window 对象时，这些解释才成立；否则再细的图表也只是更复杂的统计幻觉。

## 6. 第四层：能力暴露与动作许可是同一类定价

把权限系统只理解成“允不允许调用工具”，会严重低估治理控制面的范围。

因为 Claude Code 同时在决定：

1. 哪些工具可见。
2. 哪些 schema 可进入请求。
3. 哪些控制请求能改 runtime 边界。
4. 哪些 host/SDK 消费者能收到什么状态。

这说明安全与省 token 之所以同构，是因为它们都在问：

- 这个扩张值不值得进入当前世界

## 7. 第五层：continuation pricing 比回答长度更关键

很多系统以为省 token 的关键是：

- 回答更短

Claude Code 更接近的真相是：

- continuation 才是最大时间资产

只要系统默认继续、默认多来一轮、默认 headless 也继续跑，token 就会以时间形式被免费烧掉。

所以真正成熟的省 token 不只是：

- 控字数

而是：

- 给“继续多久”定价

这也是为什么 diminishing returns、headless deny、pending action 与 session metadata 会进入同一判断链。

更进一步，低摩擦自动化并不是绕过安全，而是只为已定价、范围已足够窄的动作省 classifier 成本。换句话说，真正成熟的系统不会把 classifier 当作额外负担，而会继续追问：

- classifier 自己值不值得这笔价格

如果 classifier 开销反客为主，治理控制面就会在自我保护时自我膨胀。

## 8. 第六层：rollback object 让治理不退回运维补救

如果治理失败后只剩：

- 回退哪些文件
- 重试几次
- 再弹一次窗

那么所谓治理系统其实已经退回事后补救。

Claude Code 更成熟的地方在于，它持续要求：

- 失败时先回答 rollback object 是谁

因为只有这样，治理才仍然围绕对象，而不是围绕情绪、面板与手工动作。

## 9. 第七层：失败语义比成功率更像治理控制面

如果一个系统只能告诉你：

- 成功了多少
- 还剩多少 token

却不能正式区分：

- `hard_reject`
- `liability_hold`
- `reentry_required`
- `reopen_required`

那么它仍然没有形成真正的治理控制面。

Claude Code 更值得学的地方是：

- 它不断把失败、继续、回退与重开写成同一套正式语义，而不是只保留产品侧的“还能不能点下一步”

这也是为什么 `requires_action -> pending_action -> session_state_changed` 这条 writeback seam 如此关键。它同时决定：

1. 当前为什么被拦。
2. 当前还能不能继续。
3. 当前什么时候算真正 turn-over。

一旦这条 seam 丢失，安全与成本就会一起退回猜测状态。

## 10. 苏格拉底式追问

### 10.1 为什么安全与省 token 不是两套平衡

因为它们共同反对的是：

- 免费扩张

### 10.2 为什么 token 面板如果不解释 decision window，就不够成熟

因为它只告诉你“花了多少”，却没告诉你：

- 为什么花
- 值不值得花
- 还能不能继续花

### 10.3 为什么 continuation 是治理问题而不是性能问题

因为免费继续会同时扩大：

- 风险
- 成本
- 上下文污染

### 10.4 为什么 authority source 比 modal 更重要

因为 modal 只是在显示治理，authority source 才在决定治理。

### 10.5 为什么真正成熟的省 token 设计必然也更安全

因为当系统拒绝免费暴露、免费继续与免费扩张时，它同时也在拒绝大量风险的无约束传播。

## 11. 对 Agent 设计者的启发

如果想学 Claude Code，最该抄走的不是：

- 再叠几层权限弹窗

而是：

1. 先定义 authority source，而不是先设计 modal。
2. 把 Context Usage 写成 decision window，而不是统计面板。
3. 把能力暴露、动作许可、上下文进入与继续时长放到同一对象里定价。
4. 把 continuation 视为最需要被治理的时间资产。
5. 让失败优先回到 rollback object，而不是退回文件级补救。
