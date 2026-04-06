# Prompt宿主修复稳态纠偏执行反例：纸面修正、口头 transcript 恢复与阈值装饰化

这一章不再回答“Prompt 宿主修复稳态纠偏执行该怎样运行”，而是回答：

- 为什么团队明明已经写了 correction card、recovery verdict order、requalification drill 与 threshold reinstatement drill，仍会重新退回假修正卡、口头真相恢复与阈值装饰化。

它主要回答五个问题：

1. 为什么最危险的失败方式不是“没有 correction card”，而是“correction card 存在，却仍围绕 steady note 与 summary 工作”。
2. 为什么纸面修正最容易把 Authority 退回完工票据。
3. 为什么口头真相恢复最容易把 Transcript 退回解释得通就算恢复。
4. 为什么前缀复托管表演与阈值装饰化最容易把 Boundary 与 Continuation 一起退回好运气和默认继续。
5. 怎样用苏格拉底式追问避免把这些反例读成“把 correction card 再填细一点就好”。

## 0. 第一性原理

Prompt 宿主修复稳态纠偏执行真正最容易失真的地方，不在 correction card 有没有写出来，而在：

- Authority、Boundary、Transcript、Lineage 与 Continuation 是否仍围绕同一个世界重建

只要这条链一断，Explainability 层的 `card / prose / reminder` 就会重新篡位。

## 1. 纸面修正：Authority 被完工票据替代

### 坏解法

- 宿主、CI、评审与交接系统虽然都拿到了 `correction_card_id` 与 `correction_verdict=steady_state_restored`，但真正执行时只要 correction card 已存在、字段看起来都填了，就默认 authority 已归还。

### 为什么坏

- correction card 保护的不是“现在像一张正式卡”，而是 correction object 仍指向同一个 authority winner。
- 一旦修正卡退回完工票据，团队就会重新容忍：
  - `compiled_request_hash` 只是抄录值
  - `correction_verdict` 先于 authority 复核生效

### Claude Code 式正解

- correction verdict 应先绑定同一个 authority winner 与同一条 truth lineage，再宣布 restored。

## 2. 口头真相恢复：Transcript 被 prose 替代

### 坏解法

- 团队虽然承认 correction 要验证 transcript repair，但真正执行时只要作者写了一段更完整的说明、summary prose 自洽、later 团队表示“现在我理解了”，就默认 transcript 已恢复。

### 为什么坏

- truth recovery 保护的是同一个 `protocol transcript`，不是“我们又把它说明白了”。
- 一旦 transcript 修复退回 prose，团队就会最先误以为：
  - “解释成立就说明 truth 回来了”
  - “later 读懂了就可以继续”

### Claude Code 式正解

- transcript repair 必须围绕 protocol witness，而不是围绕 prose handoff 与作者语气。

## 3. 前缀复托管表演：Boundary 被 readability 替代

### 坏解法

- 团队虽然承认 correction 要验证 `stable prefix recustody` 与 `lawful forgetting reseal`，但真正执行时只要 compact 之后摘要还能读、最近没触发明显 cache break，就默认前缀资产与合法遗忘边界已经被正式重封。

### 为什么坏

- Boundary 保护的是可缓存、可转写、可继续的前缀资产与合法遗忘边界，不是“看起来还读得通”。
- 一旦复托管退回好运气，团队就会最先误以为：
  - “摘要还能读，应该就还是同一前缀”
  - “最近没再炸，应该就已经 reseal”

### Claude Code 式正解

- correction 应围绕 `stable prefix boundary + lawful forgetting boundary + compaction lineage`，而不是让 readability 冒充托管。

## 4. 阈值装饰化：Continuation 被礼貌提醒替代

### 坏解法

- 团队虽然写了 `continuation_requalification` 与 `threshold_reinstatement`，但真正值班时只要没有硬错误、token 似乎还够、later 也没提出异议，就默认继续；阈值只在交接单里写成“以后有问题再 reopen”。

### 为什么坏

- continuation requalification 本质上是在持续判断“现在还配不配继续”，不是给“先继续一下”找借口。
- threshold reinstatement 本质上是在恢复 future reopen 的正式能力，不是补一条更礼貌的提醒。
- 一旦 threshold 退回装饰，团队就会重新退回：
  - continuation without gate
  - handoff without threshold
  - reopen without boundary

### Claude Code 式正解

- continuation 与 threshold 必须同时成立；没有 threshold，就只能 `hard_reject`、`reentry_required` 或 `reopen_required`。

## 5. Explainability 篡位：correction card 重新当了主语

### 坏解法

- 团队虽然承认 correction card 不应先看，但真正执行时仍先看 `correction card`、`steady note`、`summary prose` 与礼貌 reminder。

### 为什么坏

- 这会让 later maintainer 先学 carrier，再学 same-world compiler。
- 一旦 card 与 prose 成了主语，Authority、Boundary、Transcript、Lineage 与 Continuation 就会退回附属证明。

### Claude Code 式正解

- `correction card / steady note / summary prose / reminder` 都只能留在 Explainability 末端投影层。

## 6. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在修回的是 authority winner，还是一份更正式的修正卡。
2. 我现在保护的是 protocol transcript，还是一段更会安抚人的解释。
3. 我现在保护的是 stable prefix 与 lawful forgetting，还是一次暂时没触发 cache break 的好运气。
4. 我现在恢复的是 continuation qualification，还是一种“先继续再说”的默认冲动。
5. `threshold liability` 还在不在；如果不在，我是在完成纠偏，还是在删除未来反对当前状态的能力。

## 7. 一句话总结

真正危险的 Prompt 宿主修复稳态纠偏执行失败，不是没跑 correction card，而是跑了 correction card 却仍在围绕纸面修正、口头 transcript 恢复与阈值装饰化消费 Prompt 世界。
