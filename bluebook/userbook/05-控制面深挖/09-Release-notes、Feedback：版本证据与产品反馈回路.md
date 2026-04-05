# Release-notes、Feedback：版本证据与产品反馈回路

## 第一性问题

Claude Code 不只是执行当前任务，它还在持续演化。

因此系统还必须解决两件看似边缘、其实很正式的事情：

- 用户怎样在当前 CLI 里得到版本变化证据。
- 用户怎样带着现场上下文把问题反馈回产品侧。

这对应的是 `/release-notes` 和 `/feedback`。

## `/release-notes` 提供的是版本证据

`/release-notes` 不是纯链接跳转。

从实现看，它会：

- 先尝试一次很短超时的远程抓取。
- 抓不到就退回本地缓存。
- 缓存仍没有时，最后才只给 changelog URL。

底层 `releaseNotes.ts` 还明确说明：

- 非交互会话不主动抓取。
- `essential traffic only` 时不主动发这类非必要网络请求。

这说明它的设计目标是：低打扰地把“这版到底变了什么”带回当前运行时。

## `/feedback` 提供的是产品反馈回路

`/feedback` 也不是裸表单。

它在命令层先经过 provider、privacy、policy 与 `USER_TYPE` 的条件门控；进入组件后，又会走：

- 描述输入。
- consent 确认。
- 正式提交。
- 提交成功后可继续打开浏览器草拟 GitHub issue。

提交时携带的不是单条文本，而是现场证据，包括：

- 当前会话 transcript。
- 环境信息。
- Git 元数据。
- error logs。
- last API request。
- 可用时的 subagent transcripts。

误用边界：

- 它不是所有部署环境都稳定存在的按钮。
- 开启 custom data retention 的组织也会被拒绝。

## 为什么这两者应该一起看

因为它们共同处理的是“产品与运行时的双向回路”：

- `/release-notes` 让产品变化重新进入当前 CLI。
- `/feedback` 让当前 CLI 里的问题重新进入产品回路。

这不是杂项，而是产品演化的正式控制面。

## 用户策略

更稳的做法是：

- 更新后先用 `/release-notes` 看清版本变化，不要只凭体感猜行为变化。
- 遇到真实摩擦时优先用 `/feedback`，因为它能带着现场证据回流，而不是逼你脱离上下文重述。

如果你现在更想按“从评审到导出，再到反馈”的完整用户路径来读，应继续看：

- [../04-专题深潜/09-评审、提交、导出与反馈专题.md](../04-%E4%B8%93%E9%A2%98%E6%B7%B1%E6%BD%9C/09-%E8%AF%84%E5%AE%A1%E3%80%81%E6%8F%90%E4%BA%A4%E3%80%81%E5%AF%BC%E5%87%BA%E4%B8%8E%E5%8F%8D%E9%A6%88%E4%B8%93%E9%A2%98.md)

## 源码锚点

- `src/commands/release-notes/release-notes.ts`
- `src/utils/releaseNotes.ts`
- `src/commands/feedback/index.ts`
- `src/commands/feedback/feedback.tsx`
- `src/components/Feedback.tsx`
