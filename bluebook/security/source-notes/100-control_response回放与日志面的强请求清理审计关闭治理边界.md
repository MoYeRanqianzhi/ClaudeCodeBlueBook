# control_response 回放与日志面的强请求清理审计关闭治理边界

## 1. 为什么单开这一篇源码剖面

安全主线推进到 `249` 时，
真正需要被单独钉住的已经不是：

`stronger-request cleanup 线未来谁来决定 old echo 何时退出 active operational surface，`

而是：

`stronger-request cleanup 线如果未来已经让 old echo 退出活跃表面，谁来决定它什么时候也退出 replay、debug 与 diagnostics 这些审计面。`

如果这个问题只停在主线长文里，
最容易又被压成一句抽象判断：

`archive-close governor 不等于 audit-close governor。`

这句话还不够硬。
所以这里单开一篇，只盯住：

- `src/cli/structuredIO.ts`
- `src/cli/print.ts`

把 `control_response` replay、duplicate / orphan debug 轨迹与 diagnostics parse surface 并排，
逼出一句更硬的结论：

`Claude Code 已经在 old echo world 里明确展示：退出活跃表面只解决 operator surface；只要 replay / debug / diagnostics 还在继续承载它，这条 old echo 就仍然活在 audit world。`

## 2. 最短判断

这组代码最重要的技术事实不是：

`Claude Code 有一些 replay 选项和 debug log。`

而是：

`Claude Code 明确把 operational closure 与 evidentiary closure 分成两层：前者让 old echo 离开 active surface，后者才决定它是否也离开 replay / debug / diagnostics audit surface。`

## 3. 关键源码锚点

| 主题 | 关键源码 | 这里回答的问题 |
| --- | --- | --- |
| replay propagation | `src/cli/structuredIO.ts:424-428` | 为什么 `control_response` 在 replay mode 下仍会被向上游继续传播 |
| replay enqueue | `src/cli/print.ts:4030-4036` | 为什么 old echo 即使不再 active handling，也还能进入 replay output |
| duplicate trace logging | `src/cli/structuredIO.ts:386-398` | 为什么 duplicate old echo 仍留下 debug trace |
| orphaned trace logging | `src/cli/print.ts:5258-5292` | 为什么 orphaned old echo 仍留下 explainability trace |
| diagnostics parse surface | `src/cli/structuredIO.ts:228-236` | 为什么 returned message 仍会进入 diagnostics parsing |

## 4. `Propagate control responses when replay is enabled` 先证明：archive-close 之后，old echo 仍可留在 replay world

`structuredIO.ts:424-428` 很硬。

源码没有把 replay 当作旁注，
而是直接写：

`Propagate control responses when replay is enabled`

这意味着：

只要 replay mode 打开，
`control_response`

就不只是一个已经离开 active surface 的旧回包，
它还是：

`继续向上游暴露的 replay object`

`print.ts:4030-4036` 更硬。

这里再次明确：

`Replay control_response messages when replay mode is enabled`

并执行：

`output.enqueue(message)`

这条证据直接说明：

`archive-close`

并不自动带来

`replay-close`

## 5. duplicate / orphan debug 轨迹再证明：active-surface close 之后，repo 仍在保存可解释痕迹

`structuredIO.ts:386-398` 与 `print.ts:5258-5292` 很值钱。

这里至少保留了这些 old echo explainability traces：

1. `Ignoring duplicate control_response ...`
2. `handleOrphanedPermissionResponse: received orphaned control_response ...`
3. `skipping duplicate orphaned permission ...`
4. `already resolved in transcript ...`
5. `enqueuing orphaned permission ...`

这说明 repo 的态度不是：

`既然 old echo 不再 active，就应彻底 silent drop`

而是：

`即便不再 active，也要让后来的审计者知道它发生了什么、为何被跳过、为何仍被接回或被拒绝。`

所以从技术启示看，
debug trace 本身就是 old echo 仍留在 audit world 的铁证。

## 6. diagnostics parse surface 再证明：只要 returned message 还能被上游观察，它就还没 audit-close

`structuredIO.ts:228-236` 说明：

只要 `processLine()` 返回了 message，
系统就会：

`logForDiagnosticsNoPII('info', 'cli_stdin_message_parsed', { type: message.type })`

而 replay mode 下，
`control_response` 正好会被返回。

这意味着 old echo 不仅还活在 replay world，
还活在：

`diagnostics observability world`

也就是说，
它仍是一个被上游解释、被事件面观察的对象。

这显然超出了 archive-close 的边界。

## 7. 为什么这层不等于 `99` 的 archive-close gate

这里必须单独讲清楚，
否则容易把 `100` 误读成 `99` 的尾注。

`99` 问的是：

`old echo 是否已经退出 active lifecycle / waiting / queue / observability 表面。`

`100` 问的是：

`即便它已退出这些 active 表面，它是否也已经退出 replay / debug / diagnostics 这些 evidentiary 表面。`

所以：

1. `99` 的典型形态是 lifecycle close、stale prompt teardown、queue non-admission、inline completed contract
2. `100` 的典型形态是 replay propagation、replay enqueue、debug trace、diagnostics parse

前者 guarding operational closure，
后者 guarding evidentiary closure。

两者都很重要，
但不是同一个 signer。

## 8. 一条硬结论

这组源码真正说明的不是：

`只要 old echo 已经离开 active handling world，stronger-request cleanup 线就已经知道何时让它退出全部审计世界。`

而是：

repo 已经在 `StructuredIO` 的 replay propagation、`print.ts` 的 `control_response` replay enqueue、duplicate/orphan debug 轨迹与 diagnostics parse surface 上，清楚展示了 stronger-request audit-close governance 的独立存在；因此 `artifact-family cleanup stronger-request archive-close-governor signer` 仍不能越级冒充 `artifact-family cleanup stronger-request audit-close-governor signer`。

因此：

`stronger-request cleanup 线真正缺的，不只是“谁来宣布 old echo 现在已退出活跃操作表面”，还包括“谁来宣布它现在也已退出 replay、debug 与 diagnostics 这些审计世界”。`
