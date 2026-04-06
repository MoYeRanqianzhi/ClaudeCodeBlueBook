# Remote Control 入口矩阵索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/27-remote-control 命令、--remote-control、claude remote-control 与 Remote Callout：为什么 remote-control 的会内开桥、启动带桥与 standalone host 不是同一种入口.md`
- `05-控制面深挖/25-Settings、remote-control 命令、Footer 状态 pill 与 Bridge Dialog：为什么 bridge 的默认配置、当前开关与连接展示不是同一个按钮.md`
- `05-控制面深挖/21-Host、Viewer 与 Health Check：为什么 server、remote-control、assistant、doctor 不能写成同一类会外入口.md`

## 1. 四类入口总表

| 入口 | 回答的问题 | 对象 |
| --- | --- | --- |
| `/remote-control` | 当前已运行的 REPL 会话，现在要不要显式开桥 | session-first 会内入口 |
| `--remote-control` / `--rc` | 这次交互 REPL 启动时，要不要一开始就带桥进入 | startup flag |
| `claude remote-control` | 要不要直接把本机作为 remote-control host 启起来 | standalone host |
| `Remote Callout` | 第一次从 REPL 内显式开桥时，是否先做一次性的说明与确认 | first-run consent surface |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `/remote-control` = `claude remote-control` | 一个作用于当前 REPL，会内开桥；一个启动 standalone host |
| `--rc` = `/remote-control` | 一个是启动期入口，一个是运行期入口 |
| Remote Callout = 所有远控入口的总闸门 | 它只属于 REPL `/remote-control` 的 first-run consent |
| spawn mode = remote-control 的共有设置 | 它只属于 standalone host 的 multi-session 路径 |
| `remote` / `sync` / `bridge` = 主线命令名 | 它们更接近 legacy / compatibility aliases |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | `/remote-control`、`claude remote-control`、Remote Callout |
| 条件公开 | hidden `--remote-control` / `--rc`、`claude rc` alias、legacy aliases、spawn mode first-run choice |
| 内部/实现层 | cli fast-path 顺序、analytics 事件、底层 runner 与 spawn implementation |

## 4. 七个高价值判断问题

- 我是在当前 REPL 里开桥，还是在启动时带桥进入？
- 我要的是 session-first 会内开桥，还是 standalone host？
- 这个入口改的是当前 `AppState`，还是走另一条 CLI fast-path？
- 这个提示页是不是只属于 `/remote-control` 的 first-run callout？
- 现在谈的是显式开桥，还是 standalone host 的 spawn mode？
- 这个命令名是主线入口，还是 hidden / alias / legacy surface？
- 我是不是把多个 remote-control 入口又写成了一种动作？

## 5. 源码锚点

- `claude-code-source-code/src/commands/bridge/bridge.tsx`
- `claude-code-source-code/src/components/RemoteCallout.tsx`
- `claude-code-source-code/src/screens/REPL.tsx`
- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/entrypoints/cli.tsx`
- `claude-code-source-code/src/bridge/bridgeMain.ts`
- `claude-code-source-code/src/commands.ts`
- `claude-code-source-code/src/utils/config.ts`
