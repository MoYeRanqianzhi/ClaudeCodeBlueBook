# 安全与 Token 经济不是权衡而是同一优化

这一章回答四个问题：

1. 为什么 Claude Code 的安全设计和省 token 设计应被一起理解。
2. 两者在第一性原理上到底共享什么目标。
3. 哪些源码细节最能说明这种“同一优化”。
4. 这对 agent 产品设计有什么启发。

## 1. 先说结论

Claude Code 的安全与 token 经济，本质上都在做同一件事：

- 限制无序扩张

只是两者限制的对象不同：

1. 安全系统限制动作空间：
   - 什么能执行
   - 在哪里执行
   - 何时需要确认
2. token 经济限制上下文空间：
   - 什么必须常驻
   - 什么延后加载
   - 什么摘要化
   - 什么外置到文件

这两套设计的共同目标都是：

- 让 runtime 只暴露必要能力，并以更可控的方式暴露

代表性证据：

- `claude-code-source-code/src/constants/systemPromptSections.ts:27-37`
- `claude-code-source-code/src/constants/prompts.ts:508-520`
- `claude-code-source-code/src/utils/toolPool.ts:43-79`
- `claude-code-source-code/src/utils/streamlinedTransform.ts:1-193`
- `claude-code-source-code/src/remote/sdkMessageAdapter.ts:168-278`
- `claude-code-source-code/src/tools/BashTool/readOnlyValidation.ts:1914-1965`
- `claude-code-source-code/src/tools/LSPTool/LSPTool.ts:166-208`
- `claude-code-source-code/src/utils/dxt/zip.ts:42-101`

## 2. 第一性原理：agent runtime 最怕两种膨胀

一个 agent runtime 最怕的不是“偶尔回答错”，而是两种长期膨胀：

1. 动作膨胀：
   - 本来不该做的动作越来越容易做
2. 上下文膨胀：
   - 本来不该常驻的信息越来越多地常驻

前者最终会表现成：

- 权限绕过
- 风险放大
- 工具滥用

后者最终会表现成：

- cache miss
- 上下文污染
- token 浪费
- 推理退化

Claude Code 的成熟之处在于，它没有把这两件事拆开看。

## 3. 安全侧如何限制无序扩张

### 3.1 Bash read-only 不是“命令白名单”那么简单

`readOnlyValidation.ts` 明确对多种 git 逃逸路径做了专门防护：

- `cd ... && git ...` 复合命令
- bare repo / fake hooks
- 创建 git internal path 再执行 git
- sandbox 下离开 original cwd 的 git 命令

证据：

- `claude-code-source-code/src/tools/BashTool/readOnlyValidation.ts:1914-1965`

这说明安全设计不是“禁止危险工具”，而是：

- 防止本来安全的动作在新上下文里变危险

### 3.2 LSP 和 DXT 也都带着边界意识

LSPTool 会拒绝对 UNC path 做常规文件系统访问。  
DXT zip 解包会检查 traversal、大小、压缩比和文件数。

证据：

- `claude-code-source-code/src/tools/LSPTool/LSPTool.ts:166-208`
- `claude-code-source-code/src/utils/dxt/zip.ts:42-101`

这说明 Claude Code 的安全观是统一的：

- 能力越靠近系统边界，越要显式约束

## 4. token 经济侧如何限制无序扩张

### 4.1 prompt section 被分成 cache-safe 和 dangerous-uncached

这不是性能小技巧，而是明确承认：

- 某些动态信息不应该污染稳定前缀

证据：

- `claude-code-source-code/src/constants/systemPromptSections.ts:27-37`
- `claude-code-source-code/src/constants/prompts.ts:508-520`

### 4.2 tool pool 顺序本身就是 token 设计

`toolPool.ts` 把 built-ins 固定成连续前缀、MCP tools 放到后面。  
这是在保护 server-side prompt cache。

证据：

- `claude-code-source-code/src/utils/toolPool.ts:43-79`

### 4.3 streamlined / consumer subset 也是 token 设计

`streamlinedTransform.ts` 会去掉 thinking、压缩 tool summary。  
`sdkMessageAdapter.ts` 则明确说明不同 consumer 只吃不同消息子集。

证据：

- `claude-code-source-code/src/utils/streamlinedTransform.ts:1-193`
- `claude-code-source-code/src/remote/sdkMessageAdapter.ts:168-278`

它们共同说明：

- 不是所有信息都值得给每个 consumer 看

## 5. 为什么两者其实是同一优化

安全和 token 经济看似一个偏风险，一个偏成本，但它们在结构上高度一致：

1. 都在做最小暴露。
2. 都在做显式边界。
3. 都反对“全量常驻、全量开放”。
4. 都更偏向：
   - 按需加载
   - 显式确认
   - 受控子集

因此，更准确的说法是：

- 安全限制“动作过载”
- token 经济限制“上下文过载”

两者一起服务于：

- 可治理的 agent runtime

## 6. 苏格拉底式追问：为了更省 token，能不能牺牲一点安全

表面上似乎可以，比如：

- 少一点确认
- 少一点约束
- 少一点边界检查

但继续追问：

1. 没有边界检查的“省 token”会不会导致更贵的错误恢复。
2. 没有最小暴露的上下文设计，会不会让模型看到太多无关或危险信息。
3. 真正昂贵的是多几十 token，还是一次错误执行后的补救。

答案通常都指向同一处：

- 更成熟的做法不是牺牲安全换 token，而是把二者一起纳入结构优化

## 7. 对 agent 产品设计的启发

如果要复制 Claude Code 这类产品的强点，最值得学的不是：

- 再写一个 compact

而是：

1. 把高波动信息从稳定前缀中分离。
2. 把高风险动作从默认动作空间中分离。
3. 允许不同 consumer 只消费必要子集。
4. 把“看得见什么”和“做得了什么”都做成最小暴露。

## 8. 一句话总结

Claude Code 的安全设计和 token 设计并不是两套系统，而是同一套 runtime 收敛机制在动作空间与上下文空间上的两个投影。
