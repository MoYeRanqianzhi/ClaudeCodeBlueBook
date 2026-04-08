# 哲学专题

`philosophy/` 只回答三件事：世界如何合法进入模型，扩张为什么必须先被定价，过去为什么不得越权写回现在。这里不预排 first-hop，只保留 why 判据；若你缺的是证据 ceiling、对象摘要或执行 next hop，回对应 owner README，不在这里补 route。

## 三条 Why 判据

- Prompt 线
  - 如果 `verify / delegate / resume / handoff` 后仍要重答世界定义、边界或继续资格，Prompt why 就还没成立
  - 缺 Prompt why 时看 `84`；若已进入 continuation object 与 witness 细化，再看 `81`
- 治理线
  - 如果解释答不出为什么 `unpaid expansion` 不能免费续租，治理 why 就还没成立
  - 缺治理 why 时看 `85`；若 earliest `unpaid expansion` 还没定位，先回 `10`
- 源码质量线
  - 如果解释答不出为什么 current truth 不能让过去或投影代签，源码质量 why 就还没成立
  - 缺源码质量 why 时看 `87`；缺证据 ceiling 时回 `guides/102`；缺对象摘要与 writeback seam 时回 `architecture/README`

## 什么时候进来

- 当你已经知道功能或机制存在，但还没回答“为什么必须这样设计”。
- 当你要把 Prompt 效力、治理成熟度或源码先进性，从结果词压回不可约判断。
- 当你需要区分什么是 why、什么是 object、什么是 verdict，而不想在 route 页里反复兜圈。

## 按缺口进来

- 缺 Prompt why：
  - 看 [84-世界如何合法进入模型：request assembly 与 six-stage assembly chain](<84-世界如何合法进入模型：request assembly 与 six-stage assembly chain.md>)；若已进入 continuation object 与 witness 细化，再看 [81-请求编译链：可缓存、可转写、可继续](<81-请求编译链：可缓存、可转写、可继续.md>)
- 缺治理 why：
  - 看 [85-真正成熟的治理，不是更会拦截，而是更会为扩张定价.md](85-%E7%9C%9F%E6%AD%A3%E6%88%90%E7%86%9F%E7%9A%84%E6%B2%BB%E7%90%86%EF%BC%8C%E4%B8%8D%E6%98%AF%E6%9B%B4%E4%BC%9A%E6%8B%A6%E6%88%AA%EF%BC%8C%E8%80%8C%E6%98%AF%E6%9B%B4%E4%BC%9A%E4%B8%BA%E6%89%A9%E5%BC%A0%E5%AE%9A%E4%BB%B7.md>)；若 first answer 还没定位 earliest `unpaid expansion`，先回 `10`
- 缺源码质量 why：
  - 看 [87-真正成熟的源码质量判断，不是文件更小，而是复杂度中心合法、边界可证、下一次重构仍有路.md](87-%E7%9C%9F%E6%AD%A3%E6%88%90%E7%86%9F%E7%9A%84%E6%BA%90%E7%A0%81%E8%B4%A8%E9%87%8F%E5%88%A4%E6%96%AD%EF%BC%8C%E4%B8%8D%E6%98%AF%E6%96%87%E4%BB%B6%E6%9B%B4%E5%B0%8F%EF%BC%8C%E8%80%8C%E6%98%AF%E5%A4%8D%E6%9D%82%E5%BA%A6%E4%B8%AD%E5%BF%83%E5%90%88%E6%B3%95%E3%80%81%E8%BE%B9%E7%95%8C%E5%8F%AF%E8%AF%81%E3%80%81%E4%B8%8B%E4%B8%80%E6%AC%A1%E9%87%8D%E6%9E%84%E4%BB%8D%E6%9C%89%E8%B7%AF.md>)；若证据 ceiling 或对象摘要缺席，再回 `guides/102` 与 `architecture/README`
- `continuity` 时间轴自校：
  - 看 `06`；一旦主语重新落回 Prompt / 治理 / 源码质量，仍回各自 owner 页

## 这里不回答什么

- 不负责展开完整跨目录执行链。
- 不负责提供宿主接入、修复、值班与长期验证手册。
- 不负责替 `architecture/` 解释对象、替 `api/` 签 host-facing truth，或替 `playbooks/` 发现场 verdict。

## 维护约定

- `philosophy/` 只保留 why 判据，不重新库存 first-hop 或长链 route。
- README 只暴露三条 why failure test 与最少量 owner 引用。
- 需要对象、retreat layer 与 seam，转 `architecture/README`；需要苏格拉底式自校，回 `06 / 15 / 41`；需要跨目录执行链，回 [../navigation/README.md](../navigation/README.md)。
