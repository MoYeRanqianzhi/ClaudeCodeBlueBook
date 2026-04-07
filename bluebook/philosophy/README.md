# 哲学专题

`philosophy/` 只回答三件事：世界如何合法进入模型，扩张如何先被定价，过去如何不得越权写回现在。这里不重写长链，只保留 why frontdoor：Prompt 先到 `84`，治理先经 `10` 固定 canonical chain 再回 `85 / 61`，源码质量先经 `guides/102` 再回 `87`。

## 三条最短前门

- Prompt 线
  - 只认 `same-world compiler`
  - first answer 统一回 `84`；需要 how / witness / continue qualification 时，按 owner 页内部 next-hop 继续
- 治理线
  - 这里只回答“为什么扩张必须先被同一秩序定价”
  - canonical formula 与弱读回面总则先回 `10`；why 回 `85`，若还在把它误读成统一预算器，再到 `61`
- 源码质量线
  - 这里只回答“为什么源码质量首先服务 current-truth protection”
  - 证据上限与 canonical ladder 先回 `guides/102`，why 再回 `87`，对象与 writeback seam 再回 `architecture/README`
  - `87` 只解释 why，不升级 evidence class；路径级源码结论必须先由 `102` 判成 `official-artifact-backed / mirror-backed / candidate`
  - 凡涉及 `QueryGuard / sessionIngress / bridgePointer` 这类路径级 certainty，统一先退回 `guides/102` 处理 `public artifact ceiling / mirror gap discipline`

## 什么时候进来

- 当你已经知道功能或机制存在，但还没回答“为什么必须这样设计”。
- 当你要把 Prompt 效力、治理成熟度或源码先进性，从结果词压回不可约判断。
- 当你需要区分什么是 why、什么是 object、什么是 verdict，而不想在 route 页里反复兜圈。

## 单问入口

- 如果你只先判断“为什么 Prompt 必须先证明同一世界”
  - 从 [84-世界如何合法进入模型：request assembly 与 six-stage assembly chain](<84-世界如何合法进入模型：request assembly 与 six-stage assembly chain.md>) 进入；若争的是 witness、继承是否合法或 continue qualification，继续留在 `84` 的 owner next-hop，必要时再到 [81-请求编译链：可缓存、可转写、可继续](<81-请求编译链：可缓存、可转写、可继续.md>)
- 如果你只先判断“为什么安全与省 token 是同一条治理定价链”
  - 先用 `10` 固定 canonical chain 与弱读回面，再从 [85-真正成熟的治理，不是更会拦截，而是更会为扩张定价.md](85-%E7%9C%9F%E6%AD%A3%E6%88%90%E7%86%9F%E7%9A%84%E6%B2%BB%E7%90%86%EF%BC%8C%E4%B8%8D%E6%98%AF%E6%9B%B4%E4%BC%9A%E6%8B%A6%E6%88%AA%EF%BC%8C%E8%80%8C%E6%98%AF%E6%9B%B4%E4%BC%9A%E4%B8%BA%E6%89%A9%E5%BC%A0%E5%AE%9A%E4%BB%B7.md) 进入；若还在把治理误读成统一预算器、mode、usage 或弹窗投影，再到 `61`
- 如果你只先判断“为什么源码质量首先服务当前真相保护”
  - 先回 [102-如何给公开镜像做源码质量证据分级：public artifact ceiling、contract、registry、current-truth surface、consumer subset、hotspot kernel 与 mirror gap discipline.md](../guides/102-%E5%A6%82%E4%BD%95%E7%BB%99%E5%85%AC%E5%BC%80%E9%95%9C%E5%83%8F%E5%81%9A%E6%BA%90%E7%A0%81%E8%B4%A8%E9%87%8F%E8%AF%81%E6%8D%AE%E5%88%86%E7%BA%A7%EF%BC%9Acontract%E3%80%81registry%E3%80%81authoritative%20surface%E3%80%81adapter%20subset%E4%B8%8Ehotspot%20gap%20discipline.md)，再回 [87-真正成熟的源码质量判断，不是文件更小，而是复杂度中心合法、边界可证、下一次重构仍有路.md](87-%E7%9C%9F%E6%AD%A3%E6%88%90%E7%86%9F%E7%9A%84%E6%BA%90%E7%A0%81%E8%B4%A8%E9%87%8F%E5%88%A4%E6%96%AD%EF%BC%8C%E4%B8%8D%E6%98%AF%E6%96%87%E4%BB%B6%E6%9B%B4%E5%B0%8F%EF%BC%8C%E8%80%8C%E6%98%AF%E5%A4%8D%E6%9D%82%E5%BA%A6%E4%B8%AD%E5%BF%83%E5%90%88%E6%B3%95%E3%80%81%E8%BE%B9%E7%95%8C%E5%8F%AF%E8%AF%81%E3%80%81%E4%B8%8B%E4%B8%80%E6%AC%A1%E9%87%8D%E6%9E%84%E4%BB%8D%E6%9C%89%E8%B7%AF.md)；对象与 writeback seam 继续回 `architecture/README`
- 如果你只先判断“为什么 continuity 不是第四条并列母线”
  - 先回 `84` 确认 Prompt owner 与时间轴归属；若只是苏格拉底式时间轴自校，再下游回 `06`；一旦主语重新落回治理或源码质量，仍按原 owner route 回 `10 / guides/102`，必要时再看 `81 -> 85 -> 80`

## 这里不回答什么

- 不负责展开完整跨目录执行链。
- 不负责提供宿主接入、修复、值班与长期验证手册。
- 不负责替 `architecture/` 解释对象、替 `api/` 签 host-facing truth，或替 `playbooks/` 发现场 verdict。

## 维护约定

- `philosophy/` 只保留 why frontdoor，不重新库存长链 route。
- README 只暴露三条判断主语、最短 first-hop 与可复用的 why 句。
- 需要对象、retreat layer 与 seam，转 `architecture/README`；需要苏格拉底式自校，回 `06 / 15 / 41`；需要跨目录执行链，回 [../navigation/README.md](../navigation/README.md)。
