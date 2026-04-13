# `buildSystemInitMessage`、`QueryEngine`、`useReplBridge`、`convertInitMessage` 与 redaction：为什么 full init payload、bridge redacted init 与 transcript model-only banner 不是同一种 init payload thickness

## 用户目标

119 已经把：

- request start
- approval pause / resume
- turn-end release
- abort / teardown

拆成了不同的 loading lifecycle edge。

继续往下读时，读者又很容易把 init 这组相邻概念重新压平：

- `buildSystemInitMessage(...)` 会生成一条 `system/init`
- `QueryEngine` 会发它
- `useReplBridge` 也会发它
- transcript 里最后也能看到一条 init 提示

于是正文就会滑成一句顺口但不对的话：

- “既然都是 init，那最多只是同一条对象在不同地方转发一下，payload 本质没变。”

从当前源码看，这也不成立。

这里至少有三种不同厚度：

1. full SDK init payload
2. bridge redacted init payload
3. transcript model-only init banner

它们都和 `system/init` 有关，但不是同一种 init payload thickness。

## 第一性原理

更稳的提问不是：

- “init 有没有发出去？”

而是先问五个更底层的问题：

1. 当前说的是 raw SDK payload，还是 adapter 投影后的 transcript message？
2. 当前是同一个 builder 在不同输入下产出不同厚度，还是完全不同协议？
3. 当前 consumer 需要的是 capability metadata，还是只需要人类可读提示？
4. 当前宿主有没有隐私/能力约束，要求裁掉部分字段？
5. 当前 payload 的“更薄”是 feature-gated host decision，还是 public schema 先天就这么薄？

只要这五轴先拆开，下面几件事就不会再被写成同一个 init payload。

## 第一层：`buildSystemInitMessage(...)` 先定义的是厚 init contract

`systemInit.ts` 的注释把 `buildSystemInitMessage(...)` 定义得很清楚：

- 它构建 SDK 流的第一条 `system/init`
- 承载 session metadata
- remote clients 用它 render pickers 和 gate UI

而函数本体也明确塞进了很多字段：

- `cwd`
- `tools`
- `mcp_servers`
- `model`
- `permissionMode`
- `slash_commands`
- `apiKeySource`
- `claude_code_version`
- `output_style`
- `agents`
- `skills`
- `plugins`
- `fast_mode_state`

所以这一层的主语不是：

- “给 transcript 一句初始化提示”

而是：

- “给 SDK consumer 一份厚的 init metadata payload”

这是 120 最需要钉死的根句。

## 第二层：`QueryEngine` 喂的是 full payload，不是普通示意值

`QueryEngine.ts` 在 yield init 时，直接把这些对象都喂给 builder：

- `tools`
- `mcpClients`
- `model`
- `permissionMode`
- `commands`
- `agents`
- `skills`
- `enabledPlugins`
- `fastMode`

这意味着 QueryEngine 路径上的 init，回答的是：

- full SDK consumer visibility

而不是：

- 某种只供 UI banner 使用的轻量提示

换句话说：

- same builder
- full inputs

就得到：

- full init payload

这是最厚的一层。

## 第三层：`useReplBridge` 不是再发一遍 full payload，而是在 feature gate 下发 redacted init

`useReplBridge.tsx` 对 init 的处理非常关键。

它明确说：

- REPL uses query() directly
- never hits QueryEngine's SDKMessage layer
- 所以 bridge connect 时要自己发一条 `system/init`

但这里最值钱的不是“也发 init”，而是“怎么发”。

当前代码只有在：

- `tengu_bridge_system_init`

开启时，才会发送。

而且传给 builder 的 inputs 被显式裁过：

- `tools: []`
- `mcpClients: []`
- `plugins: []`
- `commands: commandsRef.current.filter(isBridgeSafeCommand)`

同时注释还把原因写得很直白：

- MCP 工具名和 server 名会泄漏用户接了什么集成
- plugin path 会泄漏原始文件系统路径
- mobile/web remote client 也只能安全使用 bridge-safe commands

所以 bridge 这一层回答的不是：

- full SDK telemetry

而是：

- privacy-aware / capability-limited remote client init

这说明：

- same builder
- redacted inputs

会得到：

- bridge redacted payload

它不是 QueryEngine full payload 的简单重发。

## 第四层：同一个 init object 一旦进入 transcript，又会被压成 model-only banner

adapter 里的 `convertInitMessage(...)` 更进一步把厚度压扁。

它没有保留：

- `tools`
- `mcp_servers`
- `slash_commands`
- `skills`
- `plugins`

而是只生成一句：

- `Remote session initialized (model: ${msg.model})`

因此当 `sdkMessageAdapter.ts` 对 `system/init` 返回：

- `{ type: 'message', message: convertInitMessage(msg) }`

它回答的就已经不是：

- SDK payload thickness

而是：

- transcript prompt thickness

这一步和 bridge redaction 又不是同一种“变薄”。

