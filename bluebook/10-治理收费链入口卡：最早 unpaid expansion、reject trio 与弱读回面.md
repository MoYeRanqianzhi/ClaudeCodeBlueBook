# 治理收费链入口卡：最早 unpaid expansion 与四问诊断

这页只压治理入口第一问，不重做 why、机制 inventory 或执行 verdict。
它只补一件最容易被写浅的事实：进入诊断时先找 `earliest unpaid expansion`，再看 `repricing proof / lease checkpoint / cleanup`；危险、花费与体验波动，只是这次扩张在判责时回看的投影，不是入口第一主语。

## 只在这里回答什么

- 这页只压缩 `earliest unpaid expansion -> repricing proof -> lease checkpoint -> cleanup` 这一条最短诊断环。
- 这页不替 `85 / security / risk / playbooks` 重判 why、安全主语、用户侧 readback 或现场执行顺序。
- 若你已经开始追问 signer、readback、rollback、reopen 或 execution next hop，说明你已经离开入口卡。

## 一句话

- 治理不是先认资源类目，也不是先看谁更会拦截，而是先问最早 `unpaid expansion` 是什么，再核对 `repricing proof`、`lease checkpoint` 与 `cleanup`。
- 因此省 token 不是压缩已准入世界，而是减少免费扩张、延后暴露、外置 durable asset，并在 cleanup 后杀死不该默认续租的 transient authority。

## 四问诊断

这页最值钱的，不是多记几组 noun，而是把治理问题压成四问：

1. `earliest unpaid expansion`
   - 最早是哪条动作、能力、上下文席位或时间扩张还没被定价。
2. `repricing proof`
   - 谁重新定价，这次重定价由哪条 `verdict ledger` 或等价正式对象证明。
3. `lease checkpoint`
   - 这次继续是否仍在同一现场、仍已定价、也仍知道该由谁结算。
4. `cleanup`
   - 旧 authority 是否已经撤租、归档、停用；若没有，继续一律不算合法续租。

`repricing seam` 不是一个补救动作名，而是这四问唯一允许改价的回炉口：凡要改写 continue、默认重试、usage 解读或 readback 结论的动作，都必须回到这里重开。若不同 surface 可以各自补签一点安全、一点成本，同一现场就会出现多头定价，`free-expansion relapse` 也会重新出现。

若症状正好发生在 `compact / resume / re-entry`，也只把它们当成 `lease checkpoint` 的暴露时刻；这页不继续展开这些入口各自的对象清单。

四问里只要有一问答不上，就先按 `free-expansion relapse` 处理，而不是继续补第二套术语表。

## 何时离场

- 若你还在问“为什么 expansion 必须先被定价”，回 `85`。
- 若你缺的是 canonical chain、runtime seam 或对象镜像，而不是 why / signer / readback / execution，回 `architecture/83`。
- 若你已经在判 signer / `verdict ledger` / cleanup authority 谁在代签，回 `security/README`。
- 若你已经在判用户侧 readback、reopen 或恢复承诺，回 `risk/README`。
- 若你已经要下现场 verdict、rollback 或回归动作，回 `playbooks/README`。
