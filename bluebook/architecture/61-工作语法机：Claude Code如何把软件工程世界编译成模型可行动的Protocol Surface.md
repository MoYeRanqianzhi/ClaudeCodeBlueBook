# 工作语法机：Claude Code如何把软件工程世界编译成模型可行动的Protocol Surface

这一章回答五个问题：

1. 为什么 Claude Code 的 prompt 魔力不该被理解成“system prompt 写得更好”，而该被理解成一种工作语法机。
2. 为什么它持续把软件工程现场编译成模型可行动、可缓存、可恢复的 protocol surface。
3. `systemPromptSections`、tool schema、protocol transcript、delta attachments、deferred discovery 为什么本质上是同一件事。
4. 为什么这条链先关心“世界怎样被表达”，再关心“模型怎样思考”。
5. 这条架构为什么比抄 prompt 文案更难抄。

## 0. 代表性源码锚点

- `claude-code-source-code/src/constants/systemPromptSections.ts:1-55`
- `claude-code-source-code/src/constants/prompts.ts:343-355`
- `claude-code-source-code/src/constants/prompts.ts:492-510`
- `claude-code-source-code/src/utils/systemPrompt.ts:25-56`
- `claude-code-source-code/src/utils/toolSchemaCache.ts:1-20`
- `claude-code-source-code/src/tools.ts:345-364`
- `claude-code-source-code/src/utils/toolSearch.ts:385-430`
- `claude-code-source-code/src/utils/toolSearch.ts:540-560`
- `claude-code-source-code/src/utils/attachments.ts:1448-1495`
- `claude-code-source-code/src/utils/mcpInstructionsDelta.ts:20-52`
- `claude-code-source-code/src/utils/messages.ts:1989-2045`

## 1. 先说结论

Claude Code 的 prompt 强，不是因为它写出了一段更强的话术。

它更像在做一件更底层的事：

- 把软件工程世界编译成模型可行动的 protocol surface

这个 surface 不是自然存在的。

它要先被 runtime 重新整理成一套工作语法：

1. 什么是稳定合同。
2. 什么是动态补丁。
3. 什么该放进主前缀。
4. 什么必须延后暴露。
5. 什么只该以 delta 或 attachment 出现。
6. 什么必须在进 API 前被再正则化一次。

所以 Claude Code 的 prompt 魔力，本质上更接近：

- 工作语法工程

而不是：

- 文案工程

## 2. 第一步：先把世界切成“稳定合同”和“动态扰动”

`systemPromptSections.ts` 最关键的不是提供了几个 helper，而是把系统 prompt 明确分成两类：

- 可 memoize 的稳定 section
- 明知会 break cache 的危险 section

`prompts.ts` 的 dynamic boundary 进一步把这个区分写成正式字节边界：

- 边界之前尽量稳定
- 边界之后承认自己会变

这一步很像编译器先做词法切分。

Claude Code 首先不问：

- 这段信息有没有用

而先问：

- 这段信息属于稳定语法，还是动态扰动

这直接决定它能不能进入前缀高位。

## 3. 第二步：把能力表改写成“可行动语法”

工具系统在 Claude Code 里并不是独立于 prompt 的第二块。

它其实是工作语法的一部分。

### 3.1 tool schema 是语法，不只是功能清单

`toolSchemaCache.ts` 的注释已经把这一点说得很清楚：

- tool schema 位于请求高位
- 任意字节变化都会击穿整个下游缓存

所以 Claude Code 不把工具看成：

- “先罗列全部功能”

而看成：

- “先稳定模型将据此行动的语法面”

### 3.2 built-ins 前缀稳定，MCP 在后

`tools.ts` 维持 built-ins 连续前缀，再把波动更大的 MCP 工具放到后面。

这不是排版偏好，而是在保护：

- 行动语法的高频核心必须稳定

### 3.3 deferred discovery 说明“知道工具名”也是语法渐进展开

`toolSearch.ts` 的 deferred tools 不是一开始全暴露，而是先暴露搜索能力，再由模型闭环发现工具，再把 discovered set 回填到后续回合。

这意味着 Claude Code 在工具面上也坚持同一原则：

- 先给最小语法
- 再在需要时扩展语法

## 4. 第三步：把高波动知识迁出主语法，改成 delta

`attachments.ts` 与 `mcpInstructionsDelta.ts` 说明 Claude Code 在反复做同一种转换：

- 把会高频变化的信息从主 prompt/主 schema 迁到 delta attachments

这至少包括：

- deferred tools
- agent listing
- MCP instructions

这一步的关键意义不是“少写几行字”，而是：

- 让世界的变化以补丁形式出现，而不是反复改写整部语法书

所以 Claude Code 的 prompt 设计其实非常接近：

- 稳定 grammar + 动态 patch stream

## 5. 第四步：把 UI 世界再编译成 protocol 世界

`normalizeMessagesForAPI()` 说明 Claude Code 根本不把 UI transcript 当成最终协议。

它会在送进 API 前继续做一轮编译：

- 清理 orphan / duplicate
- 重排 attachment
- 剥离 virtual / synthetic 污染
- 恢复合法 block 结构

这说明 Claude Code 对“模型看见的世界”非常克制。

它不接受：

- 界面上看起来是怎样，模型就直接看怎样

它坚持：

- 界面世界要先被翻译成协议世界

这也是 prompt 魔力为什么更稳的原因之一。

因为模型面对的不是自然生长的聊天记录，而是被 runtime 正则化过的工作语法。

## 6. 第五步：把“模型要做的事”也编进语法里

这套工作语法不只描述输入，还描述行动方式。

例如：

- built-in tools 是固定动词
- deferred tools 是可搜索动词库
- attachments 是晚绑定宾语
- protocol transcript 是标准句法
- permission / governance 决定哪些句子当前合法

也就是说，Claude Code 不是让模型在原始世界里自由发挥。

它先把原始世界压缩成一套：

- 模型可以稳定解析、稳定调用、稳定继续的操作语法

这比“模型理解力更强”更接近本体。

## 7. 为什么这条线解释了 prompt 的“魔力”

很多人看到 Claude Code 表现强，会直觉归因于：

- 更会写 system prompt

更准确的归因其实是：

1. 世界先被压成稳定合同。
2. 动态信息被后移成 patch。
3. 行动面被写成稳定语法。
4. UI transcript 被重编译成 protocol transcript。
5. 高波动信息不再污染主前缀。

所以 Claude Code 的魔力，不在于：

- 一次性把所有聪明都塞进 prompt

而在于：

- 持续把工作世界翻译成模型可稳定处理的形式

## 8. 一句话总结

Claude Code 的 prompt 魔力真正来自一种工作语法机：它先把软件工程世界编译成可治理、可行动、可缓存、可恢复的 protocol surface，然后才让模型在这个 surface 上思考和行动。
