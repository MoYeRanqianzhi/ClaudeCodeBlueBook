# Remote Control `session tag`、compat shim 与 reconnect tag 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/43-session tag、compat shim 与 reconnect tag：为什么 bridge 的 compat session ID、infra session ID 与 sameSessionId 不是同一种标识.md`
- `05-控制面深挖/41-sdk-url、sessionIngressUrl、environmentSecret、session access token 与 workerEpoch：为什么 standalone remote-control 的 URL、密钥、令牌与传输纪元不是同一种连接凭证.md`

## 1. 五类 session 标识对象总表

| 对象 | 回答的问题 | 典型例子 |
| --- | --- | --- |
| `Compat Session Tag` | compat API / 前端路由要认哪种 costume | `session_*` |
| `Infra Session Tag` | work poll / worker / reconnect lookup 要认哪种 costume | `cse_*` |
| `Retag Helper` | 当前对象要换到哪一层 surface | `toCompatSessionId`、`toInfraSessionId` |
| `Identity Compare Helper` | 这两个不同 costume 是否本质同一条 session | `sameSessionId` |
| `Runtime Costume Cache` | 当前 raw sessionId 对应哪个 compat costume | `sessionCompatIds` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `session_*` = 真 session，`cse_*` = 假 session | 同一 UUID 的不同 costume |
| retag helper = compare helper | 一个换 tag，一个比底层 UUID |
| pointer 存 `session_*`，reconnect 也只该用 `session_*` | reconnect 可能要试 `cse_*` |
| `sessionCompatIds` = 权威 session 表 | 它只是运行时 costume cache |
| compat shim = 永久稳定产品层 | 它是 kill-switch 控制的兼容过渡层 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | session continuity 本身、session title / archive 围绕同一条 session 发生 |
| 条件公开 | 双 tag 并存、compat shim gate、resume 双 candidate reconnect |
| 内部/实现层 | `toCompatSessionId`、`toInfraSessionId`、`sameSessionId`、`sessionCompatIds` |

## 4. 六个高价值判断问题

- 当前操作要 compat tag、infra tag，还是只要比 UUID？
- 这是 display/title/archive，还是 reconnect/worker lookup？
- 这里出现的是 retag，还是 compare？
- 我是不是又把 `session_*` 和 `cse_*` 写成两条 session？
- 我是不是又把 `sameSessionId` 写成了转换器？
- 我是不是把 compat shim 写成了稳定主线能力？

## 5. 源码锚点

- `claude-code-source-code/src/bridge/sessionIdCompat.ts`
- `claude-code-source-code/src/bridge/bridgeEnabled.ts`
- `claude-code-source-code/src/bridge/workSecret.ts`
- `claude-code-source-code/src/bridge/bridgeMain.ts`
- `claude-code-source-code/src/bridge/createSession.ts`
