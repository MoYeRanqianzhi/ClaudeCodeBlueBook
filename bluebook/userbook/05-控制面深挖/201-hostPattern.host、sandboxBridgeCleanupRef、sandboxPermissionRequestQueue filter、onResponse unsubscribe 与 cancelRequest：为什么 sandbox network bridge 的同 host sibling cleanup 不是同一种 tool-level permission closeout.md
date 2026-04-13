# `hostPattern.host`、`sandboxBridgeCleanupRef`、`sandboxPermissionRequestQueue filter`、`onResponse` unsubscribe 与 `cancelRequest`：为什么 sandbox network bridge 的同 host sibling cleanup 不是同一种 tool-level permission closeout

## 用户目标

198 已经把 request-level permission race 的 closeout 拆成：

- prompt 撤场
- subscription 退役
- late response 消费
- 策略变化后的旧等待窗重判

但这不表示 `201` 是 `198` 的 sandbox 版线性下一步。

按 permission tail 的 canonical 拓扑，

- `201`

仍应回挂到 `196` 之后的 sandbox-network 分支；

这里只是先借 `198` 的 request-level closeout 当反例，

避免把 same-host sibling sweep 误写成单 ask 收口的放大版。

但如果正文停在这里，读者还是很容易把 sandbox network bridge 这条线继续写平：

- `SandboxNetworkAccess` 不就是 bridge 里另一个普通 `can_use_tool` ask 吗？
- 本地或远端一旦给出 allow/deny，`unsubscribe()`、`cancelRequest(...)`、queue filter 看起来不也只是单 ask cleanup？
- 为什么一次对某个 host 的 verdict 会直接清掉一整组 waiting network requests？
- `sandboxBridgeCleanupRef` 不就是个 cleanup map，为什么还要单列？

这句还不稳。

从当前源码看，还得继续拆开两种不同主语：

1. request-level closeout
2. host-level sibling sweep

如果这两层不先拆开，后面就会把：

- `hostPattern.host`
- `sandboxBridgeCleanupRef`
- `sandboxPermissionRequestQueue` filter
- `unsubscribe()`
- `cancelRequest(...)`

重新压成一句模糊的“network permission cleanup”。

## 第一性原理

更稳的提问不是：

- “为什么这里一次 approve 会清掉多个 ask？”

而是先问六个更底层的问题：

1. 当前 verdict 绑定的是某个 `request_id`，还是某个 `hostPattern.host` 下面的一组 sibling asks？
2. 当前 queue 记录的是单个 tool permission 请求，还是某个 host 级别的 network gate？
3. 当前 cleanup map 是按单 ask 建索引，还是按 host 聚合？
4. 当前 `unsubscribe()` / `cancelRequest(...)` 关掉的是一个 request，还是某个 host 下面整组远端 prompt 的遗留表面？
5. 当前 `SandboxNetworkAccess` 是真正主语，还是把 host verdict 装进 bridge 协议的 synthetic shell？
6. 我现在分析的是 198 的 request-level closeout，还是 sandbox host verdict 的 sibling sweep？

只要这六轴不先拆开，后面就会把：

- tool-level closeout
- host verdict
- sibling cleanup

混成一张“sandbox approval 表”。

## 第一层：`SandboxNetworkAccess` 先只是 transport shell，不是这条线真正的收口主语

`structuredIO.ts` 里把：

- `SANDBOX_NETWORK_ACCESS_TOOL_NAME = 'SandboxNetworkAccess'`

直接注释成：

- synthetic tool name
- 用来把 sandbox network permission request forward 到 `can_use_tool` control_request 协议里

这说明这里回答的问题不是：

- “系统真的又多了一种普通 tool permission ask”

而是：

- “host-level 的 network access verdict 被临时装进 bridge 的 tool approval transport”

所以更准确的理解不是：

- 这里和普通 tool ask 的主语完全相同

而是：

- `can_use_tool` 只是运输壳
- `hostPattern.host` 才是这条线真正的 verdict 主语

## 第二层：`sandboxPermissionRequestQueue` 也是按 host settle，不是按单个 ask settle

`REPL.tsx` 在本地 network access 正常路径里先做：

- `setSandboxPermissionRequestQueue(prev => [...prev, { hostPattern, resolvePromise }])`

这条 queue 记录的不是：

- 某个 `bridgeRequestId`

而是：

- 某个 host pattern 对应的本地等待项

更关键的是，无论 verdict 来自远端还是本地 UI，真正 settle 时都做同一件事：

- 过滤出 queue 里 `item.hostPattern.host === approvedHost`
- 对这些 sibling items 全部 `resolvePromise(allow)`
- 然后把它们整组从 queue 里滤掉

这说明当前 queue 回答的问题不是：

- “某一条 permission ask 结束了吗？”

而是：

- “这个 host 下面的一组并发 network requests 现在要不要统一放行/拒绝？”

所以这一层的 settle 主语从一开始就是：

- host family

不是：

- request family

