# Host、Viewer 与 Health Check 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/21-Host、Viewer 与 Health Check：为什么 server、remote-control、assistant、doctor 不能写成同一类会外入口.md`
- `04-专题深潜/13-非交互、后台会话与自动化专题.md`
- `04-专题深潜/18-CLI 根入口、旗标与启动模式专题.md`

## 1. 对象边界总表

| 入口 | 对象类型 | 稳定性 | 是否 fast-path / hidden | 是否跳过 trust | 是否可能触发健康探针 | 正文语气 |
| --- | --- | --- | --- | --- | --- | --- |
| `server` | Host | 公开/高级 | feature-gated | 否 | 否 | 写成高级宿主面，不写默认主线 |
| `remote-control` / `rc` | Host | 条件公开 | fast-path + hidden/条件 | 取决于桥接路径 | 否 | 写成 host 启动面 |
| `cc://` / `cc+unix://` | Host 连接语义 | 公开/高级 | 入口改写 | 取决于交互/print 路径 | 否 | 写成连接语义，不写成普通命令 |
| internal `open <cc-url>` | Host plumbing | 内部 | internal | 取决于 headless 路径 | 否 | 只写实现边界 |
| `assistant [sessionId]` | Viewer | 条件公开 | feature-gated | 否 | 否 | 写成 viewer client |
| `--assistant` | Host/daemon 开关 | 内部 | hidden | 否 | 否 | 只写内部/托管 |
| `claude doctor` | Health Check | 稳定公开 | 普通 root command | 是 | 是 | 写成宿主健康检查 |
| `claude mcp list` | Health Check | 稳定公开 | 普通 root command | 是 | 是 | 写成健康检查型读取 |
| `claude mcp get` | Health Check | 稳定公开 | 普通 root command | 是 | 是 | 写成健康检查型读取 |

## 2. 三类对象到底回答什么问题

| 类型 | 回答的问题 |
| --- | --- |
| `Host` | 这次是不是要把本机/进程接成宿主、桥或服务端 |
| `Viewer` | 这次是不是要把当前 REPL 附着到一个已有会话 |
| `Health Check` | 这次是不是要诊断宿主安装、MCP、配置和运行状态 |

## 3. 为什么不能混成一条主线

| 错误写法 | 更准确的写法 |
| --- | --- |
| 把 `server`、`remote-control` 当成“高级用户常用入口” | 它们首先是 host，对象不是当前工作线程 |
| 把 `assistant [sessionId]` 当成 daemon | 它是 viewer client，附着远端 bridge session |
| 把 `doctor` 写成 updater 命令 | 它实际覆盖安装、plugin、MCP、context 等诊断面 |
| 把 `mcp list|get` 写成只读配置查看 | 它们会 `connectToServer()` 做 live health check |
| 把 internal `open` 当成公开 connect 命令 | 它只是 `cc://` 在 headless 路径下的内部 shim |

## 4. 五个高价值判断问题

- 这次入口操作的是当前工作线程、宿主、viewer，还是 health-check 对象？
- 这个入口是否被 `feature()`、`hideHelp()` 或 fast-path 截流保护？
- 当前入口会不会 skip trust dialog？
- 当前入口会不会实际连接 server，甚至拉起 `stdio` 子进程？
- 我是不是把 `assistant [sessionId]`、`--assistant`、daemon 混成了一层？

## 5. 源码锚点

- `claude-code-source-code/src/entrypoints/cli.tsx`
- `claude-code-source-code/src/main.tsx`
- `claude-code-source-code/src/server/createDirectConnectSession.ts`
- `claude-code-source-code/src/remote/RemoteSessionManager.ts`
- `claude-code-source-code/src/commands.ts`
- `claude-code-source-code/src/cli/handlers/mcp.tsx`
- `claude-code-source-code/src/cli/handlers/util.tsx`
- `claude-code-source-code/src/screens/Doctor.tsx`
- `claude-code-source-code/src/hooks/useAssistantHistory.ts`
- `claude-code-source-code/src/hooks/useRemoteSession.ts`
