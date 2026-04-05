# Rollout模板导航：统一Diff卡、阶段评审卡、灰度结果卡与回退记录ABI

这一篇不新增新的制度判断，而是回答一个更接近长期运营复用的问题：

- 当团队已经有迁移工单，也已经有 rollout 样例之后，怎样把这些证据继续压成统一 ABI，避免每次迁移都重新发明记录格式。

它主要回答四个问题：

1. 为什么 rollout 样例层之后还必须继续长出 rollout 模板与 ABI 层。
2. 为什么对象卡、Diff 卡、阶段评审卡、灰度结果卡与回退记录卡必须共用一套字段语义。
3. 怎样把 Prompt、治理与结构三条线压成“共用骨架 + 专项扩展字段”的证据接口。
4. 怎样用苏格拉底式追问避免把 rollout ABI 写成周报、复盘感想或项目管理表。

## 1. Prompt rollout ABI

如果问题是：

- 怎样把 Prompt Constitution 的迁移证据写成可重复复用的卡片，而不是只保留一份历史故事。
- 怎样固定角色主权链、section 变更、stable prefix、dynamic boundary、lawful forgetting 与 handoff continuity 的最小证据字段。

建议顺序：

1. `../playbooks/09`
2. `../playbooks/12`
3. `../playbooks/13`

这条线的核心不是：

- 把 prompt 改动写得更漂亮

而是：

- 把 prompt 升级写成可复查的证据接口

## 2. 治理与省 token rollout ABI

如果问题是：

- 怎样把治理顺序、stable bytes、decision gain、automation lease 与 continuation policy 的升级证据写成统一卡片。
- 怎样避免每次治理变更都重新定义“到底该记什么、谁来判定、何时停止、何时回退”。

建议顺序：

1. `../playbooks/10`
2. `../playbooks/12`
3. `../playbooks/13`

这条线的核心不是：

- 再补一层表格

而是：

- 固定“谁先判断、何时停止、什么被保护、什么必须回收”的证据 ABI

## 3. 结构 rollout ABI

如果问题是：

- 怎样把 authoritative surface、projection、transport shell、recovery asset 与 anti-zombie gate 的结构升级写成统一卡片。
- 怎样避免源码塑形只留下“目录改了什么”，却不留下“真相如何迁移、恢复如何验证、旧对象如何被拦截”的证据。

建议顺序：

1. `../playbooks/11`
2. `../playbooks/12`
3. `../playbooks/13`

这条线的核心不是：

- 给结构升级补管理附件

而是：

- 给真相迁移、恢复资产与反 zombie 保护建立统一证据接口

## 4. 一句话用法

如果：

- `18` 回答“正确 rollout 的完整样例长什么样”

那么：

- `19` 回答“以后每次 rollout 都该按哪套统一 ABI 写证据”

## 5. 苏格拉底式自检

在你准备把一次升级写成“标准模板”前，先问自己：

1. 我写下的是复用型证据 ABI，还是一次性项目周报。
2. 这套字段是否先保护对象、边界、指标与回退，而不是先记录感受。
3. Prompt、治理与结构三条线，哪些字段应共用，哪些字段必须保持专项扩展。
4. 如果半年后换一批维护者，他们能否仅靠这套卡片复跑同样的判断与回退决策。
