# 如何让宿主、评审者与后来者共享同一Rollout ABI：对象、指标、回退与附件消费顺序

这一章不再解释 rollout ABI 为什么重要，而是把“怎样让不同消费者共享同一套证据真相”压成一套 builder-facing 方法。

它主要回答五个问题：

1. 怎样避免宿主、评审者、运维和后来接手者各自维护一套 rollout 真相。
2. 怎样从第一性原理出发，定义对象、指标、回退与附件的统一消费顺序。
3. 怎样让同一套 ABI 同时服务运行时判断、灰度评审和失败回退。
4. 怎样把“回退哪个对象”写清，而不是只写“回退哪些文件”。
5. 怎样用苏格拉底式追问避免把统一 ABI 退化成更多管理噪音。

## 0. 第一性原理

真正有用的 rollout ABI，不是：

- 写给当前作者看的记录

而是：

- 让不同角色在不同时间点，仍消费同一套证据真相

所以更好的问题不是：

- 这张卡够不够完整

而是：

- 宿主、评审者、自动化与后来者，看到的是不是同一个对象、同一个观测窗口、同一个回退边界

## 1. 先统一“对象”，再统一“看法”

这一步最容易被跳过，却最关键。

每份 rollout ABI 开始前，先统一四件事：

1. 对象是什么。
2. 对象的 authoritative surface 在哪里。
3. 哪些字段只是 projection。
4. 失败时应该回退哪个对象。

如果对象没先统一，后面就会出现：

1. 宿主按 session 记
2. 评审者按功能点记
3. 作者按文件改动记
4. 运维按报警事件记

结果是：

- 所有人都在说同一次 rollout，却不是同一个真相

## 2. 再统一“消费顺序”

更稳的消费顺序不是：

- 先看结果
- 再补原因

而是：

1. 先看对象卡
2. 再看当前真相
3. 再看 diff
4. 再看 observed window 与 metrics delta
5. 最后看 rollback target 与 retained assets

原因很简单：

如果消费顺序反过来，大家最先看到的就会是：

- 成本结论
- 成功判断
- 主观解释

而不是：

- 当前到底在升级什么
- 当前判断是依据哪组证据

## 3. 宿主该消费什么，评审者该消费什么

### 3.1 宿主

宿主优先消费：

1. `worker_status`
2. `session_state_changed`
3. `external_metadata`
4. `Context Usage`
5. control request / response / cancel

宿主的职责不是写长解释，而是：

- 保证 authoritative signals 能被稳定留存

### 3.2 评审者

评审者优先消费：

1. `minimal_diff`
2. `entry_rule / exit_rule / stop_rule`
3. `metrics_delta`
4. `unexpected_effects`
5. `judgement`

评审者的职责不是自己重放所有 runtime，而是：

- 检查这轮 rollout 是否真的按制度推进

### 3.3 后来者

后来者优先消费：

1. 对象与 authority surface
2. 当前 retained assets
3. 当前 rollback object boundary
4. 当前 evidence refs

后来者最需要的不是：

- 当时有多热闹

而是：

- 现在还站在什么真相上继续

## 4. 如何定义 observed window

很多 rollout 记录失败，不是因为没有指标，而是因为没有观察窗口。

更稳的写法是把 observed window 显式写成：

1. 时间窗口
2. cohort / scope
3. 当前对象范围
4. 当前有效 baseline

这样做的好处是：

1. 宿主知道该汇总哪一段数据。
2. 评审者知道该对比哪一段变化。
3. 后来者知道当前结论适用于哪一段现场，而不是“永久真理”。

## 5. 回退必须先写对象边界，再写执行动作

回退最容易写成：

- revert commit
- 回滚文件
- 恢复配置

但更稳的写法应先写：

1. 当前回退对象是什么。
2. 这个对象的 authority surface 在哪里。
3. 哪些 stale writer 必须继续挡住。
4. 哪些 assets 可以保留。

然后才写：

1. 具体文件
2. 具体 commit
3. 具体操作

因为文件和 commit 只是执行手段。

真正需要被保住的，是：

- 对象真相不再继续说谎

## 6. 附件消费顺序

更稳的附件消费顺序是：

1. 状态与 metadata
2. transcript / summary / control refs
3. Context Usage / budget evidence
4. diff / cache-break / replacement refs
5. recovery / rollback refs

不要一开始就让所有人扑进：

- 最细的 diff
- 最重的日志
- 最长的 transcript

否则统一 ABI 很快会退化成：

- 谁更熟源码，谁更有解释权

而不是：

- 谁都能沿同一顺序复核

## 7. 最小团队落地法

如果你要在团队中真正推行统一 rollout ABI，建议按下面顺序做：

1. 先用 [../playbooks/12](../playbooks/12-%E7%BB%9F%E4%B8%80Rollout%20ABI%E6%A8%A1%E6%9D%BF%EF%BC%9A%E5%AF%B9%E8%B1%A1%E3%80%81Diff%E3%80%81%E9%98%B6%E6%AE%B5%E3%80%81%E8%A7%82%E6%B5%8B%E4%B8%8E%E5%9B%9E%E9%80%80%E8%AE%B0%E5%BD%95.md) 固定共用骨架。
2. 再用 [../playbooks/13](../playbooks/13-Rollout证据卡样例库：Prompt、治理与结构三类最小填写示例.md) 跑一次最小卡片。
3. 再把宿主字段映射到 [../api/35](../api/35-Rollout%E8%AF%81%E6%8D%AE%E6%B6%88%E8%B4%B9API%E6%89%8B%E5%86%8C%EF%BC%9Aworker_status%E3%80%81external_metadata%E3%80%81Context%20Usage%E4%B8%8E%E5%9B%9E%E9%80%80%E5%AF%B9%E8%B1%A1%E8%BE%B9%E7%95%8C.md) 的正式消费面。
4. 最后再用 [../architecture/76](../architecture/76-升级证据真相面：状态写回、可观测Diff、决策窗口与回退对象.md) 校准对象边界、决策窗口与回退边界。

## 8. 统一消费记录卡

```text
对象:
authority surface:
host-consumed signals:
review-consumed fields:
observed window:
rollback object boundary:
retained assets:
evidence refs:
当前最容易失真的地方:
- 对象漂移 / 顺序错误 / 指标失真 / 回退边界错误 / 附件过载
下一步该补的是:
- object / authority / metrics / rollback / refs
```

## 9. 苏格拉底式检查清单

在你准备宣布“所有角色都已经共享同一套 rollout ABI”前，先问自己：

1. 大家共享的是同一套对象真相，还是只是共享同一张表格。
2. 宿主消费的是 authoritative signals，还是在重复猜状态。
3. 评审者看到的是最小 diff 与观察窗口，还是只看到了结论。
4. 后来者知道该回退哪个对象了吗，还是仍只能回退文件。
5. 我是在降低跨时间、跨角色的判断成本，还是只是增加记录负担。
