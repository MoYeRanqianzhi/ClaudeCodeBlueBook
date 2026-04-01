# StructuredIO 与 RemoteIO 控制平面

这一章回答五个问题：

1. `print.ts`、`StructuredIO`、`RemoteIO` 如何拼成 Claude Code 的宿主控制平面。
2. 为什么这条链路不能被简化成“stdin in / stdout out”。
3. 权限请求、取消、late duplicate、orphan response 是如何被工程化处理的。
4. 为什么远程接入仍然复用同一协议，而不是另起一套 host API。
5. 这条链路体现了怎样的设计内涵。

## 1. 先说结论

Claude Code 的宿主控制平面至少分成六段：

1. 装配：`print.ts` 通过 `getStructuredIO(...)` 选择本地 `StructuredIO` 或远程 `RemoteIO`。
2. 解析：`StructuredIO.read()` 把 NDJSON 切成 message，并应用兼容归一化。
3. 关联：`pendingRequests`、`request_id`、schema parse 维护请求生命周期。
4. 仲裁：`can_use_tool`、hook race、`control_cancel_request`、duplicate/orphan 防护。
5. 远程增强：`RemoteIO` 注入 transport、token refresh、CCR v2 internal events、keepalive。
6. 宿主适配：direct connect 与 `RemoteSessionManager` 在同一协议上做窄化接入。

所以 Claude Code 的宿主接入不是“把 stdout 当接口”，而是一条带时序保证和异常恢复的控制平面。

关键证据：

