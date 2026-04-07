# `StructuredIO`、`sessionState`、`remoteBridgeCore`、`pending_action`、`requires_action_details` 与 `reportState`：为什么 `can_use_tool` 不等于 `requires_action/pending_action`，而 bridge blocked-state publish 只签裸 blocked bit

## 用户目标

203 已经把 permission tail 收成：

- verdict ledger
- closeout
- re-evaluation
- host-level sweep
- persist write surfaces

但如果正文停在这里，读者还是很容易把更上游的 blocked-state publish 继续写平：

- 远端来了一个 `can_use_tool`，不就是会话已经进入 waiting-for-input 了吗？
- `requires_action_details` 和 `pending_action` 不都是“有个 prompt 在等输入”的同义字段吗？
- bridge 自己也会发 `can_use_tool`，那它为什么不能像 `stdio` 那样顺手把完整 pending context 一起发布出去？
- worker store 里既然已经有 `pending_action`，CLI 前台为什么不能自然恢复出同样的 blocked UI？

这句还不稳。

从当前源码看，还得继续拆开三种不同层次：

1. permission ask transport subtype
2. blocked-state 双轨投影
3. bridge blocked-state publish ceiling

如果这三层不先拆开，后面就会把：

- `can_use_tool`
- `requires_action_details`
- `pending_action`
- `reportState('requires_action')`

重新压成一句模糊的“等待输入状态”。

## 第一性原理

更稳的提问不是：

- “为什么同样是 `can_use_tool`，有时 blocked 信息很厚，有时又只剩一个 waiting bit？”

而是先问六个更底层的问题：

1. 当前这个 `can_use_tool` 只是 transport ask，还是已经触发了 session-state 升级？
2. 当前 blocked 信息是 typed 窄投影，还是 queryable JSON 镜像？
3. 当前 metadata 已经写进 worker store，还是已经恢复到本地 foreground consumer？
4. bridge 现在发布的是完整 pending context，还是只发布会话相位？
5. 当前 `running -> requires_action -> running` 回跳，是否只在最后一个 pending request 清空后才成立？
6. sandbox network 那条 synthetic `can_use_tool`，是不是也一定走同样的 blocked-state 升级链？

只要这六轴不先拆开，

后面就会把：

- ask transport
- blocked projection
- worker metadata
- bridge state publish

重新压成一句模糊的：

- “permission prompt 会把会话标成 waiting”

## 第一层：`can_use_tool` 首先只是 permission ask transport，不自动等于 blocked session

`structuredIO.ts` 里，真正把一次工具 ask 发出去的动作是：

- `this.sendRequest({ subtype: 'can_use_tool', ... })`

但在同一段代码里，blocked-state 升级并不是自动跟着 `sendRequest(...)` 发生，

而是要靠更前面的：

- `onPermissionPrompt?.(buildRequiresActionDetails(...))`

也就是说，

更准确的顺序不是：

- 发了 `can_use_tool` = 会话自动进入 `requires_action`

而是：

- 先决定当前 prompt 要不要被当作 session-level blocked state
- 再由 `onPermissionPrompt` 显式把 `details` 提升出去
- `sendRequest(...)` 只是 ask transport

所以 `can_use_tool` 这层回答的是：

- 这次 permission 问题怎么走协议

不是：

- blocked session 现在长什么样

## 第二层：`stdio` permission path 才会把 ask 升级成 `requires_action + pending_action` 双轨投影

`print.ts` 把这条升级链写得很明确：

- 只有 `options.sdkUrl` 时，`effectivePermissionPromptToolName` 才被强制成 `stdio`
- `getCanUseToolFn(...)` 也只有在 `permissionPromptToolName === 'stdio'` 时，才返回 `structuredIO.createCanUseTool(onPermissionPrompt)`

而 `onPermissionPrompt` 做的事就是：

- `notifySessionStateChanged('requires_action', details)`

所以这条链真正回答的问题不是：

- “任何 permission ask 都会把 session 推成 blocked”

而是：

- 只有 `stdio` 这条 permission host path
- 才会显式把 prompt 升级成 session-level blocked state

更准确的理解不是：

- `can_use_tool` = blocked-state 协议事实

而是：

- `stdio -> onPermissionPrompt -> notifySessionStateChanged`
- 才是 blocked-state 升级门槛

## 第三层：`requires_action_details` 与 `pending_action` 是双轨投影，不是同一张面

`sessionState.ts` 里，`notifySessionStateChanged('requires_action', details)` 做了两件事：

- `stateListener?.(state, details)`
- `metadataListener?.({ pending_action: details })`

这说明 blocked-state 的输出从一开始就是双轨：

### 轨道一：`requires_action_details`

`CCRClient.reportState(...)` 会把 `details` 压成：

- `tool_name`
- `action_description`
- `request_id`