## 第三层：`sandboxBridgeCleanupRef` 明确是 host-keyed sibling cleanup map，不是 request-id map

`REPL.tsx` 前面就把这张表写成：

- `useRef<Map<string, Array<() => void>>>(new Map())`

并在注释里说明：

- keyed by host

bridge 路径每发出一个同 host 的 network ask，就会登记一个 cleanup：

- `unsubscribe()`
- `bridgeCallbacks.cancelRequest(bridgeRequestId)`

然后把它挂到：

- `sandboxBridgeCleanupRef.current.get(hostPattern.host)`

这一组里。

这说明这张表回答的问题不是：

- “某个 request_id 的 cleanup 是什么”

而是：

- “当某个 host 已经得到 verdict 时，还需要把这组 sibling bridge prompts 里哪些遗留表面一起扫掉”

所以更准确地理解不是：

- 这是 tool-level closeout map

而是：

- 这是 host-level sibling cleanup map

## 第四层：远端响应和本地响应都会触发同一套 host sweep

远端 bridge response 到来时，代码做的是：

- 先 `unsubscribe()`
- 再对同 host queue 做批量 resolve/remove
- 然后把 `sandboxBridgeCleanupRef` 里这个 host 的所有 sibling cleanups 一起执行

本地用户在 `SandboxPermissionRequest` UI 里响应时，也做同样的事：

- 先取 `approvedHost`
- 再按同 host 批量 resolve/remove
- 再扫掉这个 host 的所有 cleanups

这说明这里的对称性不在：

- “本地和远端各自都清理了自己的 request”

而在：

- “无论 verdict 从哪边来，真正要 settle 的都是同一个 host family”

所以：

- `unsubscribe()` / `cancelRequest(...)`

在这条线上不是最终主语，

只是：

- host sweep 里的局部 cleanup 动作

## 第五层：这页不是 198，也不是 78 / 79

先和 198 划清：

- 198 讲的是单个 permission race 在 verdict 之后有哪些 closeout 动作
- 201 讲的是 sandbox network bridge 里，一次 host verdict 为什么会横扫一组 sibling asks

198 的主语是：

- request-level closeout

201 的主语是：

- host-level sibling sweep

再和 78 划清：

- 78 讲的是 worker sandbox ask 不等于 leader 本地 network prompt
- 201 讲的是本地 host prompt + bridge sibling cleanup 的 host 聚合

78 的主语是：

- worker-origin vs leader-local prompt ownership

201 的主语是：

- same-host batch settle

最后和 79 划清：

- 79 是 approval shell atlas，讲更高层的五张主权图
- 201 只讲 atlas 里 sandbox host 这一张图内部，为什么还有 host-level cleanup contract

## 第六层：稳定层、条件层与灰度层

### 稳定可见

- `SandboxNetworkAccess` 当前只是把 host verdict 装进 tool approval 协议里的 transport shell。
- `sandboxPermissionRequestQueue` 当前按 `hostPattern.host` 成组 settle，不按单个 `request_id` settle。
- `sandboxBridgeCleanupRef` 当前是 host-keyed sibling cleanup map，不是 request-id cleanup map。
- 无论 verdict 来自远端 bridge response 还是本地 UI 响应，真正被 settle 的都是同一个 host family。
- `unsubscribe()` 与 `cancelRequest(...)` 当前都只是 host sweep 里的局部 cleanup 动作，不是这条线的最终主语。

### 条件公开

- 某个 host verdict 最终会横扫多少 sibling asks，仍取决于当前 queue 中同 host 的挂起项分布。
- 哪些 bridge prompt cleanup 会被一起扫掉，也仍取决于 `sandboxBridgeCleanupRef` 当前按 host 聚合的登记情况。
- future build 会不会把 transport shell、queue settle 或 cleanup map 再细分，仍取决于当前 host / bridge route，而不是这页已经稳定暴露的合同。

### 内部/灰度层

- `sandboxPermissionRequestQueue` filter 的 exact 过滤顺序
- `sandboxBridgeCleanupRef` 的具体登记/清空 wiring
- 远端 response 与本地 UI response 路径上的 helper 调用细节
- `unsubscribe()` 与 `cancelRequest(...)` 的 exact 执行时机

所以这页最稳的结论必须停在：

- sandbox network bridge 里存在一条 host-level sibling sweep 合同
- 这条合同不等于 tool-level closeout 的放大版

而不能滑到：

- 只要 approve/deny 一次，就只是顺手多清了几条 request cleanup

## 结论

所以这页能安全落下的结论应停在：

- 在 sandbox network bridge 里，真正被 settle 的不是某个 `bridgeRequestId`
- 而是某个 `hostPattern.host` 下面整组并发 sibling asks
- `SandboxNetworkAccess` 只是把这个 host verdict 装进 tool approval 协议里的运输壳
- `unsubscribe()` 与 `cancelRequest(...)` 只是 host sweep 里的局部 cleanup 动作

一旦这句成立，

就不会再把：

- same-host queue filter
- sibling cleanups
- tool-level closeout

写成同一种东西。
