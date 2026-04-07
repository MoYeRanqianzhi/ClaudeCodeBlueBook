# interactive host split 拆分记忆

## 本轮继续深入的核心判断

154 已经把 assistant 入口链拆成四段了。

但正文还缺一个更底层的 host 结论：

- 这些步骤虽然都在终端里跑，但不共享同一种 interactive host

本轮要补的更窄一句是：

- `showSetupDialog(...)` 和 `renderAndRun(...)` 代表两类完全不同的宿主合同

## 为什么这轮必须单列

如果不单列，正文最容易在三种偷换里回卷：

- 把 install / chooser 写成 attach 前两步 UI
- 把 chooser 业务标签误写成 setup-dialog 宿主标签
- 把共享的 `KeybindingSetup` 误写成共享的 host contract

这三种都会把：

- result-returning setup host
- long-lived REPL/app host

重新压扁。

## 本轮最关键的新判断

### 判断一：`showSetupDialog(...)` 是 result-returning setup-dialog host

### 判断二：assistant install wizard 和 session chooser 都属于这类宿主

### 判断三：`renderAndRun(...)` 是长期 interactive host

### 判断四：`launchRepl(...)` 把 attached/full REPL 明确装进 `<App>` 并交给 `renderAndRun(...)`

### 判断五：`launchResumeChooser(...)` 证明 chooser/picker 业务不自动等于 setup-dialog host

## 苏格拉底式自审

### 问：为什么这页不是 154 的附录？

答：因为 154 讲的是业务入口链，155 讲的是宿主合同。前者问“先做哪段流程”，后者问“这些流程跑在什么 host family 里”。

### 问：为什么一定要把 `launchResumeChooser(...)` 写进来？

答：因为它是最干净的反例，能把“业务标签”和“宿主标签”彻底剥开。

### 问：为什么一定要写 `replLauncher.tsx`？

答：因为它把 attached/full REPL host 的装配路径明确到 `<App><REPL/>`，不是只靠 main 调用点侧推。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/155-showSetupDialog、renderAndRun、launchResumeChooser、launchRepl、AppStateProvider 与 KeybindingSetup：为什么 setup-dialog host 与 attached REPL host 不是同一种 interactive host.md`
- `bluebook/userbook/03-参考索引/02-能力边界/144-showSetupDialog、renderAndRun、launchResumeChooser、launchRepl、AppStateProvider 与 KeybindingSetup 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/155-2026-04-08-interactive host split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 155
- 索引层只补 144
- 记忆层只补 155

不回写 154。

## 下一轮候选

1. 继续拆 setup-dialog host 与 attached REPL host 的退出语义和 shutdown 路径。
2. 如果后续快照能看到 `sessionDiscovery.js` 实现体，再回头拆 discovery 本体的数据源与过滤算法。
