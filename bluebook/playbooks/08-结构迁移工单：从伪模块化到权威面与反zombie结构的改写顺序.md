# 结构迁移工单：从伪模块化到 current-truth surface 与反zombie结构的改写顺序

这一章把 `guides/32` 和 `casebooks/12` 继续推进到迁移执行层。

它主要回答五个问题：

1. 怎样把旧式伪模块化、第二真相系统迁到 Claude Code 式 `current-truth surface -> current-truth writeback -> freshness -> anti-zombie -> handoff` 结构。
2. 为什么这类迁移不该从“先把目录拆碎”开始，而应从真相写回链路和恢复链路收口开始。
3. 怎样安排 `current-truth surface / writeback / freshness / anti-zombie / handoff` 的改写顺序，并把 leaf module、transport shell、recovery asset 放在从属位置。
4. 灰度、停机与回退条件分别该如何定义。
5. 怎样用苏格拉底式追问避免把结构迁移写成审美重构。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/QueryGuard.ts:1-121`
- `claude-code-source-code/src/query/config.ts:1-45`
- `claude-code-source-code/src/query/deps.ts:1-40`
- `claude-code-source-code/src/bridge/replBridgeTransport.ts:13-116`
- `claude-code-source-code/src/utils/cleanupRegistry.ts:1-21`
- `claude-code-source-code/src/utils/task/framework.ts:160-248`
- `claude-code-source-code/src/bridge/bridgePointer.ts:22-167`
- `claude-code-source-code/src/services/api/sessionIngress.ts:60-120`

这些锚点共同说明：

- 结构迁移真正昂贵的地方，不在于目录怎么排，而在于如何重新收口 `current-truth surface`、`current-truth writeback`、freshness gate、恢复句柄和对象命运。

## 1. 第一性原理

这类迁移真正要避免的，不是：

- 当前代码不够整齐

而是：

- 多份半真相继续并存，旧对象继续复活，恢复仍靠猜，未来维护者仍看不出哪里不能改

所以迁移的第一原则不是：

- 先拆文件

而是：

- 先让系统重新说真话

## 2. 迁移步骤

### 步骤 1：先标 `current-truth surface`，不先拆目录

目标：

- 找出 mode、state、metadata、pending action、query fate 等关键对象各自的 `current-truth surface`。

不要做什么：

- 不要先按层数和文件大小决定怎么拆。
- 不要在找不到 `current-truth surface` 时就开始抽公共模块。

验收信号：

- 任一关键真相都能指出唯一入口或唯一 choke point；团队不再用“差不多同步”描述当前态。

### 步骤 2：收口 `current-truth writeback`，再收回第二真相

目标：

- 让所有状态改写先进入唯一 `current-truth writeback` 路径，再由 UI、宿主、搜索、恢复消费投影。

不要做什么：

- 不要继续用多处缓存字段互相同步并绕过 writeback。
- 不要让显示层顺手成为执行层的真相来源。

验收信号：

- split truth 类问题减少；`worker_status / external_metadata / current state` 的写入口清楚且可追踪。

### 步骤 3：建立 freshness，再整理 transport 与 recovery 依赖

目标：

- 对跨 await、跨进程、跨 transport 回来的改写，一律先过 generation / freshness gate，再进入 writeback。
- 把 `v1/v2`、`local/remote`、`structured/streaming` 差异压进 transport shell。
- 把 pointer、snapshot、replacement log、cursor、adopt 规则登记为 recovery asset 账本。

不要做什么：

- 不要继续全量旧对象回写。
- 不要把 transport 条件分支扩散到业务层写路径。
- 不要在 recovery asset 未建账前上线 resume / adopt。

验收信号：

- freshness 拦截命中与误杀可解释；transport 条件显著回收到 shell；recovery 场景不再靠临时推断。

### 步骤 4：把 freshness 执行成 anti-zombie 纪律

目标：

- finally / append / snapshot 统一走 fate classification，并执行 stale drop。
- patch merge 替代旧对象全量回写，避免 zombie 对象复活。

不要做什么：

- 不要把 finally 当作永远安全的 cleanup 区。
- 不要把 anti-zombie 写成“偶发补丁”。

验收信号：

- stale finally、stale snapshot、zombie risk 明显下降；对象命运能用统一制度词汇解释。

### 步骤 5：把 handoff 变成硬闸门

目标：

- 交付可消费的 `surface -> writeback -> freshness -> anti-zombie -> handoff` 证据包。
- 让宿主、CI、评审、交接按同一顺序读证据。

不要做什么：

- 不要只交文件 diff 与目录图。
- 不要把结构结论继续绑定作者口头记忆。

验收信号：

- 任一角色都能指出 `current-truth surface`、`current-truth writeback`、freshness gate、anti-zombie gate 与 handoff carrier。

### 步骤 6：最后再做 leaf/seam/registry 的结构整形

目标：

- 在主链成立后，再把共享规则抽成 leaf module 与 anti-cycle seam。
- 把 registry 限定为薄装配层，只做注册、转运与最小构造。

不要做什么：

- 不要为了 DRY 破坏主链可追踪性。
- 不要为了方便把 fallback、策略和能力判断塞进 registry。

验收信号：

- 共享规则变小而硬；registry 不再承接业务判断；主链仍保持单向可解释。

### 步骤 7：目录与命名整理收尾

目标：

- 在 `surface / writeback / freshness / anti-zombie / handoff` 结构稳定后，再整理目录、命名与注释。

不要做什么：

- 不要把结构美观当成迁移完成信号。
- 不要在主链尚未编码进结构前宣布“架构已升级”。

验收信号：

- 新维护者进入仓库后，能直接看出哪里是 `current-truth surface`、哪里是 writeback 路径、哪里是 freshness / anti-zombie gate、哪里是 handoff 边界。

## 3. Rollout 顺序

```text
1. 先标 current-truth surface，不改行为
2. 再收 current-truth writeback，把散写回收到单一路径
3. 再上 freshness（generation gate + transport shell + recovery asset ledger）
4. 再把 freshness 执行成 anti-zombie（stale drop + fate classification）
5. 再上线 handoff gate（宿主/CI/评审/交接统一读同一证据链）
6. 最后才收 leaf/seam/registry，并整理目录与命名
```

## 4. 停止条件

```text
[ ] 还说不清任何关键状态的 current-truth surface
[ ] current-truth writeback 仍被多条散写路径绕过
[ ] freshness gate 未落地就开始删旧路径
[ ] anti-zombie 仍以“手工补救”而非制度规则运转
[ ] handoff gate 缺证据链，只能靠作者口头解释
```

## 5. 回退条件

```text
[ ] split truth 明显增加
[ ] current-truth writeback 对账出现不可解释分歧
[ ] freshness gate 误杀正常写入或放过陈旧写入
[ ] anti-zombie 上线后出现更多假死或 zombie risk
[ ] handoff 后消费者无法复述完整主链并独立判定风险
[ ] 新维护者仍无法指出哪里是 surface/writeback/freshness/handoff 边界
```

## 6. 回退动作

更稳的回退顺序是：

1. 先回退目录与命名整理，不回退 `current-truth surface` 与 writeback 成果。
2. 再回退 leaf/seam/registry 的整形，保留 freshness 合约（transport shell + recovery asset ledger）。
3. 最后才调低 anti-zombie 阈值，并保持 handoff 证据链字段不丢失。

## 7. 迁移记录卡

```text
迁移对象:
current-truth surface 是否清楚:
current-truth writeback 是否唯一:
freshness gate 是否生效:
anti-zombie 规则是否全路径覆盖:
handoff gate 是否可被宿主/CI/评审/交接共同消费:
transport shell 是否成立:
recovery asset 是否已登记:
leaf module / seam / registry 是否保持薄层:
当前 rollout 阶段:
当前最像哪类风险:
- split truth / writeback divergence / freshness miss / zombification / handoff opacity
如果回退，先回退哪一层:
```

## 8. 苏格拉底式追问

在你准备宣布“结构已经升级”前，先问自己：

1. 我是在改善真相结构，还是只是在改善目录表面。
2. 这次迁移先收口了哪个 `current-truth surface`，对应 writeback 路径是否唯一。
3. freshness 是否在写回前被强制执行，而不是只做观测指标。
4. anti-zombie 是否覆盖 finally / append / snapshot，而不是只改一条路径。
5. 如果今天交给新维护者，他能否沿 `surface -> writeback -> freshness -> anti-zombie -> handoff` 直接提出正确质疑。
