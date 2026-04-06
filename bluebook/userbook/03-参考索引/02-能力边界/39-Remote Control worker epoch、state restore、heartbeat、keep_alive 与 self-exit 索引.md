# Remote Control worker epoch、state restore、heartbeat、`keep_alive` 与 `self-exit` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/50-worker epoch、state restore、worker heartbeat、keep_alive 与 self-exit：为什么 CCR v2 worker 的初始化、保活与代际退场不是同一种存活合同.md`
- `05-控制面深挖/41-sdk-url、sessionIngressUrl、environmentSecret、session access token 与 workerEpoch：为什么 standalone remote-control 的 URL、密钥、令牌与传输纪元不是同一种连接凭证.md`
- `05-控制面深挖/20-Headless 启动链、首问就绪与 StructuredIO：为什么 print 不是没有 UI 的 REPL.md`

## 1. 六类 worker lifecycle 对象总表

| 对象 | 回答的问题 | 典型例子 |
| --- | --- | --- |
| `Generation Claim` | 当前这代 worker 有没有先完成登记 | `initialize()`、`PUT /worker` |
| `State Restore` | 启动时有没有读回上一代 external metadata | `GET /worker` |
| `Worker Liveness` | 当前这代 worker 还算不算活着 | `POST /worker/heartbeat` |
| `Ingress Keepalive` | 空闲链路会不会先被代理层回收 | `keep_alive` |
| `Generation Exit` | 新 epoch 出现后旧代为什么必须退场 | `409` epoch mismatch |
| `Auth Exit` | credential 已死或 auth 连续不可用时为什么自退 | token expired / auth failures exhausted |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `initialize()` = transport connected | 它先做的是 worker generation claim |
| state restore = worker register | 一个读旧状态，一个登记当前代 |
| worker heartbeat = `keep_alive` | 一个保 worker generation，一个保 ingress 链路 |
| epoch mismatch = session not found | 一个是新代 supersede，一个是对象不存在 |
| token expired exit = epoch mismatch | 一个是 credential 死亡，一个是 generation supersede |
| 任意 request failure = worker 应该退出 | 多数失败仍然只是 best-effort failure |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | 无；本页主对象主要属于 CCR v2 条件路径 |
| 条件公开 | partial state restore、epoch mismatch self-exit、token expired / auth failures exhausted self-exit |
| 内部/实现层 | `workerEpoch` 所有权令牌、worker heartbeat、`keep_alive`、uploader batching、wiring 顺序、毫秒数常量、GET retry 常数、diagnostic 事件名 |

## 4. 六个高价值判断问题

- 当前动作是在登记当前代、恢复旧状态、保 worker 存活，还是保 ingress 链路？
- 现在发生的是 best-effort failure，还是已经进入 self-exit verdict？
- 当前退出是因为 epoch supersede，还是 auth / token 已经不可信？
- 我是不是又把 `keep_alive` 和 `/worker/heartbeat` 写成了同一种保活？
- 我是不是又把 41 页的对象分类和这页的生命周期合同混写了？
- 我是不是又把所有 request failure 抬成了 worker 死亡？

## 5. 源码锚点

- `claude-code-source-code/src/cli/remoteIO.ts`
- `claude-code-source-code/src/cli/transports/ccrClient.ts`
- `claude-code-source-code/src/bridge/replBridge.ts`
