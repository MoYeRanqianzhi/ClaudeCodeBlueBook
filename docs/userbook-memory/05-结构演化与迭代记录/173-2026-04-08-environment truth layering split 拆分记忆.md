# environment truth layering split 拆分记忆

## 本轮继续深入的核心判断

172 已经把 bridge reconnect family 继续拆成：

- pointer-led continuity authority
- explicit original-session authority

但 environment 字段内部还缺一句更窄的判断：

- 同样都叫 environment，也不等于 truth thickness 相同

本轮要补的更窄一句是：

- pointer 里的 env、server session record 的 `environment_id`、以及注册返回的新 env，应分别落在 hint、requested truth 与 live result 三层

## 为什么这轮必须单列

如果不单列，正文最容易在三种偷换里回卷：

- 把 pointer 里的 `environmentId` 写成已经足够恢复的最终真相
- 把 `reuseEnvironmentId` 写成当前 live env，而不是 request-side original-env claim
- 把 env mismatch 误写成“换了个值但仍是同一次恢复成功”

这三种都会把：

- continuity breadcrumb
- original-environment truth
- registered live environment

重新压扁。

## 本轮最关键的新判断

### 判断一：pointer env 先是 local continuity hint，不是所有宿主都直接信的最终真相

### 判断二：standalone `--continue` 会把 environment truth 升级到 `getBridgeSession(...).environment_id`

### 判断三：`reuseEnvironmentId` 是 request-side original-env claim，不是 response-side live result

### 判断四：`registerBridgeEnvironment(...)` 返回的新 env 才是当前启动真正落成的 live environment

### 判断五：同一个 pointer env 字段在 perpetual REPL 与 standalone `--continue` 里，authority thickness 不同

## 苏格拉底式自审

### 问：为什么这页不是 172 的附录？

答：因为 172 讲的是谁拥有 reconnect authority；173 讲的是 environment 字段内部的 truth layering。

### 问：为什么必须把 REPL perpetual 也拉进来？

答：因为只有把它拉进来，才能证明同一个 pointer env 字段在不同 host 下的信任级别并不相同。

### 问：为什么一定要写 `registerBridgeEnvironment(...)` 的返回值？

答：因为没有 response-side live env，这页就无法证明 request-side truth 与 current result 不是同一层。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/173-BridgePointer.environmentId、getBridgeSession.environment_id、reuseEnvironmentId 与 registerBridgeEnvironment：为什么 pointer 里的 env hint、server session env 与 registered env 不是同一种 truth.md`
- `bluebook/userbook/03-参考索引/02-能力边界/162-BridgePointer.environmentId、getBridgeSession.environment_id、reuseEnvironmentId 与 registerBridgeEnvironment 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/173-2026-04-08-environment truth layering split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 173
- 索引层只补 162
- 记忆层只补 173

不回写 34、35、172。

## 下一轮候选

1. 继续拆 `source: 'repl'`、`source: 'standalone'` 与 workerType：为什么同属 bridge pointer，也不是同一种 prior-state trust domain。
2. 继续拆 `reuseEnvironmentId` 与 fresh-session fallback：为什么 request-side original-env claim 与 survivable continuity 不是同一种恢复主权。
