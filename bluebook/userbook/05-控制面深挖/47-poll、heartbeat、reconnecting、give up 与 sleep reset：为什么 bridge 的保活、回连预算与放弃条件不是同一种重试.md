# `poll`、`heartbeat`、`reconnecting`、`give up` 与 `sleep reset`：为什么 bridge 的保活、回连预算与放弃条件不是同一种重试

## 用户目标

不是只知道 standalone `claude remote-control` 里“有时会一直 `reconnecting`、有时自己 `Reconnected`、有时最终 `giving up`，源码里还混着 heartbeat / poll / backoff”，而是先分清七类不同对象：

- 哪些是在 bridge 还没满载时主动找新 work 的 seek-work poll。
- 哪些是在 bridge 已满载时仅为了保住 lease 而继续发 heartbeat。
- 哪些是在 heartbeat 期间定期跌回一次 poll 的 liveness backstop。
- 哪些只是 UI / status line 上把当前 backoff 过程压成 `reconnecting`。
- 哪些是在给 connection error 计独立的 retry budget。
- 哪些是在给 general poll error 计另一套 retry budget。
- 哪些是在检测到系统 sleep / wake 后把旧预算清空重算，而不是把它记成一次持续失败。

如果这些对象不先拆开，读者最容易把下面这些东西压成同一种“bridge 在重试”：

- `poll_interval_ms_not_at_capacity`
- `multisession_poll_interval_ms_partial_capacity`
- `multisession_poll_interval_ms_at_capacity`
- `non_exclusive_heartbeat_interval_ms`
- `updateReconnectingStatus(...)`
- `connGiveUpMs`
- `generalGiveUpMs`
- `pollSleepDetectionThresholdMs(...)`
- `tengu_bridge_reconnected`
- `tengu_bridge_poll_give_up`

## 第一性原理

bridge 的“还活着并且还值得继续等”至少沿着四条轴线分化：

1. `Liveness Object`：当前保的是 work discovery、work lease、error budget，还是只是 UI 状态词。
2. `Trigger Path`：当前是 below-capacity 空轮询、at-capacity 保活、瞬态 poll error、fatal error，还是系统睡眠后恢复。
3. `Budget Meaning`：当前谈的是轮询节奏、heartbeat 间隔、累计错误预算，还是最终 give-up 门槛。
4. `Outcome Surface`：当前暴露给用户的是 `connecting`、`reconnecting`、`Reconnected`、`giving up`，还是仅存在于内部的 `poll_due`、`auth_failed`、`capacity_changed`。

因此更稳的提问不是：

- “bridge 现在不是就在重试吗？”

而是：

- “当前保活打在找新 work、保 work lease、累计错误预算，还是只是在显示重连状态；它是在正常节流、错误 backoff、sleep reset，还是已经进入 give-up 判定？”

只要这四条轴线没先拆开，正文就会把 poll cadence、heartbeat keepalive、reconnecting UI 与 give-up budget 写成同一种 retry。

## 第一层：seek-work poll 解决的是“多久再去找新 work”，不是“多久后放弃”

### below-capacity poll 是工作发现节奏，不是错误预算

`pollConfigDefaults.ts` 给的默认值很直接：

- `poll_interval_ms_not_at_capacity = 2000`
- 注释明确说它决定的是：
  - 初次接到 work 时的 `connecting...` 延迟
  - server 重派发 work 后的恢复速度

`bridgeMain.ts` 在当前没有 work 且尚未满载时，也只是按：

- `multisession_poll_interval_ms_not_at_capacity`
- 或 `multisession_poll_interval_ms_partial_capacity`

去 `sleep(...)` 后继续 poll。

这说明它回答的问题不是：

- 这次连接错误还能忍多久

而是：

- 当前 bridge 应该以什么节奏继续找下一份 work

### 所以 seek-work poll 与 give-up budget 不是一层对象

更准确的区分是：

- seek-work poll：工作发现 cadence
- connection/general give-up：错误累计预算

只要这一层没拆开，正文就会把“2 秒后再 poll 一次”误写成“bridge 在做错误重试 backoff”。

## 第二层：at-capacity `heartbeat` 与 at-capacity `poll` 是并行保活，不是二选一

### `non_exclusive_heartbeat_interval_ms` 的语义就是“heartbeat 不再压掉 poll”

