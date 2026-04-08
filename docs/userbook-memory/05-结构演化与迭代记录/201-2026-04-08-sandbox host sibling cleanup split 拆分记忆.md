# sandbox host sibling cleanup split 拆分记忆

## 本轮继续深入的核心判断

198 已经拆开：

- request-level closeout

但 sandbox network bridge 里还缺一句更细的判断：

- same-host verdict 会横扫一组 sibling asks，这不是 request-level closeout 的简单重复

本轮要补的更窄一句是：

- `hostPattern.host`、`sandboxBridgeCleanupRef` 与 same-host queue filter 共同定义了 sandbox network bridge 的 host-level sibling sweep，而不是单个 tool ask 的 closeout

## 为什么这轮必须单列

如果不单列，正文最容易在四种偷换里回卷：

- 把 `SandboxNetworkAccess` 写成普通 tool ask
- 把 same-host queue filter 写成“顺手多清了几条”
- 把 `sandboxBridgeCleanupRef` 写成普通 request cleanup map
- 把 `unsubscribe()` / `cancelRequest(...)` 写成这条线的最终主语

这四种都会把：

- transport shell
- host verdict
- sibling sweep

重新压扁。

## 本轮最关键的新判断

### 判断一：`SandboxNetworkAccess` 是 synthetic transport shell，不是这条线真正主语

### 判断二：same-host queue filter 说明 settle 主语是 `hostPattern.host`

### 判断三：`sandboxBridgeCleanupRef` 是 host-keyed sibling cleanup map，不是 request-id map

### 判断四：`unsubscribe()` / `cancelRequest(...)` 只是 host sweep 的部件

## 苏格拉底式自审

### 问：为什么这页不是 198 的附录？

答：198 讲单 ask closeout；201 讲同 host sibling sweep。

### 问：为什么这页不是 78 的附录？

答：78 讲 worker-origin sandbox ask；201 讲本地 host prompt + bridge sibling cleanup。

### 问：为什么 `SandboxNetworkAccess` 不能直接当主语？

答：因为它只是把 host-level verdict 装进 tool approval 协议里的 synthetic shell。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/201-hostPattern.host、sandboxBridgeCleanupRef、sandboxPermissionRequestQueue filter、onResponse unsubscribe 与 cancelRequest：为什么 sandbox network bridge 的同 host sibling cleanup 不是同一种 tool-level permission closeout.md`
- `bluebook/userbook/03-参考索引/02-能力边界/189-hostPattern.host、sandboxBridgeCleanupRef、sandboxPermissionRequestQueue filter、onResponse unsubscribe 与 cancelRequest 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/201-2026-04-08-sandbox host sibling cleanup split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 201
- 索引层只补 189
- 记忆层只补 201

不回写 198。

## 下一轮候选

1. 若继续结构层，可把 191-201 再投影进更高层功能面导航，但不能复制 197/20 的结构页。
2. 若继续 permission 面，可看 sandbox host-level sibling sweep 与本地 persist-to-settings 的即时 config refresh 是否值得继续拆。
3. 若后续 `webhookSanitizer` 源码可见，再重新评估 transcript 前处理线。
