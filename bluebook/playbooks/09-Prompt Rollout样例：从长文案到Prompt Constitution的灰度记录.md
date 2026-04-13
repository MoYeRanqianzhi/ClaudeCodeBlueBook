# Prompt Rollout样例：从长文案到Prompt Constitution的灰度记录

这一章不再给 Prompt 迁移工单，而是给一份完整 rollout 样例。

它主要回答五个问题：

1. 一套旧式长文案 prompt 系统如何渐进迁到 Prompt Constitution。
2. rollout 期间应留下哪些可复查的 diff、指标和回退记录。
3. 怎样判断 section、边界、共享前缀与 later-consumer 继续资格是否真的变稳。
4. 怎样避免“文案变了很多，但制度并没有稳定下来”的假迁移。
5. 怎样用苏格拉底式追问避免把 rollout 样例写成成功学故事。

## 0. 改写前状态

旧系统的典型状态是：

1. 所有规则、风格、工具说明和异常提醒堆在一段总 prompt 里。
2. 不同入口各自拼一份“差不多”的上下文。
3. compact 后只保留摘要，接手依赖回看长历史。
4. cache break 只能感知成本变高，不能解释是哪类制度字节漂移。

## 1. 目标状态

迁移后的目标不是：

- 一段更强的新 prompt

而是：

1. 主语链清楚。
2. section 宪法成立。
3. stable prefix 与 dynamic boundary 分开。
4. 共享前缀生产权单一。
5. lawful forgetting ABI 成立。
6. state 与 summary 只作为载体，而真正被合法继承的是同一工作对象、同一组排除分支与同一条继续资格判定；没有新增 `decision delta` 时，旧判断继续退役，不再被 rollout 偷拉回候选集。

## 2. 最小 diff 样例

### 改写前

```text
你是一个会写代码的助手。
你需要遵守项目规则、尽量少花 token、正确使用工具、在必要时请求权限。
如果任务复杂，请自己判断是否并行。
如果上下文太长，请总结之前做过的工作并继续。
```

### 改写后

```text
[Section: Role Sovereignty]
- system 负责边界、权限与继续条件
- user 负责目标与约束
- task object 负责当前工作对象

[Section: Stable Constitution]
- 工具使用、权限与恢复规则属于稳定前缀

[Boundary]
- 临时观测、一次性结果与高波动状态不得进入稳定前缀

[Lawful Forgetting ABI]
- compact 后必须保住当前主语、当前工作对象、已排除分支、pending action、next-step guard 与 continue qualification verdict
```

### 这段 diff 的意义

真正的变化不是：

- prompt 更长了还是更短了

而是：

- 主语被制度化
- 边界被显式化
- 压缩与恢复被纳入同一份宪法

## 3. Rollout 阶段

### Phase 0：盘点与 shadow 对照

动作：

1. 把旧 prompt 按主语、规则、动态事实、工具可见性、恢复 ABI 拆槽。
2. 用 shadow assembly 生成新旧两份 effective prompt。
3. 不切线上行为，只做 diff 与成本观测。

观测指标：

- section diff 数量
- stable prefix token 规模
- cache read / cache creation 比例
- handoff 依赖全文回看的频率

回退条件：

- 新旧 prompt 同一任务出现 path parity split。
- 团队无法说明每个 section 的职责。

### Phase 1：先切只读旁路路径

动作：

1. suggestion、summary、side query 改读新 constitution。
2. 主线程仍保留旧 assembly，防止一次性打碎主路径。

观测指标：

- suggestion 命中率
- summary 后同一工作对象 / 已排除分支继承成功率
- 旁路路径 cache break 变化

回退条件：

- 旁路输出开始偏离主线程当前真相。
- summary 明显丢失 pending action 或 mode。

### Phase 2：切稳定前缀

动作：

1. 主线程改用新的 stable constitution。
2. 旧动态尾部仍保留，先不切 boundary。

观测指标：

- stable prefix token 波动
- cache 命中率
- effective prompt diff 的可解释性

回退条件：

- cache break 原因无法解释。
- 成本上升但无法归到具体 section。

### Phase 3：切动态边界与状态外化

动作：

1. 把高波动状态迁出 stable prefix。
2. 接手信息改从 metadata / summary / snapshot 读取，而不是继续靠 prompt 背全文。

观测指标：

- dynamic tail token 规模
- handoff 连续性
- externalized state 的读取正确率
- 已排除分支重新回流次数

回退条件：

- 人类接手成功率下降。
- 需要回翻全文才能继续的场景变多。

### Phase 4：切 compact / resume / handoff

动作：

1. compact、resume、handoff 统一服从新的 lawful forgetting ABI。
2. 清理旧摘要逻辑和重复 assembly 路径。

观测指标：

- compact 后续行成功率
- replay mismatch 次数
- resume 后主语漂移次数
- zero-delta judgment relapse 次数

回退条件：

- compact 后无法继续工作。
- resume 后主语或当前对象错误。

## 4. 评审问题卡

```text
这次迁移先收口了什么:
- 主语 / section / boundary / inheritance / pruning / retirement

当前仍保留的旧路径:

为什么这一步可以先切:

为什么这一步不能最后切:

如果指标恶化，先回退哪一层:

当前最像哪类风险:
- section drift / boundary drift / same-world inheritance failure / branch-pruning relapse / decision-retirement relapse
```

## 5. 灰度结果样例

```text
阶段:
Phase 2 stable prefix cutover

观测:
- stable prefix tokens -18%
- cache read ratio +11%
- side query parity stable
- handoff continuity unchanged
- excluded-branch reopen = 0

结论:
- constitution 拆分开始带来成本收益
- 但 dynamic boundary 尚未切换，resume 成本仍高
```

## 6. 回退记录样例

```text
触发器:
- compact 后 resume 失败率从 2% 升到 9%

定位:
- lawful forgetting ABI 丢失 pending action，且把一条已排除分支重新拉回候选集

回退动作:
- 回退 Phase 4 handoff/compact 切换
- 保留 Phase 0-3 的 section / boundary / shadow assembly 成果

防再发:
- 给 summary 增加 pending action 与 excluded-branch 校验
- 把这次失败写入 casebooks/10 对照样例
```

## 7. 苏格拉底式追问

在你准备宣布 Prompt rollout 完成前，先问自己：

1. 我改变的是文案，还是改变了制度体。
2. 这轮 rollout 保住的是 lawful inheritance、排除分支继续退役与 zero-delta judgment retirement，还是只是 cache / handoff 体感。
3. 哪一层最适合 shadow，哪一层必须最后切换。
4. 如果今天回退，我回退的是哪段 assembly，而不是整个 Prompt Constitution。
5. 这份样例能否让后来者复现同样的迁移判断。
