# 治理 Rollout样例：从规则堆叠到统一定价秩序的灰度记录

这一章不再给治理迁移工单，而是给一份完整 rollout 样例。

它主要回答五个问题：

1. 一套规则堆叠系统如何渐进迁到治理顺序系统。
2. rollout 期间该如何证明系统是在减少免费扩张，而不是增加治理噪音。
3. 怎样记录 stable bytes、decision gain、自动化租约和 continuation 的灰度变化。
4. 怎样判断一轮治理升级是真的更稳，还是只是更慢。
5. 怎样用苏格拉底式追问避免把 rollout 样例写成“成本优化故事”。

## 0. 改写前状态

旧系统的典型状态是：

1. 更多输入、更多工具、更多状态默认暴露给模型。
2. 安全、审批、compact、continuation 由各自规则局部处理。
3. classifier、ask、retry 经常在无决策增益时继续运行。
4. 自动化只有开启条件，没有明确撤销条件。
5. 出现 `cache break`、`cost spike`、`wrong deny` 时只能靠直觉排查。

## 1. 目标状态

迁移后的目标不是：

- 更少 token

而是：

1. 资产清单清楚。
2. 治理顺序固定。
3. stable bytes 冻结并可审计。
4. decision gain 可解释。
5. 自动化是可撤销租约。
6. continuation 已对象化，不再默认继续对话。

## 2. 最小顺序 diff 样例

### 改写前

```text
收到动作请求
-> 看 mode
-> 命中 allow rule 就直接放行
-> 否则跑 classifier
-> classifier 不确定就 ask
-> ask 后如果还不行就 retry / continue
```

### 改写后

```text
收到动作请求
-> 先做输入边界裁剪与 source gating
-> 再做不可绕过的 hard guard
-> 再进入 mode / rule 决策
-> 只有在仍有决策增益时才跑 classifier
-> classifier 无增益时直接回退人工
-> continuation 先判断是否该升级对象，而不是默认继续
```

### 这段 diff 的意义

旧系统的问题不是：

- 规则太少

而是：

- allow rule 太早拿到主权
- classifier 被迫为本该更早决定的问题烧 token
- continuation 被当成默认出路

## 3. Rollout 阶段

### Phase 0：基线冻结

动作：

1. 盘点现有规则、输入面、审批链、compact / continue 逻辑。
2. 建立症状基线：`cache break / cost spike / wrong allow / wrong deny / split truth / stale state`。
3. 列出 stable bytes 候选：prompt section、tool schema、betas、effort、headers、replacement markers。

观测指标：

- 平均 input token
- cache read / creation 比例
- 审批等待时长
- `wrong allow / wrong deny`
- compact 后继续失败率

回退条件：

- 无。此阶段只记录不切流。

### Phase 1：输入边界收口

动作：

1. 高波动说明迁出主 prompt，改为 attachment / delta / deferred。
2. 收紧默认工具可见面。
3. 把不应长驻上下文的状态移出主前缀。

观测指标：

- 主 prompt token 变化
- 高波动输入进入主前缀的频率
- cache break 触发原因变化

回退条件：

- 关键能力被错误隐藏，任务完成率明显下降。
- 模型因信息不足频繁进入无效 ask / retry。

### Phase 2：治理顺序改写

动作：

1. 建立固定判定链：source gating -> hard guard -> mode / rule -> classifier -> human fallback。
2. 危险 fast-path 单独 inventory。
3. 禁止 classifier 和审批路径抢主判断权。

观测指标：

- `wrong allow / wrong deny`
- 审批延迟
- approval race 退化率
- 重复检查但结论未变的比例

回退条件：

- 误放行上升。
- 审批链明显串行化。

### Phase 3：decision gain stop-logic

动作：

1. 为 classifier、retry、ask、compact、continuation 定义“还能改变什么决定”。
2. 增益归零时，停止自动链并回退人工或升级对象。

观测指标：

- 平均单次任务 token 花费
- classifier 调用次数 / 有效改变决策次数
- 无效 compact 次数

回退条件：

- 停止逻辑过早触发，任务完成率下降。
- token 降了，但误判明显增加。

### Phase 4：自动化租约化

动作：

1. 为 auto mode、fast-path、自动 continuation 定义 lease、撤销条件和接管点。
2. denial 累积、环境变化、上下文超长、策略变更时自动回收。

观测指标：

- auto mode 平均持续时长
- lease 正常回收率
- 自动路径下的 `wrong allow / wrong deny`

回退条件：

- 出现不可撤销自动化。
- 回收后系统进入 ask / retry 死循环。

### Phase 5：continuation 对象化

动作：

1. 区分 session、task、worktree、compact continuation。
2. 明确升级对象门槛。
3. compact / resume / replay 统一服从 lawful forgetting 与恢复不变量。

观测指标：

- task / worktree 升级率
- long-session 继续失败率
- replay mismatch / stale state 次数

回退条件：

- continuation 中断过多。
- compact 后恢复质量明显下降。

## 4. 评审问题卡

```text
本轮先收回了哪类免费扩张:
- 动作 / 能力 / 上下文 / 时间

当前治理顺序是否已固定:

stable bytes 是否已冻结:

这轮 token 花费还在改变什么决定:

自动化是否已有撤销条件:

如果回退，先回退哪一层:
```

## 5. 灰度结果样例

```text
阶段:
Phase 3 decision-gain stop-logic

观测:
- classifier 调用 -23%
- input tokens -8%
- wrong deny 持平
- 审批等待时间 -15%

结论:
- 系统开始减少无增益判断
- 但 auto lease 尚未接管，仍存在错误 continuation 风险
```

## 6. 回退记录样例

```text
触发器:
- approval race 退化为串行，人工等待时间上升 42%

定位:
- 新顺序把 classifier 放到了 human fallback 前

回退动作:
- 回退 Phase 2 顺序改写
- 保留 Phase 0-1 资产清单与输入边界收口成果

防再发:
- 把 approval race 竞速图写入 playbooks/07
- 将失败样例回填 casebooks/11
```

## 7. 苏格拉底式追问

在你准备宣布治理 rollout 完成前，先问自己：

1. 这次 rollout 先收回的是哪种免费扩张。
2. 我减少的是 token，还是减少了无意义判断。
3. 这轮自动化真的仍受主权约束吗。
4. 如果系统现在更慢，我能解释这是更稳，还是更糟吗。
5. 这份样例是否足够让后来者复跑同样的 rollout 判断。
