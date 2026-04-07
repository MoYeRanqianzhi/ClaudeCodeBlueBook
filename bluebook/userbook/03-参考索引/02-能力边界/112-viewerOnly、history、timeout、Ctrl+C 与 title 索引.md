# `viewerOnly`、history、timeout、`Ctrl+C` 与 title 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/123-viewerOnly、history、timeout、Ctrl+C 与 title：为什么 assistant client 不是 session owner.md`
- `05-控制面深挖/118-convertUserTextMessages、sentUUIDsRef、fetchLatestEvents(anchor_to_latest)、pageToMessages 与 source-blind append：为什么 viewerOnly 的本地 echo 去重、history attach overlap 与 transcript 追加不是同一种 replay dedup.md`
- `05-控制面深挖/122-timeout watchdog、reconnect warning、reconnecting 与 disconnected：为什么 remote session 的 recovery lifecycle 不是同一种状态.md`

边界先说清：

- 这页不是 replay dedup 页。
- 这页不替代 118。
- 这页不替代 122 的 recovery state split。
- 这页只抓 `viewerOnly` 为什么更像 non-owning client，而不是同一条 owner contract 的弱化版。

## 1. 四张不同的 ownership 面

| 面 | 当前回答什么 | 典型位置 |
| --- | --- | --- |
| content plane | 客户端还能不能继续发 prompt | `activeRemote.sendMessage(...)` |
| history ledger | 历史账本从哪里来 | `useAssistantHistory(...)` |
| session metadata | 谁拥有 title 更新权 | `!config.viewerOnly` title update |
| session control | 谁能判 stuck / 发 interrupt | timeout watchdog / `cancelSession()` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `viewerOnly` 就是完全只读 | 它还能继续 send prompt |
| 能发 prompt 就拥有同样 session 控制权 | title / timeout / interrupt 都显式跳过 |
| history、timeout、`Ctrl+C`、title 只是四个松散 viewer 特判 | 更像同一条 ownership contract 的不同投影 |
| 同一条 WS 就该共享同一条 liveness contract | `viewerOnly` 当前不承担 host-side stuck judgement |
| skip timeout 就说明没有 reconnect | 被切掉的是 owner-side watchdog repair，不等于 shared transport reconnect 消失 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | assistant 入口创建 `viewerOnly=true`；`viewerOnly` 仍能 send prompt；但不会改 title、不会起 timeout、不会发远端 interrupt；history paging 只在它这一侧打开 |
| 条件公开 | history paging 还受 `KAIROS` gate；122 的 warning/recovery UX 主要属于 non-viewer owner 路径 |
| 内部/灰度层 | remote daemon idle-shut / respawn 策略；未来 viewerOnly 是否继续维持当前 non-owning 权限边界 |

## 4. 五个检查问题

- 我现在写的是 content plane，还是 control plane？
- 我是不是把能发消息写成也能改 title / interrupt？
- 我是不是把 122 的 watchdog contract 直接外推给 `viewerOnly`？
- 我是不是把 history gate 写成了 transcript 细节，而不是 session contract？
- 我有没有把 `viewerOnly` 误写成“完全不能交互”？

## 5. 源码锚点

- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/hooks/useAssistantHistory.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts`
