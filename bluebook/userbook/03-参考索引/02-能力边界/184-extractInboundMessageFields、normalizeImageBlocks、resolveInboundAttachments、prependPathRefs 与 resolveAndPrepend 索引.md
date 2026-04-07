# `extractInboundMessageFields`、`normalizeImageBlocks`、`resolveInboundAttachments`、`prependPathRefs` 与 `resolveAndPrepend` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/195-extractInboundMessageFields、normalizeImageBlocks、resolveInboundAttachments、prependPathRefs 与 resolveAndPrepend：为什么 image block repair 与 attachment path-ref prepend 不是同一种 inbound normalization contract.md`
- `05-控制面深挖/194-handleIngressMessage、control_response-control_request、extractInboundMessageFields 与 enqueue(prompt)：为什么 bridge ingress 只有 control 旁路和 user-only transcript adapter，non-user SDKMessage 没有第二消费面.md`

边界先说清：

- 这页不是 user-only transcript adapter 总页。
- 这页不是 attachment 功能总页。
- 这页只抓 adapter 内部的两层前处理：content block repair 与 attachment materialization。

## 1. 五层对象

| 对象 | 当前更像什么 | 关键位置 |
| --- | --- | --- |
| `extractInboundMessageFields(...)` | user payload 抽取边界 | `inboundMessages.ts` |
| `normalizeImageBlocks(...)` | `message.content` 内的 schema repair | `inboundMessages.ts` |
| `extractInboundAttachments(...)` | `file_attachments` 外挂附件抽取 | `inboundAttachments.ts` |
| `resolveInboundAttachments(...)` + `prependPathRefs(...)` | best-effort path-ref materialization | `inboundAttachments.ts` |
| `resolveAndPrepend(...)` | attachment pipeline convenience wrapper | `inboundAttachments.ts` |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| `normalizeImageBlocks` = `resolveAndPrepend` | 一个修 `content` 内坏块，一个处理外挂附件并改写 prompt 文本 |
| attachment 处理 = 第二个 transcript sink | 它只是 sink 前的 materialization，不是新 consumer |
| print / hook 都把两层绑死在一起 | hook bridge callback 组合两层；print 的 bridge callback只显式走第一层，另一条 prompt intake 再单独走 attachment 层 |
| 这页 = 194 的细节展开 | 194 讲 consumer 形状；195 讲 adapter 内部两层前处理合同 |

## 3. stable / conditional / gray

| 类型 | 对象 |
| --- | --- |
| 专题内稳定不变量 | image block repair 与 attachment path-ref prepend 是两层不同 contract |
| 条件公开 | malformed base64 image 才触发 `normalizeImageBlocks(...)`；存在 `file_attachments` 才触发 attachment pipeline |
| 内部/灰度层 | webhook sanitize、upload 下载失败、OAuth / allowlist 环境失败细节 |

## 4. 五个检查问题

- 我现在写的是 transcript adapter 总句，还是 adapter 内部的前处理拆层？
- 我是不是把 `message.content` 内坏块修复和 `file_attachments` 下载落盘压成一件事？
- 我是不是把 attachment path-ref prepend 误写成第二消费面？
- 我是不是把 hook / print 的调用点差异写成对象主语差异？
- 我是不是又回卷到 194 的 user-only adapter 主句了？

## 5. 源码锚点

- `claude-code-source-code/src/bridge/inboundMessages.ts`
- `claude-code-source-code/src/bridge/inboundAttachments.ts`
- `claude-code-source-code/src/hooks/useReplBridge.tsx`
- `claude-code-source-code/src/cli/print.ts`
