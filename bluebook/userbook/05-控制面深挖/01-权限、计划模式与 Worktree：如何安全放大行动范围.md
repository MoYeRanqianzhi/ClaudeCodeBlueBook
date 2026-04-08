# 权限、计划模式与 Worktree：如何安全放大行动范围

## 第一性原理

Claude Code 面对的根本问题不是“能不能改代码”，而是“在多大风险半径内改代码”。

如果直接把模型的行动半径放到最大，系统会失控：

- 读得太多。
- 改得太快。
- 在错误目录里改。
- 在长任务里提前实施。
- 在并行执行时互相踩工作区。

如果你当前真正卡住的问题不是“要不要隔离代码面”，而是“要不要只在当前 session 里正式扩张工作面”，先回到 [../04-专题深潜/安全放大工作面/README.md](../04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/%E5%AE%89%E5%85%A8%E6%94%BE%E5%A4%A7%E5%B7%A5%E4%BD%9C%E9%9D%A2/README.md)。

所以权限、计划模式和 worktree 不是三个独立功能，而是一条逐级放大行动范围的治理链。

## 这条链的三层结构

### 第 1 层：权限模式

权限模式决定模型当前可行动的基本边界。是否需要审批、是否适合先探索、是否允许自动推进，先由这里定调。

### 第 2 层：计划模式

计划模式把“先探索再实施”产品化。进入后，系统明确要求只读探索、写计划、提交审批，再退出开始编码。

### 第 3 层：worktree

当任务已经确定需要实施，但不适合直接在当前工作区推进时，worktree 提供代码面的隔离边界。

## 为什么计划模式不是“多想一会儿”

`EnterPlanModeTool` 和 `ExitPlanModeV2Tool` 的实现说明：

- 进入计划模式会真的切换 permission mode。
- 退出计划模式不是“说一句我准备好了”，而是把 plan 文件、审批、附件、团队领导审批等机制串起来。
- 某些场景下还会把计划写回磁盘，并在远程场景下持久化快照。

这意味着计划模式的核心价值是：

- 防止模型在未收敛方案前直接改代码。
- 让“计划本身”成为共享对象，而不是口头摘要。
- 在多代理或 teammate 情况下，把计划审批升级成协调协议。

## 为什么 worktree 不是 Git 小技巧

`src/utils/worktree.ts` 暴露了几个重要事实：

- slug 会被严格校验，防止路径穿越。
- 嵌套 slug 会被扁平化，避免 Git ref 冲突和 worktree 删除时误伤子目录。
- 已存在的 named worktree 会被快速复用，而不是每次重建。
- 系统会尽量避免无意义 fetch，说明 worktree 被当成日常机制，而不是偶尔命令。
- 某些大目录可以通过符号链接方式减少重复磁盘占用。

这套实现说明它服务的是“正式隔离工作面”，不是临时脚本。

## 用户应该怎样组合这三者

### 场景 A：中小改动，风险可控

直接在普通模式推进，依赖权限规则和工具审批兜底。

### 场景 B：问题复杂、结构不清

先进入计划模式。目标不是写 PPT，而是把实施面推迟到理解足够清楚之后。

### 场景 C：已确定要实施，但改动风险高

在计划收敛后切入 worktree，把实现从主工作面隔离出去。

### 场景 D：多子任务并行

计划模式先拆边界，worktree 再提供各执行体的独立代码面。

## 常见误用

### 误用 1：把计划模式当作礼貌开场

如果没有真正探索和设计，计划模式只是多了一层文本噪音。

### 误用 2：一开始就开 worktree

如果任务本身还没定义清楚，先隔离目录只会把混乱复制一份。

### 误用 3：把 `/permissions` 当成事后补救

实际上 deny/allow 规则还会改变模型可见的工具宇宙。它会影响规划，不只是影响执行。

## 稳定面与灰度面

### 相对稳定

- `/permissions`
- 计划模式命令和工具
- `EnterWorktree` / `ExitWorktree`
- `/add-dir` 及其 session / local-settings 持久度选择
- Bash/File 工具上的权限检查

### 需要注意环境或门控

- 团队/teammate 里的计划审批联动
- 某些远程或 channel 场景下计划模式入口会被关闭
- 是否位于可操作的 Git/worktree 上下文

## 源码锚点

- `src/commands/permissions/index.ts`
- `src/commands/permissions/permissions.tsx`
- `src/tools/EnterPlanModeTool/EnterPlanModeTool.ts`
- `src/tools/ExitPlanModeTool/ExitPlanModeV2Tool.ts`
- `src/tools/EnterWorktreeTool/EnterWorktreeTool.ts`
- `src/tools/ExitWorktreeTool/ExitWorktreeTool.ts`
- `src/utils/worktree.ts`
- `src/utils/plans.js`
- `src/utils/permissions/*`
