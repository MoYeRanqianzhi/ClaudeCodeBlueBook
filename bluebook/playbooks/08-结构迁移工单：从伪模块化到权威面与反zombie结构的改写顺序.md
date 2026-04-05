# 结构迁移工单：从伪模块化到权威面与反zombie结构的改写顺序

这一章把 `guides/32` 和 `casebooks/12` 继续推进到迁移执行层。

它主要回答五个问题：

1. 怎样把旧式伪模块化、第二真相系统迁到 Claude Code 式 authoritative surface + recovery asset + anti-zombie 结构。
2. 为什么这类迁移不该从“先把目录拆碎”开始，而应从真相、传输和恢复路径收口开始。
3. 怎样安排权威面、叶子模块、transport shell、恢复资产与 stale-state 防治的改写顺序。
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

- 结构迁移真正昂贵的地方，不在于目录怎么排，而在于如何重新收口权威真相、传输差异、恢复句柄和对象命运。

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

### 步骤 1：先找 authoritative surface，不先拆目录

目标：

- 找出 mode、state、metadata、pending action、query fate 等关键对象各自的权威面。

不要做什么：

- 不要先按层数和文件大小决定怎么拆。
- 不要在找不到权威面时就开始抽公共模块。

验收信号：

- 任一关键真相都能指出唯一入口或唯一 choke point；团队不再用“差不多同步”描述当前态。

### 步骤 2：把第二真相收回投影层

目标：

- 让 UI、宿主、搜索、恢复等消费者改为消费投影，而不是各自维护一份“几乎等价”的状态。

不要做什么：

- 不要继续用多处缓存字段互相同步。
- 不要让显示层顺手成为执行层的真相来源。

验收信号：

- split truth 类问题减少；`worker_status / external_metadata / current state` 的来源清楚。

### 步骤 3：把共享规则抽成 leaf module 与 seam

目标：

- 只把真正高复用、低依赖的规则抽成 leaf module；其余复杂编排继续留在 choke point。

不要做什么：

- 不要把所有大文件都机械拆成 util。
- 不要为了 DRY 破坏 anti-cycle seam。

验收信号：

- 共享规则变小而硬；依赖图更诚实；高扇入节点没有顺手长成第二业务中心。

### 步骤 4：把 transport 差异关进 shell

目标：

- 把 `v1/v2`、`local/remote`、`structured/streaming` 差异重新压进 transport shell 或 compat shell。

不要做什么：

- 不要让业务层继续携带 transport 条件分支。
- 不要把 adapter 差异一路透传到状态和恢复逻辑。

验收信号：

- construction site 之外，transport 条件显著减少；高层只认统一语义面。

### 步骤 5：先定义 recovery asset，再谈恢复按钮

目标：

- 先把 pointer、snapshot、replacement log、cursor、adopt 规则等恢复资产列成正式账本。

不要做什么：

- 不要先做 resume UI，再补后端恢复句柄。
- 不要把恢复理解成“再猜一次当前态”。

验收信号：

- 崩溃、重连、adopt、resume 场景都能指向正式恢复资产，而不是临时推断。

### 步骤 6：把 stale write 改成 fresh-state merge

目标：

- 对跨 await、跨进程、跨 transport 回来的旧对象，一律先过 generation / freshness gate，再 merge into fresh state。

不要做什么：

- 不要继续全量旧对象回写。
- 不要把 finally 当作永远安全的 cleanup 区。

验收信号：

- stale finally、stale snapshot、zombie risk 明显下降；对象命运能用制度词汇解释。

### 步骤 7：把 registry 限定为薄装配层

目标：

- 让 registry 只做注册、转运与最小构造，不再顺手携带业务判断。

不要做什么：

- 不要为了方便把 fallback、策略和能力判断塞进 registry。
- 不要让 registry 变成所有路径都要懂的隐藏中心。

验收信号：

- registry 的变更集中在 slot / registration；业务逻辑重新回到显式控制面。

### 步骤 8：最后才做目录与命名整理

目标：

- 在权威面、seam、shell、recovery、anti-zombie 已成立后，再对目录、命名和注释做整理。

不要做什么：

- 不要把结构美观当成迁移完成信号。
- 不要在批评路径尚未编码进结构前就宣布“架构已升级”。

验收信号：

- 新维护者进入仓库后，能直接看出哪里是权威面、哪里是 transport shell、哪里是恢复资产、哪里最易误改。

## 3. Rollout 顺序

```text
1. 先标权威面，不改行为
2. 再收第二真相，把消费者改成投影读取
3. 再切 leaf module 与 anti-cycle seam
4. 再把 transport 差异关进 shell
5. 再登记 recovery asset，并做 adopt / resume shadow drill
6. 再上线 generation / fresh merge / stale drop
7. 最后才收 registry、整理目录与命名
```

## 4. 停止条件

```text
[ ] 还说不清任何关键状态的 authoritative surface
[ ] transport 差异仍在业务层大面积扩散
[ ] recovery asset 还没列账本，就准备 rollout resume / adopt
[ ] stale write 仍以全量对象回写为主
[ ] registry 继续承接新的业务判断
```

## 5. 回退条件

```text
[ ] split truth 明显增加
[ ] adopt / resume 后出现更多 stale state 或 zombie risk
[ ] transport shell 迁移导致高层语义不一致
[ ] registry 收口后反而出现大面积构造失败，且无法在装配层解释
[ ] 新维护者仍无法指出哪里是权威面、哪里不能随便改
```

## 6. 回退动作

更稳的回退顺序是：

1. 先回退目录与命名整理，不回退权威面标定成果。
2. 再回退 registry 收口与 transport shell 改写，仅保留 seam 与投影层改造。
3. 最后才回退 stale merge 策略，而且必须保留 recovery asset 账本与风险命名。

## 7. 迁移记录卡

```text
迁移对象:
authoritative surface 是否清楚:
第二真相是否已收回投影层:
leaf module / seam 是否诚实:
transport shell 是否成立:
recovery asset 是否已登记:
fresh-state merge 是否生效:
当前 rollout 阶段:
当前最像哪类风险:
- split truth / transport leakage / recovery-asset corruption / zombification / registry obesity
如果回退，先回退哪一层:
```

## 8. 苏格拉底式追问

在你准备宣布“结构已经升级”前，先问自己：

1. 我是在改善真相结构，还是只是在改善目录表面。
2. 这次迁移先收口了什么权威面。
3. transport 差异是否真的被困进 shell，而不是只是换了名字。
4. 恢复与 stale-state 风险是否已被正式对象化。
5. 如果今天交给新维护者，他能否沿着结构本身提出正确质疑。
