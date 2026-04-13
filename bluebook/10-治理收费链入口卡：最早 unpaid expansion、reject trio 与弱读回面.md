# 治理收费链入口卡：最早 unpaid expansion 与四问诊断

这页只压治理入口第一问，不重做 why、机制 inventory 或执行 verdict。
它只补一件最容易被写浅的事实：进入诊断时先找 `earliest unpaid expansion`，再核对 `same authority lease / new decision delta / cleanup trigger state` 是否仍成立；`repricing proof / checkpoint / cleanup` 只是这条硬公式在现场里的旧简称。危险、花费与体验波动，只是这次扩张在判责时回看的投影，不是入口第一主语。

## 只在这里回答什么

- 这页只压缩 `earliest unpaid expansion -> repricing proof -> same authority lease / new decision delta / cleanup trigger state` 这一条最短诊断环。
- 这页不替 `85 / security / risk / playbooks` 重判 why、安全主语、用户侧 readback 或现场执行顺序。
- 若你已经开始追问 signer、readback、rollback、reopen 或 execution next hop，说明你已经离开入口卡。

## 一句话

- 治理不是先认资源类目，也不是先看谁更会拦截，而是先问最早 `unpaid expansion` 是什么，再核对 `repricing proof`、`same authority lease / new decision delta / cleanup trigger state`。
- 因此省 token 不是压缩已准入世界，而是减少免费扩张、延后暴露、外置 durable asset，并在 cleanup 后杀死不该默认续租的 transient authority。
- 更硬一点说，任何 surface 只有在新增 signer 证据、boundary delta 或 cleanup delta 时才配升级成治理事实；否则一律只算 receipt-grade readback。

## 四问诊断

这页最值钱的，不是多记几组 noun，而是把治理问题压成四问：

1. `earliest unpaid expansion`
   - 最早是哪条动作、能力、上下文席位或时间扩张还没被定价。
2. `repricing proof`
   - 谁重新定价，这次重定价由哪条 `verdict ledger` 或等价正式对象证明。
3. `lease checkpoint`
   - 这次继续是否仍在同一条 `authority lease` 上、仍已定价、也仍知道该由谁结算；若没有新增 `decision delta`，就只是 checkpoint，不是续租。
4. `cleanup`
   - 旧 authority 是否已经撤租、归档、停用，以及显式 `cleanup trigger` 是否已触发；若没有，继续一律不算合法续租。

如果要把这四问再压成 later maintainer 可直接执行的 typed-state 判断，也只先看三格：

| field | 允许值 | 一旦不是正向值会发生什么 |
|---|---|---|
| `authority lease` | `same / changed / unknown` | `changed / unknown` 一律不再默认继续，必须回 `repricing seam` |
| `decision delta` | `new / zero / unknown` | `zero / unknown` 不配续租 authority，只配停在 checkpoint / receipt-grade readback |
| `cleanup trigger state` | `fired / owed / failed / unknown` | `owed / failed / unknown` 一律不把当前 surface 读成已结算 truth |

再往前压一步，typed-state 真正要导向的也不是更多术语，而是更少动作分叉：

| state reading | 默认动作 |
|---|---|
| `authority lease = changed/unknown` | `reprice or suspend`，先回 `repricing seam`，不默认继续 |
| `decision delta = zero` 且其余字段仍正向 | `do not reopen`，保留 receipt-grade projection，但不重开旧判断 |
| `cleanup trigger state = owed/failed/unknown` | `suspend or reject`，先结清旧 authority，再谈继续 |
| 三格都正向，且新增 delta 已被正式写回 | `continue / reopen`，但只开放新增 delta 真正触及的那部分动作空间 |

`repricing seam` 不是一个补救动作名，而是这四问唯一允许改价的回炉口：凡要改写 continue、默认重试、usage 解读或 readback 结论的动作，都必须回到这里重开。若不同 surface 可以各自补签一点安全、一点成本，同一现场就会出现多头定价，`free-expansion relapse` 也会重新出现。这里入口层唯一认的 `reject trio` 也只剩：`decision-window collapse / projection usurpation / free-expansion relapse`；凡 usage、status、readback 或 reopen tail 不能补齐 `same authority lease / new decision delta / cleanup trigger state`，一律先降回 `receipt-grade checkpoint projection / tail evidence`，没有新增 `decision delta` 时也只算 `zero-delta ask / receipt-grade evidence`，不得在尾链补签继续、重试或 reopen 资格。若同类安全扩张在没有新增 `repricing / deny` 决策增益时仍反复 ask，入口层也先按 `approval fatigue` 记账，而不是按体验波动归档；这说明最早 `unpaid expansion` 已从动作本身转移到重复批准。
更硬一点说，`receipt-grade projection` 也有稳定的 verb ceiling：它可以报告 drift、pressure、acknowledgement 与 aftermath，但不能代签 repricing、continue、retry、reopen 或 cleanup truth。
这里的 `weak readback` 也应显式包含 settings diff、hook review、status snapshot 与 host replay：凡这些 surface 只能展示“刚才发生了什么”，却不能独立补齐 `same authority lease / new decision delta / cleanup trigger state`，就只配回单，不配回判。
一旦某次 ask 只能产出 approval receipt，却没有新增 signer 证据、boundary delta 或 cleanup 结果，它也应视作 `weak readback`：这类 `zero-delta ask` 只会补一张回单，不会补一条 `repricing proof`。
一旦这类 `zero-delta ask` 开始被拿来证明“已经够安全、可默认继续”，而不只是留下一张 approval receipt，它就不再只是成本噪音，而是 `projection usurpation`：tail evidence 正在越权代签 `continue qualification`。
治理效率也不该被写成 approval 更快，而应写成 delta-free approvals 更少；若 ask 更频繁更顺滑，却仍没有新增 signer、边界或 cleanup 增量，入口层就仍按 `approval fatigue / free-expansion relapse` 记账。

若症状正好发生在 `compact / resume / re-entry`，也只把它们当成 `lease checkpoint` 的暴露时刻；它们可以搬运或恢复状态，但不自动续租旧 authority。这页不继续展开这些入口各自的对象清单。

四问里只要有一问答不上，就先按 `free-expansion relapse` 处理，而不是继续补第二套术语表。

## 何时离场

- 若你还在问“为什么 expansion 必须先被定价”，回 `85`。
- 若你缺的是 canonical chain、runtime seam 或对象镜像，而不是 why / signer / readback / execution，回 `architecture/83`。
- 若你已经在判 signer / `verdict ledger` / cleanup authority 谁在代签，回 `security/README`。
- 若你已经在判用户侧 readback、reopen 或恢复承诺，回 `risk/README`。
- 若你已经要下现场 verdict、rollback 或回归动作，回 `playbooks/README`。
