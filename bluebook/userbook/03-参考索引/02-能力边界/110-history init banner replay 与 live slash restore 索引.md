# history init banner replay 与 live slash restore 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/121-useAssistantHistory、fetchLatestEvents(anchor_to_latest)、pageToMessages、useRemoteSession onInit 与 handleRemoteInit：为什么 history init banner 回放与 live slash 恢复不是同一种 attach 恢复语义.md`
- `05-控制面深挖/120-buildSystemInitMessage、QueryEngine、useReplBridge、convertInitMessage 与 redaction：为什么 full init payload、bridge redacted init 与 transcript model-only banner 不是同一种 init payload thickness.md`
- `05-控制面深挖/118-convertUserTextMessages、sentUUIDsRef、fetchLatestEvents(anchor_to_latest)、pageToMessages 与 source-blind append：为什么 viewerOnly 的本地 echo 去重、history attach overlap 与 transcript 追加不是同一种 replay dedup.md`

边界先说清：

- 这页不是 attach/replay 总体工作流。
- 这页不替代 120 的 init thickness 拆分。
- 这页不替代 118 的 replay dedup 拆分。
- 这页只抓 history banner replay 与 live `onInit(...)` bootstrap 为什么不是同一种 attach 恢复语义。

## 1. 两种恢复语义

| 恢复层 | 当前回答什么 | 典型例子 |
| --- | --- | --- |
| transcript restore | attach 后历史里哪些 init 痕迹会被显示出来 | `pageToMessages(...)` + `convertInitMessage(...)` |
| command-surface restore | attach/live 后本地命令集会不会按远端能力重算 | `onInit(sdkMessage.slash_commands)` + `handleRemoteInit(...)` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| history 里有 init banner，就说明 attach 恢复了初始化能力面 | banner 只恢复 transcript，不自动恢复 command surface |
| `pageToMessages(...)` 和 live `onInit(...)` 都消费 init，所以作用相同 | 一个走 adapter message，一个走 raw metadata callback |
| 两条 hook 都共用 `setMessages`，所以 attach / live restore 差不多 | 只有 live `useRemoteSession` 接了 `onInit` |
| init banner 重复就等于 bootstrap callback 重复 | transcript path 和 bootstrap path 分离 |
| `handleRemoteInit` 只是 UI 小修小补 | 它直接重算本地命令可见集 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | history hook 当前只做 transcript replay；live remote hook 当前会在 raw init 上调用 `onInit`；`handleRemoteInit` 当前会收窄本地 command surface |
| 条件公开 | attach 后 live init 是否一定还会再到、history 是否未来补跑 bootstrap side effect，都取决于后续宿主策略 |
| 内部/灰度层 | 是否给 history path 增加 metadata hydration、是否在 attach 时显式重放 init callback、是否把 banner 与 bootstrap 对齐 |

## 4. 五个检查问题

- 当前写的是 transcript restore，还是 command-surface restore？
- 我是不是把 banner 写成了 bootstrap side effect？
- 我是不是默认 history hook 也会触发 `onInit`？
- 我是不是把 banner 重复直接写成 callback 重复？
- 我有没有把 attach 看到 init 痕迹写成 full init recovery？

## 5. 源码锚点

- `claude-code-source-code/src/hooks/useAssistantHistory.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/remote/sdkMessageAdapter.ts`
- `claude-code-source-code/src/assistant/sessionHistory.ts`
