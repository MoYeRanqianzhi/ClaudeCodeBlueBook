# 结构 Host Implementation审读模板：权威路径、恢复资产、反zombie 与危险路径交接

这一章不再解释结构 host implementation 为什么重要，而是把它压成团队可复用审读模板。

它主要回答五个问题：

1. 怎样判断结构 implementation 是否真的围绕 authoritative path、recovery asset ledger 与 rollback object 成立，而不是围绕门禁存在与恢复通过成立。
2. 怎样把 anti-zombie evidence、retained assets、danger paths 与 handoff gate 放进同一张审读卡。
3. 怎样让宿主、CI、评审与交接沿同一审读顺序消费结构 implementation。
4. 怎样识别“门禁存在、恢复通过、规则已写、作者知道危险路径”这类看似合规的假实现。
5. 怎样用苏格拉底式追问避免把源码先进性审读退回目录审美或作者权威。

## 0. 代表性源码锚点

- `claude-code-source-code/scripts/prepare-src.mjs:3-64`
- `claude-code-source-code/scripts/stub-modules.mjs:2-42`
- `claude-code-source-code/src/bridge/replBridgeTransport.ts:13-116`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-167`
- `claude-code-source-code/src/services/api/sessionIngress.ts:60-120`
- `claude-code-source-code/src/utils/cleanupRegistry.ts:1-21`
- `claude-code-source-code/src/utils/QueryGuard.ts:69-106`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`

这些锚点共同说明：

- 源码先进性不是“结构更好看”，而是权威路径、恢复资产、反 zombie 协议与对象级回退能被非作者沿同一骨架继续判断。

## 1. 第一性原理

更成熟的结构 implementation 不是：

- 规则更多

而是：

- 不同角色在不同时间点，仍然围绕同一条权威路径、同一组恢复资产与同一个回退对象继续判断

所以审读结构 implementation 时，最该先问的不是：

- 门禁是不是已经挂上了

而是：

- 当前路径到底是不是唯一权威路径

## 2. Structure Implementation Header

任何结构 implementation 审读都先填这一张统一 header：

```text
审读对象:
authoritative path:
projection set:
current write path:
current read path:
recovery asset ledger:
anti-zombie evidence:
retained assets:
danger paths:
rollback object:
dropped stale writers:
```

团队规则：

1. 没有 authoritative path 的结构卡，不算正式结构卡。
2. 没有 recovery asset ledger 的恢复成功，不算正式恢复证据。
3. 没有 rollback object 与 retained assets 的交接，不算正式结构交接。

## 3. Authority Path Audit

先审当前 authority 是不是活的运行时事实：

```text
[ ] authoritative path 已点名
[ ] current write path 已点名
[ ] current read path 已点名
[ ] projection set 已点名
[ ] 旧路径是否仍可写已点名
```

常见假实现：

1. authority surface 已命名，但旧 writer 仍可写。
2. 目录图很清楚，但读写路径仍然 split-brain。
3. 评审只看命名，不看运行时路径。

宿主审读的关键不是“结构图是否完整”，而是：

- 它有没有重新制造第二条权威路径

## 4. Recovery Asset Audit

恢复成功必须绑定恢复资产，而不是只绑定结果：

```text
[ ] recovery asset ledger 已点名
[ ] retained assets 已点名
[ ] replacement / merge 规则已点名
[ ] stale state 处理规则已点名
[ ] rollback object 能解释恢复边界
```

团队规则：

1. “恢复通过”不能替代 recovery asset ledger。
2. “成功率不错”不能替代 retained assets。
3. “作者知道怎么恢复”不能替代正式台账。

## 5. Anti-Zombie Audit

任何结构 implementation 都要单独审 stale writer：

```text
[ ] anti-zombie gate 已点名
[ ] dropped stale writers 已点名
[ ] 旧 projection 是否仍可回写已点名
[ ] generation / epoch 或等价边界已点名
[ ] 危险路径是否已列入 handoff
```

如果它只剩一条规则说明，那么结构 implementation 已经退回：

- 象征性治理

## 6. Review Order Audit

结构 implementation 更稳的评审顺序是：

1. authoritative path
2. current write / read path
3. projection set
4. recovery asset ledger
5. anti-zombie evidence
6. retained assets
7. rollback object
8. 文件 diff 与目录图

如果顺序被改成：

- 先看目录和 diff，再看对象边界

那么结构审读就已经退回审美评论。

## 7. Handoff Gate Audit

交接时必须先验结构化包，再听作者说明：

```text
[ ] authoritative path 已写清
[ ] retained assets 已写清
[ ] danger paths 已写清
[ ] rollback object 已写清
[ ] dropped stale writers 已写清
[ ] 接手者不问作者也能继续判断
```

任何“听懂了危险，但拿不到结构化对象包”的情况，都应被判定为：

- 结构 implementation 未成立

## 8. 常见自欺

看到下面信号时，应提高警惕：

1. 用门禁存在替代 authoritative path truth。
2. 用恢复通过替代 recovery asset ledger。
3. 用 anti-zombie 规则存在替代 stale writer 已死。
4. 用 danger path 口头说明替代 rollback object。
5. 用结构图更清爽替代对象边界更真实。

## 9. 审读记录卡

```text
审读对象:
authoritative path:
recovery asset ledger:
anti-zombie evidence:
retained assets:
rollback object:
danger paths:
当前最像哪类失真:
- 命名替代权威 / 结果替代资产 / 规则替代清退 / 口头替代交接
下一步应重写的是:
- authority path / recovery ledger / anti-zombie proof / handoff package
```

## 10. 苏格拉底式检查清单

在你准备宣布“结构 host implementation 已经成立”前，先问自己：

1. 我现在消费的是结构 implementation object，还是只是在看门禁与图。
2. 恢复成功是否真的绑定了 recovery asset ledger。
3. anti-zombie gate 约束的是旧路径死亡，还是只是一条写在文档里的原则。
4. rollback object 与 retained assets 是否已经比作者口头说明更早被交付。
5. 我统一的是结构 implementation 真相，还是只统一了一套合规外观。
