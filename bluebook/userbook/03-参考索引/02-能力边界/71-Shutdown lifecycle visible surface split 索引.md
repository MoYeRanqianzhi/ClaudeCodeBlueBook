# Shutdown lifecycle visible surface split 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/82-shutdown_request、shutdown_approved、shutdown_rejected、teammate_terminated 与 stopping：为什么 shutdown 生命周期不会完整落在同一可见消息面.md`
- `05-控制面深挖/81-shutdown_request、shutdown_approved、shutdown_rejected、terminate 与 kill：为什么 swarms 的 shutdown mailbox 消息属于 lifecycle termination family.md`

边界先说清：

- 这页不是 shutdown protocol family 总论。
- 这页不替代 81 页对 termination lifecycle family 的定义。
- 这页只抓 shutdown 生命周期在 rich message、attachment、task/spinner、cleanup 四张面上的可见性分裂。

## 1. 四张面总表

| 面 | 代表对象 | 更接近什么 |
| --- | --- | --- |
| rich message 面 | `ShutdownMessage`、`UserTeammateMessage` | request / rejected 的人读对话 |
| mailbox attachment 面 | `AttachmentMessage`、summary helper | 压缩后的 mailbox 可见计数与摘要 |
| task / spinner 面 | `shutdownRequested`、`stopping` | 运行态投影 |
| hidden cleanup 面 | `useInboxPoller`、`print.ts`、`attachments.ts` | 移除 teammate、清任务、收口状态 |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| request / rejected / approved 应该同等显示 | approved 更偏 cleanup signal，不保证占主显示位 |
| `[stopping]` 就是已经退出 | 它只表示 shutdown 流程已发起 |
| `teammate_terminated` 就是 approved 的别名 | 前者是 cleanup 通知，后者是 mailbox lifecycle response |
| helper 能生成 summary，就一定会显示 | summary 能力不等于 rich render 权利 |
| visible surface 的不对称只是 UI 偶然 | task、spinner、attachment、headless cleanup 都在复制这套分层 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | shutdown 生命周期会分裂到 rich message、status/spinner、cleanup 等多张面；request/rejected 更偏可读对话；approved 更偏 cleanup signal |
| 条件公开 | `stopping` 在 in-process teammate 上最稳定；pane teammate 最终退出更依赖 backend kill；`teammate_terminated` 是否显示取决于当前渲染面 |
| 内部/实现层 | structured protocol 白名单是否包含某一类 shutdown 消息；attachment 去重、idle collapse、系统通知注入与过滤顺序 |

## 4. 六个检查问题

- 这条 shutdown 信号是给谁看的：人、模型、spinner，还是 cleanup path？
- 这是 lifecycle decision，还是 cleanup consequence？
- 它应该占 transcript 主位，还是只投影到状态面？
- 这里看到的是 `stopping`，还是已经完成退出？
- 这是 mailbox response，还是本地注入的 system notification？
- 我是不是把 lifecycle family sameness 写成 visible surface sameness 了？

## 5. 源码锚点

- `claude-code-source-code/src/components/messages/ShutdownMessage.tsx`
- `claude-code-source-code/src/components/messages/UserTeammateMessage.tsx`
- `claude-code-source-code/src/components/messages/AttachmentMessage.tsx`
- `claude-code-source-code/src/components/messages/PlanApprovalMessage.tsx`
- `claude-code-source-code/src/components/tasks/taskStatusUtils.tsx`
- `claude-code-source-code/src/components/Spinner/TeammateSpinnerLine.tsx`
- `claude-code-source-code/src/hooks/useInboxPoller.ts`
- `claude-code-source-code/src/utils/attachments.ts`
- `claude-code-source-code/src/utils/teammateMailbox.ts`
