# 安全真相源层级：为什么 `worker_status`、`external_metadata`、`AppState` 与界面文案不能互相替代

## 1. 为什么在 `29` 之后还要继续写“安全真相源层级”

`29-宿主资格等级` 已经把宿主分成了：

1. 观察宿主
2. 控制宿主
3. 证明宿主

但如果继续往前推进，还会碰到一个更根的问题：

`这些宿主到底在依赖哪一层真相？`

这不是术语洁癖。  
因为一旦这个问题没被单独说清楚，  
系统就很容易在实现或分析时犯四种错误：

1. 把 UI 文案当真相
2. 把本地 `AppState` 当真相
3. 把 `external_metadata` 当真相本体
4. 把某一次 `worker_status` 变化当成完整安全证明

所以这一章的核心问题是：

`Claude Code 的安全控制面里，为什么必须正式区分不同层级的真相源，而不能把任何单一表面当成全部真相？`

## 2. 最短结论

从源码看，Claude Code 的安全真相不是单个字段，  
而是一套：

`分层复制的真相系统。`

更准确地说，它至少分成五层：

1. 实时协议真相
2. 语义会话真相
3. 复制后的 worker 真相
4. 宿主本地状态真相
5. UI 投影真相

这五层都重要，  
但它们的职责完全不同，  
也绝不能互相替代。

所以 `30` 的核心判断是：

`安全控制台真正要治理的，不只是对象，也不只是宿主，而是“不同层真相各自负责什么、又绝不能冒充什么”。`

## 3. 第一性原理：为什么安全系统一定会长成“多层真相”

只要系统同时满足这三件事：

1. 有本地交互状态
2. 有远程复制与恢复
3. 有多宿主消费面

它就不可能只靠单一真相源运转。

因为系统必须同时解决三种不同问题：

1. 现在正在发生什么
2. 系统长期认为自己处于什么状态
3. 其他宿主或恢复逻辑该从哪里读回这份状态

所以多层真相不是设计偶然，  
而是：

`分布式安全控制面必然出现的结构。`

## 4. 第一层真相：实时协议真相

最上层、也最接近“当前发生了什么”的，是实时协议对象。

这些对象来自：

- `control_request`
- `control_response`
- SDK event stream
- `status`
- `auth_status`

它们描述的是：

`当前回合、当前动作、当前阻塞、当前恢复窗口。`

这一层的特点不是稳定，  
而是：

`时效性最强。`

## 4.1 `sessionState.ts` 明确把“需要动作”拆成两条投递路径

`src/utils/sessionState.ts:4-24` 很关键。  
这里把 `requires_action` 上下文拆成两条路径：

1. `tool_name + action_description` 进入 typed 的 `RequiresActionDetails`
2. 完整对象进入 `external_metadata.pending_action`

这说明作者从一开始就知道：

`同一份真相需要同时以“即时动作语义”和“可查询复制语义”存在。`

也就是说，实时协议真相本身就已经不是“单份消息”模型，  
而是：

`事件 + 复制对象` 的双投递结构。

## 5. 第二层真相：语义会话真相

比实时协议更稳定一点的，是会话级语义真相。

这层真相回答的不是每个 transport frame，  
而是：

`当前会话语义上处于 idle、running 还是 requires_action。`

## 5.1 `sessionState.ts` 就是这层语义真相的中心 choke point

`src/utils/sessionState.ts:30-45` 定义了 `SessionExternalMetadata`，  
而 `92-140` 又进一步说明：

1. `notifySessionStateChanged(...)` 会更新 `currentState`
2. `requires_action` 会被镜像到 `external_metadata.pending_action`
3. 返回非 blocked 状态时会清掉 pending action
4. `idle` 会清空 `task_summary`

这说明 `sessionState.ts` 在这里承担的不是显示责任，  
而是：

`语义归约责任。`

它把各种局部事件归约成会话级真相。