这是一条 typed、窄、相位相关的 blocked context。

### 轨道二：`external_metadata.pending_action`

`reportMetadata(...)` 则会把完整 metadata bag 写出去，

其中：

- `pending_action` 保留完整 `details`

它是一条 queryable、宽、可被外部 frontend 继续解析的 JSON 镜像。

所以更准确的理解不是：

- 这两个字段只是同一份 blocked 信息的两个名字

而是：

- 一个回答“当前相位下最核心的 typed blocked context 是什么”
- 一个回答“外部 consumer 可查询的完整 pending object 是什么”

## 第四层：worker-side store existence 不等于 CLI foreground restore

`RemoteIO` 会把：

- `setSessionStateChangedListener(...)`
- `setSessionMetadataChangedListener(...)`

分别接到：

- `ccrClient.reportState(...)`
- `ccrClient.reportMetadata(...)`

`CCRClient.initialize()` 还会在 worker init 时主动清掉：

- `pending_action: null`
- `task_summary: null`

这说明 worker-side store 的 producer 确实存在。

但再往回看本地恢复链，

`print.ts` 在 resume/hydrate 时调用的是：

- `setAppState(externalMetadataToAppState(metadata))`

而 `externalMetadataToAppState(...)` 当前只回填：

- `permission_mode`
- `is_ultraplan_mode`

`model` 还是单独走另一条 override 路径。

也就是说，即便 worker store 已经带着：

- `pending_action`

当前 CLI foreground restore 也不会把它重建成同等厚度的本地 blocked UI。

所以更准确的理解不是：

- worker-side metadata already exists = CLI foreground 已接上

而是：

- producer/store 存在
- foreground restore 仍然只接了窄子集

## 第五层：bridge blocked-state publish ceiling 天生更低，只签裸 blocked bit

`remoteBridgeCore.ts` 在 bridge 这条线里做的事情很克制：

- 送出 `control_request.can_use_tool` 时：`transport.reportState('requires_action')`
- 收到 `control_response` 或 `control_cancel_request` 时：`transport.reportState('running')`

而 `replBridgeTransport.ts` 的接口签名本身就说明了这条 publish ceiling：

- `reportState(state: SessionState): void`

没有 details，没有 `pending_action`。

所以 bridge 这条线回答的问题不是：

- “把完整 pending context 发布给远端前台”

而是：

- “把 session 目前是不是 blocked 这件事推给 bridge backend”

更准确的理解不是：

- bridge 只差一步就能发布 `pending_action`

而是：

- transport contract 自己就把 publish ceiling 压在了 coarse blocked bit

## 第六层：同样复用 `can_use_tool` 的 sandbox network access，也不会自动进入同一条 blocked-state 升级链

`structuredIO.ts` 里 `createSandboxAskCallback()` 也会发：

- `subtype: 'can_use_tool'`
- `tool_name: SANDBOX_NETWORK_ACCESS_TOOL_NAME`

但这条线只是：

- synthetic transport shell

它不会经过：

- `onPermissionPrompt`
- `notifySessionStateChanged('requires_action', details)`

这再次说明：

- 不能只靠看见 `can_use_tool` subtype
- 就断言这里一定存在完整 blocked-state publish

所以更准确的结论不是：

- `can_use_tool` 协议本身天然承诺 blocked session

而是：

- 只有某些更窄的 permission host path
- 才会把它提升到 `requires_action + pending_action`

## 第七层：这页不是 51，也不是 133，更不是 203 的重复

先和 51 划清：

- 51 讲远端看到的运行态为什么不是同一张面
- 206 讲一次 `can_use_tool` ask 何时会上升成 blocked-state 双轨投影，以及 bridge 为什么只发裸 blocked bit

51 的主语是：

- remote visible runtime surfaces

206 的主语是：

- blocked-state promotion + publish ceiling

再和 133 划清：

- 133 讲 schema/store 里有账，不等于当前前台已经消费
- 206 讲这张账本身是怎么被生产出来，以及 bridge publish ceiling 为什么更低

最后和 203 划清：

- 203 讲的是 verdict ledger 之后的 tail branches
- 206 讲的是 verdict 之前，permission ask 如何先变成 blocked-state projection

## 结论

更稳的一句应该是：

- `can_use_tool` 首先只是 permission ask transport
- 只有 `stdio -> onPermissionPrompt -> notifySessionStateChanged` 这条链，才会把它升级成 `requires_action + pending_action` 双轨投影
- `requires_action_details` 是 typed 窄投影
- `pending_action` 是 queryable JSON 镜像
- worker-side metadata existence 也不等于 CLI foreground restore
- bridge 这条线则被有意压到只发布裸 blocked bit

一旦这句成立，

就不会再把：

- ask transport
- blocked projection
- worker metadata
- bridge state publish

写成同一种“等待输入状态”。
