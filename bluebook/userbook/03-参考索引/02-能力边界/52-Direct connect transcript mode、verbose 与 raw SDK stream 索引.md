# Direct connect transcript mode、`verbose` 与 raw SDK stream 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/63-Ctrl+O transcript、verbose、showAllInTranscript 与 tool_result：为什么 direct connect 的 transcript 不是 prompt 面展开版，也不是 raw SDK stream.md`
- `05-控制面深挖/61-init、status、tool_result、tool_progress 与 ignored families：为什么 direct connect 的远端消息流不是原样落进 REPL transcript.md`
- `05-控制面深挖/62-Connected to server、Remote session initialized、busy_waiting_idle、PermissionRequest 与 stderr disconnect：为什么 direct connect 的可见状态面不是同一张远端状态板.md`

边界先说清：

- 这页不是 direct connect 的 transcript surface 总论
- 这页只抓 prompt 面、transcript 屏、`verbose`、`showAllInTranscript` 与 raw SDK 流之间的差异

## 1. 六类对象总表

| 对象 | 回答的问题 | 典型例子 |
| --- | --- | --- |
| `Prompt Surface` | 日常 REPL 默认显示哪些 | `verbose={verbose}` |
| `Transcript Surface` | `Ctrl+O` 时额外放开什么 | `verbose={true}` |
| `Transcript Cap` | transcript 是否还要保留 30 条裁剪 | `showAllInTranscript` |
| `Transcript-only Message` | 哪些消息只在 transcript 屏出现 | `isVisibleInTranscriptOnly` |
| `Remote User Echo Rule` | 普通 user echo 与 `tool_result` 怎样分叉 | `tool_result` special-case |
| `Wire Gap` | 为什么 transcript 仍看不到全部远端事件 | manager / adapter filtering |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `Ctrl+O transcript` = raw SDK stream | 它只是更宽的 UI 视图 |
| prompt 面看不到某条 info message = 远端没发 | 可能只是 `verbose=false` 隐藏了 |
| `showAllInTranscript` = 显示全部远端事件 | 它只放开数量截断 |
| direct connect 的 `user` 气泡主要是远端回显 | 普通用户消息是本地先写，远端只特判保留 `tool_result` |
| transcript 只是 prompt 面的滚动更多 | transcript 还会放开 transcript-only 与 info 级 system visibility |
| transcript 看不到某类事件 = server 没有那类事件 | 可能上游早已过滤掉 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | transcript 比 prompt 更宽，但仍然比 raw wire 更窄；普通 user echo 默认不重复显示；`showAllInTranscript` 只改截断 |
| 条件公开 | info system message visibility 取决于 `verbose`； transcript-only 消息只在 transcript 屏出现； `tool_result` 依赖特判保留 |
| 内部/实现层 | 30 条 cap、virtual scroll gate、具体 filtered families、`parent_tool_use_id` 不可靠的实现细节 |

## 4. 七个检查问题

- 当前说的是 prompt 面、transcript 屏，还是 raw wire？
- 这是被上游过滤，还是只是被 `verbose=false` 暂时隐藏？
- `showAllInTranscript` 改的是过滤，还是 cap？
- 当前 `user` family 是本地 prompt，还是远端 `tool_result`？
- 这条消息是不是 transcript-only？
- transcript 的扩张发生在 UI，还是发生在 wire？
- 我是不是又把 transcript 写成 raw SDK stream 了？

## 5. 源码锚点

- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/components/Messages.tsx`
- `claude-code-source-code/src/components/messages/SystemTextMessage.tsx`
- `claude-code-source-code/src/utils/messages.ts`
- `claude-code-source-code/src/remote/sdkMessageAdapter.ts`
- `claude-code-source-code/src/hooks/useDirectConnect.ts`
