# 演练记录样例库：Prompt、治理与结构演化三类完整样例

这一章不给出新模板，而是给出三份完整填表示例。

它主要回答四个问题：

1. 同一张记录 ABI 在三类对象上到底该怎么填。
2. `authority source`、`assembly path`、`decision-gain judgement` 和 `evidence schema` 在实战里长什么样。
3. 怎样把一份记录自然回填到样本层。
4. 怎样用苏格拉底式追问避免把模板填成流水账。

## 1. Prompt 样例

```text
记录名称:
Prompt 修宪后 boundary 漂移回归

时间窗口:
一次 prompt section 调整后的回归窗口

对象类型:
prompt

authority source:
default + append

assembly path:
REPL main path

前提:
- 调整一条 system prompt section 的标题和放置位置
- 当前运行在交互式 REPL

触发器:
- 修宪后首次回归

期望不变量:
- section token 分布保持在预期范围
- dynamic 信息不进入稳定前缀

观测信号:
- dump-system-prompt diff
- section breakdown
- cache break cause

decision-gain judgement:
- 这轮观测能直接判断是否 boundary 漂移，因此值得花费

最终判定:
漂移

根因标签:
boundary drift

修复动作:
invalidate + 调整 section 位置

防再发动作:
新增一条 boundary review case

evidence schema:
- prompt dump
- section token stats
- cache break logs
```

## 2. 治理样例

```text
记录名称:
approval race 退化回归

时间窗口:
一次审批路径改动后的治理回归窗口

对象类型:
governance

authority source:
bridge won the race

assembly path:
interactive permission path

前提:
- hook / local UI / bridge / classifier 同时可用

触发器:
- 审批等待时间异常升高

期望不变量:
- 多通道并发竞速
- winner 明确
- loser 被取消

观测信号:
- permission waiting time
- source logs
- claim winner

decision-gain judgement:
- 若继续等待不能改变 winner，则应尽早结束

最终判定:
退化

根因标签:
approval-race degradation

修复动作:
tighten-order + restore-guard

防再发动作:
新增 race regression

evidence schema:
- request id
- winner source
- timing
- cancellation trace
```

## 3. 结构样例

```text
记录名称:
stale snapshot zombie 演练

时间窗口:
一次 task framework 变更后的恢复演练窗口

对象类型:
structure

authority source:
fresh state

assembly path:
task runtime merge path

前提:
- 存在 await 后状态更新
- 同一对象可能已有新 terminal transition

触发器:
- 注入 stale snapshot 回写场景

期望不变量:
- stale snapshot 不得覆盖 fresh object
- terminal state 不被复活

观测信号:
- generation gate
- merge path
- stale drop log

decision-gain judgement:
- 一旦已确认 stale，不应继续尝试完整覆盖写入

最终判定:
zombie risk

根因标签:
zombification

修复动作:
merge-against-fresh + drop-stale

防再发动作:
新增 anti-zombie drill

evidence schema:
- state version
- stale/fresh compare
- merge outcome
- dropped snapshot trace
```

## 4. 使用协议

这三份样例的作用不是替代真实记录，而是说明：

1. 一条记录怎样从“事故描述”变成“制度记录”。
2. 一条记录怎样自然映射回 `casebooks/04` 标签。
3. 一条记录怎样反过来更新 `playbooks/01-04`。

## 5. 苏格拉底式追问

在你准备填写新记录前，先问自己：

1. 我填的是故事，还是结构化证据。
2. 这条记录能否落回某个明确标签。
3. 这次观测是否真的有 decision gain。
4. 未来团队看到这条记录，能否据此复现与复盘。
