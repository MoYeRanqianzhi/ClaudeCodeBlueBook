# 治理收费链入口卡：四类被收费资源、reject trio 与弱读回面

这页只把 [09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在](09-%E4%B8%89%E5%BC%A0%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%80%BB%E5%9B%BE%EF%BC%9A%E4%B8%96%E7%95%8C%E8%BF%9B%E5%85%A5%E6%A8%A1%E5%9E%8B%E3%80%81%E6%89%A9%E5%BC%A0%E5%AE%9A%E4%BB%B7%E4%B8%8E%E9%98%B2%E8%BF%87%E5%8E%BB%E5%86%99%E5%9D%8F%E7%8E%B0%E5%9C%A8.md)、[philosophy/85-真正成熟的治理，不是更会拦截，而是更会为扩张定价](philosophy/85-%E7%9C%9F%E6%AD%A3%E6%88%90%E7%86%9F%E7%9A%84%E6%B2%BB%E7%90%86%EF%BC%8C%E4%B8%8D%E6%98%AF%E6%9B%B4%E4%BC%9A%E6%8B%A6%E6%88%AA%EF%BC%8C%E8%80%8C%E6%98%AF%E6%9B%B4%E4%BC%9A%E4%B8%BA%E6%89%A9%E5%BC%A0%E5%AE%9A%E4%BB%B7.md)、[architecture/83-反扩张治理流水线：trusted inputs、distributed ask arbitration、deferred visibility与continuation pricing](architecture/83-%E5%8F%8D%E6%89%A9%E5%BC%A0%E6%B2%BB%E7%90%86%E6%B5%81%E6%B0%B4%E7%BA%BF%EF%BC%9Atrusted%20inputs%E3%80%81distributed%20ask%20arbitration%E3%80%81deferred%20visibility%E4%B8%8Econtinuation%20pricing.md) 与 [guides/100-如何用苏格拉底诘问法审读当前世界准入主权：trusted inputs、最小可见面与continuation pricing](guides/100-%E5%A6%82%E4%BD%95%E7%94%A8%E8%8B%8F%E6%A0%BC%E6%8B%89%E5%BA%95%E8%AF%98%E9%97%AE%E6%B3%95%E5%AE%A1%E8%AF%BB%E5%BD%93%E5%89%8D%E4%B8%96%E7%95%8C%E5%87%86%E5%85%A5%E4%B8%BB%E6%9D%83%EF%BC%9Atrusted%20inputs%E3%80%81%E6%9C%80%E5%B0%8F%E5%8F%AF%E8%A7%81%E9%9D%A2%E4%B8%8Econtinuation%20pricing.md) 已承认的治理对象压成一屏入口卡，不重新定义治理主语。
它也只补一件最容易被写浅的事实：安全与省 token 不是两套并列 feature，而是同一条收费链在对 model-reachable world 的危险扩张与昂贵扩张同时定价。

## 发言权卡

- `能合法说`
  - 只压缩 canonical chain、四类被收费资源、reject trio、弱读回面声明与最短二跳。
- `不能改判`
  - 不替 `09 / 85 / 83 / 100` 重判第一性原理、运行时 seam 或审读问题，也不替 `playbooks/` 直接发现场 verdict。
- `canonical owner`
  - 宪法主语回 `09`；为什么如此回 `85`；运行时对象回 `83`；失稳前审读回 `100`；机制面与用户侧读回分别回 `security/README` 与 `risk/README`。
- `申诉路径`
  - 若你怀疑这里只是在重复而不是压缩，先回 `09` 看是否真缺最小顺序；若争议是 runtime seam，回 `83`；若争议是现场 verdict，回 `playbooks/README`。

## 一句话

- 治理不是更会拦截，而是先固定 `governance key -> externalized truth chain -> typed ask -> decision window -> continuation pricing -> durable-transient cleanup`，再让权限投影、状态读数、继续入口与收口结果词只读这条收费链在不同资产上的外观。
- 因此省 token 不是压缩已准入世界，而是减少免费扩张、延后暴露、外置 durable asset，并在 cleanup 后杀死不该继续收费的 transient authority。

## canonical chain

- `governance key`
- `externalized truth chain`
- `typed ask`
- `decision window`
- `continuation pricing`
- `durable-transient cleanup`

这里还应先记一句：

- `compact / resume / re-entry` 不构成第四条治理对象线；它们只是 `continuation pricing` 与 `durable-transient cleanup` 在时间轴上的消费点。

## 四类被收费资源

Claude Code 治理线真正统一收费的是四类稀缺资源：

1. 动作
2. 能力
3. 上下文席位
   - 临时治理席位，不是免费常驻背景
4. 时间
   - `authority lease` 的持续期，不是无限继续资格

如果一句治理说明答不上“这次在给哪类资源收费”，它通常还停在界面词、结果词或规则堆层。

如果把 `authority lease accounting` 压成最短 crosswalk，也只剩四句：

| priced resource | 谁开闸 | 谁记账 | 谁结算 |
|---|---|---|---|
| 动作 | signer | `externalized truth chain (verdict ledger)` | cleanup |
| 能力 | signer | `externalized truth chain (verdict ledger)` | cleanup |
| 上下文席位 | signer | `externalized truth chain (verdict ledger)` | cleanup |
| 时间 | signer | `externalized truth chain (verdict ledger)` | cleanup |

