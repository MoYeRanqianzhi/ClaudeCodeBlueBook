# task-recovery vs worksite-restore echo 拆分记忆

## 本轮继续深入的核心判断

在上一刀已经把：

- `/session` 的 viewer continuation

钉回 `--remote` 链上的 `remoteSessionUrl` 暴露面之后，

下一刀应回到 recovery/continuity 横轴里尚未本地接球的一枝：

- `task recovery`

也就是：

- `02-能力地图/02-执行与工具/02-任务对象、输出回流、通知与恢复.md`

## 为什么这轮值得单独提交

### 判断一：当前缺口不在“有没有 task recovery 的定义”，而在“任务页自己还没显式拒收 /resume 语义”

上游现在已经有三层定义：

- `02-能力地图/README.md`
  把 `task recovery` 单列成恢复对象
- `04-会话真相层：实时状态、Transcript 与恢复账本.md`
  把它定义成后台执行对象与结果回收能力
- `02-任务对象、输出回流、通知与恢复.md`
  已经把 `local_agent / remote_agent`
  的恢复不对称写出来

但这张任务页自己还没显式写出：

- 这里讨论的是 task recovery
- 它不是稳定 `/resume` 的 worksite restore

所以本轮最小有效修正，

就是在“恢复语义是不对称的”标题下先补一句总括。

### 判断二：这句不能只写否定，必须把消费资产一起写出来

并行只读分析指出，

如果只补一句：

- `task recovery != /resume 本体`

会有四个风险：

- 把 `local_agent / remote_agent` 又混成一类
- 把 `outputFile` 误听成 `/resume` 恢复账的一部分
- 把 `<task-notification>` 误写成 generic resume path
- 把 sidecar identity 越权成“已恢复”

所以当前最稳的句子必须同时说明：

- 它恢复什么对象
- 它主要消费什么资产
- 它不是什么

## 这轮具体怎么拆

这轮只做一件事：

1. 在 `02-任务对象、输出回流、通知与恢复.md`
   的：
   - `## 恢复语义是不对称的`
   下面，
   先补一句总括：
   - 这里的 recovery 只指 task recovery：恢复的是后台任务对象与结果回收能力，主要消费 `task object / output file / notification` 回流链，`remote_agent` 还会额外消费 sidecar identity；它不是稳定 `/resume` 那条恢复工作现场的会话恢复，也不把 `local_agent` 与 `remote_agent` 写成同一种“后台自动接回”

这样：

- 任务页终于自己接住 recovery 横轴
- `outputFile / notification / sidecar identity`
  不会被顺手写成 `/resume` 恢复账
- `local_agent / remote_agent`
  的不对称恢复也有了统一总括句

## 苏格拉底式自审

### 问：为什么不只补一句“task recovery != /resume 本体”？

答：因为脱离横轴表格之后，纯否定句不够稳。这里必须把“消费什么资产”和“恢复什么对象”一起带上，边界才不会重新塌回去。

### 问：为什么不把这句放到结论区，离用户更近？

答：因为这页的局部问题正好发生在“恢复语义是不对称的”这一节。放在这里可以先总括，再往下读本地/远程两类恢复差异，结构更紧。

### 问：为什么这轮不顺手去改 `TaskOutputTool` 或 casebook 页？

答：因为那会把“执行层叶子页本地接球”升级成跨层扩写。当前最值钱的是让这页自己先说清 recovery 的对象、资产和非对象边界。
