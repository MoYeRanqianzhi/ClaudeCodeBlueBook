# 失败语义、取消请求与孤儿修复API手册

这一章回答五个问题：

1. Claude Code 的 host/control API 在失败路径上到底承诺了什么。
2. `control_response(error)`、`control_cancel_request`、orphaned response 分别意味着什么。
3. 为什么 unsupported subtype 必须显式回错，而不是静默忽略。
4. 为什么 transcript repair 也应被视为正式 API 行为，而不是内部补丁。
5. 宿主实现者怎样避免“系统失败了，但宿主还在猜”的错误接法。

## 1. 关键源码锚点

- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts:606-619`
- `claude-code-source-code/src/cli/structuredIO.ts:362-429`
- `claude-code-source-code/src/cli/structuredIO.ts:469-520`
- `claude-code-source-code/src/bridge/bridgeMessaging.ts:265-283`
- `claude-code-source-code/src/bridge/bridgeMessaging.ts:373-383`
- `claude-code-source-code/src/server/directConnectManager.ts:81-99`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts:189-213`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts:159-170`
- `claude-code-source-code/src/utils/sessionState.ts:92-130`
- `claude-code-source-code/src/cli/print.ts:5241-5270`
- `claude-code-source-code/src/utils/messages.ts:5133-5188`

## 2. 先说结论

Claude Code 的控制面如果只看 success path，会被严重误解。

更完整的写法应该是：

1. 失败语义是正式 API，不是实现细节。
2. 取消语义是正式 API，不是本地小优化。
3. orphan / duplicate 修复是正式 API，不是 transcript 清洁工。
4. 状态回写是失败闭环的一部分，不是附加信息。

换句话说，Claude Code 的 host/control 面不只是：

- 发请求
- 等成功

而是：

- 发请求
- 处理中止
- 处理显式失败
- 处理迟到或重复的响应
- 处理失败后需要同步给宿主的当前真相

## 3. `control_response(error)`：unsupported 必须显式报错

`bridgeMessaging.ts`、`DirectConnectManager.ts`、`RemoteSessionManager.ts` 都体现出同一原则：

- 遇到不支持的 `control_request` subtype，直接回 `control_response(error)`

作者这样做，不是为了“报错更规范”，而是为了避免三种更糟糕的结果：

1. 服务端一直挂等，以为本地还在处理。
2. 宿主误以为请求已经生效。
3. 用户看到假成功，后续却发现状态没有变化。

所以对宿主开发者来说，第一条规则不是“尽量支持更多 subtype”，而是：

- 任何不支持的 subtype，都必须被显式结束

## 4. `control_cancel_request`：取消本身是正式协议动作

`controlSchemas.ts` 已经把 `control_cancel_request` 定义成正式 schema：

- `type: 'control_cancel_request'`
- `request_id`

`StructuredIO.sendRequest(...)` 又说明它不是摆设。

如果本地 abort 发生，CLI 会：

1. 发出 `control_cancel_request`
2. 立即 reject 本地 pending promise
3. 把对应 tool_use 标记为 resolved，防止迟到响应再次污染会话

`RemoteSessionManager` 也会消费这个取消请求，并把 pending permission request 清掉。

所以更准确的理解是：

- 取消不是 UI 行为，而是控制协议的一部分

## 5. orphan / duplicate response：成功也可能是坏消息

`StructuredIO` 里最容易被低估的两组对象是：

- `pendingRequests`
- `resolvedToolUseIds`

当 `control_response` 到来时，系统先查 request 是否仍然存在。

如果不存在，并不直接当作“多一条无害消息”，而是继续判断：

- 这是不是已经处理过的 `toolUseID`
- 这是不是一条迟到的 duplicate delivery
- 是否需要走 `unexpectedResponseCallback`

`print.ts` 里的 `handleOrphanedPermissionResponse(...)` 又进一步说明：

- orphaned success response 仍可能触发真实副作用
- 因此必须再做去重与补救

这说明 Claude Code 在 host/control 面上的成熟度，不只在“成功时怎么继续”，还在：

- 成功来晚了怎么办
- 成功重复了怎么办
- 这条成功现在是否还属于当前真相

## 6. transcript repair：失败路径的最后防腐层

`ensureToolResultPairing(...)` 是这条链路里非常重要的一环。

它会显式修复：

- orphaned `tool_result`
- duplicate `tool_use_id`
- resume 后起始消息缺失配对

必要时还会插入：

- synthetic placeholder
- orphan strip

这说明 Claude Code 的 transcript 不是“日志写坏了就算了”，而是：

- 即使失败已经发生，也要把执行轨迹修回到可恢复、可继续的形态

所以 transcript repair 不是后台清洁，而是：

- host/control/runtime 全链条里的最后一道防腐层

## 7. 状态回写：宿主不该猜系统现在处于什么状态

`notifySessionStateChanged(...)` 把 `requires_action` 的 details 镜像到：

- `external_metadata.pending_action`
- 可选的 `system:session_state_changed`

`onChangeAppState.ts` 又把 permission mode 变化同步到：

- `external_metadata.permission_mode`

这说明 Claude Code 不接受一种常见的宿主设计：

- 靠最后一条消息猜现在是不是 blocked / running / idle

它更接近：

- 失败与阻塞之后，系统必须把“当前真相”再外化一次

## 8. 对宿主实现者的最小规则

如果你在实现 Claude Code host，至少要遵守五条规则：

1. unknown / unsupported `control_request` 必须回 `error`
2. 本地 abort 必须正确发送并处理 `control_cancel_request`
3. orphan / duplicate `control_response` 不能再次进入主会话
4. transcript pairing 错位必须修复，而不是继续带病重试
5. blocked / pending / mode changed 必须通过 snapshot 或 metadata 外化

否则宿主看到的就不是 Claude Code 的真实控制环，而只是：

- 一个只在 happy path 看起来正常的外壳

## 9. 一句话总结

Claude Code 的 host/control API 不是“成功就继续，失败就报错”这么简单，而是一整套围绕显式失败、取消请求、孤儿修复与状态外化构成的可恢复控制环。
