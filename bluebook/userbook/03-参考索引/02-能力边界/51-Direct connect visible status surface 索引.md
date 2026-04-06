# Direct connect visible status surface 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/62-Connected to server、Remote session initialized、busy_waiting_idle、PermissionRequest 与 stderr disconnect：为什么 direct connect 的可见状态面不是同一张远端状态板.md`
- `05-控制面深挖/61-init、status、tool_result、tool_progress 与 ignored families：为什么 direct connect 的远端消息流不是原样落进 REPL transcript.md`
- `05-控制面深挖/60-can_use_tool、interrupt、result、disconnect 与 stderr shutdown：为什么 direct connect 的控制子集、回合结束与连接失败不是同一种收口.md`

边界先说清：

- 这页不是 direct connect 的 transcript surface 索引
- 这页不是 direct connect 的 shutdown 语义索引
- 这页只抓用户实际能看到的几张状态面，以及它们分别来自哪里

## 1. 六类对象总表

| 对象 | 回答的问题 | 典型例子 |
| --- | --- | --- |
| `Startup Hint` | 本地是否已经完成 connect 启动交接 | `Connected to server at ...` |
| `Transcript Status Event` | 远端是否发来一条值得显示的状态事件 | `Remote session initialized` / `Status: ...` |
| `Derived Tab Status` | 当前 REPL 总体是忙、等、闲哪一种 | `busy / waiting / idle` |
| `Approval Overlay` | 当前是否被用户批准动作阻塞 | `PermissionRequest` |
| `Fatal Failure Surface` | 当前是否已进入致命断连收口 | `Server disconnected.` |
| `State Authority` | 这条状态描述的是远端事件、本地交互，还是连接存活性 | transcript / local derived / stderr |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `Connected to server at ...` = 远端 init | 这是本地启动提示 |
| transcript 里的 `Status: ...` = REPL 当前总状态 | 它只是离散事件 |
| `busy` / `waiting` = 远端 status subtype | 这是本地派生 tab status |
| `waiting` = 远端卡住了 | 很多时候只是本地在等批准 |
| `PermissionRequest` = transcript 状态消息 | 它是 overlay |
| disconnect 文案 = 普通状态消息 | 它属于 fatal stderr 收口 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | direct connect 至少有启动提示、transcript 状态、tab status、approval overlay、fatal stderr 这几张不同状态面 |
| 条件公开 | waiting 取决于本地 approval/dialog；busy 取决于 loading；transcript 状态取决于远端是否发对应事件 |
| 内部/实现层 | `waitingFor` 拼接、`hasReceivedInitRef` 去重、tab status gate、disconnect 文案里的 `wsUrl` 选择 |

## 4. 七个检查问题

- 当前这条状态来自本地启动、远端 transcript，还是本地派生？
- 它落在哪一张面：transcript、tab、overlay、stderr？
- 这条状态描述的是远端事件、本地阻塞，还是连接死亡？
- 它是一条离散消息，还是持续派生态？
- 当前 `waiting` 是不是其实来自 approval overlay？
- 我是不是把 disconnect 文案写成普通状态消息了？
- 我是不是又把 direct connect 写成单一状态板了？

## 5. 源码锚点

- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/remote/sdkMessageAdapter.ts`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/hooks/useDirectConnect.ts`
