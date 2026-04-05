# Prompt Evidence Envelope落地手册：宿主消费、CI门禁、评审顺序与交接包

这一章不再解释 Prompt evidence envelope 应该长什么样，而是把它压成宿主、CI、评审与交接都能直接执行的一套落地手册。

它主要回答五个问题：

1. Prompt 线真正的 host implementation playbook 到底该检查什么。
2. 宿主、CI、评审与交接分别必须消费哪些信号，哪些属于硬门禁，哪些属于软检查点。
3. 怎样避免 Prompt 再次退回成“原文 prompt + token 指标 + 作者总结”的拼贴。
4. 怎样把 compiled request truth、stable bytes、lawful forgetting 与 handoff state 接成同一流程。
5. 怎样用苏格拉底式追问避免把这章写成纯 checklist。

## 0. 改写前状态

没有 Prompt host implementation playbook 的团队，最常见状态是：

1. 宿主只显示 prompt 原文或最终输出。
2. CI 只看 cache hit / token 曲线。
3. 评审只读作者总结和部分 diff。
4. 交接依赖 transcript 和口头说明。
5. 一旦 Prompt 失稳，团队重新退回文案崇拜。

## 1. 目标状态

迁移后的目标不是：

- 给 Prompt 再补一层看板

而是：

1. 宿主消费当前 Prompt 对象与 handoff state。
2. CI 消费 compiled request truth 与 stable bytes 门禁。
3. 评审先看 authority / assembly / diff，再看解释。
4. 交接先看 lawful forgetting ABI 与 next-step guard，再看历史。
5. 四类角色围绕同一 Prompt envelope 骨架判断。

## 2. 最小落地 diff

### 改写前

```text
宿主:
- 展示 prompt 原文

CI:
- 看 token / cache 指标

评审:
- 读作者总结

交接:
- 读 transcript
```

### 改写后

```text
宿主:
- 展示 current object / pending action / task summary / current mode

CI:
- 检查 compiled request diff / stable bytes / cache-break summary

评审:
- 先看 authority source / assembly path / stable-dynamic boundary

交接:
- 先看 lawful forgetting ABI / current object / next-step guard
```

### 这段 diff 的意义

真正的变化不是：

- 多了几个字段

而是：

- Prompt 证据终于从“材料集合”变成“角色化消费顺序”

## 3. 角色检查点

### 3.1 宿主最小检查点

宿主至少必须消费：

1. 当前 Prompt 对象。
2. 当前 `pending_action`。
3. 当前 `task_summary`。
4. 当前 `permission_mode` / `model`。
5. handoff 需要的 next-step guard。

硬要求：

- 不能只显示 prompt 原文或 assistant 输出。

### 3.2 CI 最小检查点

CI 至少必须检查：

1. compiled request diff 是否越界。
2. stable bytes 是否发生不可解释漂移。
3. cache-break summary 是否能归因。
4. assembly path 是否保持单一主路径。
5. lawful forgetting ABI 是否仍被保留。

硬门禁：

- compiled request truth 缺失
- stable bytes 无法归因
- lawful forgetting ABI 关键位点缺失

### 3.3 评审最小检查点

评审至少必须先看：

1. `authority source`
2. `assembly path`
3. `stable_prefix_surface`
4. `dynamic_boundary_surface`
5. `lawful_forgetting_abi`

软检查点：

- 总结是否准确解释这些字段
- 原文 prompt 改动是否与 compiled diff 一致

禁止事项：

- 只读作者总结就做 Prompt 结论

### 3.4 交接最小检查点

交接至少必须交付：

1. current object
2. current mode
3. pending action
4. task summary
5. next-step guard
6. lawful forgetting 之后仍保留的最小 ABI

硬要求：

- 交接不能只给 transcript 链接

## 4. 统一检查顺序

Prompt 线四类角色更稳的统一顺序是：

1. 当前对象
2. authority source
3. assembly path
4. compiled request diff
5. stable bytes / cache-break summary
6. lawful forgetting ABI
7. handoff state

## 5. Prompt 线硬门禁

下面这些最适合写成硬门禁：

1. `authority source` 缺失。
2. `assembly path` 缺失。
3. compiled request diff 缺失。
4. stable bytes 漂移但无法解释。
5. lawful forgetting ABI 关键字段缺失。
6. handoff state 只剩 transcript，没有结构化 next-step guard。

## 6. 回退与交接包

当 Prompt 线需要回退时，至少保留：

1. 上一版 compiled request summary。
2. stable bytes ledger。
3. cache-break summary。
4. current object / pending action / next-step guard。

回退优先级：

1. 先回退 assembly path / boundary。
2. 再回退 section constitution。
3. 最后才考虑整份原文 prompt。

## 7. 苏格拉底式追问

在你准备宣布 Prompt host implementation 已落地前，先问自己：

1. 宿主、CI、评审与交接是不是都先围绕 compiled request truth 判断。
2. 我保住的是 stable bytes 与 lawful forgetting，还是只保住了 prompt 原文。
3. 任何一个角色现在还能不能只靠原文 prompt 就继续下结论。
4. 如果今天交接，这套包能否在不读全文的前提下继续工作。
