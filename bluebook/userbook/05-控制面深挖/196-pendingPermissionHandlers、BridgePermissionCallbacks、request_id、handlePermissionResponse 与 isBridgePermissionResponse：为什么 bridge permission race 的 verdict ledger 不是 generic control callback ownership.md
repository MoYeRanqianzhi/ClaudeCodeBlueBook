# `pendingPermissionHandlers`、`BridgePermissionCallbacks`、`request_id`、`handlePermissionResponse` 与 `isBridgePermissionResponse`：为什么 bridge permission race 的 verdict ledger 不是 generic control callback ownership

## 用户目标

29 已经说明：

- bridge permission callbacks
- control request
- command 白名单

不是同一种控制合同。

193 又说明：

- ingress 的 `control_response` 不是通用 control reply 总线

但如果正文停在这里，读者还是很容易把 hook 内部的 permission ownership 写平：

- `pendingPermissionHandlers` 不就是一个回调 Map 吗？为什么不能把它看成 bridge control 的通用回调注册表？
- `request_id` 既然来自 `control_request` / `control_response`，为什么不能直接说它是 generic control correlation id？
- `handlePermissionResponse(...)` 明明就在吃 `control_response`，为什么还要再强调它不是通用 dispatcher？
- `BridgePermissionCallbacks` 既有 `sendRequest` 又有 `sendResponse` 还有 `onResponse`，这看起来不就是一条完整的通用 RPC 面吗？

这句还不稳。

从当前源码看，还得继续拆开两层不同对象：

1. control side-channel 的 transport frame
2. permission race 的本地 verdict ledger

如果这两层不先拆开，后面就会把：

- `pendingPermissionHandlers`
- `request_id`
- `handlePermissionResponse(...)`
- `BridgePermissionCallbacks`

重新压成一句模糊的“bridge 的 control callback ownership”。

## 第一性原理

更稳的提问不是：

- “为什么这个 Map 不是通用 callback registry？”

而是先问六个更底层的问题：

1. 当前登记的 handler 是在等待任何一种 control reply，还是只在等 permission verdict？
2. 当前 `request_id` 关联的是整条 control side-channel，还是 bridge permission race 这一条子协议？
3. 当前回调被消费后，是长期保留订阅，还是在第一次 verdict 后立刻出账？
4. 当前 payload gate 关心的是任意 `control_response` 是否可读，还是它是不是 `allow/deny` 这类 permission verdict？
5. 当前这张 ledger 的主语是 transport 层的 frame 对齐，还是本地 race 所有权？
6. 我现在分析的是 193 的 callback 非对称，还是 permission leg 自己为什么还有一张更窄的本地账？

只要这六轴不先拆开，后面就会把：

- control frame
- permission verdict
- local ownership

混成一张“bridge callback 表”。

## 第一层：`BridgePermissionCallbacks` 看起来像 RPC 面，但它的主语从一开始就只限于 permission race

`bridgePermissionCallbacks.ts` 里这套接口只有四件事：

- `sendRequest(...)`
- `sendResponse(...)`
- `cancelRequest(...)`
- `onResponse(...)`

它并没有声明：

- 任意 control subtype 的注册
- 通用 `control_response` 订阅
- 任意 session-control 请求的回调 ownership

更关键的是它的 response 类型也很窄：

- `BridgePermissionResponse`
- `behavior: 'allow' | 'deny'`
- 可选 `updatedInput`
- 可选 `updatedPermissions`

这说明它回答的问题不是：

- “bridge control plane 上所有 frame 的回调 ownership 怎么管”

而是：

- “bridge permission race 的 request / verdict / cancel / listener 怎么闭环”

所以更准确的理解不是：

- 这是一套 generic control RPC

而是：

- 这是一套 permission-race-specific RPC-like surface

## 第二层：`pendingPermissionHandlers` 不是通用 registry，而是挂起 permission verdict 的本地 ledger

`useReplBridge.tsx` 把这张账写得非常直白：

- `const pendingPermissionHandlers = new Map<string, (response: BridgePermissionResponse) => void>()`
- 注释就写着：keyed by `request_id`
- 每个 entry 都是在等 CCR reply 的 `onResponse` handler

它的写入点也很窄：

- `permissionCallbacks.onResponse(requestId, handler)` 里 `set`
- 返回值只是一个 `unsubscribe`，用于删掉同一个 `requestId`

它的消费点也很窄：

- `handlePermissionResponse(...)` 里按 `request_id` 查找
- 命中后立刻 `delete`

所以这张账的真实身份不是：

- “桥接层所有控制回调的中央注册表”

而是：

- “本地 permission race 里尚未出账的 verdict handlers”

这也是为什么它天然是一张：

- pending ledger

不是：

- durable registry

## 第三层：`request_id` 在这里不是 generic control id，而是 permission verdict 的 correlation key

Transport 层看上去：

- `sendRequest(...)` 发的是 `type: 'control_request'`
- `sendResponse(...)` 发的是 `type: 'control_response'`

很容易让人误以为：

- `request_id` 就是整条 control side-channel 的统一主键

但 hook 里实际对它的使用更窄：