更硬一点说，signer 打开被定价的 authority，`externalized truth chain (verdict ledger)` 记录被定价的扩张，cleanup 负责把这份 lease 收口。

## reject trio

这条链最短的 reject trio 只认：

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

## 弱读回面声明

真正配签字的，只有 `governance key / externalized truth chain (verdict ledger) / typed ask / decision window / continuation pricing / durable-transient cleanup` 这组强面；其余对象最多只能做三件事：

1. 触发怀疑
2. 消费已外化 verdict
3. 承接继续动作

它们永远不配做第四件事：重新签治理真相。

更稳一点说：

- 弱层可以提醒你去复核，但不能替 signer 改判。
- 继续入口可以承接下一步，但不能替 ledger 回写 verdict。
- cleanup 之后留下的是尾部责任与证据，不是可再次收费的 authority handle。

它们之所以永远不配代签，不是因为“信息不够多”，而是因为一旦代签，observability 就会从 consumer 长成第二个 current-world compiler / host-truth source。
更硬一点说，如果某个对象既不能改写 `authority allocation`，也不能改写价格、结算或继续资格，它就不是 signer；它顶多只是 projection、consumer 或触发怀疑的症状面。

如果一句治理解释还必须把这些对象再分出第二张 taxonomy，说明你已经离开入口卡，进入 `risk/`、`playbooks/` 或 deeper owner pages 了。

## 最短二跳

- 缺“为什么治理首先处理的是免费扩张”，回 [philosophy/85-真正成熟的治理，不是更会拦截，而是更会为扩张定价](philosophy/85-%E7%9C%9F%E6%AD%A3%E6%88%90%E7%86%9F%E7%9A%84%E6%B2%BB%E7%90%86%EF%BC%8C%E4%B8%8D%E6%98%AF%E6%9B%B4%E4%BC%9A%E6%8B%A6%E6%88%AA%EF%BC%8C%E8%80%8C%E6%98%AF%E6%9B%B4%E4%BC%9A%E4%B8%BA%E6%89%A9%E5%BC%A0%E5%AE%9A%E4%BB%B7.md)
- 缺“为什么共用预算器还不够、为什么 token saving 实际是在重定价暴露”，回 [philosophy/61-真正成熟的安全与省Token系统，不是统一预算器，而是治理顺序、失败语义与可撤销自动化](philosophy/61-%E7%9C%9F%E6%AD%A3%E6%88%90%E7%86%9F%E7%9A%84%E5%AE%89%E5%85%A8%E4%B8%8E%E7%9C%81Token%E7%B3%BB%E7%BB%9F%EF%BC%8C%E4%B8%8D%E6%98%AF%E7%BB%9F%E4%B8%80%E9%A2%84%E7%AE%97%E5%99%A8%EF%BC%8C%E8%80%8C%E6%98%AF%E6%B2%BB%E7%90%86%E9%A1%BA%E5%BA%8F%E3%80%81%E5%A4%B1%E8%B4%A5%E8%AF%AD%E4%B9%89%E4%B8%8E%E5%8F%AF%E6%92%A4%E9%94%80%E8%87%AA%E5%8A%A8%E5%8C%96.md)
- 缺 runtime seam、typed transaction、外化真相链或 cleanup 运行时对象，回 [architecture/83-反扩张治理流水线：trusted inputs、distributed ask arbitration、deferred visibility与continuation pricing](architecture/83-%E5%8F%8D%E6%89%A9%E5%BC%A0%E6%B2%BB%E7%90%86%E6%B5%81%E6%B0%B4%E7%BA%BF%EF%BC%9Atrusted%20inputs%E3%80%81distributed%20ask%20arbitration%E3%80%81deferred%20visibility%E4%B8%8Econtinuation%20pricing.md)
- 缺失稳前问法、阈值矩阵或准入主权审读动作，回 [guides/100-如何用苏格拉底诘问法审读当前世界准入主权：trusted inputs、最小可见面与continuation pricing](guides/100-%E5%A6%82%E4%BD%95%E7%94%A8%E8%8B%8F%E6%A0%BC%E6%8B%89%E5%BA%95%E8%AF%98%E9%97%AE%E6%B3%95%E5%AE%A1%E8%AF%BB%E5%BD%93%E5%89%8D%E4%B8%96%E7%95%8C%E5%87%86%E5%85%A5%E4%B8%BB%E6%9D%83%EF%BC%9Atrusted%20inputs%E3%80%81%E6%9C%80%E5%B0%8F%E5%8F%AF%E8%A7%81%E9%9D%A2%E4%B8%8Econtinuation%20pricing.md)
- 缺 signer / ledger / cleanup 机制入口，或缺“为什么弱层永远不配越级代签”，回 [security/README.md](security/README.md)
- 缺用户侧尾部读回、资格尾链或证据绑定，回 [risk/README.md](risk/README.md)
- 缺现场验收、回退、人工接管或 reopen 执行，回 [playbooks/README.md](playbooks/README.md)
