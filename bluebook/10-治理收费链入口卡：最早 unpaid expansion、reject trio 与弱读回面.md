# 治理收费链入口卡：最早 unpaid expansion、reject trio 与弱读回面

这页只把 [09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在](09-%E4%B8%89%E5%BC%A0%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%80%BB%E5%9B%BE%EF%BC%9A%E4%B8%96%E7%95%8C%E8%BF%9B%E5%85%A5%E6%A8%A1%E5%9E%8B%E3%80%81%E6%89%A9%E5%BC%A0%E5%AE%9A%E4%BB%B7%E4%B8%8E%E9%98%B2%E8%BF%87%E5%8E%BB%E5%86%99%E5%9D%8F%E7%8E%B0%E5%9C%A8.md)、[philosophy/85-真正成熟的治理，不是更会拦截，而是更会为扩张定价](philosophy/85-%E7%9C%9F%E6%AD%A3%E6%88%90%E7%86%9F%E7%9A%84%E6%B2%BB%E7%90%86%EF%BC%8C%E4%B8%8D%E6%98%AF%E6%9B%B4%E4%BC%9A%E6%8B%A6%E6%88%AA%EF%BC%8C%E8%80%8C%E6%98%AF%E6%9B%B4%E4%BC%9A%E4%B8%BA%E6%89%A9%E5%BC%A0%E5%AE%9A%E4%BB%B7.md)、[architecture/83-反扩张治理流水线：trusted inputs、distributed ask arbitration、deferred visibility与continuation pricing](architecture/83-%E5%8F%8D%E6%89%A9%E5%BC%A0%E6%B2%BB%E7%90%86%E6%B5%81%E6%B0%B4%E7%BA%BF%EF%BC%9Atrusted%20inputs%E3%80%81distributed%20ask%20arbitration%E3%80%81deferred%20visibility%E4%B8%8Econtinuation%20pricing.md) 与 [guides/100-如何用苏格拉底诘问法审读当前世界准入主权：trusted inputs、最小可见面与continuation pricing](guides/100-%E5%A6%82%E4%BD%95%E7%94%A8%E8%8B%8F%E6%A0%BC%E6%8B%89%E5%BA%95%E8%AF%98%E9%97%AE%E6%B3%95%E5%AE%A1%E8%AF%BB%E5%BD%93%E5%89%8D%E4%B8%96%E7%95%8C%E5%87%86%E5%85%A5%E4%B8%BB%E6%9D%83%EF%BC%9Atrusted%20inputs%E3%80%81%E6%9C%80%E5%B0%8F%E5%8F%AF%E8%A7%81%E9%9D%A2%E4%B8%8Econtinuation%20pricing.md) 已承认的治理对象压成一屏入口卡，不重新定义治理主语。
它也只补一件最容易被写浅的事实：进入诊断时先找 `earliest unpaid expansion`，再看 `repricing proof / lease checkpoint / cleanup`；危险或昂贵，只是这次扩张在判责时才回看的两种后果，不是入口第一主语。

## 只在这里回答什么

- 这页只压缩 `earliest unpaid expansion -> repricing proof -> lease checkpoint -> cleanup` 这一条最短诊断环。
- 这页不替 `09 / 85 / 83 / 100` 重判 why、运行时 seam 或审读问题，也不替 `playbooks/` 直接发现场 verdict。
- 若你已经开始问 signer / tail readback / execution next hop，分别离场到 `security/README`、`risk/README`、`playbooks/README`。

## 一句话

- 治理不是先认资源类目或更会拦截，而是先问最早 `unpaid expansion` 是什么，再核对 `repricing proof`、`lease checkpoint` 与 `cleanup`；`governance key -> externalized truth chain -> typed ask -> decision window -> continuation pricing -> durable-transient cleanup` 只是这四问在对象层的正式落点。
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

