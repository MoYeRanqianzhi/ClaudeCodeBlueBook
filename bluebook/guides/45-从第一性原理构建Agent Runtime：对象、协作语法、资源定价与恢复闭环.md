# 从第一性原理构建Agent Runtime：对象、协作语法、资源定价与恢复闭环

这一章不再解释 Claude Code 为什么强，而是把它压成一套可迁移的 Agent Runtime 构建顺序。

它主要回答五个问题：

1. 如果你要做自己的 Agent Runtime，最先应该固定什么，而不是最先实现什么。
2. 怎样把 Prompt 设计哲学、安全/省 token 设计与恢复设计压成同一套构建顺序。
3. 为什么好的 Runtime 不是更会堆功能，而是更早固定对象、协作语法、预算与恢复。
4. 怎样用苏格拉底式追问避免把“功能存在”误当“系统成立”。
5. 怎样把 Claude Code 的设计母线迁移到自己的系统，而不误抄它的局部投影。

## 0. 代表性源码锚点

- `claude-code-source-code/src/constants/prompts.ts:491-557`
- `claude-code-source-code/src/utils/systemPrompt.ts:28-104`
- `claude-code-source-code/src/query/stopHooks.ts:84-120`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/services/compact/compact.ts:517-711`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:243-520`
- `claude-code-source-code/src/tools.ts:271-367`
- `claude-code-source-code/src/utils/permissions/permissions.ts:1158-1280`
- `claude-code-source-code/src/query/tokenBudget.ts:45-92`
- `claude-code-source-code/src/utils/sessionStorage.ts:1823-1955`
- `claude-code-source-code/src/QueryEngine.ts:436-463`

这些锚点共同说明：

- Claude Code 的底层设计单位不是“命令”“工具”或“提示词段落”，而是“正式对象 + 协作语法 + 预算秩序 + 恢复闭环”。

## 1. 第一性原理

更成熟的 Agent Runtime 构建法，不是：

- 先照着功能表抄一遍

而是：

1. 先定义对象。
2. 先定义这些对象之间的协作语法。
3. 先定义这些语法如何被预算器治理。
4. 先定义这些对象如何恢复。
5. 最后才让命令、工具、UI、技能与集成长出来。

这也是为什么 Claude Code 的高级感不在：

- “会不会某个功能”

而在：

- “这些功能是否都围绕同一组对象与语法成立”

## 2. 第一步：先固定对象，而不是先固定功能

如果对象不清楚，后面所有设计都会漂。

更稳的最小对象集至少应包括：

1. 当前主任务对象
2. 当前继续条件对象
3. 当前回退对象
4. 当前恢复资产对象
5. 当前消费者可见真相对象

Claude Code 里这些对象不会总以同一个类型名出现，但会反复以相同角色出现：

1. `session` / `task` / `worktree`
2. `compiled request object`
3. `decision_window`
4. `rollback object`
5. `bridge/session ingress/recovery asset`

构建动作：

1. 先列出你的 Runtime 中有哪些正式对象。
2. 先写清每个对象的 authority surface。
3. 先写清哪些对象可以升级、哪些对象只能恢复、哪些对象只能被观察。

如果一开始就没有对象表，后面通常只会得到：

- 一组互相竞争的半真相

## 3. 第二步：把 Prompt 写成协作语法，而不是写成文案

Claude Code 的 prompt 魔力不来自“更强的措辞”，而来自：

1. section registry
2. role sovereignty
3. dynamic boundary
4. lawful forgetting
5. protocol transcript compilation

更稳的构建顺序是：

1. 先定义 section 与主权链
2. 再定义 dynamic boundary
3. 再定义 compiled request truth
4. 再定义 lawful forgetting ABI
5. 最后才往里加内容

不要做的事：

1. 不要让 summary、resume、side question、suggestion 各自产生一个“差不多的主世界”。
2. 不要把 UI transcript 直接当成模型输入。
3. 不要把 compact 误写成“生成摘要”。

构建动作：

