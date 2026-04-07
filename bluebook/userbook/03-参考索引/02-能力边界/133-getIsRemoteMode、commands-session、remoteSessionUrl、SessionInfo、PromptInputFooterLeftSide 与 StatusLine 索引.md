# `getIsRemoteMode`、`commands/session`、`remoteSessionUrl`、`SessionInfo`、`PromptInputFooterLeftSide` 与 `StatusLine` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/144-getIsRemoteMode、commands-session、remoteSessionUrl、SessionInfo、PromptInputFooterLeftSide 与 StatusLine：为什么 session 命令的显隐与 pane 内容不是同一种 remote mode.md`
- `05-控制面深挖/143-getIsRemoteMode、setIsRemoteMode、activeRemote、remoteSessionUrl、commands-session 与 StatusLine：为什么全局 remote behavior 开关，不等于 remote presence truth.md`
- `05-控制面深挖/141-remoteSessionUrl、remoteConnectionStatus、remoteBackgroundTaskCount、useRemoteSession、activeRemote 与 getIsRemoteMode：为什么 remote-session presence ledger 不会自动被 direct connect、ssh remote 复用.md`

边界先说清：

- 这页不是 143 的重复摘要。
- 这页不是 `/session` UI walkthrough。
- 这页只抓 `/session` 里的双门控为什么必须保留。

## 1. 四类 consumer

| consumer | 当前回答的问题 | 读的对象 |
| --- | --- | --- |
| `/session` 命令显隐 | 命令该不该露出来 | `getIsRemoteMode()` |
| `/session` pane 内容 | 当前有没有 URL / QR 可展示 | `remoteSessionUrl` |
| footer mode 抑制 | 本地 permission mode 会不会误导 | `getIsRemoteMode()` |
| status line remote 字段 | 要不要对 hook 下游导出 remote schema | `getIsRemoteMode()` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `/session` 可见，就说明当前已有 remote-session presence | 可见性 gate 与 pane 内容 gate 分开 |
| `getIsRemoteMode()` 和 `remoteSessionUrl` 只是同一状态的粗细投影 | 一个是 coarse latch，一个是 presence field |
| footer 里的 remote link 和 mode 抑制都在表达同一个 remote 状态 | 前者表达 presence link，后者表达 UI 防误导 |
| status line remote tag、`/session` 显隐、pane 内容都属于同一种 remote truth | 它们分别属于 schema、affordance、presence content |

## 3. 启动路径给出的硬证据

| 路径 | `setIsRemoteMode(true)` | 初始 `remoteSessionUrl` |
| --- | --- | --- |
| `claude assistant` attach / viewer | 会写 | 初始化时不显式种下 |
| `claude --remote` TUI | 会写 | 初始化时显式种下 |

因此稳定能得出的不是：

- “有 flag 就一定有 URL”

而是：

- “同一 coarse latch 下，presence 载荷厚度仍会因启动路径不同而分叉”

补一层：

- `/session` 本身又在 `REMOTE_SAFE_COMMANDS` 里，被 remote 预过滤与 remote init 之后的重算共同保留
- 所以 viewer path 上“命令可见，但 pane 内容未就绪”是稳定结构，不是纸面矛盾

## 4. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `/session` 显隐看 `getIsRemoteMode()`；`SessionInfo` 内容看 `remoteSessionUrl`；footer 同时消费两者；status line 只消费 `getIsRemoteMode()`；`REMOTE_SAFE_COMMANDS` 让这组分叉在 viewer path 上稳定可达 |
| 条件公开 | attach / `--remote` TUI 都会进入 coarse remote latch，但只有部分路径在初始状态里显式给出 URL；footer remote pill 又只拿 mount-time snapshot，不承诺后续自动恢复 |
| 内部/灰度层 | `SessionInfo` 的 warning 文案是面向用户的解释语，不是精密术语；以后文案可变，但双门控结构不变 |

## 5. 五个检查问题

- 我现在写的是 slash affordance，还是 pane presence content？
- 我是不是把 `getIsRemoteMode()` 的 consumer 很多，偷换成了它能回答所有 remote 问题？
- 我是不是忽略了 footer 同时读 `remoteSessionUrl` 与 `getIsRemoteMode()` 这个硬证据？
- 我是不是把 status line 的 schema export 和 `/session` 的 pane 内容写成了同一类 consumer？
- 我是不是又把 143 的“flag 不是 truth”与本页的“命令 gate 不等于内容 gate”压回一句话？

## 6. 源码锚点

- `claude-code-source-code/src/commands.ts`
- `claude-code-source-code/src/commands/session/index.ts`
- `claude-code-source-code/src/commands/session/session.tsx`
- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/components/PromptInput/PromptInputFooterLeftSide.tsx`
- `claude-code-source-code/src/components/StatusLine.tsx`
- `claude-code-source-code/src/bootstrap/state.ts`