## 5.2 这层真相还会继续镜像到 SDK event stream

`src/utils/sessionState.ts:118-133` 说明如果启用相应开关，  
会把语义状态再镜像成 `session_state_changed` 事件。

这再次说明一个关键点：

`语义真相本身就不是只给一个宿主看的。`

它天然需要被不同消费面重放、恢复和解释。

## 6. 第三层真相：复制后的 worker 真相

如果说语义会话真相回答的是“当前会话在语义上是什么”，  
那么复制后的 worker 真相回答的是：

`远程控制平面如何持久、恢复和查询这份状态。`

这层真相的核心对象就是：

- `worker_status`
- `requires_action_details`
- `external_metadata`

## 6.1 `WorkerStateUploader.ts` 直接揭示：这是一层复制真相，不是原始真相

`src/cli/transports/WorkerStateUploader.ts:4-17` 直接说清楚了这层机制：

1. 它是 `PUT /worker` 的 coalescing uploader
2. 顶层键 last value wins
3. `external_metadata` / `internal_metadata` 走 RFC 7396 merge

再看 `39-47`、`69-84`、`98-130`：

1. patch 会被合并
2. 失败会退避重试
3. 重试期间新 patch 会被吸收
4. metadata 是 merge，不是原样覆盖

这说明 `worker_status` / `external_metadata` 这一层真相有一个本质：

`它是复制后、可合并、可延迟一致的真相。`

因此它很重要，  
但它不是原始事件真相本体。

## 6.2 `ccrClient.ts` 更明确地显示这层真相会被初始化、清理和恢复

`src/cli/transports/ccrClient.ts:473-526` 很关键：

1. 初始化时先并发拉回旧 `worker` 状态
2. 再 `PUT /worker`
3. 显式清掉 stale `pending_action` / `task_summary`
4. 最后把恢复到的 `external_metadata` 作为 metadata 返回

这说明复制真相不是只写不读，  
而是：

`既被恢复，又会在进程重启时被清理和重建。`

所以它的哲学地位非常明确：

`它是可恢复真相，不是瞬时真相。`

## 6.3 `reportState` 和 `reportMetadata` 说明这层真相本来就分两类

`src/cli/transports/ccrClient.ts:645-663` 直接把这层复制真相拆成：

1. `worker_status` / `requires_action_details`
2. `external_metadata`

这意味着系统内部并不把“状态”和“元数据”混成一锅。  
它已经知道：

`有些真相需要强语义枚举，有些真相需要可演化的 JSON 面。`

## 7. 第四层真相：宿主本地状态真相

这层真相最典型的代表就是本地 `AppState`。

它的职责不是做远程复制，  
也不是做 transport frame，  
而是：

`维持当前宿主可交互、可渲染、可操作的对象状态。`

## 7.1 `onChangeAppState.ts` 明确说明本地状态变化必须继续镜像出去

`src/state/onChangeAppState.ts:43-92` 非常关键。  
这段代码清楚地说：

1. mode 变化不该只留在本地 `AppState`
2. 必须通过统一 choke point 镜像到 CCR metadata
3. 同时还要镜像到 SDK status stream

这说明 `AppState` 虽然是本地真相，  
但它不是封闭真相。  
它需要不断和更高层语义真相及复制真相对齐。

## 7.2 `print.ts` 又说明本地状态在恢复时会反过来吃回复制真相

`src/cli/print.ts:694` 把 `restoredWorkerState` 传入恢复流程。  
`5048-5060` 进一步说明：

1. 恢复 internal events 时会并发等待 restored worker state
2. 若 metadata 存在，会用 `externalMetadataToAppState(...)` 把它灌回本地状态
3. model 也会从 metadata 恢复回来

这意味着 `AppState` 不是一份凭空状态，  
而是：

`本地交互真相与远程复制真相之间的重建产物。`

## 8. 第五层真相：UI 投影真相

