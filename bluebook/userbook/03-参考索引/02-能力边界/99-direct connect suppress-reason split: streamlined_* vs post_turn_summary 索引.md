# direct connect suppress-reason split: `streamlined_*` vs `post_turn_summary` 索引

这页只做速查，不替代长文专题。长文解释请结合：

- `05-控制面深挖/110-streamlined_*、post_turn_summary、createStreamlinedTransformer 与 directConnectManager：为什么同样在过滤名单里，却不是同一种 suppress reason.md`
- `05-控制面深挖/108-StdoutMessage、SDKMessage、onMessage 与 post_turn_summary：为什么 direct connect 对 summary 的过滤不是消息不存在，而是 callback consumer-path 收窄.md`
- `05-控制面深挖/109-createStreamlinedTransformer、structuredIO.write、lastMessage 与 streamlined_*：为什么 headless print 的 streamlined output 不是 terminal semantics 后处理，而是 pre-wire rewrite.md`

边界先说清：

- 这页不是 direct connect 过滤总论。
- 这页不替代 108 对 `post_turn_summary` callback narrowing 的拆分。
- 这页不替代 109 对 `streamlined_*` pre-wire rewrite 的拆分。
- 这页只抓二者虽然同样被 `directConnectManager` 过滤，但不是同一种 suppress reason。

## 1. 四层对象总表

| 层级 | `streamlined_*` 更接近什么 | `post_turn_summary` 更接近什么 |
| --- | --- | --- |
| 更宽 `StdoutMessage` 层 | conditional projection family | raw background summary family |
| `SDKMessage` callback contract | 不属于普通 callback member | 不属于普通 callback member |
| direct connect skip list 结果 | callback 不消费 | callback 不消费 |
| provenance identity | transformer replacement artifact | standalone summary tail event |

## 2. 最常见的假等式

| 错误写法 | 更准确的写法 |
| --- | --- |
| 都在 skip list 里，所以它们是同一种内部噪音 | same callback exclusion 不等于 same upstream provenance |
| `streamlined_*` 只是另一种 summary tail | 它们来自 transformer 的 replacement/projection path |
| `post_turn_summary` 只是另一种 streamlined output | 它是独立定义的 background summary family |
| manager 一起过滤它们，说明二者同样稳定、同样常见 | `streamlined_*` 还受 feature/env/outputFormat gate 约束 |
| 既然 callback 都看不到，就都可以写成“不存在” | 二者都仍属于更宽 `StdoutMessage` 层可承认的对象 |

## 3. stable / conditional / internal

| 类型 | 对象 |
| --- | --- |
| 稳定可见 | 二者都在 `StdoutMessageSchema`、都不在 `SDKMessageSchema`、都被 direct connect 挡在 callback 外 |
| 条件公开 | `streamlined_*` 只在 streamlined gate 打开且 transformer 真产出对象时才可能出现；`post_turn_summary` 则取决于 upstream 是否 emit background summary |
| 内部/灰度层 | `streamlined_*` 与 `post_turn_summary` 都带 internal 色彩，但 internal 不等于同一种对象族 |

## 4. 六个检查问题

- 当前比较的是 callback exclusion 结果，还是对象来源？
- 我是不是把同一 skip list 写成了同一 provenance？
- 我是不是把 `streamlined_*` 写成了 raw system tail？
- 我是不是把 `post_turn_summary` 写成了 projection artifact？
- 我是不是把 gate 条件写没了，暗示 `streamlined_*` 与 `post_turn_summary` 一样天然会出现？
- 我有没有把 108/109 的单对象结论直接重讲，而没有继续压到 suppress-reason split？

## 5. 源码锚点

- `claude-code-source-code/src/server/directConnectManager.ts`
- `claude-code-source-code/src/utils/streamlinedTransform.ts`
- `claude-code-source-code/src/cli/print.ts`
- `claude-code-source-code/src/entrypoints/sdk/coreSchemas.ts`
- `claude-code-source-code/src/entrypoints/sdk/controlSchemas.ts`