- `sendRequest(...)` 构造的是 `subtype: 'can_use_tool'`
- `sendResponse(...)` 回的是桥接 permission payload
- `handlePermissionResponse(...)` 只在 `request_id` 命中 pending map 时继续

这说明这里的 `request_id` 回答的问题不是：

- “任何 control frame 和任何 callback 之间怎么相关”

而是：

- “这一轮 permission race 的请求与 verdict 怎么重新配对”

所以更准确地说：

- 在 permission leg 里，`request_id` 是 race-local correlation key

不是：

- generic control ownership key

## 第四层：`handlePermissionResponse(...)` 不是通用 dispatcher，而是 verdict ledger 的 drain 点

`handlePermissionResponse(...)` 的逻辑非常有选择性：

1. 没 `request_id` 直接返回
2. 找不到 pending handler 直接记日志并返回
3. 命中后先 `delete`
4. 只有 `inner.subtype === 'success'`
5. 只有 `inner.response` 通过 `isBridgePermissionResponse(...)`
6. 才真正调用 handler

这说明它做的不是：

- 对所有 `control_response` 做通用分发

而是：

- 从本地 pending ledger 里取出对应 race entry
- 验证这是不是 permission verdict payload
- 然后把这张账出掉

所以更准确的理解不是：

- 它是一个 `control_response` dispatcher

而是：

- 它是 verdict ledger 的 drain function

## 第五层：`isBridgePermissionResponse(...)` 证明这张账的 payload ownership 也不是通用的

如果 `pendingPermissionHandlers` 真是 generic registry，

你会期待：

- 对 `SDKControlResponse` 的通用 schema 判定
- 或至少不同 subtype 的并行 decoder

但这里实际 gate 的只是：

- `behavior === 'allow' || behavior === 'deny'`

这说明本地账里挂起的 handler 从一开始就只关心：

- bridge permission verdict payload

而不关心：

- `initialize`
- `set_model`
- 其他 session-control reply

这再次证明：

- 这张账的 ownership 绑定的是 permission verdict

不是：

- 任意 control response

## 第六层：这页不是 29，也不是 193

29 的主语是：

- control 对象家族

它回答：

- 权限提示、会话控制、命令白名单为什么不是同一类对象

196 的主语更窄：

- permission race 内部的本地 verdict ledger ownership

193 的主语是：

- `control_response` 和 `control_request` 在 ingress 上为什么不是对称 callback 腿

196 继续追的是：

- 既然 `control_response` 已经被收窄成 permission leg，为什么这条腿内部还有一张更窄的本地账，而不是 generic callback registry

所以：

- 29 讲对象分层
- 193 讲 callback 腿分裂
- 196 讲 permission leg 的 local ledger ownership

如果把三层重新压平，就会把：

- control object
- transport callback
- local pending ledger

又写成一句泛泛的：

- “bridge 会根据 request_id 分发控制响应”

这句会把真正的 ownership 边界全部抹掉。

## 第七层：稳定层、条件层与灰度层

### 稳定可见

- `pendingPermissionHandlers` 当前不是 generic control callback registry。
- 它当前是一张以 `request_id` 为键的本地 pending verdict ledger。
- `handlePermissionResponse(...)` 当前是这张 ledger 的 drain 点，不是通用 `control_response` dispatcher。
- `isBridgePermissionResponse(...)` 当前又把 payload ownership 继续收窄到 `allow/deny` 这类 permission verdict。
- `request_id` 在这里当前只服务 permission race 的 request / verdict 配对，不代表所有 control frame 的统一 ownership key。

### 条件公开

- 某个 pending verdict 最终何时被 drain，仍取决于当前 response arrival timing 与 race 路径。
- 未来是否会在 permission leg 内再分更多 subtype gate，仍取决于当前 host / transport route，而不是这页已经稳定暴露的 ledger 合同。
- `request_id` 在其他 control path 上是否承担别的相关角色，仍取决于那些路径自己的主语，不改变这页当前收住的 ownership 边界。

### 内部/灰度层

- `pendingPermissionHandlers` 的具体存取 wiring
- `handlePermissionResponse(...)` 的 helper 调度细节
- `isBridgePermissionResponse(...)` 的 exact payload gate 细节
- permission leg 内部的 future branch / subtype 扩张

所以这页最稳的结论必须停在：

- permission leg 内部存在一张本地 pending verdict ledger
- 这张 ledger 不等于 generic control callback registry

而不能滑到：

- 只要带 `request_id` 的 `control_response` 都会走同一张通用 registry

## 结论

所以这页能安全落下的结论应停在：

- `pendingPermissionHandlers` 不是 generic control callback registry
- 它是一张以 `request_id` 为键的本地 pending verdict ledger
- `handlePermissionResponse(...)` 不是通用 `control_response` dispatcher，而是这张 ledger 的 drain 点
- `isBridgePermissionResponse(...)` 又把 payload ownership 进一步限制在 `allow/deny` 这类 permission verdict

一旦这句成立，就不会再把：

- `BridgePermissionCallbacks`
- `request_id`
- `pendingPermissionHandlers`

写成 generic control callback ownership。
