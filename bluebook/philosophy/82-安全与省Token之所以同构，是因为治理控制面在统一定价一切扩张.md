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

## 2. 第一层：authority source 优于界面形态

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

## 3. 第二层：Context Usage 不是统计，而是 decision window

如果 token 面板只负责告诉你“已经用了多少”，那它只是统计层。

Claude Code 更接近的真相是：

- Context Usage 应同时解释当前对象、当前可见面、当前成本来源与当前继续边界

这会让安全与省 token 回到同一个问题：

- 哪些东西为什么被允许进入模型世界

所以真正成熟的 Context Usage 不是：

- 看起来很细的面板

而是：

- decision window 的可视化投影

## 4. 第三层：能力暴露与动作许可是同一类定价

把权限系统只理解成“允不允许调用工具”，会严重低估治理控制面的范围。

因为 Claude Code 同时在决定：

1. 哪些工具可见。
2. 哪些 schema 可进入请求。
3. 哪些控制请求能改 runtime 边界。
4. 哪些 host/SDK 消费者能收到什么状态。

这说明安全与省 token 之所以同构，是因为它们都在问：

- 这个扩张值不值得进入当前世界

## 5. 第四层：continuation pricing 比回答长度更关键

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

## 6. 第五层：rollback object 让治理不退回运维补救

如果治理失败后只剩：

- 回退哪些文件
- 重试几次
- 再弹一次窗

那么所谓治理系统其实已经退回事后补救。

Claude Code 更成熟的地方在于，它持续要求：

- 失败时先回答 rollback object 是谁

因为只有这样，治理才仍然围绕对象，而不是围绕情绪、面板与手工动作。

## 7. 苏格拉底式追问

### 7.1 为什么安全与省 token 不是两套平衡

因为它们共同反对的是：

- 免费扩张

### 7.2 为什么 token 面板如果不解释 decision window，就不够成熟

因为它只告诉你“花了多少”，却没告诉你：

- 为什么花
- 值不值得花
- 还能不能继续花

### 7.3 为什么 continuation 是治理问题而不是性能问题

因为免费继续会同时扩大：

- 风险
- 成本
- 上下文污染

## 8. 对 Agent 设计者的启发

如果想学 Claude Code，最该抄走的不是：

- 再叠几层权限弹窗

而是：

1. 先定义 authority source，而不是先设计 modal。
2. 把 Context Usage 写成 decision window，而不是统计面板。
3. 把能力暴露、动作许可、上下文进入与继续时长放到同一对象里定价。
4. 把 continuation 视为最需要被治理的时间资产。
5. 让失败优先回到 rollback object，而不是退回文件级补救。
