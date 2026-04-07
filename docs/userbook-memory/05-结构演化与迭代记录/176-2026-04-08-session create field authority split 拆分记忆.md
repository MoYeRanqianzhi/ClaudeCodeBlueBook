# session create field authority split 拆分记忆

## 本轮继续深入的核心判断

175 已经把 bridge provenance 拆成：

- origin label
- prior-state trust domain
- environment identity

但 session create request body 内部还缺一句更窄的判断：

- attach target、来源声明、上下文载荷与默认策略也不等于同一种会话归属

本轮要补的更窄一句是：

- `createBridgeSession` 里的 `environment_id`、`source`、`session_context`、`permission_mode` 应分别落在 attach、declaration、context、policy 四层

## 为什么这轮必须单列

如果不单列，正文最容易在三种偷换里回卷：

- 把 `environment_id` 写成 session provenance
- 把 `source:'remote-control'` 写成更细的 host identity
- 把 `session_context` 或 `permission_mode` 写成会话归属的同类字段

这三种都会把：

- attach target
- source declaration
- context payload
- default policy

重新压扁。

## 本轮最关键的新判断

### 判断一：`environment_id` 在 session create 面里先是 attach target，不是来源声明

### 判断二：`source:'remote-control'` 声明的是更粗的来源家族，而不是 standalone / REPL host identity

### 判断三：`session_context` 是上下文载荷，不是来源声明的展开版

### 判断四：`permission_mode` 是 default policy，不是 attach/source/context 的同类字段

### 判断五：同一 helper 同时服务 standalone 与 `/remote-control`，正好证明 `source` 的粒度刻意更粗

## 苏格拉底式自审

### 问：为什么这页不是 174 的附录？

答：因为 174 讲 environment register authority；176 讲 session create request body 里的字段主语。

### 问：为什么必须把 `source:'remote-control'` 单列出来？

答：因为没有它，就无法证明“同在 request body 里”不等于“都在定义 session attach/identity”。

### 问：为什么要把 `session_context` 和 `permission_mode` 也带进来？

答：因为只有把它们一起摆出来，才能稳地阻止正文把 attach/source/context/policy 混成一类“会话归属字段”。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/176-createBridgeSession.environment_id、source、session_context 与 permission_mode：为什么 session attach target、来源声明、上下文载荷与默认策略不是同一种会话归属.md`
- `bluebook/userbook/03-参考索引/02-能力边界/165-createBridgeSession.environment_id、source、session_context 与 permission_mode 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/176-2026-04-08-session create field authority split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 176
- 索引层只补 165
- 记忆层只补 176

不回写 39、42、174、175。

## 下一轮候选

1. 继续拆 `createBridgeSession.source` 与 `workerType`：为什么 session origin declaration 与 environment origin label 不是同一种 remote provenance。
2. 继续拆 `session_context` 里的 `sources/outcomes/model`：为什么同属 createSession 载荷，也不是同一种上下文主语。
