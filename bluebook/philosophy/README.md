# 哲学专题

`philosophy/` 只回答三件事：世界如何合法进入模型，扩张如何先被定价，过去如何不得越权写回现在。
如果你还没先经过 `09 / 05 / 15 / 41` 这组高阶前门，通常先补它们；但如果你只在追 Prompt 线 canonical source，可以直接进入 `84`，不必先在别页重复找 Prompt 前门。

如果把 `philosophy/` 前门再压成最短公式，只剩三条：

1. Prompt 线
   - 只认 `same-world compiler`；Prompt 线先到 `84`，需要 how 再到 `51`
2. 治理线
   - `governance key -> externalized truth chain -> typed ask -> decision window -> continuation pricing -> durable-transient cleanup`
   - why 统一回 `85`；`Narrow / Later / Outside` 只是用户侧助记，不是第二套治理故事
3. 源码质量线
   - 这里只回答“为什么源码质量首先服务 current-truth protection”；证据上限与 canonical ladder 先回 `guides/102`，why 再回 `86 / 87`，对象与 writeback seam 再回 `architecture/README`

需要对象、retreat layer 与 seam 的展开，转到 `architecture/README`；需要苏格拉底式自校，再回 `06 / 15 / 41`。

如果只先记 Prompt 前门的一句话，也只记这句：

- Prompt 前门不先比较措辞，而先问 same-world compiler 是否仍单源成立；Prompt 线先到 `84`，需要 how 再到 `51`。

如果只先记治理前门的一句话，也只记这句：

- 治理不是更会拦截，而是先由 governance key 外化当前真相，再给动作、可见性、上下文与 continuation 的一切扩张定价；安全、省 Token 与恢复都只是这条收费链的外观。

这里还要再多记一句：

- `governance key` 不只是第一环，而是后续收费权的主权对象；若这层退回 settings merge 或 mode 切换，后面的 `typed ask / decision window / continuation pricing / cleanup` 就只剩事后补救。

Prompt 线分流只保留一句：

- 先到 `84`；需要 how 再到 `51`。

治理线分流也只保留一句：

- 先到 `85`；需要机制拆解再看 `64 / 82 / 83 / 100`。

治理线的 first reject signal 与弱读回面总则统一回 `10 / 85`；本 README 不再另列治理 reject trio。

## 什么时候进来

- 当你已经知道功能和机制存在，但还没回答“为什么必须这样设计”。
- 当你想把世界如何合法进入模型、统一定价治理、当前真相保护，从做法解释压回不可约判断。
- 当你需要区分什么是实现、什么是约束、什么是迁移到别的 runtime 后仍成立的原则。
- 当你已经完成“模仿对象校正”和“失稳前追问”，准备把它们继续压成第一性原理。

## 如果你只先判断一件事

- 如果你只先判断“为什么 Prompt 必须先证明同一世界”，从 [84-世界如何合法进入模型：request assembly 与 six-stage assembly chain](<84-世界如何合法进入模型：request assembly 与 six-stage assembly chain.md>) 进入。
  - 缺 `first-reject path` 回 `84`；缺 witness / continue qualification 回 `51`。
- 如果你只先判断“为什么安全与省 token 是同一条治理定价链”，从 [85-真正成熟的治理，不是更会拦截，而是更会为扩张定价.md](85-%E7%9C%9F%E6%AD%A3%E6%88%90%E7%86%9F%E7%9A%84%E6%B2%BB%E7%90%86%EF%BC%8C%E4%B8%8D%E6%98%AF%E6%9B%B4%E4%BC%9A%E6%8B%A6%E6%88%AA%EF%BC%8C%E8%80%8C%E6%98%AF%E6%9B%B4%E4%BC%9A%E4%B8%BA%E6%89%A9%E5%BC%A0%E5%AE%9A%E4%BB%B7.md) 进入。
  - 失败信号：还在把治理理解成权限门数、模式面板、token 百分比，或把 `Context Usage` 继续读成成本面板；还没把 `governance key -> externalized truth chain -> typed ask -> decision window -> continuation pricing -> durable-transient cleanup` 写成正式判断。
