# `Workspace Trust`、`/login`、restart `remote-control`、fresh session fallback 与 `retry`：为什么 bridge 的补救动作不是同一种恢复建议

## 用户目标

不是只知道 Claude Code 里“有时让我先跑一次普通 `claude`，有时让我 `/login`，有时又说重启 `claude remote-control` 或 `/remote-control`，还有时它直接 `Creating a fresh session instead`，甚至只让我 `try running the same command again`”，而是先分清五类不同对象：

- 哪些问题发生在 bridge 启动前的工作区前提层。
- 哪些问题发生在账户认证与订阅资格层。
- 哪些问题说明当前 remote-control host 已经过期，只能重建。
- 哪些问题说明旧 continuity 断了，但当前启动还可以自动降级成 fresh session。
- 哪些问题只是本次 reconnect 没成功，但系统仍故意保留旧轨迹给下一次重试。

如果这些对象不先拆开，读者最容易把下面这些文案压成同一种“恢复建议”：

- `Workspace not trusted. Please run \`claude\` in ... first`
- `Please use \`/login\` to sign in with your claude.ai account`
- `Please restart with \`claude remote-control\` or /remote-control`
- `Creating a fresh session instead`
- `The session may still be resumable — try running the same command again`

## 第一性原理

bridge 的补救动作至少沿着四条轴线分化：

1. `Broken Plane`：坏掉的是 workspace 前提、账户身份、bridge host、旧 continuity，还是一次瞬态 reconnect。
2. `Repair Scope`：系统需要你建立前提、修复身份、重建 host、接受 continuity 降级，还是保留原轨迹重试。
3. `Continuity Cost`：当前失败会不会彻底丢掉旧 session continuity，还是只是当前这一跳没接上。
4. `System Policy`：源码这次是直接拒绝启动、给显式人工动作、自动回退，还是故意保留重试入口。

因此更稳的提问不是：

- “为什么这次恢复失败后给的建议又不一样了？”

而是：

- “这次坏掉的是哪一层对象；系统要我修什么；旧 continuity 是必须放弃、可以自动降级，还是值得保留再试一次？”

只要这四条轴线没先拆开，正文就会把 trust、auth、restart、fallback 与 retry 写成同一种“恢复建议”。

## 第一层：`Workspace Trust` 修的是工作区前提，不是 bridge 身份

### bridge 在这里先检查 workspace 是否已被普通 `claude` 会话信任

`bridgeMain.ts` 在进入 auth 与 resume 之前，先检查：

- `checkHasTrustDialogAccepted()`

如果没有，就直接报：

- `Workspace not trusted. Please run \`claude\` in ... first to review and accept the workspace trust dialog.`

这说明这里坏掉的不是：

- 账户没登录
- bridge token 过期
- 老 session 恢复失败

而是：

- 这个目录还没完成普通交互会话里的 trust 建立

### 所以它要求的是“先建立工作区前提”，不是“修 bridge”

源码注释写得很直白：

- bridge bypasses `main.tsx`
- 因而不能在这里临时弹出正常的 Trust Dialog

所以更稳的理解应是：

- 先跑普通 `claude`
- 在该目录里接受 trust
- 再回来开 bridge

这条补救动作解决的是 workspace plane，不是 auth plane。

## 第二层：`/login` 修的是身份与订阅前提，不是当前 bridge continuity

### 无 token 与 `401` 都指向同一个身份修复动作

`types.ts` 里把 `BRIDGE_LOGIN_INSTRUCTION` 固定写成：

- `Please use \`/login\` to sign in with your claude.ai account`

`bridgeMain.ts` 在本地根本拿不到 bridge token 时，直接打印完整 `BRIDGE_LOGIN_ERROR`。

`bridgeApi.ts` 在 API 路径收到 `401` 时，也会把同一条 `BRIDGE_LOGIN_INSTRUCTION` 拼进 fatal error。

这说明这里系统回答的问题不是：

- 这条 remote-control session 还活不活

而是：

- 当前账户身份 / 订阅前提不足，bridge 连入口都不该继续走

### 因而 `/login` 修的是 account plane

更稳的区分是：

- `run \`claude\` first`：修 workspace trust
- `/login`：修账户身份与 claude.ai 订阅前提

只要这一层没拆开，正文就会把：

- workspace prerequisite
- account prerequisite

混写成同一种“开不了 bridge”。

## 第三层：restart `remote-control` 修的是已失效的 bridge host，不是让旧 continuity 自己复活

### expiry 语义的 `403` / `410` 明确要求重建 remote-control

`bridgeApi.ts` 对：

- 含 expiry 语义的 `403`
- `410`

都会给出同一条补救建议：

- `Please restart with \`claude remote-control\` or /remote-control.`

这说明这里坏掉的对象不是：

- 登录态本身
- 一次临时网络抖动

而是：

- 当前 remote-control session / environment 已经过期，必须重建 bridge host

### REPL 的 `session expired · /remote-control to reconnect` 是同一条补救语义的短写

