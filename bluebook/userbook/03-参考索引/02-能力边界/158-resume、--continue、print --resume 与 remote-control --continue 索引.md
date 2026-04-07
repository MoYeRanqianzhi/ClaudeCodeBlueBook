# `/resume`、`--continue`、`print --resume` 与 `remote-control --continue` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/169-resume、--continue、print --resume 与 remote-control --continue：为什么 stable conversation resume、headless remote hydrate 与 bridge continuity 不是同一种接续来源.md`
- `05-控制面深挖/161-main.tsx、launchResumeChooser、ResumeConversation、resume.tsx 与 REPL.resume：为什么 --continue、startup picker 与会内 resume 共享恢复合同，却不是同一种入口宿主.md`
- `05-控制面深挖/24-remoteControlAtStartup、CCR Mirror、Perpetual Session 与 --continue：为什么 bridge 的 auto、mirror、resume 不是同一种重连.md`

边界先说清：

- 这页不是入口宿主分叉页。
- 这页不是 print 内部 hydrate stage 页。
- 这页不是 bridge teardown / pointer closeout 页。
- 这页只抓“接续来源”本身为什么不是同一种 source。

## 1. 三种接续来源

| 来源 | 当前更像什么 | 关键对象 |
| --- | --- | --- |
| stable conversation source | 继续本地 conversation history | `/resume`、generic `--continue`、`print --continue` |
| conditional remote-hydrated transcript source | 先把 remote transcript 落地，再 formal restore | `print --resume`、`parseSessionIdentifier()`、`hydrateFromCCRv2InternalEvents()`、`hydrateRemoteSession()` |
| bridge pointer continuity source | 回到原来的 bridge env / session 轨迹 | `remote-control --continue`、`readBridgePointerAcrossWorktrees()` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 所有 `continue` 都是在继续同一份旧对话 | 名字相似，但 source 可以是 conversation history、remote-hydrated transcript 或 bridge pointer |
| `print --resume` 就是 generic `--continue` 的 headless 写法 | `print --resume` 是 host；它能消费不同 source |
| `remote-control --continue` 是 generic `--continue` 的 remote 别名 | 它读取的是 crash-recovery bridge pointer，不是普通 conversation history |
| stable `/resume` 与 remote/bridge continuation 可以并列写成默认主线 | userbook 应先写 stable conversation resume，再写条件路径 |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `/resume`、generic `--continue`、`print --continue` |
| 条件公开 | `print --resume` 的 URL / CCR remote hydrate 分支 |
| 内部/灰度层 | `remote-control --continue` 的 bridge pointer continuity 与跨 worktree pointer 搜索 |

## 4. 五个检查问题

- 当前继续的是 conversation history，还是 bridge pointer？
- 当前是 stable default path，还是 remote / bridge 条件补充路径？
- 当前 source 是先读本地历史，还是先 remote hydrate？
- 我是不是把 `print --resume` 错写成了单一 source？
- 我是不是又把 `remote-control --continue` 写成 generic `--continue` 的别名？

## 5. 源码锚点

- `claude-code-source-code/src/commands/resume/index.ts`
- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/utils/conversationRecovery.ts`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/bridge/bridgeMain.ts`
- `claude-code-source-code/src/bridge/bridgePointer.ts`
