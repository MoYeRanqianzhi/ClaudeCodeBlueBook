# Prompt事故案例集：修宪漂移、路径失配与合法遗忘失效

这一章不再讲 Prompt Constitution 的一般原理，而是收集最能暴露它本质的失败样本。

它主要回答五个问题：

1. 为什么 prompt 的魔力真正暴露在“失效时怎么坏”，而不只在“正常时多强”。
2. 哪些事故最能说明 prompt 不是长文案，而是受治理的宪法。
3. 为什么 section、boundary、assembly path、lawful forgetting 与 invalidation 必须一起看。
4. 怎样从样本里反推出 Claude Code prompt 的设计哲学。
5. 怎样用苏格拉底式追问避免把案例读成零散 bug。

## 0. 代表性源码锚点

- `claude-code-source-code/src/memdir/memoryTypes.ts:228-240`
- `claude-code-source-code/src/QueryEngine.ts:284-321`
- `claude-code-source-code/src/utils/queryContext.ts:77-84`
- `claude-code-source-code/src/services/compact/compact.ts:330-340`
- `claude-code-source-code/src/services/compact/postCompactCleanup.ts:31-62`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:437-520`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`

## 1. 案例一：同一知识，不同标题和位置，效果完全不同

### 现象

一条 memory 内容没有改语义，只改了标题 wording 或插入位置，eval 结果却从差变好。

### 为什么重要

这说明 prompt 的关键不是“信息有没有”，而是：

- 它被放进宪法的哪个 section
- 它以什么标题被模型识别

### 暴露的制度边界

- section placement 不是排版问题，而是立法问题
- header wording 不是修辞问题，而是编译输入问题

### 反推哲学

Prompt 的魔力不来自多写信息，而来自：

- 行动语义被放在正确的制度位置

## 2. 案例二：REPL、QueryEngine 与 side-question 路径不完全同构

### 现象

REPL 主路径、QueryEngine headless 路径、`side_question` fallback 都在组装 prompt，但不完全走同一条路径。

### 为什么重要

如果同一现场在不同入口编译出不同宪法，问题就不是“模型忽然变笨”，而是：

- assembly path split

### 暴露的制度边界

- prompt 设计必须同时约束内容与组装路径
- “看上去差不多一样”对宪法系统来说不够

### 反推哲学

强 prompt 系统最终必须重视：

- path parity

而不只是 prompt text quality。

## 3. 案例三：compact 后 summary 还在，但协议连续性已经断了

### 现象

compact 看起来成功，summary 也在，但某些 tool pairing、thinking ownership 或 recovery boundary 已被切断。

### 为什么重要

这说明 compact 的失败不是“总结写得不好”，而是：

- lawful forgetting 失效

### 暴露的制度边界

- 忘记历史不是自由操作
- history 只能在保住继续工作的文法条件下被删除

### 反推哲学

Claude Code 的 prompt 强，不是最会记，而是：

- 最会合法地忘

## 4. 案例四：worktree / repo identity 变了，但 invalidation 没跟上

### 现象

环境已经换了，但 section cache、context cache 或 prompt triage 仍按旧世界工作。

### 为什么重要

用户会把这种现象感知为：

- “这次 prompt 反应很怪”

但真正问题是：

- invalidation drift

### 暴露的制度边界

- prompt 生效不是静态事实，而是失效事件管理
- 不写 invalidation ledger，就会出现“内容已变、宪法未更新”

### 反推哲学

强 prompt 团队不只是会修宪，还会：

- 管理修宪后的失效传播

## 5. 案例五：UI 历史看起来没问题，但模型看到的 protocol truth 已偏移

### 现象

前台显示层的 transcript 似乎连续，但进入 `normalizeMessagesForAPI()` 后协议真相已经被重写或过滤。

### 为什么重要

一旦只看 UI，不看 protocol truth，团队就会复盘错对象。

### 暴露的制度边界

- prompt 事故首先是模型真相事故，不是显示层事故

### 反推哲学

Prompt 的魔力来自工作语法机，而不是聊天记录重放。

## 6. 苏格拉底式追问

在你读完这些案例后，先问自己：

1. 我看到的是文案问题，还是立法位置问题。
2. 我看到的是“模型输出差”，还是 assembly path split。
3. compact 失败时，我关注的是摘要质量，还是 forgetting ABI。
4. cache miss 时，我关注的是“更贵了”，还是 invalidation drift。
5. 我读的是 UI 历史，还是 protocol truth。

## 7. 一句话总结

Prompt 的真正魔力，往往在它失效时更容易看清：它是一部受标题、位置、路径、删除策略和失效传播共同治理的宪法。