若症状正好发生在 `compact / resume / re-entry`，也只把它们当成 lease 续租失败的暴露时刻：`compact` 核外置后是否还保住 `same scene / repricing proof`，`resume` 核旧 `verdict ledger` 是否仍能证明 lease 合法，`re-entry` 核旧 transient authority 是否已先被 `revoke / retire`。`reject trio` 只负责命名四问在哪条 seam 先暴露，不能反向长成第二套入口卡。

四问里只要有一问答不上，就先按 `free-expansion relapse` 处理。

## 四问答不上时只回看这些

- `governance key`
- `externalized truth chain (verdict ledger)`
- `typed ask`
- `decision window`
- `continuation pricing`
- `durable-transient cleanup`

这里还应先记一句：

- `compact / resume / re-entry` 不构成第四条治理对象线；它们只是续租失败最常暴露的三个时刻。
- 治理线里的 `continuity` 统一只问这道 checkpoint：`same scene? still priced? who settles?`；`compact / resume / re-entry` 只是它的三种入口形式。

Claude Code 治理线真正统一收费的是四类稀缺对象，但诊断时不要先从这里起步：

1. 动作
2. 能力
3. 上下文席位
   - 临时治理席位，不是免费常驻背景
4. 时间
   - `authority lease` 的持续期，不是无限继续资格

更稳的诊断顺序也只认一句：先找最早那条 unpaid expansion，而不是先盯最吵的 surface noun；只有在 `repricing / cleanup / lease checkpoint` 需要判责时，才回头问它属于哪类对象。

真正进入诊断时，也只先问四件事：

1. `what expanded`
   - 最早扩张的是动作、能力、上下文席位还是时间
2. `who repriced it`
   - 谁重新定价了这次扩张
3. `what ledger / verdict proves it`
   - 哪条 `externalized truth chain (verdict ledger)` 证明这次定价真实发生
4. `what cleanup / revocation ends it`
   - 什么结算或撤销动作终止了这份 lease

四问里只要有一问答不上，就先按 unpaid renegotiation 或 default-renewed lease 处理。

更硬一点说，signer 打开被定价的 authority，`externalized truth chain (verdict ledger)` 记录被定价的扩张，cleanup 负责把这份 lease 收口；`compact / resume / re-entry` 真正检查的，也只是这三者有没有重新对齐同一份 lease。

若还需要补 seam 名称，这条链最短的 `reject trio` 也只认：

1. `decision-window collapse`
2. `projection usurpation`
3. `free-expansion relapse`

这三条 reject 真正值钱，不在名字，而在它们各自固定追问哪条 seam：

- `decision-window collapse`
  - 定价是不是发生在暴露之后，而不是暴露之前
- `projection usurpation`
  - 弱层是不是替 signer 或 `verdict ledger` 说话了
- `free-expansion relapse`
  - lease 是不是在未重定价、未结算的情况下被默认续期了

若还需要补弱读回面边界，也只记一句：真正配签字的，只有 `governance key / externalized truth chain (verdict ledger) / typed ask / decision window / continuation pricing / durable-transient cleanup` 这组强面；其余对象最多只能做三件事：

1. 触发怀疑
2. 消费已外化 verdict
3. 承接继续动作

它们永远不配做第四件事：重新签治理真相。

更稳一点说：

- 弱层可以提醒你去复核，但不能替 signer 改判。
- 继续入口可以承接下一步，但不能替 ledger 回写 verdict。
- cleanup 先 `revoke / retire` 旧 authority、封存 `verdict / liability receipt`、停止默认续租；之后留下的才只是尾部责任与证据，而不是可再次收费的 authority handle。

它们之所以永远不配代签，不是因为“信息不够多”，而是因为一旦代签，observability 就会从 consumer 长成第二个 current-world compiler / host-truth source。
更硬一点说，如果某个对象既不能改写 `authority allocation`，也不能改写价格、结算或继续资格，它就不是 signer；它顶多只是 projection、consumer 或触发怀疑的症状面。

如果一句治理解释还必须把这些对象再分出第二张 taxonomy，说明你已经离开入口卡，进入 `risk/`、`playbooks/` 或 deeper owner pages 了。
