# Prompt Host Implementation审读模板：编译真相、稳定字节、合法遗忘与交接闸门

这一章不再解释 Prompt host implementation 为什么重要，而是把它压成团队可复用审读模板。

它主要回答五个问题：

1. 怎样判断 Prompt implementation 是否真的围绕 compiled request truth 成立，而不是围绕卡片、摘要与原文 prompt 成立。
2. 怎样把 stable bytes、lawful forgetting ABI 与 handoff guard 放进同一张审读卡。
3. 怎样让宿主、CI、评审与交接沿同一审读顺序消费 Prompt implementation。
4. 怎样识别“卡片存在、CI 通过、顺序走完、摘要导出”这类看似合规的假实现。
5. 怎样用苏格拉底式追问避免把 Prompt 审读退回文案评论。

## 0. 代表性源码锚点

- `claude-code-source-code/src/constants/prompts.ts:491-557`
- `claude-code-source-code/src/constants/systemPromptSections.ts:17-43`
- `claude-code-source-code/src/utils/systemPrompt.ts:28-104`
- `claude-code-source-code/src/utils/messages.ts:1989-2148`
- `claude-code-source-code/src/services/api/promptCacheBreakDetection.ts:243-520`
- `claude-code-source-code/src/services/compact/sessionMemoryCompact.ts:232-437`
- `claude-code-source-code/src/services/compact/postCompactCleanup.ts:31-62`
- `claude-code-source-code/src/utils/sessionState.ts:92-146`
- `claude-code-source-code/src/services/api/sessionIngress.ts:57-170`

这些锚点共同说明：

- Prompt 的魔力不是来自更长文案，而是来自编译真相、稳定字节、合法遗忘与交接闸门共同维持的可继续行动语义。

## 1. 第一性原理

更成熟的 Prompt implementation 不是：

- 卡片更多

而是：

- 不同角色在不同时间点，仍然围绕同一份编译真相继续判断

所以审读 Prompt implementation 时，最该先问的不是：

- 这些卡片是不是都填了

而是：

- 它们是否仍然共同指向同一份 compiled request truth

## 2. Prompt Implementation Header

任何 Prompt implementation 审读都先填这一张统一 header：

- 这张 header 只消费 `philosophy/84` 已固定的 canonical Prompt ABI，不在这里重定义字段语义。

```text
审读对象:
authority source:
assembly path:
compiled request summary:
compiled request diff:
message_lineage_ref:
section_registry_ref:
stable_prefix_ref:
protocol_transcript_ref:
continuation_object_ref:
stable bytes ledger:
lawful forgetting ABI:
current object:
pending action:
next-step guard:
continue_qualification_verdict:
rollback object:
```

团队规则：

1. 没有 authority source 的 Prompt 卡片，不算正式实现卡。
2. 没有 compiled request diff 的 CI 绿灯，不算正式实现证据。
3. 按 `philosophy/84` canonical naming 填写的必填 refs 里任一缺席，或 `continue_qualification_verdict` 缺席，host / handoff 一律视为硬阻断。
4. 没有 lawful forgetting ABI 与 next-step guard 的 handoff，不算正式交接。

## 3. Host Surface Audit

先审宿主是否仍在消费同一对象真相：

```text
[ ] 宿主展示的是 current object，而不是 prompt 原文截图
[ ] authority source 已点名
[ ] assembly path 已点名
[ ] compiled request summary 能回到真实请求对象
[ ] 按 `philosophy/84` canonical naming 填写的必填 refs 与 `continue_qualification_verdict` 都能被反查
[ ] next-step guard 没被摘要包吞掉
```

常见假实现：

1. 宿主卡片只展示 prompt 原文或作者总结。
2. 宿主把 assistant 最后一条输出误当当前对象。
3. 宿主把 suggestion、side question 或 UI 装饰混入主任务真相。

宿主审读的关键不是“看起来信息够多”，而是：

- 它有没有重新生产第二份 Prompt 真相

## 4. Stable Bytes Audit

任何 CI 或评审都必须单独审稳定字节，而不是只审 pass / fail：

```text
[ ] stable bytes 变化是否点名
[ ] drift 是否有解释
[ ] cache-break summary 是否存在
[ ] compiled request diff 是否能解释 drift
[ ] 变化是否影响 replay / cache key
```

团队规则：

1. 绿灯不能替代 drift explanation。
2. cache hit 不能替代 stable bytes ledger。
3. “这次只是环境波动”不是正式证据。

## 5. Lawful Forgetting Audit

compact、summary、handoff 一律沿同一 ABI 审：

```text
[ ] current object 仍可指出
[ ] pending action 仍可指出
[ ] task summary 仍可继续行动
[ ] next-step guard 仍存在
[ ] kept tail 没切断协议连续性
[ ] transcript 是否只是辅证
```

核心原则不是：

- 忘得少一点

而是：

- 忘掉之后系统仍能合法地继续

## 6. Review Order Audit

Prompt implementation 更稳的评审顺序是：

1. authority source
2. assembly path
3. compiled request diff
4. stable bytes ledger
5. lawful forgetting ABI
6. next-step guard
7. 摘要与解释

如果顺序被改成：

- 先看作者总结，再看字段

那么 Prompt 审读就已经退回修辞审读。

## 7. Handoff Gate Audit

交接时必须先验闸门，再验摘要：

- 六个 ABI ref 与 `continue_qualification_verdict` 是交接硬闸门，不是“有就更好”的补充字段。

```text
[ ] current object 已写清
[ ] pending action 已写清
[ ] next-step guard 已写清
[ ] rollback object 已写清
[ ] message lineage ref 已写清
[ ] section registry ref 已写清
[ ] stable prefix ref 已写清
[ ] protocol transcript ref 已写清
[ ] continuation object ref 已写清
[ ] lawful forgetting 之后保留的 ABI 已写清
[ ] continue qualification verdict 已写清
[ ] 如果不读全文，接手者仍能继续
```

任何“必须通读全文才能接手”的情况，都应被判定为：

- Prompt implementation 未成立

## 8. 常见自欺

看到下面信号时，应提高警惕：

1. 用宿主卡片替代 compiled request truth。
2. 用 CI 绿灯替代 stable bytes explanation。
3. 用评审顺序完成替代真实对象判断。
4. 用摘要包存在替代 lawful forgetting ABI。
5. 用“大家都看到了材料”替代“大家都审了同一对象”。

## 9. 审读记录卡

```text
审读对象:
authority source:
assembly path:
compiled request diff:
message_lineage_ref:
section_registry_ref:
stable_prefix_ref:
protocol_transcript_ref:
continuation_object_ref:
stable bytes drift:
lawful forgetting ABI:
handoff guard:
continue_qualification_verdict:
当前最像哪类失真:
- 卡片替代真相 / 绿灯替代解释 / 顺序替代判断 / 摘要替代交接
下一步应重写的是:
- host card / CI report / review order / handoff package
```

## 10. 苏格拉底式检查清单

在你准备宣布“Prompt host implementation 已经成立”前，先问自己：

1. 我现在消费的是 compiled request truth，还是只是在看卡片与摘要。
2. 这次稳定，是因为 stable bytes 被治理，还是因为还没撞上坏样本。
3. 交接留下的是 lawful forgetting 之后的 ABI，还是一段更短的历史。
4. 如果今天换人，接手者拿到的是 next-step guard，还是 transcript archaeology。
5. 我统一的是 Prompt implementation 真相，还是只统一了一套格式。
