# Prompt宿主修复稳态执行反例：authority 假稳态、boundary 好运气与免费继续

这一章不再回答“Prompt 宿主修复稳态执行该怎样运行”，而是回答：

- 为什么团队明明已经写了 steady-state card、continuity verdict order、re-entry threshold 与 residual reopen drill，仍会重新退回假稳态、前缀托管表演与无阈值继续。

它主要回答五个问题：

1. 为什么 Prompt 宿主修复稳态执行最危险的失败方式不是“没有 steady-state card”，而是“steady-state card 存在，却仍围绕 summary 平静感工作”。
2. 为什么假稳态最容易把 Authority 与 Transcript 一起退回“最近一直很稳”的气氛判断。
3. 为什么前缀托管表演最容易把 Boundary 退回摘要好运气与交接叙事。
4. 为什么无阈值继续最容易把 Continuation 退回默认继续与以后再说。
5. 怎样用苏格拉底式追问避免把这些反例读成“把 steady-state card 再填细一点就好”。

## 0. 第一性原理

Prompt 宿主修复稳态执行真正最容易失真的地方，不在 `steady_verdict` 有没有写出来，而在：

- Authority、Boundary、Transcript、Lineage 与 Continuation 是否仍在围绕同一世界工作

只要这条链一断，Explainability 层的 `card / verdict / prose` 就会反客为主。

## 1. 假稳态：Authority 被“最近很稳”替代

### 坏解法

- 宿主、CI、评审与交接系统虽然都拿到了 `steady_verdict=steady_state`，但真正执行时只要 release 之后一段时间没有新噪音，就默认 authority 与 truth 已经稳定。

### 为什么坏

- steady 不是情绪平静，而是 Authority 仍在定义同一个世界。
- 一旦稳态退回平静感，团队就会重新容忍：
  - authority winner 只是收尾名词
  - restored request 只是抄录值
  - steady verdict 先于 authority 复核生效

### Claude Code 式正解

- steady verdict 应先绑定同一个 authority winner，再宣布 steady。

## 2. 前缀托管表演：Boundary 被“摘要还读得通”替代

### 坏解法

- 团队虽然承认 steady 要验证 `stable prefix` 与 `lawful forgetting boundary`，但真正执行时只要 compact summary 还能读、handoff prose 自洽，就默认前缀资产与合法遗忘边界仍被正式托管。

### 为什么坏

- Boundary 保护的是可缓存、可转写、可继续的前缀与遗忘边界，不是解释文本是否完整。
- 一旦 Boundary 退回好运气，团队就会误以为：
  - “summary 很完整，应该就还是同一前缀”
  - “交接很清楚，later 应该能接”

### Claude Code 式正解

- steady 应围绕 `section registry + stable prefix boundary + lawful forgetting boundary + cache-safe reuse`，而不是围绕 summary prose。

## 3. 假 transcript：模型实际消费什么被投影夺权

### 坏解法

- 团队虽然知道 steady 还应看 transcript，但真正执行时只要 display transcript、handoff prose 或 summary 讲得通，就默认模型实际消费的历史也没问题。

### 为什么坏

- `protocol transcript` 保护的是模型真正消费了什么，不是 later 团队现在读起来是否顺滑。
- 一旦投影夺权，Prompt 世界就会从 compiler 退回 narrative。

### Claude Code 式正解

- display transcript、summary prose 与 handoff prose 都只能作为 Explainability 投影，不得反向替代 `protocol transcript`。

## 4. 无阈值继续：Continuation 被免费时间线替代

### 坏解法

- 团队虽然写了 `reopen_threshold`，但真正值班时只要没有硬错误、token 似乎还够、later 也没提出异议，就默认继续。

### 为什么坏

- continuation qualification 本质上是在判断“现在还配不配继续”，不是给“先继续一下”找借口。
- 一旦 threshold 跟着 steady 一起消失，团队就会继承一条没有正式阈值对象的免费时间线。

### Claude Code 式正解

- `current work + required assets + rollback boundary + continuation qualification + reopen threshold` 必须同时成立；没有 threshold，就只能 `steady_state_blocked`、`reentry_required` 或 `reopen_required`。

## 5. Explainability 篡位：steady-state card 重新当了主语

### 坏解法

- 团队虽然承认 card 不应先看，但真正执行时仍先看 `steady-state card`、`steady_verdict`、`verdict_reason`、`watch note`。

### 为什么坏

- 这会让 later maintainer 先学 artifact，再学 same-world compiler。
- 一旦 card 成了主语，Authority、Boundary、Transcript、Lineage 与 Continuation 就会退回附属证明。

### Claude Code 式正解

- `card / verdict / note / prose` 都只能留在 Explainability 末端投影层。

## 6. 苏格拉底式追问

在你读完这些反例后，先问自己：

1. 我现在 steady 的是 authority winner，还是一段更顺滑的稳态叙事。
2. 我现在保护的是 stable prefix 与 lawful forgetting，还是一次暂时没触发 cache break 的好运气。
3. 我现在保护的是 protocol transcript，还是 handoff prose。
4. 我现在放行的是 continuation qualification，还是一种“先继续再说”的情绪。
5. 我现在保留的是 threshold liability，还是一句“以后再看”。

## 7. 一句话总结

真正危险的 Prompt 宿主修复稳态执行失败，不是没写 steady-state card，而是写了 steady-state card 却仍在围绕 authority 假稳态、boundary 好运气与免费继续消费 Prompt 世界。
