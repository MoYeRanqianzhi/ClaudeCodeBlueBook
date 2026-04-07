# loading start、pause、resume、turn-end 与 teardown 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/119-sendMessage、onPermissionRequest、onAllow、result、cancelRequest 与 onDisconnected：为什么 direct connect 的 setIsLoading(true_false) 不是同一种 loading lifecycle.md`
- `05-控制面深挖/116-success result ignored、error result visible、isSessionEndMessage、setIsLoading(false) 与 permission pause：为什么 direct connect 的 visible result、turn-end 判定与 busy state 不是同一种 completion signal.md`
- `05-控制面深挖/118-convertUserTextMessages、sentUUIDsRef、fetchLatestEvents(anchor_to_latest)、pageToMessages 与 source-blind append：为什么 viewerOnly 的本地 echo 去重、history attach overlap 与 transcript 追加不是同一种 replay dedup.md`

边界先说清：

- 这页不是 remote host 全状态机总论。
- 这页不替代 116 对 completion signal 的拆分。
- 这页不替代 118 对 replay dedup 的拆分。
- 这页只抓 loading flag 自身的 start / pause / resume / end / abort / teardown 为什么不是同一种 lifecycle。

## 1. 六种 loading edge

| edge | 当前回答什么 | 典型位置 |
| --- | --- | --- |
| request start | 新请求已发出，开始等待远端推进 | `sendMessage(...) -> true` |
| approval pause | ask 到达，暂时停表等本地审批 | `onPermissionRequest(...) -> false` |
| approval resume | ask 已放行，远端执行恢复 | `onAllow(...) -> true` |
| turn-end release | 本轮收到了 `result` | `onMessage(result) -> false` |
| user-abort release | 本地主动 interrupt 当前请求 | `cancelRequest() -> false` |
| transport teardown release | 连接丢失/进程退出 | `onDisconnected() -> false` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 所有 `true` 都是 request start | `onAllow(true)` 是 resume，不是 initial start |
| 所有 `false` 都是完成信号 | pause、cancel、disconnect 也会 false |
| reject 没写 `false`，所以 reject 不影响 loading | request 到达时 already paused |
| disconnect false 和 result false 没区别 | 一个是 teardown，一个是 turn-end release |
| 同一个 bool 就是一条单线状态机 | 同一个 bool 也能承载多个 edge 语义 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | direct connect 当前存在 start/pause/resume/end/abort/teardown 多 edge；SSH sibling 上也有近似形状 |
| 条件公开 | 不同 host 是否增加 timeout/reconnect 等更多 edge 取决于具体 transport |
| 内部/灰度层 | 是否把 loading 再拆成更细状态枚举、不同 host 是否进一步收敛到统一 lifecycle contract |

## 4. 五个检查问题

- 当前写的是 start、resume、pause，还是 end/abort/teardown？
- 我是不是把 `onAllow(true)` 写成了新的 request start？
- 我是不是把 permission request 的 false 写成了完成？
- 我是不是把 disconnect false 写成了普通 turn close？
- 我有没有把 host-local loading edge 推广成 universal remote lifecycle？

## 5. 源码锚点

- `claude-code-source-code/src/hooks/useDirectConnect.ts`
- `claude-code-source-code/src/hooks/useSSHSession.ts`
