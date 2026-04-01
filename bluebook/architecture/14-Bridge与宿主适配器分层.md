# Bridge 与宿主适配器分层

这一章回答五个问题：

1. bridge、direct connect、remote session manager 在架构上分别处于哪一层。
2. 为什么它们不能被简单统称为“远程模式”。
3. bridge 比 direct connect / remote session manager 多做了哪些事。
4. `handleIngressMessage(...)`、`handleServerControlRequest(...)`、`useReplBridge.tsx` 共同体现了怎样的分层。
5. 为什么“协议全集不等于适配器子集”是 Claude Code 架构里非常重要的一条边界。

## 1. 先说结论

当前可见源码里的宿主适配链，至少可以拆成四层：

1. 协议全集层：`controlSchemas.ts` + `StructuredIO`
2. 远程投射层：`RemoteIO`
3. bridge 控制面层：`bridgeMessaging.ts` + `replBridge.ts` + `remoteBridgeCore.ts` + `useReplBridge.tsx`
4. 窄适配器层：`DirectConnectSessionManager`、`RemoteSessionManager`

所以“远程能力”并不是单层东西，而是一组宽窄不同、职责不同的适配器。

关键证据：

- `claude-code-source-code/src/cli/structuredIO.ts:135-162`
- `claude-code-source-code/src/cli/remoteIO.ts:35-240`
- `claude-code-source-code/src/bridge/bridgeMessaging.ts:132-391`
- `claude-code-source-code/src/bridge/replBridge.ts:1190-1235`
- `claude-code-source-code/src/bridge/replBridge.ts:1528-1819`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:422-456`
- `claude-code-source-code/src/hooks/useReplBridge.tsx:367-586`
- `claude-code-source-code/src/server/directConnectManager.ts:40-210`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts:95-323`

## 2. 第一层：协议全集层

这层回答的是：

- “理论上 CLI worker 定义了什么正式控制语义”

核心对象是：

- `controlSchemas.ts`
- `StructuredIO`

这层的特点是：

- subtype 最完整
- request/response 关联最完整
- cancel、duplicate/orphan、防乱序最完整
- 不关心某个具体宿主最终只接了其中哪一部分

## 3. 第二层：远程投射层

`RemoteIO` 不是新宿主，而是把协议全集投射到远程 transport 的那一层。

它额外处理：

- session ingress token
- header refresh
- transport 选择
- CCR v2 internal events
- bridge-only keepalive

但它并不决定“某个远程宿主最终支持哪些 control subtype”。

所以 `RemoteIO` 更像：

- remote transport harness

而不是：

- product-facing host adapter

## 4. 第三层：bridge 控制面层

bridge 是当前源码里最容易被低估的一层，因为它既不像 `StructuredIO` 那么“协议纯”，也不像 direct connect 那么“适配器薄”。

### 4.1 `handleIngressMessage(...)`：bridge 的入口过滤器

它会：

- 单独识别 `control_response`
- 单独识别 `control_request`
- 只把 `user` 类型的 inbound SDKMessage 继续转发
- 对 echo 和 re-delivery 做双重 UUID 去重

因此 bridge 根本不是“把所有 SDKMessage 原样搬进 REPL”。

证据：

- `claude-code-source-code/src/bridge/bridgeMessaging.ts:132-208`

### 4.2 `handleServerControlRequest(...)`：bridge 的服务端控制请求分发器

它当前显式处理：

- `initialize`
- `set_model`
- `set_max_thinking_tokens`
- `set_permission_mode`
- `interrupt`

未知 subtype 明确回 error，避免服务端等待超时。

证据：

- `claude-code-source-code/src/bridge/bridgeMessaging.ts:243-391`

### 4.3 bridge 不只传权限，还传会话状态

`remoteBridgeCore.ts` 在发送控制消息时还会显式回写 transport state：

- 发 `can_use_tool` 时报告 `requires_action`
- 发 `control_response` 时回到 `running`
- 发 `control_cancel_request` 时也回到 `running`
- 发 result 时转成 `idle`

这说明 bridge 搬运的不只是 message，还包括远程会话状态机。

证据：

- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:424-456`
- `claude-code-source-code/src/bridge/remoteBridgeCore.ts:824-878`

### 4.4 `useReplBridge.tsx`：bridge 与本地交互层的粘合器

`useReplBridge.tsx` 一方面：

- 接 `control_response` 并按 `request_id` 分发 permission handler

另一方面：

- 把本地交互层的 permission callbacks 收敛成 `sendRequest` / `sendResponse` / `cancelRequest` / `onResponse`
- 把 bridge inbound control 映射到 `onInterrupt`、`onSetModel`、`onSetMaxThinkingTokens`、`onSetPermissionMode`

这使它成为“bridge 控制面”和“本地 REPL 状态机”之间的接口胶水层。

证据：

- `claude-code-source-code/src/hooks/useReplBridge.tsx:367-385`
- `claude-code-source-code/src/hooks/useReplBridge.tsx:392-474`
- `claude-code-source-code/src/hooks/useReplBridge.tsx:538-586`

## 5. 第四层：窄适配器层

### 5.1 direct connect

direct connect 的特点是：

- 控制语义极窄
- 重点在最小可用宿主接入
- 只做 permission request / response 与 interrupt

它不试图重建完整控制平面。

### 5.2 `RemoteSessionManager`

remote session manager 的特点是：

- 重点在 remote session client
- WebSocket 收、HTTP 发
- permission 往返与 reconnect
- 控制子类型支持面明显窄于 bridge

它也不试图重建完整控制平面。

## 6. bridge 为什么比它们更宽

bridge 比 direct connect / remote session manager 更宽，原因不是“功能更多”这么简单，而是它承担了额外职责：

1. 要把本地 REPL 会话映射成远程可控节点。
2. 要把服务端控制请求落进本地状态机。
3. 要处理权限竞速、本地 policy verdict、outbound-only 模式。
4. 要维护 echo dedup、history flush、state reporting、teardown 时序。

因此 bridge 的本质更接近：

- distributed control-plane adapter

而不是：

- remote websocket wrapper

## 7. 目录与阅读上的直接启发

这套分层直接解释了为什么蓝皮书需要把三件事分开：

1. `api/13` 讲协议全集
2. `api/14` 讲宿主能力子集
3. `architecture/14` 讲适配器分层

如果把三者压成一章，读者会同时失去：

- 字段可查性
- 结构可解释性
- 边界可反驳性

## 8. 当前边界

需要继续保守两点：

1. bridge 当前可见支持面仍以 `initialize` / `set_model` / `set_max_thinking_tokens` / `set_permission_mode` / `interrupt` / `can_use_tool` 为主，不能擅自扩写为“支持全部 control subtype”。
2. direct connect 与 `RemoteSessionManager` 当前实现都偏窄，不能因为它们复用了 `control_request` / `control_response` 封套就把它们写成完整 SDK host。

## 9. 一句话总结

Claude Code 的远程宿主链不是“一套远程模式”，而是从协议全集到远程投射、再到 bridge 控制面与窄适配器的分层体系。
