# 消息塑形、输出外置与 Token 经济

这一章回答五个问题：

1. Claude Code 真正把 token 花在了哪里。
2. 为什么它的省 token 设计不止是 compact。
3. `messages.ts`、tool result budget、shell output 外置、deferred delta 是怎样协同工作的。
4. 为什么 compact 在这套系统里反而是最后一道手段。
5. 这套设计透露了怎样的上下文经济学。

## 1. 先说结论

Claude Code 的省 token 不是单一摘要策略，而是一套四层经济系统：

1. 稳定前缀：
   - system prompt
   - context
   - tool schema
2. 按需目录：
   - deferred tools
   - agent list delta
   - MCP instructions delta
3. 外置大块输出：
   - tool result budget
   - shell / task output file
4. 尾部回收：
   - snip
   - microcompact
   - autocompact
   - full compact

所以 Claude Code 真正在做的是：

- 先不让大块内容进上下文
- 再把已进入的消息重新塑形
- 最后才做摘要回收

关键证据：

- `claude-code-source-code/src/utils/analyzeContext.ts:918-1164`
- `claude-code-source-code/src/query.ts:365-468`
- `claude-code-source-code/src/utils/messages.ts:1989-2534`
- `claude-code-source-code/src/utils/toolResultStorage.ts:769-941`
- `claude-code-source-code/src/utils/shell/outputLimits.ts:4-4`
- `claude-code-source-code/src/utils/task/TaskOutput.ts:282-282`
- `claude-code-source-code/src/utils/toolSearch.ts:545-646`
- `claude-code-source-code/src/utils/mcpInstructionsDelta.ts:37-55`
- `claude-code-source-code/src/services/compact/autoCompact.ts:33-33`

## 2. 第一层：先看固定税

`get_context_usage` 的统计口径已经说明，固定税主要花在：

- system prompt
- system/user context
- memory files
- tool schemas

而且 deferred 类项目会被单独标成：

- 名字已知
- 但不占当前真实窗口

这说明 Claude Code 不只关心“上下文现在多大”，还关心“哪些东西本来可以不进来”。

证据：

- `claude-code-source-code/src/utils/analyzeContext.ts:363-616`
- `claude-code-source-code/src/utils/analyzeContext.ts:918-1164`
- `claude-code-source-code/src/context.ts:116-155`
- `claude-code-source-code/src/constants/prompts.ts:491-579`

## 3. 第二层：message shaping 先于摘要

`messages.ts` 的 `normalizeMessagesForAPI()` 本质上像一个编译器，而不只是格式转换器。

它会做很多省 token、保合法性的动作：

- 合并相邻 user
- hoist / smoosh 某些 system-reminder
- 清理 stale `tool_reference`
- 过滤空白 / orphan assistant
- 修复 tool_use / tool_result 拓扑

这说明 Claude Code 的第一反应不是“摘要掉”，而是：

- 先把消息编译成更紧凑、更稳定、更合法的 API 形态

证据：

- `claude-code-source-code/src/utils/messages.ts:1989-2534`
- `claude-code-source-code/src/utils/messages.ts:3097-3101`
- `claude-code-source-code/src/utils/messages.ts:4194-4253`
- `claude-code-source-code/src/utils/messages.ts:5133-5133`

## 4. 第三层：大块输出优先外置

### 4.1 tool result budget

`query.ts` 会先跑 tool result budget，把高体积工具结果做 preview + filepath 外置。

而 `toolResultStorage.ts` 还特地冻结决策，避免后面回合重新改写旧前缀，破坏 cache 稳定性。

### 4.2 shell / task output

shell 输出还有另一层：

- 默认截断
- 落盘
- 把对用户真正有用的部分留下

这说明作者很清楚：

- 最大的 token 黑洞通常不是对话，而是工具输出

证据：

- `claude-code-source-code/src/query.ts:379-468`
- `claude-code-source-code/src/utils/toolResultStorage.ts:769-941`
- `claude-code-source-code/src/utils/shell/outputLimits.ts:4-4`
- `claude-code-source-code/src/utils/task/TaskOutput.ts:32-282`
- `claude-code-source-code/src/tools/BashTool/BashTool.tsx:589-589`

## 5. 第四层：动态目录外移，别污染前缀

Claude Code 还专门把容易抖动的“目录类信息”从前缀里拆出去：

- deferred tools
- MCP instructions
- agent listing

典型做法是：

- 先只给 name / delta
- 真正需要时再按需加载 schema 或说明

这比“每轮都把全量目录塞回 prompt”节省得多，也更利于 cache 命中。

证据：

- `claude-code-source-code/src/utils/toolSearch.ts:545-646`
- `claude-code-source-code/src/utils/attachments.ts:1455-1559`
- `claude-code-source-code/src/utils/mcpInstructionsDelta.ts:37-55`
- `claude-code-source-code/src/tools/AgentTool/prompt.ts:48-64`

## 6. 第五层：compact 是最后一道手段

Claude Code 的回收顺序不是：

- 一接近上限就摘要

而是：

1. tool result budget
2. snip / message shaping
3. microcompact
4. autocompact / session memory compact
5. full compact

这说明作者的偏好是：

- 能不改历史就不改历史
- 能删噪音就不做摘要
- 只有前面都不够了，才动 summary

证据：

- `claude-code-source-code/src/query.ts:365-468`
- `claude-code-source-code/src/services/compact/microCompact.ts:253-273`
- `claude-code-source-code/src/services/compact/autoCompact.ts:241-241`
- `claude-code-source-code/src/services/compact/compact.ts:567-608`
- `claude-code-source-code/src/services/compact/compact.ts:1136-1136`

## 7. 为什么这套设计会显得“省得很聪明”

因为它始终在用更便宜的方式表达同一事实：

1. 目录信息用 delta，不用全量
2. 大块输出用 file pointer，不用全量正文
3. 合法性修复用重排，不用额外解释
4. cache 前缀尽量稳定，不让系统自己重写自己

这是一种非常工程化的 token 经济学：

- 先压字节抖动
- 再压大块输出
- 最后才压语义历史

## 8. 一句话总结

Claude Code 的上下文经济学真正厉害的地方，不是会做 compact，而是它在 compact 之前，已经把 prompt 前缀、消息拓扑、工具输出和动态目录都做了系统性的 token 治理。
