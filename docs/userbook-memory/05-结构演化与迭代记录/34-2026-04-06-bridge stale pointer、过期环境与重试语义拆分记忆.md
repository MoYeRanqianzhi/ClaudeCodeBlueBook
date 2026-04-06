# bridge stale pointer、过期环境与重试语义拆分记忆

## 本轮继续深入的核心判断

第 33 页已经拆开了：

- closeout initiator
- remote asset fate
- pointer cleanup / preserve
- `--continue`

但 closeout 之后，bridge 恢复线仍然缺一层非常容易混写的失败语义：

- stale pointer
- session not found
- no `environment_id`
- env mismatch fallback
- transient reconnect retry

如果不单独补这一批，正文会继续犯六种错：

- 把 `No recent session found` 写成 server-side session 失败
- 把 `Session not found` 写成“再试一次也许就好”
- 把 env mismatch 写成 resume 成功
- 把 “try running the same command again” 写成低信息量安慰句
- 把 perpetual 与 `--continue` 写成同一套 pointer prior state
- 把 deterministic invalid source 与 transient retry 压成同一种恢复失败

## 苏格拉底式自审

### 问：为什么这批不能塞回第 33 页？

答：第 33 页解决的是：

- 如何收口
- 收口后 pointer fate 怎样变化

而本轮问题已经换成：

- 当恢复真的失败时，系统如何区分“该清掉”与“该保留重试”

这已经从：

- closeout trajectory

继续下钻到：

- resume failure semantics

所以需要新起一页。

### 问：为什么这批值得进入正文，而不是只留在 memory？

答：因为读者真实会遇到的就是这些具体误读：

- 为什么这次 `--continue` 直接说没有 recent session
- 为什么这次它说 session 不存在
- 为什么它让我重跑一次而不是直接清理
- 为什么这次 continuity 断了却又自动新开了 fresh session

这些都是 user-facing 失败边界，不是作者内部实现笔记。

### 问：这批最该防的偷换是什么？

答：

- artifact missing = server missing
- invalid source = transient retry
- fallback = successful resume
- shared pointer dependency = same prior-state filter

只要这四组没拆开，bridge 恢复失败正文就还会继续糊。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/34-No recent session found、Session not found、environment_id 与 try running the same command again：为什么 bridge 的 stale pointer、过期环境与瞬态重试不是同一种恢复失败.md`
- `bluebook/userbook/03-参考索引/02-能力边界/23-Remote Control stale pointer、过期环境与重试语义索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/34-2026-04-06-bridge stale pointer、过期环境与重试语义拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 正文落笔纪律

### 应写进正文的

- `No recent session found` 先说明 artifact missing
- `Session not found` / `has no environment_id` 属于 deterministic invalid source
- env mismatch 表示 fallback 到 fresh session，不是 resume success
- transient reconnect failure 会故意保留 pointer
- perpetual 与 `--continue` 虽然都依赖 pointer，但 prior-state 过滤不同

### 不应写进正文的

- pointer TTL / mtime 具体数值
- worktree fanout cap
- `session_*` 与 `cse_*` 兼容转换细节
- reconnect candidate 全部实现细枝末节

这些只保留为作者判断依据。

## 本轮特别保留到记忆的源码发现

### `No recent session found` 之前，stale / invalid pointer 就可能已被读路径清掉

`bridgePointer.ts` 在 read 路径里会对：

- invalid schema
- stale mtime

直接 `clearBridgePointer(dir)`。

所以 artifact missing 不能被草率写成“从没开过 bridge”。

### deterministic failure 会清 pointer，transient failure 则故意保留

`bridgeMain.ts` 在：

- session 不存在
- 没有 `environment_id`
- fatal reconnect failure

时清 `resumePointerDir`。

但 transient reconnect failure 则明确保留 pointer，作为下次 retry 机制。

### perpetual 与 `--continue` 的 pointer 依赖不是同一套 prior-state 过滤

- perpetual init 只接受 `source:'repl'`
- root `--continue` 先消费统一 bridge pointer，再做 server 校验

正文必须写“同依赖 pointer，但不同过滤”，不能偷写成单一恢复源。

## 并行 agent 结果

本轮复用了现成 subagent 做并行核查。

若有延迟返回，只作为后续种子进入 memory，不回灌本轮正文。

## 后续继续深入时的检查问题

1. 我现在拆的是 artifact validity、server survivability，还是 retry policy？
2. 这句话是在解释为什么当前恢复源无效，还是在解释为什么系统保留它再试？
3. 我是不是把 fallback 写成了 resume success？
4. 我是不是又把 stale pointer、expired env 与 transient retry 压成了一种恢复失败？

只要这四问没先答清，下一页继续深入就会重新滑回：

- 失败语义混写
- 或错误实现细节泄漏到正文

而不是用户真正可用的 bridge resume failure 正文。
