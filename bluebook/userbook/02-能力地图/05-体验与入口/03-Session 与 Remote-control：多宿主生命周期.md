# `/session`、`/remote-control` 与多宿主生命周期

## 第一性原理：远程 viewer 和本机宿主不是同一件事

Claude Code 的多前端能力最容易被写错的地方，就是把下面两条链混成一个“远程模式”：

- `--remote` / teleport：你连到远端会话
- bridge / `/remote-control`：别人连到你这台机器

它们都可能出现 URL、QR 和跨设备继续工作，但工作对象的宿主完全不同。

## 第一条链：`--remote` / teleport

这条链里，本地 CLI 更像 viewer 或 client：

1. 选择远端环境
2. 创建或恢复远端 session
3. 用 `RemoteSessionManager` 连接远端事件流
4. 把 `remoteSessionUrl` 注入前端状态
5. `/session` 只是把这个远端 session 的 URL / QR 暴露出来

这里真正执行代码的是远端 environment，不是当前机器。

## 第二条链：bridge / `/remote-control`

这条链里，本地机器才是宿主：

1. 初始化 bridge environment
2. 通过 poll loop 领取 work item
3. 拿到 ingress token / session token
4. 建立 transport
5. 在 `ready / connected / reconnecting / failed` 之间推进
6. heartbeat、重连、环境重建
7. 归档或保留为可恢复宿主

这里 `/remote-control` 打开的不是“远端 viewer”，而是“本机被 web / mobile / Claude app 接入”的能力。

## `/session` 与 `/remote-control` 不能混写

更稳的写法是：

- `/session` 属于 remote mode，面向远端 session 的接续与暴露。
- `/remote-control` 属于 bridge mode，面向本机宿主被远控。

两者同样会显示 URL，但 URL 指向的对象不同。

如果把它们写成“远程会话的两种 UI”，正文就会误导读者。

## `desktop`、`mobile`、`voice`、`chrome` 与这两条链的关系

它们都属于多前端生态，但不应并入同一宿主状态机：

- `desktop`：把当前 session 深链接交给 Claude Desktop
- `mobile`：主要是 App 下载与接续入口
- `voice`：本地语音输入能力
- `chrome`：浏览器扩展 + native host + MCP 接入

所以更稳的结构应该是：

- 一页讲前端与接入面
- 一页讲宿主生命周期

## entitlement 是叠层门禁，不是单一开关

远程相关能力的真实边界通常由多层同时决定：

- `claude.ai` 订阅
- OAuth scope
- GrowthBook gate
- 组织策略
- remote managed settings

这也是为什么“源码里看见命令”不等于“普通用户稳定可用”。

## 稳定面、条件面与内部面

### 稳定公开

- `--remote`
- `/session`
- `/desktop`
- `/mobile`

### 条件公开

- `/remote-control`
- `/remote-env`
- `/voice`
- `/chrome`

### 内部或灰度

- `bridge-kick`
- `remoteControlServer`
- ccr mirror
- env-less v2 等更细的 bridge rollout 路径

## 对用户最有价值的结论

### 结论 1

如果你是“我要去看远端会话”，先想 `--remote` / `/session`。

### 结论 2

如果你是“我要让别的前端接到这台机器”，才想 `/remote-control`。

### 结论 3

`voice`、`chrome`、`desktop` 虽然与多前端有关，但不该被误写成 bridge 主链的一部分。

## 源码锚点

- `src/main.tsx`
- `src/commands/session/index.ts`
- `src/commands/session/session.tsx`
- `src/commands/bridge/index.ts`
- `src/commands/bridge/bridge.tsx`
- `src/hooks/useReplBridge.tsx`
- `src/bridge/initReplBridge.ts`
- `src/bridge/replBridge.ts`
- `src/bridge/remoteBridgeCore.ts`
- `src/bridge/bridgeMain.ts`
- `src/bridge/sessionIdCompat.ts`
- `src/remote/RemoteSessionManager.ts`
- `src/utils/teleport.tsx`
- `src/components/RemoteEnvironmentDialog.tsx`
- `src/utils/teleport/environmentSelection.ts`
- `src/services/policyLimits/index.ts`
- `src/services/remoteManagedSettings/index.ts`
- `src/services/remoteManagedSettings/securityCheck.tsx`
- `src/utils/auth.ts`
- `src/bridge/bridgeEnabled.ts`