1. 先固定 stable prefix 与 dynamic tail。
2. 先定义 cache-safe prefix 的唯一生产者。
3. 先定义 protocol transcript 编译器，再定义显示层消息。

## 4. 第三步：把安全与省 Token 写成统一资源定价秩序

Claude Code 的安全设计和省 token 设计本质上是一回事：

- 都在决定什么该先看见、什么该先协商、什么该外置、什么不该继续

更稳的构建顺序是：

1. 先给动作定价：permission / ask / deny / safety
2. 先给能力定价：tool visibility / deferred exposure / subset
3. 先给上下文席位定价：externalization / preview / compact
4. 先给时间定价：continuation / stop / object upgrade

不要做的事：

1. 不要先把权限全放开，再补审批。
2. 不要先把所有工具都暴露给模型，再补 ToolSearch。
3. 不要先把所有结果都塞回 prompt，再补压缩。

构建动作：

1. 先决定哪些动作是 typed decision，不是 UI 交互。
2. 先决定哪些能力是默认可见，哪些必须 deferred。
3. 先决定什么时候继续当前对象，什么时候必须升级对象。

## 5. 第四步：把恢复闭环写在日常路径之前

Claude Code 的恢复设计不是事故补丁，而是日常写法的上游约束。

更稳的构建顺序是：

1. 先定义 durable boundary
2. 先定义 accepted turn 如何落盘
3. 先定义 compact boundary 与 replay 规则
4. 先定义 replacement / preview / drift ledger
5. 先定义 stale writer 如何被拒绝

不要做的事：

1. 不要等功能都跑通后再想 resume。
2. 不要把恢复资产写成“一坨 transcript”。
3. 不要允许旧 finally、旧 task snapshot、旧 control response 回写 fresh state。

构建动作：

1. 先决定什么是 accepted request 的 durable checkpoint。
2. 先决定什么是 replay / resume / fork 的合法输入。
3. 先决定 drift ledger 如何进入下一轮继续条件。

## 6. 第五步：把消费者边界当成正式设计对象

Claude Code 不是只有一个消费者：

1. 模型
2. REPL 用户
3. SDK host
4. 远程 bridge
5. 后来维护者

所以更稳的 Runtime 必须先区分：

1. 协议全集
2. 当前注册子集
3. 某个宿主当前实现子集
4. internal-only / gated surface

不要做的事：

1. 不要把“代码里有类型”当成“所有消费者都支持”。
2. 不要把 internal-only surface 当成公开能力。
3. 不要把 host 投影当成 authority surface。

构建动作：

1. 先为每类消费者定义它能看见什么。
2. 先为每类消费者定义它能改写什么。
3. 先为每类消费者定义它消费的是 timeline、snapshot 还是 evidence envelope。

## 7. 六步最小构建顺序

如果要把上面的原则压成一张 builder 卡，顺序可以固定成：

1. `对象表`
   - session / task / worktree / request / rollback / recovery
2. `协作语法`
   - section registry / role sovereignty / transcript compiler
3. `预算秩序`
   - action pricing / visibility pricing / externalization / continuation
4. `恢复闭环`
   - durable checkpoint / replay / compact boundary / stale-writer kill
5. `消费者边界`
   - protocol set / registry subset / host subset / internal-only
6. `再长功能`
   - commands / tools / host UI / skills / integrations

## 8. 苏格拉底式检查清单

在你准备继续加功能前，先问自己：

1. 我已经固定了哪些正式对象。
2. 模型消费的是文案，还是协作语法。
3. 我定义的是预算秩序，还是只是几个零散限制。
4. 恢复闭环是在保护当前对象，还是只在补日志。
5. 当前消费者看到的是 authority surface，还是某个投影面。
6. 如果这套功能今天删掉，系统剩下的对象与语法是否仍然成立。

## 9. 一句话总结

从第一性原理看，成熟的 Agent Runtime 不是先有很多功能，再靠设计把它们解释通；而是先固定对象、协作语法、资源定价与恢复闭环，再让功能自然长出来。
