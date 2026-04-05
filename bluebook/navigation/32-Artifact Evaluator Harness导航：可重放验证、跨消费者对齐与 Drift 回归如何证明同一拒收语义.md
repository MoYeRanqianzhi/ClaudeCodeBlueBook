# Artifact Evaluator Harness导航：可重放验证、跨消费者对齐与 Drift 回归如何证明同一拒收语义

这一篇不再新增新的规则包，而是回答一个更接近系统验证底盘的问题：

- 当团队已经有 `rule packet`、最小规则样例、失败样例与 evaluator 接口之后，下一步就不该继续停在“能不能跑出结果”，而要把这些样例接成可重放验证、跨消费者对齐与 drift 回归的正式 harness。

它主要回答四个问题：

1. 为什么 Artifact Rule Sample Kit / Evaluator 层之后仍需要单独讨论 evaluator harness / replay lab 层。
2. 为什么真正成熟的重放，不是把脚本再跑一遍，而是让同一 reject reason 在宿主、CI、评审与交接里重复成立。
3. 怎样把 Prompt、安全/省 token 与结构演化三条线分别压成可重放验证实验室。
4. 怎样用苏格拉底式追问避免把这层写成“又一套测试脚本”。

## 1. Prompt Artifact Evaluator Harness

适合在这些问题下阅读：

- 为什么 Prompt 线不能停在最小规则样例，而必须继续证明 `compiled request continuity` 能跨宿主、CI、评审与交接被反复重放。
- 为什么 Claude Code 的 Prompt 魔力进入验证层之后，必须靠 replay harness 才能证明共享的不是文案，而是 continuation 语义。

稳定阅读顺序：

1. `31`
2. `../playbooks/23`
3. `../philosophy/73`

这条线的核心不是：

- 再跑一次规则匹配

而是：

- 证明同一 `prompt_object_id` 断裂时，不同消费者会在同一回放里给出同一拒收

## 2. 治理 Artifact Evaluator Harness

适合在这些问题下阅读：

- 为什么治理线不能停在最小规则样例，而必须继续证明 `decision gain`、`failure semantics` 与 `rollback object` 能跨宿主、CI、评审与交接被反复重放。
- 为什么安全与省 token 设计进入验证层之后，必须靠 replay harness 才能证明共享的是同一“没有决策增益就不该继续”的语义。

稳定阅读顺序：

1. `31`
2. `../playbooks/24`
3. `../philosophy/73`

这条线的核心不是：

- 再跑一次 object-upgrade gate

而是：

- 证明状态色、计数、verdict 与状态摘要在不同消费者里会被同一 rollback / reject 语义拦住

## 3. 结构 Artifact Evaluator Harness

适合在这些问题下阅读：

- 为什么结构线不能停在最小规则样例，而必须继续证明 `authoritative path`、`recovery asset`、`anti-zombie evidence` 与 `rollback object` 能跨宿主、CI、评审与交接被反复重放。
- 为什么源码先进性进入验证层之后，必须靠 replay harness 才能证明共享的是同一 split-brain / anti-zombie 拒收语义。

稳定阅读顺序：

1. `31`
2. `../playbooks/25`
3. `../philosophy/73`

这条线的核心不是：

- 再跑一次结构 gate

而是：

- 证明目录图、恢复成功率与作者说明在不同消费者里会被同一对象级拒收拦住

## 4. 一句话用法

如果：

- `31` 回答“这些规则包怎样被最小样例、失败样例与 evaluator 反复证明”

那么：

- `32` 回答“这些证明怎样被组织成可重放验证、跨消费者对齐与 drift 回归实验室”

## 5. 苏格拉底式自检

在你准备宣布“团队已经有 evaluator harness 了”前，先问自己：

1. 这套 harness 重放的是同一 reject semantics，还是只是在不同消费者上各跑各的脚本。
2. 同一对象断裂时，宿主、CI、评审与交接是否真的会在同一回放里给出同一拒收。
3. 这里验证的是 shared object continuity，还是只验证字段存在与结果数量。
4. drift 回归样本暴露的是对象 split-brain，还是你仍在用四套局部真相解释同一失败。
