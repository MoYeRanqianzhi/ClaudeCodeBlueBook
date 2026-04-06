# Headless print shutdown prompt and team drain 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/86-SHUTDOWN_TEAM_PROMPT、inputClosed、hasWorkingInProcessTeammates、waitForTeammatesToBecomeIdle 与 hasActiveInProcessTeammates：为什么 headless print 的 team drain 不是 interactive REPL 的直接缩小版.md`
- `05-控制面深挖/84-useInboxPoller、attachments、print、shutdown_approved、teammate_terminated 与 pending-processing：为什么 interactive、attachment bridge 与 headless print 不共享同一条 shutdown 收口宿主路径.md`

边界先说清：

- 这页不是 general headless mode 总论。
- 这页不替代 84 对 host-path convergence/divergence 的比较。
- 这页只抓 `print.ts` 在 input 关闭后进入 shutdown prompt / team drain 的专用协议。

## 1. 三段式收口总表

| 阶段 | 判定对象 | 主要动作 |
| --- | --- | --- |
| 输入关闭前 | `inputClosed === false` | 正常 run loop |
| 输入关闭后但仍有 working teammate | `hasWorkingInProcessTeammates(...)` | 先等待工作者进入 idle |
| 输入关闭后 idle 仍有 active swarm | `hasActiveInProcessTeammates(...)` 或 team members 未清理 | 注入 `SHUTDOWN_TEAM_PROMPT` 并继续 run |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `inputClosed` 就等于可以退出 | 它意味着进入 team drain 协议 |
| 没有 teammate 在工作，就能结束 | 还要看 active in-process teammates 与 team cleanup 是否完成 |
| headless 会自然像 REPL 一样收口 | non-interactive 需要显式 `SHUTDOWN_TEAM_PROMPT` |
| `waitForTeammatesToBecomeIdle(...)` 等到的就是 terminal | 它只等到 idle，不等于 completed |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | headless `print` 在 input 关闭后不会立刻退出，而会进入专用 team drain；它先等 working teammates idle，再决定是否注入 shutdown prompt |
| 条件公开 | 这条协议只有在存在 teammates / active swarm 时才生效；某些判断还依赖 `teamContext.teammates` 是否已清理；轮询阶段和主收口分支会在不同位置使用 shutdown prompt |
| 内部/实现层 | `shutdownPromptInjected` 作用域、轮询间隔、output.done 前的 suggestion/hook 清理、prompt 文案细节 |

## 4. 六个检查问题

- 现在是 input 仍开着，还是已经进入 inputClosed drain？
- 当前还存在 working teammate，还是只是 active-but-idle teammate？
- 这里等待的是 idle，还是 terminal？
- 这里看的是真正活跃任务，还是未清理 team membership？
- 这里是轮询阶段注入 prompt，还是主收口分支注入 prompt？
- 我是不是把 headless drain 写成 interactive close 了？

## 5. 源码锚点

- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/utils/teammate.ts`
- `claude-code-source-code/src/utils/swarm/inProcessRunner.ts`
