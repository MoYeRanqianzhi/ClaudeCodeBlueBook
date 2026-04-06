# Remote `slash_commands`、`stream_event`、`task_*` 与 `compacting` consumer 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/67-slash_commands、stream_event、task_started 与 status_compacting：为什么 remote session 的命令集、流式正文、后台计数与 timeout 策略不是同一种消费者.md`
- `05-控制面深挖/66-stream_event、task_started、status、remote pill 与 BriefIdleStatus：为什么同一 remote session 事件不会以同样厚度出现在每个消费者里.md`
- `05-控制面深挖/51-worker_status、requires_action_details、pending_action、task_summary、post_turn_summary 与 session_state_changed：为什么远端看到的运行态不是同一张面.md`

边界先说清：

- 这页不是 remote 事件类型索引
- 这页不是跨模式对照索引
- 这页只抓四类关键 remote 事件分别喂给哪种本地消费者

## 1. 五类对象总表

| 对象 | 回答的问题 | 典型例子 |
| --- | --- | --- |
| `Command Consumer` | 本地该保留哪些命令 | `slash_commands` |
| `Streaming Consumer` | 正文该怎样持续推进 | `stream_event` |
| `Counter Consumer` | 后台任务数该怎样维护 | `task_started/task_notification` |
| `Timeout Policy Consumer` | 当前 timeout 策略该怎样调节 | `status=compacting` / `compact_boundary` |
| `Transcript Hint` | 当前要不要给用户一条离散状态消息 | `Status: ...` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `init` 只是初始化提示 | 它还会裁剪本地命令集 |
| `stream_event` 只是普通消息 | 它主要服务流式正文 |
| `task_*` 只是后台提示消息 | 它们主要服务计数器 |
| `Status: compacting` 就是完整 compacting 状态 | 它还在喂 timeout policy |
| 所有 remote 事件都只是给用户看的 | 很多主要在喂本地控制器 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | remote session 会把四类关键事件分别喂给不同本地消费者 |
| 条件公开 | `slash_commands` 依赖 init； stream 依赖 callbacks； task count 依赖 task 事件； compacting timeout 依赖 ref 与 boundary reset |
| 内部/实现层 | 具体集合维护、timeout 常量、重复 compacting suppress、echo 过滤 |

## 4. 七个检查问题

- 当前这条事件服务哪个消费者？
- 它改变命令集、正文流、计数，还是 timeout？
- 它进正文了吗，还是只喂行为控制？
- 如果漏掉它，坏的是命令面、正文、计数，还是超时判断？
- 我是不是把 `slash_commands` 写成纯正文事件了？
- 我是不是把 `task_*` 写成 transcript 消息了？
- 我是不是把 `compacting` 的双重消费写平了？

## 5. 源码锚点

- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/remote/sdkMessageAdapter.ts`
- `claude-code-source-code/src/components/Spinner.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooterLeftSide.tsx`
