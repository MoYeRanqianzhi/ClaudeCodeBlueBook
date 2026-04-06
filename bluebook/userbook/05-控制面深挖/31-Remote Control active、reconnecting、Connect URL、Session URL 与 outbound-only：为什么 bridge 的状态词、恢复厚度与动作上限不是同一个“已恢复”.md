# `Remote Control active`、`reconnecting`、`Connect URL`、`Session URL` 与 `outbound-only`：为什么 bridge 的状态词、恢复厚度与动作上限不是同一个“已恢复”

## 用户目标

不是只知道 Claude Code 里“底部会显示 `Remote Control active`、偶尔变成 `reconnecting`、Bridge Dialog 里还能看到 URL”，而是先分清五类不同对象：

- 哪些只是 bridge 的粗粒度状态词。
- 哪些属于 bridge host 自己更细的状态树。
- 哪些 URL surface 说明的是“可接入”与“已附着”的厚度差异。
- 哪些模式虽然还在写事件，却已经不是 full remote-control。
- 哪些动作当前仍可做，哪些只是看到绿色词后被用户脑补出来的能力。

如果这些对象不先拆开，读者最容易把下面这些东西压成同一种“已恢复”：

- `Remote Control active`
- `Remote Control reconnecting`
- `Remote Control failed`
- `replBridgeConnected`
- `replBridgeSessionActive`
- `replBridgeReconnecting`
- `Connect URL`
- `Session URL`
- `outbound-only`
- `BRIDGE_SAFE_COMMANDS`

## 第一性原理

bridge host 的“当前状态”至少沿着四条轴线分化：

1. `Status Word`：控制面现在用什么词总结当前情况。
2. `Recovery Thickness`：当前到底只恢复到“可接入”、还是已经进入活动会话、还是只是写链还在。
3. `Action Ceiling`：当前远端实际还能做什么，不能做什么。
4. `Display Surface`：这条信息是通过 footer pill、Bridge Dialog、系统通知，还是远端错误响应暴露出来。

因此更稳的提问不是：

- “它现在是不是 active，所以已经恢复好了？”

而是：

- “我现在看到的是一个粗粒度状态词，还是更细的状态节点；当前恢复到哪一层厚度；动作上限又被收窄到哪里？”

只要这四条轴线没先拆开，正文就会把 `active`、`reconnecting`、`Connect URL`、`Session URL` 与 `outbound-only` 写成同一种“绿色恢复”。

## 第一层：`Remote Control active` 是粗粒度状态词，不是完整恢复承诺

### `getBridgeStatus()` 故意把不同内部厚度压成少数词

`bridgeStatusUtil.ts` 里，bridge 状态词的映射非常短：

- 有 `error` 就是 `Remote Control failed`
- 在 `reconnecting` 就是 `Remote Control reconnecting`
- `sessionActive || connected` 就统一变成 `Remote Control active`
- 其余才是 `Remote Control connecting...`

这说明 `active` 回答的问题不是：

- “底层状态机究竟走到了哪一格”

而是：

- “当前有没有足够低噪音的正向摘要可以给用户看”

### `active` 至少吃掉了两层不同厚度

同一份映射里，下面两种状态都会被压成：

- `Remote Control active`

但它们并不等价：

- `connected`
- `sessionActive`

所以更稳的理解应是：

- `active` 是 coarse summary

而不是：

- fully interactive / fully recovered 的正式签字

### 因而状态词不能直接替代动作判断

只要这一层没先拆开，读者就会自然脑补：

- 既然是 `active`
- 那远端现在应该什么都能做

这正是本页要纠正的第一种错写。

## 第二层：bridge host 的真实状态树，比 footer 上那几个词更厚

### `AppState` 明确把 bridge 拆成多张状态表

`AppStateStore.ts` 在 bridge 这一段单独定义了：

- `replBridgeEnabled`
- `replBridgeExplicit`
- `replBridgeOutboundOnly`
- `replBridgeConnected`
- `replBridgeSessionActive`
- `replBridgeReconnecting`
- `replBridgeConnectUrl`
- `replBridgeSessionUrl`
- `replBridgeError`

这说明产品从状态树层面就承认：

- bridge 有没有启用
- 当前是不是显式远控
- 当前是不是 outbound-only
- transport / environment 是否 ready
- ingress session 是否 active
- 当前是不是在回连