`pollConfigDefaults.ts` 和 `pollConfig.ts` 都把这个字段讲得很清楚：

- `non_exclusive_heartbeat_interval_ms > 0` 时，满载期间会按该节奏给 active work 发 heartbeat
- 它和 at-capacity poll 不是互斥，而是可以并存
- schema 还强制要求：
  - heartbeat 或 at-capacity poll 至少开一个
  - 否则会落成 tight loop

这说明系统在防的不是：

- 某一条 session timeout

而是：

- 满载时既不能疯狂空 poll
- 也不能完全失去 lease 续命能力

### `poll_due` 只是 heartbeat 模式里的内部落点，不是失败

`bridgeMain.ts` 在满载且 heartbeat 开启时，会进入 heartbeat loop，并记录几个退出原因：

- `auth_failed`
- `fatal`
- `shutdown`
- `capacity_changed`
- `poll_due`
- `config_disabled`

其中：

- `poll_due`

只是说明：

- heartbeat loop 到了该跌回 poll 的时间点

它回答的问题不是：

- bridge 刚刚失败了一次

而是：

- 该回到 poll 路径补一次 work / token / liveness 检查

### 所以满载保活不能写成一种“重试循环”

更准确的区分是：

- heartbeat：保 work lease
- at-capacity poll：定期补做 liveness / redispatch backstop
- `poll_due`：内部退出原因

只要这一层没拆开，正文就会把 heartbeat mode 写成一种“失败后退避重试”。

## 第三层：`reconnecting` 是 backoff 的展示面，不是 lease 已死、也不是 session timeout

### `updateReconnectingStatus(...)` 只在错误 backoff 时更新 UI

`bridgeMain.ts` 只有在两类错误路径里才调用：

- connection error backoff
- general poll error backoff

而 `bridgeUI.ts` 的 `updateReconnectingStatus(...)` 展示的是：

- `Reconnecting`
- `retrying in {delay}`
- `disconnected {elapsed}`

`bridgeStatusUtil.ts` 也只是把：

- `reconnecting: true`

压成：

- `Remote Control reconnecting`

这说明 `reconnecting` 回答的问题不是：

- work lease 一定已经死了
- child session 一定 timeout 了
- bridge 一定会最终 give up

而是：

- 当前 poll loop 正在错误 backoff 窗口里

### 所以 `reconnecting` 与 page 46 的 session timeout 不是同一层语义

更准确的区分是：

- page 46 的 `sessionTimeoutMs`：单条 child session 运行过久
- 这页的 `reconnecting`：bridge host 在 poll / connection 错误上做 backoff

只要这一层没拆开，正文就会把：

- bridge reconnecting
- child session timed out

写成同一种“超时”。

## 第四层：bridge 明确把 connection error 与 general error 记成两套预算

### 两条 backoff track 会分别累计、分别 give up、并互相清零

`bridgeMain.ts` 把错误分成两路：

- `isConnectionError(err) || isServerError(err)`
- 其余 general poll error

然后分别维护：

- `connErrorStart` / `connBackoff` / `connGiveUpMs`
- `generalErrorStart` / `generalBackoff` / `generalGiveUpMs`

而且每次切换错误类型时，还会主动把另一条轨清零。

这说明系统回答的问题不是：

- “总之失败次数又加一”

而是：

- 这是连不上 server 的那类故障
- 还是 poll 本身的另一类故障
- 它们不应该共享同一条累计预算

### give-up 的文案也在区分两类错误

源码最后给出的放弃文案并不一样：

- `Server unreachable ... giving up.`
- `Persistent errors ... giving up.`

这说明用户可见层面最终也承认：

- reachability failure
- general poll failure

不是同一种“桥挂了”。

## 第五层：backoff 之前先 `heartbeat`，说明“正在 reconnect”不等于“已经失去 lease”

### poll error 期间，bridge 会在 sleep 前尝试续 lease

在 connection/general error 两条 backoff 路径里，`bridgeMain.ts` 都会先做同一件事：

- 如果 heartbeat 功能开启，就先 `await heartbeatActiveWorkItems()`
- 然后才 `sleep(delay, loopSignal)`

源码注释写得很直白：

- `/poll` outage 不应该顺手把 300s 的 lease TTL 一起耗死

这说明 bridge 在 reconnecting 时做的，不只是：

