# Prompt Constitution审读模板：section card、修宪工作流、失效台账与triage runbook

这一章不再解释 Prompt Constitution 是什么，而是把它压成团队可执行模板。

它主要回答五个问题：

1. 怎样把 prompt 改动当成修宪，而不是文案微调。
2. 怎样把 section、boundary、主权链、合法遗忘与 triage 放进同一张工作卡。
3. 怎样审计 prompt 失稳，而不是凭感觉说“最近魔力变差了”。
4. 怎样记录 invalidation，而不是让 section cache 漂移成口头知识。
5. 怎样用苏格拉底式追问避免把 prompt 又写回神秘长文本。

## 0. 代表性源码锚点

- `claude-code-source-code/src/constants/prompts.ts:491-557`
- `claude-code-source-code/src/constants/systemPromptSections.ts:17-43`
- `claude-code-source-code/src/utils/systemPrompt.ts:28-104`
- `claude-code-source-code/src/utils/api.ts:321-388`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/services/compact/compact.ts:330-340`
- `claude-code-source-code/src/services/compact/sessionMemoryCompact.ts:232-437`
- `claude-code-source-code/src/services/compact/postCompactCleanup.ts:31-62`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:437-520`
- `claude-code-source-code/src/utils/analyzeContext.ts:937-1048`
- `claude-code-source-code/src/entrypoints/cli.tsx:50-90`

这些锚点共同说明：

- Claude Code 的 prompt 已经是 section registry、角色主权链、动态边界、合法遗忘与可观测 triage 共同维护的一部可编译宪法。

## 1. Section Constitution Card

任何新增或修改 section，都先填这张卡：

```text
Section Name:
目标:
是否位于 dynamic boundary 前:
默认 cache scope:
触发 invalidation 的事件:
如果会打碎稳定性，原因是什么:
谁有权改它:
它影响哪些 transport / adapter:
如何观测它的 token 占比与 cache-break:
```

最重要的不是“描述功能”，而是把下面三件事一次写清：

1. 这条条款属于稳定正文，还是动态修正案。
2. 这条条款由谁立法、谁覆写、谁只能追加。
3. 这条条款一旦变化，会打碎哪些稳定字节。

## 2. Role Sovereignty Matrix

在修改 prompt 正文之前，先锁定主权链：

```text
override:
- 能否完全替换默认宪法

coordinator:
- 能否替换执行者身份

agent:
- 是正式替换，还是只在默认之上附加

custom:
- 是组织级补丁，还是任务级补丁

default:
- 作为哪一层的兜底正文

append:
- 哪些内容只能末尾追加，不能越权改写前文
```

团队规则：

1. 不允许用“最后再 append 一段”偷渡更高位主权。
2. fork / resume 必须明确沿用哪一份 rendered prompt。
3. 任何角色调整都要被当成修宪，而不是提示词润色。

## 3. Prompt Amendment Workflow

每次修宪按六步走：

1. 先写 `Section Constitution Card`。
2. 再确认 `Role Sovereignty Matrix` 是否被越权修改。
3. 再判断内容是在 boundary 前、boundary 后，还是应下沉成 delta attachment。
4. 再补 `Lawful Forgetting ABI` 是否仍成立。
5. 再更新 `Prompt Invalidation Ledger`。
6. 最后才跑 triage 与回归。

如果这六步顺序被打乱，最常见的后果是：

1. section 已改，但 invalidation 没同步。
2. 某条动态信息误入稳定前缀。
3. compact 之后任务还能看起来继续，实际已经丢了协议连续性。

## 4. Boundary Placement Checklist

任何新信息在进入 prompt 前，先过这张表：

```text
[ ] 它是否必须进入稳定前缀
[ ] 它是否只是回合级动态修正案
[ ] 它是否更适合进入 delta / attachment
[ ] 它是否会频繁变化并打碎 cache key
[ ] 它是否会污染多个 transport 共享的宪法正文
```

经验规则：

1. 高频漂移信息优先后置，不优先前置。
2. transport 差异优先被编译进 adapter / delta，不优先写死在宪法正文。
3. 任何必须用 `DANGEROUS` 方式进入的条款，都要在变更评审里单列理由。

## 5. Lawful Forgetting ABI Checklist

compact、session memory compact、recovery 一律按同一张 ABI 检查：

```text
[ ] compact boundary 是否保留
[ ] summary 是否仍能解释当前任务
[ ] kept tail 是否保住最近协议连续性
[ ] tool pairing 是否没被切断
[ ] thinking ownership 是否未漂移
[ ] recovery 补边是否仍合法
[ ] attachments / hook results 是否已重新注入
```

核心原则不是“记得更多”，而是：

- 忘掉之后系统仍然合法地继续

## 6. Prompt Invalidation Ledger

团队应长期维护一张失效台账，而不是把 invalidation 逻辑藏在代码里：

```text
触发器:
- compact cleanup
- worktree 切换
- repo class / source class 变化
- tool / beta / model / attachment 变化

影响面:
- 哪些 section cache 失效
- 哪些 fingerprint 会变化
- 哪些 triage 指标应重新采样
```

这张台账的意义是：

1. 变更时知道该清什么，不该清什么。
2. 排障时知道哪种漂移是预期 invalidation，哪种是真 bug。
3. 回归时知道“更贵了”到底是制度变化，还是系统失稳。

## 7. Prompt Triage Runbook

当 prompt 失稳或“魔力变差”时，按这条链排查：

1. 先用 `--dump-system-prompt` 抽出当前 effective prompt。
2. 再用 `/context` 或 context breakdown 看 section / message / tool 分布。
3. 再看 `analyzeContextUsage()` 输出是否出现异常膨胀。
4. 再看 `promptCacheBreakDetection` 记录的 break cause。
5. 最后才判断是内容问题、边界问题、主权问题，还是 invalidation 问题。

不要直接问：

- “最近 prompt 是不是写差了”

先问：

- “是哪一类制度字节改了”

## 8. Review Checklist

```text
[ ] 每条新 prompt 内容都已进入 section card
[ ] boundary 选择有书面理由
[ ] 主权链没有被 append 偷渡
[ ] lawful forgetting ABI 仍成立
[ ] invalidation ledger 已更新
[ ] triage runbook 已跑过
[ ] cache-break 原因可解释
```

## 9. 苏格拉底式检查清单

在你继续改 prompt 前，先问自己：

1. 我是在修宪，还是在堆匿名文本。
2. 我改的是内容，还是改了主权链。
3. 这条变化应进正文、动态修正案，还是 delta。
4. compact 之后我是否仍保住了合法继续所需的 ABI。
5. 这次变化若导致失稳，我是否已经知道要去看哪张台账和哪条 runbook。
