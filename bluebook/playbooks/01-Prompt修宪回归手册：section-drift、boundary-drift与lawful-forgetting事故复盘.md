# Prompt修宪回归手册：section-drift、boundary-drift与lawful-forgetting事故复盘

这一章把 `guides/27` 继续推进到运营层。

它主要回答五个问题：

1. Prompt Constitution 为什么最终必须进入回归与事故复盘，而不是只停在修宪模板。
2. prompt 失稳时，团队应先查哪些制度字节，而不是凭感觉说“最近魔力变差了”。
3. 怎样把 section drift、boundary drift、lawful forgetting 失败与 invalidation 漂移放进同一套复盘框架。
4. 怎样让 prompt 变更进入正式 regression ritual，而不是靠个别维护者记忆。
5. 怎样用第一性原理与苏格拉底追问避免把 prompt 再写回神秘文案。

## 0. 代表性源码锚点

- `claude-code-source-code/src/constants/prompts.ts:491-557`
- `claude-code-source-code/src/constants/systemPromptSections.ts:17-43`
- `claude-code-source-code/src/utils/systemPrompt.ts:28-104`
- `claude-code-source-code/src/services/compact/compact.ts:330-340`
- `claude-code-source-code/src/services/compact/postCompactCleanup.ts:31-62`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:437-520`
- `claude-code-source-code/src/utils/analyzeContext.ts:937-1048`
- `claude-code-source-code/src/entrypoints/cli.tsx:50-90`
- `claude-code-source-code/src/memdir/memoryTypes.ts:228-240`

这些锚点共同说明：

- Claude Code 的 prompt 强，不只是因为它被设计过，而是因为它被持续回归、持续解释、持续清理漂移。

## 1. 第一性原理：Prompt 的魔力为什么必须进入运营层

从第一性原理看，prompt 真正昂贵的不是：

- 写一段更强的 system prompt

而是：

- 在多轮修宪、多入口、compact、恢复和缓存条件下，仍然让系统维持同一部有效宪法

因此真正强的 prompt 系统，最终都必须能回答四件事：

1. 哪条条款漂移了。
2. 它为什么漂移。
3. 漂移后是否仍然合法。
4. 如何把系统带回合法状态。

这就是 `playbook` 存在的理由。

## 2. Prompt 事故分类

最常见的事故不是“文案不够强”，而是下面五类：

```text
1. section drift
- 条款内容或顺序变了，但变更没有被制度化

2. boundary drift
- 原本应在动态边界后的信息，被误塞回稳定前缀

3. sovereignty drift
- 本应高位主权决定的内容，被 append 或低位 patch 偷渡改写

4. lawful-forgetting failure
- compact / recovery 后历史看似被压缩，实际协议连续性已断

5. invalidation drift
- 条款、工具、beta、transport 变了，但缓存或 triage 仍按旧世界运行
```

只有把事故先按制度类型命名，团队才不会把不同根因都叫成：

- “prompt 变差了”

## 3. 修宪前回归仪式

任何 prompt 变更，在进入主线前都先跑这四步：

```text
1. Constitution Diff
- 哪个 section 变了
- 它属于稳定正文还是动态修正案

2. Boundary Review
- 新内容是否应进 boundary 前
- 是否更适合 attachment / delta

3. Sovereignty Review
- 这次变更是否影响角色主权链

4. Forgetting Review
- compact / recovery 之后 ABI 是否仍成立
```

最关键的不是“这次内容写得对不对”，而是：

- 这次修改是否改变了 prompt 的制度结构

## 4. Prompt Regression Ritual

每次修宪后至少跑下面这组回归：

```text
[ ] 用 --dump-system-prompt 导出 effective prompt
[ ] 检查 section breakdown 是否符合预期
[ ] 检查 token 占比是否出现异常膨胀
[ ] 检查 promptCacheBreakDetection 是否出现新的 break cause
[ ] 检查 compact 之后的 summary / tail / attachments 是否仍合法
[ ] 检查 worktree / transport 切换后的 invalidation 是否正确发生
```

如果不能稳定做这组回归，所谓 Prompt Constitution 仍然只是设计理念，不是工程制度。

## 5. Prompt 事故复盘模板

可以直接用下面这张单子复盘：

```text
事故现象:
是输出变差、成本变高，还是 cache hit 降低:

事故分类:
- section / boundary / sovereignty / forgetting / invalidation

触发点:
- 哪个 commit / 哪次配置变更 / 哪个入口变化

制度字节:
- 哪些 section
- 哪个 boundary
- 哪个 tool / beta / transport

修复动作:
- 回滚 / 调整边界 / 更新失效台账 / 修改 compact ABI

防再发动作:
- 新增 triage 步骤
- 新增 regression case
- 新增 invalidation rule
```

## 6. Lawful-Forgetting 演练

Prompt Constitution 在 compact / recovery 条件下最容易失效，所以应定期演练：

```text
演练 1:
- 强制 compact，检查 summary + tail + attachments 是否仍可继续任务

演练 2:
- 切换 worktree 或 source class，检查 prompt invalidation 是否发生

演练 3:
- 模拟恢复补边，检查 tool pairing / thinking ownership 是否仍成立
```

演练的目的不是追求零变化，而是确认：

- 系统即使合法地忘，也没有忘掉继续工作的文法

## 7. 修宪后的苏格拉底式追问

在你准备宣布“这次 prompt 改得更强”之前，先问自己：

1. 我改的是内容，还是改了宪法结构。
2. 这次变化应该进正文、动态修正案，还是 delta。
3. compact / recovery 之后，我是否仍保住了继续工作的 ABI。
4. 如果今天出事故，我是否能指出是哪一类制度字节漂移。
5. 我是否已经把这次变化写进回归仪式，而不是只留在脑中。

## 8. 一句话总结

Prompt Constitution 的终局不是“写出好 prompt”，而是把修宪、回归、失效、复盘做成正式运营制度。
