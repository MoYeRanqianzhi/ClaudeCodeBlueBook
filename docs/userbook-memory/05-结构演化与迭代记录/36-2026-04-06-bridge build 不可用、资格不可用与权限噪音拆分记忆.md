# bridge build 不可用、资格不可用与权限噪音拆分记忆

## 本轮继续深入的核心判断

第 23 页已经拆开：

- workspace trust
- bridge eligibility
- trusted-device

第 35 页已经拆开：

- trust repair
- `/login`
- restart remote-control
- fresh fallback
- retry

但 remote-control 仍缺一层非常容易被写扁的“不能用”语义：

- build 不带
- 资格未开
- policy 禁用
- runtime environment 不可用
- 核心权限拒绝
- suppressible 403 噪音

如果不单独补这一批，正文会继续犯六种错：

- 把 build 不带写成账号没资格
- 把资格未开写成组织策略禁用
- 把运行时 404 写成 preflight policy denial
- 把核心权限拒绝和附属权限噪音写成同一类 403
- 把 suppressible 403 写进 reader 正文
- 把第 23 页的资格门总图和第 35 页的补救动作重新揉成一页

## 苏格拉底式自审

### 问：为什么这批不能塞回第 23 页？

答：第 23 页解决的是：

- remote-control 进入前到底有哪几道门

而本轮问题已经换成：

- 用户真正看到“不能用”时，系统到底是在说哪一种不能用

也就是从：

- prerequisite layers

继续下钻到：

- denial surfaces

所以需要新起一页。

### 问：为什么这批也不能塞回第 35 页？

答：第 35 页解决的是：

- 失败后为什么建议 trust、`/login`、restart、fallback、retry

而本轮更偏：

- 有些情况连“进入补救动作选择”都还没到
- 系统先要判断这是不是一类值得公开展示的 denial

这已经从：

- remedy path

换成：

- availability / permission boundary

所以不能再混回去。

### 问：这批最该防的偷换是什么？

答：

- build unavailable = entitlement unavailable
- policy disabled = runtime unavailable
- core 403 = all 403
- suppressible noise = user-facing failure

只要这四组没拆开，remote-control 的“不能用”正文就还会继续糊。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/36-Remote Control build 不可用、资格不可用、组织拒绝与权限噪音：为什么 bridge 的 not enabled、policy disabled、not available 与 Access denied 不是同一种“不能用”.md`
- `bluebook/userbook/03-参考索引/02-能力边界/25-Remote Control build 不可用、资格不可用、组织拒绝与权限噪音索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/36-2026-04-06-bridge build 不可用、资格不可用与权限噪音拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- build 不带属于 capability absence
- 资格未开属于 entitlement absence
- policy disabled 属于组织主动禁止
- runtime 404 属于 environment availability denial
- `Access denied (403)` 属于核心权限拒绝
- suppressible 403 只作为“为什么不该写进正文”的边界说明

### 不应写进正文的

- `external_poll_sessions`
- `environments:manage`
- fatal loop 的 debug / telemetry 写法
- `isSuppressible403` 的具体匹配实现

这些只保留为作者判断依据。

## 本轮特别保留到记忆的源码发现

### `getBridgeDisabledReason()` 同时承载 build 不带与 entitlement 不开

`bridgeEnabled.ts` 在一个函数里连续返回：

- `requires a claude.ai subscription`
- `requires a full-scope login token`
- `Unable to determine your organization`
- `not yet enabled for your account`
- `not available in this build`

所以正文必须强调：

- 同属 disabled reason
- 但不是同一类 capability boundary

### `/remote-control` 与 `claude remote-control` 都先检查 policy，但 policy 不是 runtime 404

`commands/bridge/bridge.tsx` 与 `entrypoints/cli.tsx` 都在 preflight 里直接检查：

- `allow_remote_control`

这意味着：

- policy disabled 在本地启动前就能被拒

而 `bridgeMain.ts` 里的：

- `Remote Control environments are not available for your account`

发生在注册 environment 的 runtime 里。

### generic 404 与 context-specific 404 不应在正文里平铺对待

`bridgeApi.ts` 的 fallback 说：

- may not be available for this organization

`bridgeMain.ts` 的注册环境上下文则收窄成：

- environments are not available for your account

正文应优先采用更贴近用户动作面的收窄语义，而不是把 API fallback 原文制度化。

### suppressible 403 的真正价值是“提醒作者不要把噪音写进正文”

这批最重要的不是读者需要知道 `external_poll_sessions` 是什么，而是作者必须知道：

- 并非所有 403 都是 reader-facing failure
- 源码已经在两个宿主里执行了降噪政策

如果把这层忘掉，正文会再次被实现噪音污染。

## 并行 agent 结果

本轮并行 agent 已确认：

- build / entitlement / policy / runtime availability / core permission denial 可以形成独立批次
- suppressible 403 应留在 memory，不应进入正文主线
- 第 23 页与第 35 页都不适合承载这层 denial surface

## 后续继续深入时的检查问题

1. 我现在拆的是 prerequisite layer，还是 denial surface？
2. 这条错误是在说 capability absence、policy refusal，还是 runtime denial？
3. 这是不是核心权限失败，还是附属操作噪音？
4. 我是不是又把 generic API fallback 写成了 reader 主承诺？
5. 我是不是又让 suppressible 403 污染了正文？

只要这五问没先答清，下一页继续深入就会重新滑回：

- 不可用语义混写
- 或实现噪音回流正文

而不是用户真正可用的 availability / permission boundary 正文。
