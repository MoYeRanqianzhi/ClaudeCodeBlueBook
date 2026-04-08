# Add-dir：工作面扩张、权限上下文与 Sandbox 刷新

## 第一性问题

在 Claude Code 里，目录不只是路径问题，而是：

- 上下文边界。
- 权限边界。
- sandbox 可访问边界。

所以 `/add-dir` 解决的不是“cd 到另一个目录”，而是“把另一片目录正式纳入当前工作面”。

如果你现在是在整条治理链里判断“该收权限、进计划、切 worktree，还是只扩工作面”，先读 [../04-专题深潜/安全放大工作面/README.md](../04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/%E5%AE%89%E5%85%A8%E6%94%BE%E5%A4%A7%E5%B7%A5%E4%BD%9C%E9%9D%A2/README.md)。

## `/add-dir` 真正修改的是什么

从实现看，它不是单步动作，而是一条短治理链：

1. 先验证目录是否存在、是否是目录、是否已被当前工作面覆盖。
2. 再更新 `toolPermissionContext`。
3. 再刷新 bootstrap 级 additional dirs 与 sandbox 配置。
4. 最后决定只作用于本 session，还是记入 local settings。

这意味着 `/add-dir` 一次性在修改三件事：

- 工作面。
- 权限上下文。
- shell / sandbox 的可达集合。

## 为什么这不是 shell 技巧

如果只是在终端里 `cd` 到另一个目录：

- Claude Code 的正式工作面不一定扩张。
- 工具权限和 sandbox 可写集合也不一定同步更新。

而 `/add-dir` 的价值就在于，它把“目录扩张”做成一个正式、可校验、可持久化的运行时动作。

## 两种持久度

实现里显式区分：

- 只加到当前 session。
- 记到 local settings。

这说明 Claude Code 不把目录边界默认当长期偏好，而是把它当成需要用户明确决定持久度的控制项。

## 最常见误用

- 把 `/add-dir` 当成 `cd` 的花哨包装。
- 把它当成越过权限边界的捷径。
- 在已经被现有 working dir 覆盖的路径上重复扩张工作面。

## 用户策略

更稳的做法是：

- 只有当任务真的需要跨多个目录、文档区、脚本区或相关仓库时，再用 `/add-dir`。
- 先想清楚这是临时 session 需要，还是长期本地设置需要。

## 源码锚点

- `src/commands/add-dir/add-dir.tsx`
- `src/commands/add-dir/validation.ts`
- `src/components/permissions/rules/AddWorkspaceDirectory.tsx`
- `src/utils/permissions/PermissionUpdate.ts`
- `src/utils/sandbox/sandbox-adapter.ts`