最低层、也是最容易被误当成全部真相的，就是 UI 投影。

它包括：

- footer pill
- status line
- settings 页面摘要
- adapter 压缩后的文案

这一层很重要，  
但它只能回答：

`当前界面决定展示什么。`

而不能单独回答：

`系统整体现在到底是什么状态。`

这就是为什么 `sdkMessageAdapter.ts` 把 `status` 压成文案、  
或 bridge footer 只显示几个状态标签时，  
我们绝不能把它们误读成全部真相。

## 9. 五层真相之间的正确关系是什么

我会把它压成一条层级链：

1. 实时协议真相：最及时
2. 语义会话真相：最像系统当前语义判定
3. 复制 worker 真相：最适合恢复、查询和跨端持久
4. 本地宿主真相：最适合交互和渲染
5. UI 投影真相：最适合给人看

最危险的事情，是把低层冒充高层。

例如：

1. 把 UI 文案当作完整会话真相
2. 把 `external_metadata` 当作原始事件真相
3. 把本地 `AppState` 当作跨宿主一致真相

这正是安全解释会失真的根源之一。

## 10. 从第一性原理看，为什么单一真相幻想是危险的

很多系统会本能追求：

`有没有一个字段能代表全部？`

但 Claude Code 的源码已经反过来证明：

`没有。`

因为任何一个单点字段都不可能同时满足：

1. 足够及时
2. 足够可恢复
3. 足够可查询
4. 足够可交互
5. 足够适合显示

所以更成熟的做法不是寻找唯一真相，  
而是：

`明确每一层真相负责什么，不负责什么。`

## 11. 技术先进性与技术启示

这一章最重要的技术判断是：

`Claude Code 的先进性，不只是它有状态回写，而是它已经在源码里把“多层真相”做成了正式工程结构。`

这表现在：

1. `sessionState.ts` 区分语义状态与 metadata 镜像
2. `WorkerStateUploader.ts` 明确把复制真相设计成 mergeable patch 面
3. `ccrClient.ts` 把恢复、初始化、清理和 report 做成统一 worker 面
4. `onChangeAppState.ts` 把本地状态 diff 变成向外镜像的 choke point
5. `print.ts` 又把复制真相重新灌回本地交互真相

这对其他 Agent 平台构建者的启示非常直接：

1. 不要用一个字段假装统治全部真相
2. 要明确区分实时真相、语义真相、复制真相、本地真相和 UI 真相
3. 真相层之间必须有明确镜像方向和恢复路径

## 12. 哲学本质

这一章更深层的哲学是：

`真相不是一个点，而是一条有方向的流。`

它从事件出发，  
被归约成语义，  
被复制成可恢复面，  
被重建成本地状态，  
最后被投影成界面。

任何一层都重要，  
但没有一层有权冒充全部。

## 13. 苏格拉底式反思：这章最容易犯什么错

### 13.1 我们是不是又把层级做复杂了

不能为了复杂而复杂。  
层级只有在能解释真实源码职责差异时才有价值。  
而这里它确实解释了：

1. 为什么 `external_metadata` 能恢复但不是全部真相
2. 为什么 UI 文案最容易误导
3. 为什么 worker 状态写回不等于动作已经被证明修复

### 13.2 复制真相是不是就不可靠

也不是。  
复制真相非常重要。  
它只是：

`可靠，但不是原始。`

### 13.3 我们是不是该把哪一层封为“唯一权威”

也不该。  
更合理的说法是：

`不同问题依赖不同层的权威。`

## 14. 结语

`29` 回答的是：不同宿主为什么必须按资格分层。  
`30` 继续推进后的结论则是：

`统一安全控制台真正要治理的，不只是宿主和对象，还是真相层级本身。`

只有当实时协议、语义状态、复制状态、本地状态和 UI 投影被明确分层，  
系统才不会再把某个方便读到的表面，  
误当成：

`全部安全真相。`
