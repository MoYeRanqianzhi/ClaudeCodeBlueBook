# remote 运行态面与 ownership 拆分记忆

## 本轮继续深入的核心判断

第 28 页回答的是：

- remote session client
- assistant viewer
- bridge host

第 29 页回答的是：

- permission response
- session control request
- command contract

但这两批之间还缺一层更细的“运行态对象边界”：

- `remoteConnectionStatus`
- `remoteBackgroundTaskCount`
- `BriefSpinner` / `BriefIdleStatus`
- `remoteSessionUrl` / remote pill
- `viewerOnly` 对 ownership 的改写

如果不单独补这一批，正文会继续犯五种错：

- 把 remote session runtime 和 bridge host runtime 混成一张状态面
- 把 `remoteBackgroundTaskCount` 写成本地 task 列表的镜像
- 把 `BriefIdleStatus` 写成 generic remote 状态页
- 把 `viewerOnly` 写成纯只读 viewer
- 把 `viewerOnly` 写成“viewer 完全不会 reconnect”
- 把 remote pill 写成任意 remote mode 的统一指示灯

## 苏格拉底式自审

### 问：为什么这批不能继续塞在第 28 页结尾？

答：第 28 页已经在结尾带到：

- `remoteConnectionStatus`
- `remoteBackgroundTaskCount`

但那一页的主问题仍然是：

- role boundary

如果继续把运行态、UI 投影和 reconnect ownership 挤在同一页里，读者会先记住：

- client / viewer / host

却更难记住：

- 这些角色在运行时到底投影出哪些状态对象

所以本轮要把“角色边界”继续下钻成：

- runtime-surface boundary

### 问：为什么这批值得进入正文，而不是只留在记忆？

答：因为这些都是用户真会撞上的误判：

- assistant 为什么会显示 `Reconnecting...`
- 为什么 brief 右边会出现 `n in background`
- 为什么 `--remote` 有 remote pill，assistant viewer 却主要给 attach message
- 为什么 viewerOnly 不该被写成“完全不重连”

这些已经是读者使用面的问题，不是作者内部实现备注。

### 问：这批最该防的假并列是什么？

答：

- remote runtime = bridge runtime
- background count = local tasks
- viewerOnly = no reconnect
- remote pill = any remote mode

只要这四组没拆开，远端运行态正文就还会继续糊。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/30-remoteConnectionStatus、remoteBackgroundTaskCount、BriefIdleStatus 与 viewerOnly：为什么远端会话的连接告警、后台任务与 bridge 重连不是同一张运行态面.md`
- `bluebook/userbook/03-参考索引/02-能力边界/19-Remote 运行态、后台任务与 viewerOnly ownership 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/30-2026-04-06-remote 运行态面与 ownership 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- `remoteConnectionStatus` / `remoteBackgroundTaskCount` 属于 remote session runtime，不属于 `replBridge*`
- `BriefSpinner` / `BriefIdleStatus` 是 brief / assistant 的状态投影
- `remoteBackgroundTaskCount` 来自远端 task lifecycle 事件，不是本地任务列表
- `viewerOnly` 改的是 title / interrupt / watchdog ownership，不是底层 transport 是否存在 reconnect
- `viewerOnly` 仍可向远端 session 发消息，不能被偷换成“只能看不能发”
- remote pill 只属于 `remoteSessionUrl` 这条 URL surface，assistant viewer 主要走 attach message

### 不应写进正文的

- `RESPONSE_TIMEOUT_MS` / `COMPACTION_TIMEOUT_MS`
- `4001` retry budget 与 close code 预算
- 重连时清空 task / tool 状态的补偿逻辑
- ping interval、echo filter、force reconnect 等传输细节
- mount-time capture `remoteSessionUrl` 的实现技巧

这些内容只保留为作者判断依据。

## 本轮特别保留到记忆的源码发现

### `viewerOnly` 不控制底层 `SessionsWebSocket`

`RemoteSessionManager` 创建 `SessionsWebSocket` 时没有把 `viewerOnly` 往下传。

因此更稳的正文结论只能是：

- viewerOnly 不拥有上层控制动作
- 共享 transport 仍可能回连

不能写成：

- viewer 根本不会 reconnect

### reconnect gap 会主动清空远端任务计数与工具执行态

`useRemoteSession.ts` 在 `onReconnecting` / `onDisconnected` 会清空：

- `runningTaskIdsRef`
- `remoteBackgroundTaskCount`
- in-progress tool use IDs

这是为避免状态漂高的补偿逻辑，适合记忆，不适合正文。

### brief 右侧的 `n in background` 本质是合并投影

`Spinner.tsx` 会把：

- 本地 background task
- remote background task

合并后显示。

正文应写“投影合并”，不该反推成：

- 两者底层来源相同

## 后续继续深入时的检查问题

1. 我现在拆的是 runtime object、UI projection，还是又回到了 role boundary？
2. 这句话是在描述共享 transport，还是在描述 viewer / client 的 ownership？
3. 我是不是把 brief / assistant 的专用状态投影写成 generic remote UI？
4. 我是不是又把 remote runtime、bridge runtime、remote URL surface 混成一张状态面？

只要这四问没先答清，下一页继续深入就会重新滑回：

- 对象混写
- 或实现笔记外泄到正文

而不是用户真正可用的运行态边界正文。

## 并行 agent 提供的下一批候选

本轮并行 agent 额外给出一个很稳的后续方向：

- remote-control 的状态词
- 恢复厚度
- 当前可用动作上限

它更适合继续留在 `05-控制面深挖`，作为 bridge host 语义页，而不是并入本轮 remote session runtime 正文。

这一候选之所以不并入本轮，是因为本轮已经固定在：

- remote session runtime
- brief / assistant projection
- viewer ownership

如果把 bridge 的状态词与恢复厚度同时并进来，就会重新把：

- remote session runtime
- bridge host runtime

压回同一张状态面。

因此后续继续深入时，更稳的切分是：

1. 本轮保留为 remote session runtime / ownership 页。
2. 下一轮再单起 bridge host 的状态词 / 恢复厚度 / 动作上限页。