- 等一会儿再试一次 poll

还包括：

- 尽量保住现有 active work 的 lease

### 所以 reconnecting 是“错误恢复 + lease 保活”的叠加态

更准确的理解应是：

- reconnecting 期间可能仍在成功 heartbeat
- heartbeat 还活着，不代表 poll 已恢复
- poll 没恢复，也不代表 active work 一定马上丢 lease

只要这一层没拆开，正文就会把 `reconnecting` 写成：

- “桥已经完全断了，只是在傻等下一次重试”

## 第六层：`sleep reset` 与 `give up` 是相反方向的判定，不是同一条预算上的不同文案

### 系统 sleep 会重置旧预算，不会把睡眠时间硬算进连续故障

`pollSleepDetectionThresholdMs(...)` 的注释说明：

- 阈值必须大于最大 backoff cap
- 当前取值是 `2 * connCapMs`

而在 connection/general error 路径里，只要：

- 当前时间与上次 poll error 的间隔超过这个阈值

系统就会：

- 记录 `Detected system sleep`
- 清空 `connErrorStart` / `connBackoff`
- 清空 `generalErrorStart` / `generalBackoff`

这说明 sleep reset 回答的问题不是：

- 刚刚已经恢复成功

而是：

- 旧的连续故障区间不再可信，应该重新给一份预算

### give-up 则是在连续错误预算真正耗尽后停止

只有当：

- `elapsed >= connGiveUpMs`
- 或 `elapsed >= generalGiveUpMs`

系统才会：

- 打 `giving up`
- 记 `tengu_bridge_poll_give_up`
- `fatalExit = true`

所以更准确的区分是：

- sleep reset：重新开始算预算
- give up：预算已经耗尽，停止继续等

只要这一层没拆开，正文就会把：

- “睡了一觉回来重新开始”

和：

- “桥终于认定这次错误不值得再等”

写成同一种恢复结果。

## 第七层：稳定、条件与内部三层要分开保护

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `Remote Control reconnecting`、`Reconnected`、长时间 reachability / persistent error 最终会 `giving up` |
| 条件公开 | below-capacity poll 影响 work pickup 速度、at-capacity heartbeat mode、connection/general 两套预算、错误 backoff 前先 heartbeat 保 lease、sleep 后重置预算 |
| 内部/实现层 | `poll_due`、GrowthBook poll config 字段、jitter/cap 公式、`pollSleepDetectionThresholdMs` 公式、`reclaim_older_than_ms`、`session_keepalive_interval_v2_ms` |

这里尤其要避免两种写坏方式：

- 把所有 poll / heartbeat / backoff 字段写成一页“参数总表”
- 把 `reconnecting`、sleep reset 与 give-up 写成同一种 retry outcome

## 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| seek-work poll = 错误 backoff | 一个是工作发现 cadence，一个是错误恢复预算 |
| at capacity = 只能等下次重试 | 满载时也可能持续 heartbeat 保 lease |
| `poll_due` = heartbeat 失败 | 它只是 heartbeat mode 跌回 poll 的内部时点 |
| `Remote Control reconnecting` = child session timeout | 一个是 host backoff，一个是 session runtime 超时 |
| sleep reset = 已经恢复成功 | 它只是把旧错误预算清零重算 |
| give up = `sessionTimeoutMs` 到了 | 一个是 host 级 poll error budget，一个是 child 级 runtime limit |

## 六个高价值判断问题

- 当前桥在保的是 work discovery、work lease，还是错误预算？
- 我看到的是正常 poll cadence、heartbeat mode，还是错误 backoff？
- 这次 `reconnecting` 是因为 connection error、general error，还是只是我把 at-capacity liveness 想成了错误恢复？
- 当前系统是在重置预算，还是已经进入 give-up？
- 我是不是又把 bridge host 的 reconnecting 写成 child session timeout？
- 我是不是又把 `poll_due`、heartbeat、sleep reset 与 give-up 混成了一种 retry？

## 源码锚点

- `claude-code-source-code/src/bridge/pollConfigDefaults.ts`
- `claude-code-source-code/src/bridge/pollConfig.ts`
- `claude-code-source-code/src/bridge/bridgeMain.ts`
- `claude-code-source-code/src/bridge/bridgeUI.ts`
- `claude-code-source-code/src/bridge/bridgeStatusUtil.ts`