本来就不是同一个布尔值。

### `ready` 与 `connected` 是两种不同厚度

`useReplBridge.tsx` 的 `handleStateChange()` 里：

- `ready` 会写 `replBridgeConnected: true`
- 但同时保持 `replBridgeSessionActive: false`
- 并写入 `Connect URL`、`Session URL`、`environmentId`、`sessionId`

而到了：

- `connected`

才会进一步写：

- `replBridgeSessionActive: true`

这说明更准确的理解是：

- `ready` 更像“桥已可接入”
- `connected` 更像“远端活动会话已经真正附着上来”

### `reconnecting` 与 `failed` 又是另外两类退化状态

同一处逻辑里：

- `reconnecting` 会把 `replBridgeReconnecting: true`
- 同时把 `replBridgeSessionActive: false`

而：

- `failed`

则会写入：

- `replBridgeError`
- `replBridgeConnected: false`
- `replBridgeSessionActive: false`
- `replBridgeReconnecting: false`

所以更稳的结论是：

- `active` / `reconnecting` / `failed` 是展示层词
- `connected` / `sessionActive` / `reconnecting` / `error` 才更接近底层节点

## 第三层：`Connect URL` 与 `Session URL` 暴露的是恢复厚度，不是同一种链接

### Bridge Dialog 会根据 `sessionActive` 切换显示哪条 URL

`BridgeDialog.tsx` 与 `/remote-control` 的 disconnect dialog 都写了同样的选择逻辑：

- `sessionActive ? sessionUrl : connectUrl`

这说明系统已经默认承认：

- “现在只有可接入 URL”
- 与
- “现在已经有活动会话 URL”

不是同一种恢复厚度。

### footer 文案也在区分“可接入”与“已附着”

`bridgeStatusUtil.ts` 里同时存在：

- `buildIdleFooterText(url)`
- `buildActiveFooterText(url)`

对应的文案语义分别更像：

- 现在可以从别处接进来
- 现在已经可以在别处继续这条活动会话

所以 `Connect URL` 与 `Session URL` 的差别，不只是：

- 一个 URL 参数不同

而是：

- 这条 bridge 到底恢复到了哪种交互厚度

### 因而“有 URL 了”也不是完整恢复证明

更稳的区分是：

- `Connect URL`：说明桥已 ready，可以接入
- `Session URL`：说明已有活动 session surface

它们都比“完全恢复”更窄。

## 第四层：`outbound-only` / mirror 说明的是动作上限，不是弱化版 active

### outbound-only 不是“有点弱的 remote-control”

`bridgeMessaging.ts` 对 outbound-only 的处理非常明确：

- `initialize` 仍要成功
- 但所有 mutable control request 都返回错误
- 固定错误文案是：
  `This session is outbound-only. Enable Remote Control locally to allow inbound control.`

这说明 outbound-only 回答的问题不是：

- “当前颜色是不是比 active 更淡一点”

而是：

- “当前还能不能接收入站控制、能不能真正反控本地”

### mirror 分支连状态写回都故意更薄

`useReplBridge.tsx` 里，outbound-only 分支对状态写回明显比 full remote-control 更窄：

- `failed` 只会把 `replBridgeConnected` 拉低
- `ready` / `connected` 只会把 `replBridgeConnected` 拉高

而不会像 full remote-control 那样持续维护：

- `replBridgeSessionActive`
- `replBridgeReconnecting`
- URL / ID 全套 surface

这说明 mirror 模式在设计上就不是：

- “完整 bridge 的一个视觉弱态”

而是：

- 恢复厚度与动作上限都更薄的一条并行路径

### 所以 outbound-only 更像“写链还在，但控制权不在”

更稳的理解应是：

- 还能继续向外送事件
- 但不能假定远端还能改模型、改 permission mode、打断本地、或执行完整 inbound control

只要这一层没拆开，正文就会把 mirror / outbound-only 错写成：

- 一个几乎等于 full remote-control 的半成品

## 第五层：即使是 `active` 的 full remote-control，也仍有动作上限

### remote client 先看到的是 bridge-safe 命令，不是全部命令

`useReplBridge.tsx` 在发送 `system/init` 时，会把命令集过滤成：

- `commandsRef.current.filter(isBridgeSafeCommand)`

