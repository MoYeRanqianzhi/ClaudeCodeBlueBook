# Narrow、Later、Outside：安全设计与省Token设计的统一反扩张运行时

这一章回答五个问题：

1. 为什么 Claude Code 的安全设计和省 token 设计本质上共享同一组动作。
2. 为什么它不偏爱“先全给模型，再事后补救”，而偏爱 `Narrow / Later / Outside`。
3. `permissions`、`toolSchemaCache`、`tokenBudget`、输出外置、deferred visibility 为什么应该放在一张图里。
4. 为什么这不是成本附属优化，而是正式运行时治理。
5. 这套反扩张方法为什么比“再调一点 prompt”更稳定。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/permissions/permissions.ts:1160-1265`
- `claude-code-source-code/src/utils/toolSchemaCache.ts:1-20`
- `claude-code-source-code/src/query/tokenBudget.ts:1-84`
- `claude-code-source-code/src/constants/systemPromptSections.ts:17-50`
- `claude-code-source-code/src/utils/toolSearch.ts:385-430`
- `claude-code-source-code/src/utils/toolResultStorage.ts:272-320`
- `claude-code-source-code/src/utils/toolResultStorage.ts:740-772`
- `claude-code-source-code/src/utils/attachments.ts:1448-1495`
- `claude-code-source-code/src/utils/mcpInstructionsDelta.ts:20-52`

## 1. 先说结论

Claude Code 在安全、治理和省 token 上，反复使用的是同一组动作：

1. `Narrow`
   - 先缩小模型当前可达世界。
2. `Later`
   - 需要的信息不一开始给，而在正确时机再给。
3. `Outside`
   - 高体积、高波动、高风险对象不塞进主工作集，而迁到外部表面。

这三种动作同时作用在：

- 动作空间
- 上下文空间
- 时间空间

所以 Claude Code 真正在做的不是：

- 安全系统一套
- token 经济一套

而是：

- 同一反扩张运行时的三种统一操作

## 2. 第一种动作：`Narrow`

`Narrow` 的本质是：

- 模型不是默认看见全部世界，而是先看见一个被裁剪过的世界

### 2.1 安全面的 `Narrow`

`permissions.ts` 的顺序非常说明问题：

- 先 deny
- 再 ask
- 再 tool-specific checks
- 再 mode / bypass 逻辑

这表明 Claude Code 不相信：

- 先让模型自由决定，事后再收回来

它先限制行动空间，再讨论剩余空间里的执行。

### 2.2 prompt / tool 面的 `Narrow`

`toolSchemaCache.ts` 与 built-ins stable prefix 说明 Claude Code 同样在缩：

- 当前真正暴露给模型的能力语法面

不是所有可安装、可连接、可声明能力都必须立刻进入当前会话的 action grammar。

### 2.3 这为什么同时省 token

因为世界一旦先被缩小：

- schema token 少了
- 噪声少了
- cache churn 少了
- 分类与决策负担也少了

所以 `Narrow` 既是安全动作，也是省 token 动作。

更硬一点说，`Narrow` 还必须继续回指治理对象：

1. `governance key`
   - 谁配先改当前边界。
2. `typed ask`
   - 哪些扩张这次必须进入正式仲裁。
3. `capability surface`
   - 当前最小可见面到底由谁单源定义。

## 3. 第二种动作：`Later`

`Later` 的本质是：

- 不否认某些信息有用，但拒绝让它们过早进入主工作集

### 3.1 deferred tools 是 `Later`

`toolSearch.ts` 先暴露 ToolSearch，再按发现结果逐步回填 deferred tools。

这意味着：

- 能力不是没有
- 只是被延后暴露

### 3.2 dynamic sections 是 `Later`

`systemPromptSections` 把 cache-breaking 的 section 明确放进动态区，本质上也是：

- 信息不是没有
- 只是不能提前污染静态前缀

### 3.3 budget continuation 也是 `Later`

`tokenBudget.ts` 不是简单地“预算不够就停”，而是把完成过程拆成：

- 继续一点
- 观察边际收益
- 该停时再停

这说明 Claude Code 不是只会粗暴剪掉工作，而是用时间维度重新安排信息和行动的出现顺序。

但 `Later` 不等于“先等等再说”。

更稳的判断还应继续写成：

1. 只有在仍有 `decision gain` 时，延后暴露或延后继续才合法。
2. 一旦检查、分类或继续已经不能改变 verdict，`Later` 就必须转成 `stop / cleanup / step-up`，不能继续拖延。
3. 所以 `Later` 真正在保护的是 `decision window / continuation pricing`，不是“更温和的继续”。

## 4. 第三种动作：`Outside`

`Outside` 的本质是：

- 某些对象太大、太脏、太易漂移，不该继续停留在主上下文内部

### 4.1 tool result externalization 是 `Outside`

`toolResultStorage.ts` 把大块 `tool_result` 落盘并替换成外置引用，这说明 Claude Code 拒绝让大输出长期霸占工作集。

### 4.2 delta attachments 是 `Outside`

deferred tools、MCP instructions、agent listings 等被迁成 delta attachments，也是在把高波动知识放到主前缀外部。

### 4.3 为什么 `Outside` 同时提升安全与稳定性

因为高体积对象一旦待在主工作集里，带来的不仅是成本问题，还有：

- 更大的误行动作空间
- 更差的 cache 稳定性
- 更弱的恢复可推理性

所以 `Outside` 不是节省技巧，而是控制复杂性的位置。

更硬一点看，`Outside` 还必须继续回答三件事：

1. 哪个对象被迁出
   - output、instruction delta、preview、replacement bytes 还是 capability listing。
2. 迁出后靠什么回钉
   - stable ref、replacement carrier、externalized truth，还是另一个 projection 替身。
3. 失败时由谁收尾
   - `rollback / cleanup / human-fallback` 中哪一个 verdict 在签发。

## 5. 三种动作为什么本质同构

`Narrow / Later / Outside` 看起来像三种不同策略，底层其实都在做同一件事：

- 拒绝无序扩张立刻进入模型此刻的可达世界

更具体地说：

1. `Narrow`
   - 改变世界的宽度。
2. `Later`
   - 改变世界出现的时间。
3. `Outside`
   - 改变世界出现的位置。

一旦宽度、时间、位置都被 runtime 接管，安全、token、prompt 稳定性就自然开始共享一套治理语言。

如果继续把三种动作压成一张 crosswalk，它至少要能对齐成：

1. `Narrow`
   - 宽度治理
   - `governance key / typed ask / capability surface`
2. `Later`
   - 时间治理
   - `decision window / continuation pricing / decision gain`
3. `Outside`
   - 位置治理
   - `externalized truth / replacement carrier / durable-transient cleanup`

只要这张 crosswalk 说不清，`Narrow / Later / Outside` 就还只是三个好记口号，不是同一条治理位置学。

## 6. 为什么这不是成本附属层，而是正式 runtime

如果它只是成本优化，你会看到的是：

- 多一点压缩
- 多一点裁剪
- 多一点缓存

但 Claude Code 的结构明显更强：

- deny/ask 先于动作执行
- deferred discovery 先于全量能力暴露
- dynamic boundary 先于 prompt 装配
- output externalization 先于 microcompact
- budget continuation 先于盲目多轮生成

也就是说，作者不是在“优化已经形成的世界”，而是在：

- 先决定世界以什么形式进入系统

这就是正式 runtime，而不是附属调优。

failure semantics 也因此不是后来补上的副产品，而是这条 runtime 本体的一部分。

更稳的资产分型至少要继续回答：

1. `reject`
   - 当前扩张不配进入这个世界。
2. `degrade`
   - 只能退化成最小合法形态，不能继续装作 full capability。
3. `halt`
   - 继续已经没有决策增益。
4. `cleanup-before-resume`
   - transient authority 必须先清空，才能重新进入当前世界。
5. `human-fallback`
   - 当前 verdict 不再配自动化签发。

如果解释又退回权限弹窗、usage 条、compact 技巧或 default continue 这些投影替身，而不是回到 `governance key / decision window / continuation pricing / cleanup` 这组对象，这一章就已经在前门失真。

## 7. 一句话总结

Claude Code 的安全设计和省 token 设计之所以能统一，是因为它反复使用 `Narrow / Later / Outside` 三种动作，持续压制模型可达世界的无序扩张。