`replBridge.ts` 在 fatal poll error 上，如果 `errorType` 被判成 expiry，就把状态改成：

- `session expired · /remote-control to reconnect`

所以 REPL 与 CLI 的关系不是：

- 一个说重连
- 一个说重启

而是：

- 二者都在指向“旧 host 已失效，需要重新建立 remote-control”
- 只是 REPL 用更短的状态词承载同一 repair route

### 这也说明不是所有 `403` 都属于 restart 路线

同一个 `bridgeApi.ts` 里，普通 `403` 会变成：

- `Access denied ... Check your organization permissions.`

因此更稳的写法应是：

- expiry 型 `403` / `410` -> restart remote-control
- 普通权限型 `403` -> 检查组织权限

而不能把所有 `403` 都写成“重启 bridge 就行”。

## 第四层：fresh session fallback 不是恢复成功，而是 continuity downgrade

### env mismatch 的语义是“旧 continuity 断了，但当前启动还可以继续”

`bridgeMain.ts` 在 resume 流里，如果请求重用的 `environment_id` 与后端返回的新 `environment_id` 不一致，就告警：

- `Could not resume session ... its environment has expired. Creating a fresh session instead.`

这说明这里系统并没有说：

- 旧 session 已成功恢复

而是在说：

- 老环境已经过期
- 原 continuity 断了
- 但当前命令不必整体判死，可以直接降级成一条 fresh session

### 所以这条补救动作既不同于 hard failure，也不同于 retry

更准确的理解是：

- hard failure：当前启动失败，需要人工补救
- fresh fallback：旧 continuity 失败，但当前启动自动继续
- retry：当前启动失败，但旧 continuity 仍值得保留给下一次再试

只要这一层没拆开，正文就会把：

- “还能继续跑”

偷换成：

- “原 session 已恢复成功”

## 第五层：`try running the same command again` 说明系统故意保留旧轨迹

### transient reconnect failure 的核心不是“失败了”，而是“先别删轨迹”

`bridgeMain.ts` 在 reconnect 候选全部失败后，先区分：

- fatal failure
- transient failure

只有 fatal failure 才清 pointer。

如果是 transient failure，错误文案会变成：

- `The session may still be resumable — try running the same command again`

这说明这里最关键的系统政策不是：

- 给了一句客套安慰

而是：

- 旧恢复轨迹被故意保留
- “再跑一次同样命令”本身就是 retry 机制

### 因而 retry 修的是“这一跳没接上”，不是“所有 continuity 已作废”

更稳的区分是：

- restart remote-control：旧 host 已失效，要重建
- fresh fallback：旧 continuity 失效，但当前启动自动降级
- retry same command：旧 continuity 仍可能成功，系统不该先把它删掉

## 第六层：同样提到 `/login`，也可能不是纯 auth repair

### `Session not found` 偶尔会带上 “run \`claude /login\`”，但它仍先清 pointer

`bridgeMain.ts` 的 resume 路径里，如果：

- `getBridgeSession(...)` 根本拿不到 session

系统会先清掉 pointer，然后再报：

- `Session ... not found. It may have been archived or expired, or your login may have lapsed (run \`claude /login\`).`

这说明即便错误文案里出现了登录建议，这里回答的问题也仍然可能是：

- 当前恢复源已经是 deterministic invalid source

而不是：

- 一个纯粹的 auth failure

### 所以“看到了 `/login`”不等于“这次一定属于 account plane”

更稳的写法应是：

- 纯 `401` / 无 token：身份前提缺失
- `Session not found` + login hint：恢复源已无效，登录只是可能原因之一

这也是为什么本页必须和上一页的“恢复失败对象”分开写。

## 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `run claude first` = `/login` | 一个修 workspace trust，一个修账户身份 |
| `/login` = restart remote-control | 一个修 account prerequisite，一个重建过期 bridge host |
| `Creating a fresh session instead` = resume success | 它表示旧 continuity 已断，只是当前启动自动降级继续 |
| `try running the same command again` = 安慰文案 | 它意味着系统故意保留 pointer 作为 retry 机制 |
| 文案里出现 `/login` = 这次一定是纯认证问题 | 也可能是 invalid resume source 的附带原因提示 |

## stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `run \`claude\` first`、`/login`、restart `claude remote-control` / `/remote-control`、fresh session fallback、`try running the same command again` |
| 条件公开 | 普通权限型 `403` 不走 restart；`Session not found` 可能附带 login hint；REPL 用短状态词压缩 expiry 补救建议 |
| 内部/实现层 | 401 前的 token refresh、expiry 的 `errorType` 判定、suppressible 403、pointer 是否清理的实现细节 |

## 源码锚点

- `claude-code-source-code/src/bridge/bridgeMain.ts`
- `claude-code-source-code/src/bridge/bridgeApi.ts`
- `claude-code-source-code/src/bridge/replBridge.ts`
- `claude-code-source-code/src/bridge/types.ts`