而 `commands.ts` 又把 `BRIDGE_SAFE_COMMANDS` 限在少数安全命令上。

这说明即使当前已经进入：

- `Remote Control active`

也不等于：

- 远端拿到了与本地 REPL 完全对等的命令面

### 所以状态词永远不能单独推导出“远端能做全部动作”

更稳的区分是：

- `Status Word` 只告诉你大致运行态
- `Action Ceiling` 还要看当前是不是 outbound-only、远端收到的命令集合是什么、控制合同是否被放行

因此本页虽然不重讲第 29 页的控制合同细节，但必须保留一句：

- `active` 不等于 unrestricted remote control

## 第六层：footer pill、Bridge Dialog 与 notification 不是同一张状态展示面

### footer pill 会故意隐藏很多“真实存在但不值得占位”的状态

`PromptInputFooter.tsx` 里：

- bridge 未启用就不显示
- implicit config-driven bridge 在非 reconnecting 时也不显示

`PromptInput.tsx` 甚至把 footer 导航可见性跟这条条件写死同步，避免出现 invisible selection stop。

这说明 footer pill 的职责不是：

- 成为 bridge 是否存在的完整证明

而是：

- 在占位受限的底栏里，只投影最值得立即注意的粗粒度状态

### failed 状态还会被故意分流到 notification

`PromptInputFooter.tsx` 直接写了：

- failed state 走 notification，不走 footer pill

这说明系统自己也承认：

- 不同风险级别的状态
- 本来就该落在不同展示面

所以更稳的写法应是：

- footer pill = coarse, low-footprint summary
- Bridge Dialog = inspect / disconnect surface
- notification = 更强异常信号

### 因而“pill 没了”与“bridge 完全不存在”也不是同一句话

只要这一层没拆开，正文就会把：

- pill 可见性
- 真实状态树
- 当前异常级别

重新压成一张表。

## 第七层：稳定主线、条件面与内部面要继续保护

### 稳定可见或相对稳定可见的

- `Remote Control active` / `reconnecting` / `failed` 这些状态词
- `Connect URL` 与 `Session URL` 是不同厚度的 surface
- outbound-only 会拒绝入站可变控制
- bridge 远端命令面仍受 `BRIDGE_SAFE_COMMANDS` 上限约束

这些都适合进入 reader-facing 正文。

### 条件公开或应降权写入边界说明的

- implicit config-driven bridge 的 pill 抑制规则
- mirror / outbound-only 只在特定启动路径下出现
- `RemoteCallout` 与 first-run consent
- full remote-control 的细粒度控制动作仍受更多 gate / policy 影响

### 更应留在实现边界说明的

- auto-disable failure fuse 的具体时长
- bridge transport 的轮询 / backoff / ingress 细节
- mirror 分支的全部内部 tag / transport 写法
- 安全章节里那些更原始的作者命名，如 `write-ready/read-blind`

这些内容只保留为作者判断依据，不回流正文主线。

## 最后的判断公式

当你看到 `Remote Control active`、`reconnecting`、`Connect URL`、`Session URL` 或 outbound-only 时，先问七个问题：

1. 我现在看到的是展示层状态词，还是更细的状态节点？
2. 这个 `active` 来自 `connected`，还是已经到了 `sessionActive`？
3. 当前这条桥只恢复到“可接入”，还是已经有活动会话附着？
4. 当前是 full remote-control，还是 outbound-only / mirror？
5. 远端当前的动作上限是什么，能不能接收入站控制？
6. 这条信息来自 footer pill、Bridge Dialog，还是 notification？
7. 我是不是又把状态词、恢复厚度与动作上限偷换成了同一个“已恢复”？

只要这七问先答清，就不会把 bridge host 的状态语义写糊。

## 源码锚点

- `claude-code-source-code/src/bridge/bridgeStatusUtil.ts`
- `claude-code-source-code/src/hooks/useReplBridge.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooter.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInput.tsx`
- `claude-code-source-code/src/components/BridgeDialog.tsx`
- `claude-code-source-code/src/commands/bridge/bridge.tsx`
- `claude-code-source-code/src/bridge/bridgeMessaging.ts`
- `claude-code-source-code/src/commands.ts`
- `claude-code-source-code/src/state/AppStateStore.ts`
