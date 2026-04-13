# 好的Prompt同时组织模型与人类接手路径

这页只解释一件事：为什么 Prompt 的“魔力”最后表现为 later consumer 能否不重谈世界就继续工作。`84` 继续拥有 Prompt why 的 owner law，`81` 继续拥有 canonical witness chain；本页只消费那两页已锁定的三条母法则，解释为什么这三条法则会直接改写人类接手成本。

这一章回答四个问题：

1. 为什么 Claude Code 的 prompt 不只在组织模型，也在组织人类下一步如何接手。
2. 为什么真正强的 agent runtime 会主动降低人类-模型协调成本。
3. 为什么 suggestion、sticky prompt、session memory、teammate navigation 都该和 prompt 一起理解。
4. 这对 agent 设计者意味着什么。

## 1. 先说结论

Claude Code 的 prompt 真正高级的一层，不是让人类更容易接手，而是把 later consumer 的拒收权、已排除分支的保留义务与同一工作对象的合法继承一起写进继续接口。

所以这里值钱的也不是“接手路径更顺”，而是 `verify / resume / handoff` 之后，接手者继承的仍是同一份工作对象、同一批仍被排除的分支，以及同一条 `continue-or-reject verdict`。
更硬一点说，人类接手不是体验优化，而是另一个 lawful consumer；系统必须先规定他看到哪层 projection、可拒收什么、何时必须 `reopen`，而不是沿旧资格继续。没有新增 `decision delta` 时，旧判断继续退役，人类也不应只靠 summary 或 display convenience 把它们静默拖回候选集。
这里也要先压住一个常见误读：sticky prompt、suggestion、session memory、handoff note 都更接近 carrier / projection，而不是 witness 本身；它们能帮 later consumer 更快定位现场，但不能绕过 admissibility gate 直接续租 continue 资格。
如果把“Prompt 为什么强”继续压成第一性原理，本页也只认三条 why-proof：`lawful inheritance` 让接手者继承的仍是同一工作对象；`search-pruning` 让已排除分支继续保持被排除；`decision-retirement` 让没有新增 `decision delta` 的旧判断继续退役。所谓 Prompt 魔力，只是系统提前替 later consumer 付掉了“重谈世界、重搜动作、重判旧结论”这三笔税。
也因此，sticky prompt、suggestion、session memory、handoff note 的真正 `effect ceiling` 也该写死：它们最多只配搬运定位、方向、提醒与局部 projection，不配单独改判 `world-definition`、`boundary` 或 `continue qualification`。一旦 later consumer 只能靠这些 carrier 判断“应该还能继续”，Prompt 的强度就应先降回 `provisional`，而不是继续包装成顺滑体验。

## 2. 为什么这很重要

一个 coding agent 真正难的，不只是生成下一步动作。

还包括：

1. 人类是否还能快速理解现场。
2. 人类是否知道该从哪里继续。
3. 人类是否能低成本切回另一条执行链。
4. 人类是否能用最少反馈把模型重新导回正轨。

如果这些成本不被主动压低，再强的模型也会在长期协作里显得笨重。
这些成本之所以必须被压低，也不是为了“更顺手”而已，而是为了让 later consumer 不必重读全量 transcript、不必重做 `world-definition / tool-legality / next-action search`，就能对旧资格做 `continue / reject / reopen` 的正式判断。

## 3. 苏格拉底式追问

### 3.1 prompt 只要把模型组织好就够了吗

不够。

因为长期任务里，人类迟早要接手、确认、切换、纠偏。

### 3.2 suggestion 是在补全文本，还是在降低协调成本

更接近后者；它的价值在于降低 later consumer 重新搜索下一步动作的成本，而不是代签 continue 资格。

### 3.3 sticky prompt 是视觉小优化吗

不只是。

它更像在维护“下一步从哪里继续”的行动锚点；但它最多只配当锚点，不配越权改写世界主语、边界或继续资格。

### 3.4 真正强的 prompt 更像什么

更像：

- 一套提前替 later consumer 退休“重谈世界、重搜动作、重判旧结论”三类税的协作接口

## 4. 对 Agent 设计者的启发

如果想学 Claude Code，最该问的不是：

- 模型看见了什么

还要问：

1. 人类接手时会看见什么。
2. 人类接手时看到的是哪层 projection，而不是哪份 summary 体感；如果看到的只是一份 carrier，却没有 witness rebind，人类接手仍然不算合法继承。
3. 人类如何低成本给出纠偏反馈，同时保留正式 reject 权。
4. 多执行链之间如何切换而不丢现场，并在必要时明确 `reopen` 而不是偷续旧资格。

如果只想先看一个最小 lawful-consumer review object，也只先问四格：

| field | fail signal | pass signal |
|---|---|---|
| `projection kind` | 只拿到 summary / sticky prompt / handoff prose 这类 carrier | 能明确自己看到的是哪层 projection，且没有越权代签 |
| `effect ceiling` | carrier 已经开始静默改判 `world-definition / boundary / continue qualification` | surface 只负责定位、提醒、路由或展示，不越权代签 |
| `witness rebind` | 只能靠体感判断“应该还能继续” | 能点名 `lineage / boundary / continuation verdict` 已回绑 |
| `reject right` | 接手者只能顺着旧资格继续 | 接手者仍可正式做 `continue / reject / reopen` 判断 |
| `delta scope` | 旧判断被整包拖回候选集 | 只重开新增 `decision delta` 真正触及的局部问题 |

这五格不是第二条 Prompt ABI；它只是在本页局部消费 `84` 的 owner law 与 `81` 的 witness chain。只要前面三格里任一格仍停在 carrier 体感，人类接手就还不算 lawful consumer 接手，而只是更顺手地阅读了旧叙事。

## 5. 一句话总结

Claude Code 的 prompt 之所以强，不只是因为它让模型更会继续，而是因为它让 later consumer 不必重判世界、重搜动作空间，或把已排除路径与已退役判断重新拉回候选集；所谓“魔力”只是这三笔税被提前编译进了 witness，而不是被交给 carrier 临时兜底。
