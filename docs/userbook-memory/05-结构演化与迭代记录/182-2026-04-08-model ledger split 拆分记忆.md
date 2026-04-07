# model ledger split 拆分记忆

## 本轮继续深入的核心判断

181 已经把 bridge create / hydrate 拆成：

- session birth
- history hydrate

但 model 这条线里还缺一句更窄的判断：

- 带着 `model` 之名的对象，也不等于共享同一种账本

本轮要补的更窄一句是：

- `session_context.model`、`metadata.model`、`STATE.modelUsage` / `lastModelUsage` 与 `restoreAgentFromSession(...)` 应分别落在 create-time stamp、live shadow、durable usage ledger 与 resumed-agent fallback 四层

## 为什么这轮必须单列

如果不单列，正文最容易在三种偷换里回卷：

- 把 `session_context.model` 写成当前 runtime authoritative model
- 把 `metadata.model` 与 `lastModelUsage` 写成同一种 restore ledger
- 把 agent restore model 写成 durable ledger 的另一种入口

这三种都会把：

- stamp
- shadow
- accounting
- fallback

重新压扁。

## 本轮最关键的新判断

### 判断一：`session_context.model` 先是 create-time stamp

### 判断二：当前 runtime model truth 先由 override cascade 决定

### 判断三：`metadata.model` 先是 live runtime shadow / readback

### 判断四：`STATE.modelUsage` / `lastModelUsage` 先是 per-model usage ledger

### 判断五：`restoreAgentFromSession(...)` 先是 resumed-agent fallback source

## 苏格拉底式自审

### 问：为什么这页不是 107 的附录？

答：107 讲的是 `metadata.model` 为什么不是普通 AppState mapper；182 讲的是就算承认这点，model 仍然还分成 stamp / shadow / usage / fallback 四张账。

### 问：为什么一定要把 `lastModelUsage` 拉进来？

答：因为不把 per-model usage ledger 明写出来，读者仍会把“恢复了 model”与“恢复了 model usage 账本”混成同一种 restore。

### 问：为什么一定要把 `restoreAgentFromSession(...)` 拉进来？

答：因为否则 resume 语义里还会残留一种误写：以为 resumed agent model 只是 metadata shadow 或 durable usage 的另一种同义回放。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/182-session_context.model、metadata.model、lastModelUsage、modelUsage 与 restoreAgentFromSession：为什么 create-time model stamp、live override shadow、durable usage ledger 与 resumed-agent fallback 不是同一种 model ledger.md`
- `bluebook/userbook/03-参考索引/02-能力边界/171-session_context.model、metadata.model、lastModelUsage、modelUsage 与 restoreAgentFromSession 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/182-2026-04-08-model ledger split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 182
- 索引层只补 171
- 记忆层只补 182

不回写 52、107、152、167、178、181。

## 下一轮候选

1. 继续拆 `initialMessageUUIDs` 注释语义与真实 ingress flush ledger：为什么“messages sent as session creation events”注释不等于当前 bridge 的真实历史账。
2. 若继续沿 model 线往下拆，可再单独写 `settings.model`、override cascade 与 resumed agent model precedence，但必须避免回卷到 52 / 107。
3. `createBridgeSession.source` 与 `BridgePointer.source` 仍暂不再优先单列：高重叠回卷到 175 / 177。
