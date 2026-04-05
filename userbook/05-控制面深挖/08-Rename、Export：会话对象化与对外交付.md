# Rename、Export：会话对象化与对外交付

## 第一性问题

会话连续性解决的是“还能不能继续工作”。

但在真正的长期使用里，还要再解决两件事：

- 当前会话如何变成一个有稳定身份的工作对象。
- 当前会话如何正式离开 Claude Code，变成可交付对象。

这对应的就是 `/rename` 和 `/export`。

## `/rename` 不是纯 UI 美化

`/rename` 的职责是给当前会话建立稳定身份。

从源码看，它会：

- 空参数时尝试基于 compact boundary 后的消息自动生成名字。
- 把名字写入 `custom title`。
- 同时更新 `agent name`，影响当前提示栏身份显示。
- 如果当前会话有 bridge session，还会 best-effort 同步远端标题。

这说明 `/rename` 改的不是显示文案，而是会话对象的身份一致性。

误用边界：

- 没有上下文时，自动命名并不总能成功。
- teammate 会话不能自己改名。

## `/export` 不是 `/copy` 的大号版本

`/export` 的职责不是快速搬运当前片段，而是正式外化整个会话。

从实现看，它会先通过 headless renderer 把消息渲染成纯文本，再分成两条路径：

- 有参数时，直接写到当前 cwd 下的 `.txt` 文件。
- 无参数时，先给出默认文件名，再进入导出对话框。

这说明 `/export` 是正式交付路径，而不是终端内的快捷复制动作。

误用边界：

- 它不承诺任意格式导出。
- 它也不是用来替代 `/compact` 或 `/resume` 的内部连续性工具。

## 为什么这两者应被放在一起

因为它们共同回答的是：

- 会话如何成为对象。
- 会话如何离开系统。

`/rename` 负责对象化，`/export` 负责外化。

## 用户策略

更稳的路径通常是：

1. 当一段会话已变成长期工作对象时，用 `/rename` 固定其身份。
2. 当结果要发给人、发给流程或归档到文件系统时，用 `/export` 正式外化。

如果你现在更想按“评审、提交、导出和反馈”这一整条用户工作目标来读，应继续看：

- [../04-专题深潜/09-评审、提交、导出与反馈专题.md](../04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/09-%E8%AF%84%E5%AE%A1%E3%80%81%E6%8F%90%E4%BA%A4%E3%80%81%E5%AF%BC%E5%87%BA%E4%B8%8E%E5%8F%8D%E9%A6%88%E4%B8%93%E9%A2%98.md)

## 源码锚点

- `src/commands/rename/index.ts`
- `src/commands/rename/rename.ts`
- `src/commands/rename/generateSessionName.ts`
- `src/commands/export/index.ts`
- `src/commands/export/export.tsx`
- `src/utils/exportRenderer.tsx`
- `src/components/ExportDialog.tsx`
