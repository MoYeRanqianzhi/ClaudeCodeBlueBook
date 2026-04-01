# 可迁移设计法则：给 Agent 平台构建者的启示

## 1. 为什么要写这一章

Claude Code 的风控研究如果只停留在“它怎么限制用户”，价值会偏小。  
更高价值的问题是：

它有哪些设计思路值得别的 agent 平台直接借鉴？

这一章就是把前面所有研究压缩成一组可迁移的工程法则。

## 2. 先说结论

如果只能从这套系统里带走十条设计法则，我会带走下面这些：

1. 主体连续性优先于凭证存在性。
2. 资格 gating 和处罚逻辑必须分开。
3. 组织治理必须有独立控制面。
4. 高安全远程会话必须独立建模。
5. 本地动作治理必须前置。
6. 策略应当数据化、可热更新，而不是硬编码。
7. selective fail-open / fail-closed 比全局单一策略成熟得多。
8. step-up auth 必须和 token expiry 分开处理。
9. 失败风暴控制本身就是安全设计的一部分。
10. reason code、解释层和支持路径不是附属物，而是治理系统的一部分。

## 3. 法则一：主体连续性优先于凭证存在性

一个 token 是否存在，不等于一个主体是否稳定成立。

Claude Code 的源码反复在解决这个问题：

- token source 仲裁
- keychain / FD / env token 区分
- 401 后的并发去重与刷新锁
- 组织 profile 权威校验

### 给构建者的启示

不要把认证系统设计成“有 token 就继续”。  
应该设计成“主体是否还连续、可信、可解释”。

## 4. 法则二：资格 gating 和处罚逻辑必须分开

`not enabled for your account`、`requires subscription`、`allow_remote_sessions`、`needs-auth`、`rate limit` 和真正的账号失效不是一回事。

### 给构建者的启示

不要把 rollout、套餐、组织策略、连接认证和处罚都塞进一个“不可用”状态。  
否则用户、支持和平台自己都会失去诊断能力。

## 5. 法则三：组织治理必须有独立控制面

policy limits、managed settings、managed env、组织绑定，说明组织治理不是“给个人配置多加一个字段”，而是独立的治理层。

### 给构建者的启示

只要系统面向企业和团队，组织治理就必须脱离个人偏好配置。

## 6. 法则四：高安全远程会话必须独立建模

Remote Control / bridge / trusted device 明确说明：

- 高权限远程能力不是普通功能开关。
- 它需要更高的身份、组织、设备和环境一致性。

### 给构建者的启示

不要把高安全远程能力复用普通 API 客户端的思路去做。  
要单独建模、单独错误语义、单独恢复逻辑。

## 7. 法则五：本地动作治理必须前置

permission rules、safety checks、classifier、sandbox 的意义是：

在动作发生前尽量消化风险，而不是一上来就升级到账号处罚。

### 给构建者的启示

账号治理和动作治理是两套系统。  
动作能在本地收口，就不要把所有成本压到主体处罚上。

## 8. 法则六：策略应当数据化、可热更新

GrowthBook、policy limits、remote managed settings 都在说明：

- 策略不该散落在代码里的 if/else。
- 它应该是可分桶、可轮询、可回滚、可热更新的数据面。

### 给构建者的启示

如果你的 agent 平台还只能靠发版更新治理边界，那治理成本会非常高。

## 9. 法则七：Selective fail-open / fail-closed 才是成熟策略

这套系统最成熟的地方之一，就是它没有追求简单一致性：

- entitlement stale false 可能要纠正
- 组织越界必须 fail-closed
- 高危 settings 变更必须硬确认
- 部分 background polling 则允许 graceful degradation

### 给构建者的启示

问清楚“错杀”和“错放”哪一个代价更大，再决定失败语义。

## 10. 法则八：Step-up auth 和 token expiry 必须分开

`403 insufficient_scope` 和 `401 expired token` 完全不是一类问题。

### 给构建者的启示

如果你把 scope 不足也当成普通 refresh 去处理，系统会既不安全，也不稳定。

## 11. 法则九：失败风暴控制也是安全设计

bridge 的 401 风暴治理、needs-auth cache、连续失败上限、cross-process backoff 都在说明：

平台治理不仅是判断谁该被挡住，也包括防止错误自身扩散成系统噪声。

### 给构建者的启示

失败如果会指数放大，它就已经是安全和可用性的共同问题。

## 12. 法则十：解释层和支持路径不是附属功能

reason code、support hint、switch-to-subscription 提示、组织策略说明、session expired 引导，都说明：

治理系统最终也必须面对普通用户。

### 给构建者的启示

你不能只设计内部判定正确，还要设计外部体验可解释、可支持、可恢复。

## 13. 一句话总结

Claude Code 给构建者最大的启示，不是“怎么做一个更严的风控”，而是“怎么把身份、资格、组织、动作、高安全会话、失败控制和解释层拼成一个真正可持续的 agent 治理系统”。
