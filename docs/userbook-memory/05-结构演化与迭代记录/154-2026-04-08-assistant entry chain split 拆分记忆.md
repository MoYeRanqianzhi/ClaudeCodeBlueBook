# assistant entry chain split 拆分记忆

## 本轮继续深入的核心判断

58、123、145、146、151、153 已经把 attach 之后的 attached viewer 行为拆得很细了。

但正文还缺一条更上游的入口链结论：

- `claude assistant` 本身不是单段 connect flow

本轮要补的更窄一句是：

- `claude assistant` 先后经过 discovery、install bootstrap、chooser 和 viewerOnly attach 四段不同入口链

## 为什么这轮必须单列

如果不单列，正文最容易在三种偷换里回卷：

- 把 zero-session 写成 attach failure
- 把 chooser 写成 attach 的 UI 皮肤
- 把 install / chooser / attach 都写成同一种前端

这三种都会把：

- discovery
- daemon bootstrap
- candidate selection
- attached REPL

重新压扁。

## 本轮最关键的新判断

### 判断一：未传 `sessionId` 时，assistant 入口先走 discovery

### 判断二：zero-session 会转 install / daemon bootstrap，而不是 attach failed

### 判断三：多 session 会走 chooser，解决的是 candidate selection，不是 attach 本体

### 判断四：只有拿到 `targetSessionId` 之后，才真正进入 viewerOnly attach 合同

### 判断五：install / chooser 是 setup-dialog host，attach 才是 REPL host

## 苏格拉底式自审

### 问：为什么这页不是 146 的上游补充？

答：因为 146 讲的是 attach 之后 assistant viewer 与 `--remote` TUI 的合同厚度差；这页讲的是 attach 之前和 attach 当下的入口链分叉。

### 问：为什么实现体缺席还能写？

答：因为当前快照里 `main.tsx`、`dialogLaunchers.tsx` 和 `showSetupDialog(...)` 已经把四段链的调用合同、返回值和退出路径写明了。内部实现只应标灰，不该阻断结构切分。

### 问：为什么一定要把 setup-dialog host 单列？

答：因为不把宿主差异写出来，chooser / wizard 很容易被误写成 attached REPL 的前几步 UI。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/154-discoverAssistantSessions、launchAssistantInstallWizard、launchAssistantSessionChooser、createRemoteSessionConfig 与 attach banner：为什么 claude assistant 的发现、安装、选择与附着不是同一种 connect flow.md`
- `bluebook/userbook/03-参考索引/02-能力边界/143-discoverAssistantSessions、launchAssistantInstallWizard、launchAssistantSessionChooser、createRemoteSessionConfig 与 attach banner 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/154-2026-04-08-assistant entry chain split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 154
- 索引层只补 143
- 记忆层只补 154

不回写 58、123、145、146、151、153。

## 下一轮候选

1. 继续拆 assistant discovery 本体的 data source / filtering 细节，前提是后续源码快照能看到 `sessionDiscovery.js` 实现体。
2. 继续拆 setup-dialog host 与 attached REPL host 的共享壳与主权边界，避免把它们写成同一种 interactive host。
