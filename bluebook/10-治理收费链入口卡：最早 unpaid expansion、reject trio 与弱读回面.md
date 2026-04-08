# 治理收费链入口卡：最早 unpaid expansion、reject trio 与弱读回面

这页只压治理入口第一问，不重做 why、运行时 seam 或审读题表。
它只补一件最容易被写浅的事实：进入诊断时先找 `earliest unpaid expansion`，再看 `repricing proof / lease checkpoint / cleanup`；危险或昂贵，只是这次扩张在判责时回看的后果，不是入口第一主语。

## 只在这里回答什么

- 这页只压缩 `earliest unpaid expansion -> repricing proof -> lease checkpoint -> cleanup` 这一条最短诊断环。
- 这页不替 `09 / 85 / 83 / 100` 重判 why、运行时 seam 或审读问题，也不替 `playbooks/` 直接发现场 verdict。
- 若你已经开始问 signer / tail readback / execution next hop，分别离场到 `security/README`、`risk/README`、`playbooks/README`。

## 一句话

- 治理不是先认资源类目或更会拦截，而是先问最早 `unpaid expansion` 是什么，再核对 `repricing proof`、`lease checkpoint` 与 `cleanup`。
- 因此省 token 不是压缩已准入世界，而是减少免费扩张、延后暴露、外置 durable asset，并在 cleanup 后杀死不该继续收费的 transient authority。

## 最短诊断环

这页最值钱的，不是多记几组 noun，而是把治理问题压成四问：

1. `earliest unpaid expansion`
   - 先找最早哪条动作 / 能力 / 上下文席位 / 时间扩张还没被定价
2. `repricing proof`
   - 再问谁重新定价、哪条 `verdict ledger` 证明它发生、什么 cleanup / revocation 负责结算
3. `lease checkpoint`
   - 若这一步答不上，先冻结 continuation；若症状来自 `compact / resume / re-entry`，只问 `same scene? still priced? who settles?`
4. `cleanup`
   - 若这一步答不上，先 `revoke / retire` 旧 authority、封存 `verdict / liability receipt`、停止默认续租；若没完成，continue 一律不算合法续租

若症状正好发生在 `compact / resume / re-entry`，也只把它们当成 lease 续租失败的暴露时刻；本页不继续展开这些时刻各自的对象清单。

四问里只要有一问答不上，就先按 `free-expansion relapse` 处理。

若需要继续判责对象、运行时 seam 或执行边界，统一退到对应 owner 页；不要在入口卡先摆第二张 taxonomy。

## reject trio

- `decision-window collapse`
- `projection usurpation`
- `free-expansion relapse`

这里只命名三类 first reject seam，不在入口卡继续解释每一条 seam 的对象细节。

## 弱读回面

- 弱层只配触发复核、消费已外化 verdict、承接继续动作。
- 它们不配重新签治理真相；一旦开始代签，就说明问题应退回 `security / risk / playbooks` 对应 owner 页。