- `claude-code-source-code/src/cli/print.ts:587-620`
- `claude-code-source-code/src/cli/print.ts:1021-1048`
- `claude-code-source-code/src/cli/print.ts:5199-5232`
- `claude-code-source-code/src/cli/structuredIO.ts:135-258`
- `claude-code-source-code/src/cli/structuredIO.ts:275-429`
- `claude-code-source-code/src/cli/structuredIO.ts:470-773`
- `claude-code-source-code/src/cli/remoteIO.ts:35-240`
- `claude-code-source-code/src/server/directConnectManager.ts:40-210`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts:95-323`
- `claude-code-source-code/src/remote/SessionsWebSocket.ts:82-403`

## 2. 装配段：host protocol 在 `print.ts` 被确立

### 2.1 `getStructuredIO(...)` 是分叉点

`print.ts` 在真正进入 runtime 前，会先把输入 prompt 规范化成流，再根据 `sdkUrl` 选择：

- `new StructuredIO(...)`
- `new RemoteIO(...)`

这说明宿主协议面从一开始就被当成核心运行形态，而不是“某些 SDK 才额外有”。

证据：

- `claude-code-source-code/src/cli/print.ts:587-620`
- `claude-code-source-code/src/cli/print.ts:5199-5232`

### 2.2 `stream-json` guard 说明协议流洁净度是硬约束

一旦启用 `stream-json`，`print.ts` 会显式安装 stdout guard，防止任何 stray stdout 污染 NDJSON 解析。

这说明作者把“宿主可稳定逐行解析”看成协议层约束，而不是调试便利。

证据：

- `claude-code-source-code/src/cli/print.ts:589-596`

## 3. 解析段：`StructuredIO` 不是薄的序列化壳

### 3.1 它首先是一个流解析器

`StructuredIO.read()` 会：

- 把 input block 累积到 buffer
- 按换行切分
- 在同一 block 内重复检查 `prependedLines`
- 解析成 `StdinMessage | SDKMessage`

这使得“中途 prepend 用户消息”“重放历史 user turn”都成为协议级能力。

证据：

- `claude-code-source-code/src/cli/structuredIO.ts:199-258`

### 3.2 它其次是一个消息归一化器

`processLine(...)` 不只是 parse JSON，还会：

- `normalizeControlMessageKeys(...)`
- 忽略 `keep_alive`
- 应用 `update_environment_variables`
- 区分 `control_response` / `control_request` / `assistant` / `system` / `user`

因此 `StructuredIO` 既做 wire parsing，也做运行语义归一化。

证据：

- `claude-code-source-code/src/cli/structuredIO.ts:333-449`

## 4. 关联段：为什么 `request_id` 与统一 FIFO 很重要

### 4.1 `pendingRequests` 才是协议真相

每个 `sendRequest(...)` 都会进入 `pendingRequests`，直到：

- 收到成功 `control_response`
- 收到错误 `control_response`
- 本地 signal abort
- 输入流关闭

所以 control protocol 不是 fire-and-forget，而是严格的请求-关联模型。

证据：

- `claude-code-source-code/src/cli/structuredIO.ts:137-162`
- `claude-code-source-code/src/cli/structuredIO.ts:470-531`

### 4.2 一条 FIFO 保证控制请求不会超车

源码注释直接说明：

- `sendRequest()` 与 `print.ts` 共用 `structuredIO.outbound`
- drain loop 是唯一 writer
- 这样 `control_request` 不会越过已排队的 `stream_event`

这说明宿主控制平面不是“另开一条私有 side channel”，而是和运行事件共享时序队列。

证据：

- `claude-code-source-code/src/cli/structuredIO.ts:160-162`
- `claude-code-source-code/src/cli/print.ts:1021-1023`

## 5. 仲裁段：真正复杂的是权限竞速与异常响应

### 5.1 hook 与 SDK host 被明确设计成并行竞速

`createCanUseTool(...)` 的关键不是 `can_use_tool` 本身，而是：

- hook evaluation 后台启动
- SDK host dialog 立即发出
- `Promise.race(...)`
- 胜者决定 permission，输家被取消或忽略

作者显然在优化“宿主 UI 响应速度”和“hook 自动化决策”之间的并发协作。

证据：

- `claude-code-source-code/src/cli/structuredIO.ts:533-658`

### 5.2 `control_cancel_request` 是正式取消语义

signal abort 后，`sendRequest(...)` 会：

- enqueue `control_cancel_request`
- 立即 reject pending promise
- 先把 tool use 标成 resolved

这样后续迟到的 host response 就不会被当成新的合法事件再次进入主链。

证据：

- `claude-code-source-code/src/cli/structuredIO.ts:490-504`

### 5.3 duplicate / orphan response 有专门护栏

`StructuredIO` 用两套护栏处理异常：

1. `resolvedToolUseIds` 防 late duplicate
2. `unexpectedResponseCallback` 接 orphan response

这说明作者不相信网络与宿主会永远按理想时序运行。

证据：

- `claude-code-source-code/src/cli/structuredIO.ts:149-155`
- `claude-code-source-code/src/cli/structuredIO.ts:362-399`

### 5.4 bridge 注入说明权限仲裁可跨宿主转发

`injectControlResponse(...)` 允许 bridge 把外部权限回答注回本地 SDK 流程，并且主动发 `control_cancel_request` 中断 SDK consumer 的悬挂回调。

这是典型的“同一协议被多个宿主共同仲裁”的设计。

证据：

- `claude-code-source-code/src/cli/structuredIO.ts:275-309`

## 6. 远程增强段：`RemoteIO` 把同一协议投射到远程输运

### 6.1 它先解决的是 transport 与鉴权

`RemoteIO` 在 `StructuredIO` 之上增加：

- session ingress token
- environment runner version
- dynamic header refresh
- URL-to-transport 选择

证据：

- `claude-code-source-code/src/cli/remoteIO.ts:54-103`

### 6.2 它再把 CCR v2 internal events 接进来

一旦启用 CCR v2：

- `CCRClient` 必须先于 transport connect 初始化
- internal event writer/reader 被挂到 session storage
- command delivery、session state、metadata 被上报

这说明远程不只是传消息，还要承载运行状态同步。

证据：

- `claude-code-source-code/src/cli/remoteIO.ts:111-172`

### 6.3 keepalive 是输运保活，不是产品消息

bridge-only keepalive 的存在说明：

- 远程控制会话可能因为代理层空闲超时被回收
- 但 `keep_alive` 又不能污染宿主 UI 与 transcript

于是作者选择让它在 transport 层显式存在，在语义层被过滤掉。

证据：

- `claude-code-source-code/src/cli/remoteIO.ts:174-196`
- `claude-code-source-code/src/cli/structuredIO.ts:344-346`

## 7. 宿主适配段：不是所有宿主都拥有同样宽的控制面

### 7.1 direct connect 是最小镜像

`DirectConnectSessionManager`：

- 只专门识别 `can_use_tool`
- 只回发 `control_response`
- 只主动发 `interrupt`
- 过滤掉 keepalive、cancel、streamlined message

它本质上是一个最薄的协议镜像层。

证据：

- `claude-code-source-code/src/server/directConnectManager.ts:40-210`

### 7.2 `RemoteSessionManager` 是远程会话编排器

它把：

- WebSocket 收消息
- HTTP POST 送 user event
- pending permission map
- permission cancel
- interrupt / reconnect

收拢成一个远程会话客户端。

证据：

- `claude-code-source-code/src/remote/RemoteSessionManager.ts:95-323`
- `claude-code-source-code/src/utils/teleport/api.ts:361-417`

### 7.3 `SessionsWebSocket` 负责连接可靠性，而不是业务解释

它真正关心的是：

- 连接与认证
- close code 分流
- `4001` compaction 窗口重试
- `4003` 永久拒绝
- ping / reconnect
- 发送 `control_request` / `control_response`

业务解释则上浮给 `RemoteSessionManager`。

证据：

- `claude-code-source-code/src/remote/SessionsWebSocket.ts:97-205`
- `claude-code-source-code/src/remote/SessionsWebSocket.ts:231-299`
- `claude-code-source-code/src/remote/SessionsWebSocket.ts:325-403`

## 8. 设计内涵

从架构上看，这条链路透露出三个非常强的设计判断：

1. Claude Code 不相信“UI 回调散落在各模块里”的集成方式，所以把宿主交互收拢成显式协议。
2. Claude Code 不相信网络与宿主时序永远正确，所以显式设计了 cancel、duplicate、orphan、reconnect、retry。
3. Claude Code 不相信远程模式需要推翻本地协议，所以选择让 `RemoteIO` 继承 `StructuredIO`，而不是再造一套 remote-only 语义。

## 9. 一句话总结

`StructuredIO` 与 `RemoteIO` 共同定义的，不是一个“把 CLI 输出给外部”的适配层，而是 Claude Code 把宿主、远程和运行时统一起来的正式控制平面。