- 如果你只先判断“为什么源码质量首先服务当前真相保护”，先回 [102-如何给公开镜像做源码质量证据分级：public artifact ceiling、contract、registry、current-truth surface、consumer subset、hotspot kernel 与 mirror gap discipline.md](../guides/102-%E5%A6%82%E4%BD%95%E7%BB%99%E5%85%AC%E5%BC%80%E9%95%9C%E5%83%8F%E5%81%9A%E6%BA%90%E7%A0%81%E8%B4%A8%E9%87%8F%E8%AF%81%E6%8D%AE%E5%88%86%E7%BA%A7%EF%BC%9Acontract%E3%80%81registry%E3%80%81authoritative%20surface%E3%80%81adapter%20subset%E4%B8%8Ehotspot%20gap%20discipline.md)，再回 [86-真正先进的内核，不是更会分层，而是更会阻止过去写坏现在.md](86-%E7%9C%9F%E6%AD%A3%E5%85%88%E8%BF%9B%E7%9A%84%E5%86%85%E6%A0%B8%EF%BC%8C%E4%B8%8D%E6%98%AF%E6%9B%B4%E4%BC%9A%E5%88%86%E5%B1%82%EF%BC%8C%E8%80%8C%E6%98%AF%E6%9B%B4%E4%BC%9A%E9%98%BB%E6%AD%A2%E8%BF%87%E5%8E%BB%E5%86%99%E5%9D%8F%E7%8E%B0%E5%9C%A8.md) 与 [87-真正成熟的源码质量判断，不是文件更小，而是复杂度中心合法、边界可证、下一次重构仍有路.md](87-%E7%9C%9F%E6%AD%A3%E6%88%90%E7%86%9F%E7%9A%84%E6%BA%90%E7%A0%81%E8%B4%A8%E9%87%8F%E5%88%A4%E6%96%AD%EF%BC%8C%E4%B8%8D%E6%98%AF%E6%96%87%E4%BB%B6%E6%9B%B4%E5%B0%8F%EF%BC%8C%E8%80%8C%E6%98%AF%E5%A4%8D%E6%9D%82%E5%BA%A6%E4%B8%AD%E5%BF%83%E5%90%88%E6%B3%95%E3%80%81%E8%BE%B9%E7%95%8C%E5%8F%AF%E8%AF%81%E3%80%81%E4%B8%8B%E4%B8%80%E6%AC%A1%E9%87%8D%E6%9E%84%E4%BB%8D%E6%9C%89%E8%B7%AF.md)。
  - 失败信号：还在用目录观感、文件大小和热点体感代替证据顺序；对象与 writeback seam 继续回 `architecture/README`。
  - `future maintainer` 是这条源码质量线的高阶门槛，不另立并行前门；继续统一回 `87` 与 `architecture/README`。
- 如果你只先判断“为什么 continuity system 不是命令集合，而是三条母线在时间维度的交汇”，先回 `06` 做时间轴仲裁，再走 [81-请求编译链：可缓存、可转写、可继续](<81-请求编译链：可缓存、可转写、可继续.md>) -> [85-真正成熟的治理，不是更会拦截，而是更会为扩张定价.md](<85-真正成熟的治理，不是更会拦截，而是更会为扩张定价.md>) -> [80-真正先进的源码，会先替未来维护者保留反对当前实现的能力.md](<80-真正先进的源码，会先替未来维护者保留反对当前实现的能力.md>)。
  - 失败信号：还在把 continuity 理解成 `/compact / /resume / /memory` 的按钮并排，而不是 `Continuation / continuation pricing / anti-zombie` 的共同制度面。
- 如果你只先判断“三条母线的哲学收束是不是已经成立”，以 [../09-三张控制面总图：世界进入模型、扩张定价与防过去写坏现在.md](../09-%E4%B8%89%E5%BC%A0%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%80%BB%E5%9B%BE%EF%BC%9A%E4%B8%96%E7%95%8C%E8%BF%9B%E5%85%A5%E6%A8%A1%E5%9E%8B%E3%80%81%E6%89%A9%E5%BC%A0%E5%AE%9A%E4%BB%B7%E4%B8%8E%E9%98%B2%E8%BF%87%E5%8E%BB%E5%86%99%E5%9D%8F%E7%8E%B0%E5%9C%A8.md) 为宪法页，再用 `84-87` 校正三条母线。

## 这里不回答什么

- 本目录不负责展开完整跨目录执行链。
- 本目录不负责提供宿主接入、修复、值班与长期验证手册。
- 本目录也不负责失败样本与反例库；这些统一回 `navigation/README.md` 分流。
- 如果你还在问“现在到底该模仿什么”或“第一条反证信号是什么”，先回 `../navigation/05` 与 `../navigation/15`。

## 维护约定

- `philosophy/` 负责解释“为什么”，不替代 `architecture/` 的机制拆解和 `api/` 的协议定义。
- README 只保留判断式入口，不再展开长链路由。
- README 应优先暴露三条判断主语、最短 first-hop route 与 later maintainer 可直接复用的 why 句，不重新退回对象库存页。
- README 只负责三条母线的最短前门；苏格拉底审读与机制哲学展开分别回 `15 / 41`，第一性原理总收束回 `06`。
- 需要跨目录执行链时，回到 [../navigation/README.md](../navigation/README.md)。