bridge redaction 仍然保留一份结构化 init object，只是字段被裁了。

`convertInitMessage(...)` 则直接把结构化 payload 压成一条面向人的 banner。

所以更准确的写法应是：

- redacted init 仍是 object-level thinning
- model-only banner 则是 prompt-level collapsing

## 第五层：同一 builder 的 payload 还能再长出内部厚度，不止 public schema 一层

`buildSystemInitMessage(...)` 里还有一个很容易被漏掉的灰度点：

- `UDS_INBOX` feature 开启时
- 会把 `messaging_socket_path` 塞进 `initMessage`
- 注释直接说明这是 hidden from public SDK types

这说明 even before transcript projection：

- init payload thickness

也不只是：

- public schema 允许的那一层

还有：

- internal/feature-gated extra field thickness

因此 120 不仅要保护：

- full vs redacted vs banner

也要顺手保护：

- public SDK-visible thickness
- internal hidden thickness

不要把它们混成同一张表。

## 第六层：所以 init 至少有四种厚度

把上面几层压实之后，更稳的总表是：

| 厚度层 | 当前回答什么 | 典型例子 |
| --- | --- | --- |
| public full payload | SDK consumer 能拿到哪些标准 init metadata | `QueryEngine -> buildSystemInitMessage(full inputs)` |
| host-redacted payload | 某类远端宿主可安全拿到哪些字段 | `useReplBridge` redacted init |
| internal extra thickness | feature-gated 内部字段是否附着在同一对象上 | `messaging_socket_path` |
| transcript banner | 用户在正文里最终看到哪句初始化提示 | `convertInitMessage(...)` |

所以真正该写成一句话的是：

- same `system/init`

不等于：

- same payload thickness

更不等于：

- same consumer contract

## 第七层：稳定层、条件层与灰度层

### 稳定可见

- same init builder != same payload thickness in practice
- `buildSystemInitMessage(...)` 当前定义的是厚的 init metadata contract
- QueryEngine 当前走 full inputs
- bridge init 当前受 feature gate 控制，且输入被显式 redaction
- transcript 侧当前最后只剩 model-only prompt
- internal feature 下当前还能附着 public schema 外字段

### 条件公开

- 所有 build 是否都会开启 `tengu_bridge_system_init`，仍取决于当前 feature/build route
- bridge redaction 策略未来会不会继续调整，仍取决于当前实现策略
- transcript prompt 会不会永远只保留 model、不再加更多字段，也仍是条件化宿主选择

### 内部/灰度层

- `buildSystemInitMessage(...)`、QueryEngine、`useReplBridge` 与 `convertInitMessage(...)` 的 exact helper 顺序
- bridge redaction 的 exact field list 与 build wiring
- internal-only 附着字段未来会不会继续变化

所以这页最稳的结论必须停在：

- same init builder != same payload thickness in practice

而不能滑到：

- all hosts consume one identical init payload

## 第八层：为什么 120 不能并回 117

117 的主语是：

- init 在 metadata、callback、dedupe、prompt 与 bootstrap 里不是同一种初始化可见性

120 的主语则更窄：

- even before/through those layers，init payload 本身在 full、redacted、banner 三种厚度里也不是同一层

117 讲：

- visibility surfaces

120 讲：

- payload thickness surfaces

不是一页。

## 第九层：为什么 120 也不能并回 119

119 的主语是：

- loading flag 的 lifecycle edge

120 的主语已经完全换成：

- init metadata payload width

一个讲：

- waiting state transitions

另一个讲：

- initialization metadata thickness

问题域已经不同。

## 第十层：最常见的假等式

### 误判一：bridge 发的 `system/init` 只是 QueryEngine init 的转发副本

错在漏掉：

- gate
- redaction
- bridge-safe command filtering

### 误判二：只要 transcript 里有 init 提示，就说明用户已经“看到了 init payload”

错在漏掉：

- banner 只保留了 model

### 误判三：同一个 builder 说明 payload 厚度一定一致

错在漏掉：

- 输入集合可以被宿主主动裁剪

### 误判四：public schema 就是 init 的全部厚度

错在漏掉：

- `UDS_INBOX` 下还有 hidden field

### 误判五：bridge redaction 和 transcript 压缩只是同一种“变少一点”

错在漏掉：

- 一个仍是 object-level metadata
- 一个已经是 human-readable prompt

## 第十一层：苏格拉底式自审

### 问：我现在写的是 full object、redacted object，还是 transcript banner？

答：如果答不出来，就说明又把 payload thickness 写平了。

### 问：我是不是把 bridge init 写成了 full payload 的普通副本？

答：如果是，就漏掉了 explicit redaction。

### 问：我是不是把 init banner 写成了 metadata 可见性？

答：如果是，就还没把 object-level thickness 和 prompt-level collapsing 分开。

### 问：我是不是忘了 internal hidden field 这一层？

答：如果是，就把 public schema 当成了全部厚度。
