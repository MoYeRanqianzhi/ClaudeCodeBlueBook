# resume entry host split 拆分记忆

## 本轮继续深入的核心判断

160 已经把 formal restore 里面的 payload taxonomy 拆开了。

但正文还缺一个更外层的恢复结论：

- 同一 restore 合同也不等于同一种入口宿主

本轮要补的更窄一句是：

- `--continue`、startup picker 与会内 `/resume` 都能恢复旧会话，但分别站在 startup direct、startup chooser、live command 三种宿主位置上

## 为什么这轮必须单列

如果不单列，正文最容易在三种偷换里回卷：

- 把 startup picker 写成 `--continue` 的交互版
- 把会内 `/resume` 写成 startup resume 的重复调用
- 把 helper family 话题重新写成 host role 话题

这三种都会把：

- entry host
- restore contract

重新压扁。

## 本轮最关键的新判断

### 判断一：`--continue` 是 startup direct restore host

### 判断二：`launchResumeChooser -> ResumeConversation` 是 startup chooser host

### 判断三：`resume.tsx -> REPL.resume()` 是 live command host

### 判断四：会内 `/resume` 比 startup 路径多了一层“退出当前活会话”的宿主责任

### 判断五：155 讲的是 helper family，这页讲的是 resume host role

## 苏格拉底式自审

### 问：为什么这页不是 155 的附录？

答：因为 155 拆的是 `showSetupDialog` vs `renderAndRun`；161 拆的是 resume lifecycle 里的宿主角色。

### 问：为什么一定要写 `REPL.resume()`？

答：因为它是“live command host”最硬的证据，能直接暴露 current-session unwind 责任。

### 问：为什么一定要写 `launchResumeChooser()`？

答：因为 startup picker 的核心不是恢复本身，而是“先挂 chooser host 再决定目标”。

## 本轮结构决策

本轮新增：

- `bluebook/userbook/05-控制面深挖/161-main.tsx、launchResumeChooser、ResumeConversation、resume.tsx 与 REPL.resume：为什么 --continue、startup picker 与会内 resume 共享恢复合同，却不是同一种入口宿主.md`
- `bluebook/userbook/03-参考索引/02-能力边界/150-main.tsx、launchResumeChooser、ResumeConversation、resume.tsx 与 REPL.resume 索引.md`
- `docs/userbook-memory/05-结构演化与迭代记录/161-2026-04-08-resume entry host split 拆分记忆.md`

并同步修改：

- `bluebook/userbook/README.md`
- `bluebook/userbook/00-阅读路径.md`
- `bluebook/userbook/03-参考索引/README.md`
- `bluebook/userbook/03-参考索引/02-能力边界/README.md`
- `bluebook/userbook/05-控制面深挖/README.md`
- `docs/userbook-memory/05-结构演化与迭代记录/README.md`

## 本轮目录策略

继续最小增量：

- 长文层只补 161
- 索引层只补 150
- 记忆层只补 161

不回写 155、158、160。

## 下一轮候选

1. 继续拆 transcript 合法化、interrupt 修复与 hook 注入为什么都在“恢复前后”发生，却不是同一种 runtime stage。
2. 继续拆 interactive TUI resume host 与 `print.ts` / headless resume host 为什么共享恢复合同，却不是同一种宿主族。
