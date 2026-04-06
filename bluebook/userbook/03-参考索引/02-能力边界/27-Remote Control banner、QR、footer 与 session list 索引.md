# Remote Control banner、QR、footer 与 session list 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/38-Bridge Banner、QR、footer、session count 与 session list：为什么 standalone remote-control 的 banner、状态行与会话列表不是同一种显示面.md`
- `05-控制面深挖/31-Remote Control active、reconnecting、Connect URL、Session URL 与 outbound-only：为什么 bridge 的状态词、恢复厚度与动作上限不是同一个“已恢复”.md`
- `05-控制面深挖/26-Connect URL、Session URL、Environment ID、Session ID 与 remoteSessionUrl：为什么 remote-control 的链接、二维码与 ID 不是同一种定位符.md`

## 1. 六类显示对象总表

| 对象 | 回答的问题 | 典型例子 |
| --- | --- | --- |
| `Bootstrap Facts` | 这台 host 以什么配置启动 | banner、Environment ID、Spawn mode |
| `Lifecycle State` | host 现在处在什么生命周期状态 | Connecting、Ready、Connected、Reconnecting、Failed |
| `Session Budget` | 当前还能接多少会话 | `Capacity: x/y` |
| `Session Fleet` | 当前挂着哪些 session | session bullet list |
| `Action Target` | 用户下一步应该打开哪个链接继续工作 | QR、footer |
| `Interaction Hint` | 当前显示层还能按什么键 | `space` / `w` hint |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| banner = 连接状态 | banner 是启动事实面 |
| `Ready` = `Connected` | 一个是 idle host，一个是 attached session |
| session list = 状态行延长 | 它是多会话对象列表 |
| QR = 状态词的图形版 | QR 指向 action target |
| footer = 当前状态总结 | footer 更像下一步动作提示 |
| `w` / `space` = 状态本体 | 它们只是交互提示 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | banner、状态词、session count、session list、QR、footer、hint |
| 条件公开 | `w` hint、single vs multi-session 投影、title 的异步补齐 |
| 内部/实现层 | shimmer、visual line 计数、OSC8 链接包装、ticker 更新机制 |

## 4. 六个高价值判断问题

- 当前显示的是 host facts、lifecycle、session budget，还是 session object list？
- QR / footer 现在指向 connect target 还是 session target？
- 这是 single-session 还是 multi-session 的显示投影？
- 当前 `Attached` 是真实 title，还是列表占位态？
- 这行内容是在描述系统状态，还是提示下一步交互动作？
- 我是不是又把 banner、状态行、QR 和 session list 写成了一张面？

## 5. 源码锚点

- `claude-code-source-code/src/bridge/bridgeUI.ts`
- `claude-code-source-code/src/bridge/bridgeStatusUtil.ts`
- `claude-code-source-code/src/bridge/bridgeMain.ts`
