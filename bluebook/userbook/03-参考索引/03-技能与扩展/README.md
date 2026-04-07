# 技能与扩展

这一层回答的不是“Claude Code 自己能做什么”，而是“它怎样把外部能力和可复用工作流接进正式运行时”。

如果把这一层压成最短前门，也只剩两条：

1. 先认 `source signer -> projection consumer -> runtime gate -> activation witness`
   - 技能和扩展先从哪条来源链进入，再按谁来看、谁来调、何时激活被投影出来。
2. 先认 `workspace trust -> source trust -> surface lock -> runtime gate`
   - 扩展面不是“有或没有”，而是不同来源和 surface 在不同层级被治理。

所以这里不是技能库存目录，而是“能力怎样进入世界、怎样被看见、怎样被拦住”的索引层。

这里也要先压住一个常见误读：skills / MCP / plugins / hooks 在索引层不是第四条工作主线；它们只是同一工作对象在 source、projection 与 runtime gate 上的扩张路径。

更硬一点说，这一层真正先问的也不是“哪张表更全”，而是：

1. 谁在签 source truth。
2. 谁只是在消费这条 truth 的投影。
3. 谁只拥有 gate / activation witness，而不拥有 signer 权。

这一层最该先拒收的误读也只有三种：

1. 把库存当 activation
   - 菜单里有，不等于当前会话真能调。
2. 把 projection 当 signer
   - `/skills`、skill reminder、SkillTool、remote skills 看到的不是同一层。
3. 把 source trust 当 runtime gate
   - 来源可信，不等于当前 surface 已被放行。

如果你把 relevant skills、静态 listing 或提醒面当成技能全集，也先按“库存化误读”退回本页，不要直接跳索引子页。

更稳一点说，这一层也必须继承 `问题分型 -> 工作对象 -> 控制面 -> 入口` 的 first-answer order；若对象和控制面还没判清，就不该先用扩展库存决定路径。

当前这一层先从技能索引切入：

- [01-内置技能索引.md](./01-%E5%86%85%E7%BD%AE%E6%8A%80%E8%83%BD%E7%B4%A2%E5%BC%95.md)
  这一页只做库存，不承担前门判断。
- [02-技能来源、可见性与触发索引.md](./02-%E6%8A%80%E8%83%BD%E6%9D%A5%E6%BA%90%E3%80%81%E5%8F%AF%E8%A7%81%E6%80%A7%E4%B8%8E%E8%A7%A6%E5%8F%91%E7%B4%A2%E5%BC%95.md)
  这一页专管“source signer 在哪、何时激活、为什么没进这张表”。
- [03-能力曝光、技能提醒与发现机制索引.md](./03-%E8%83%BD%E5%8A%9B%E6%9B%9D%E5%85%89%E3%80%81%E6%8A%80%E8%83%BD%E6%8F%90%E9%86%92%E4%B8%8E%E5%8F%91%E7%8E%B0%E6%9C%BA%E5%88%B6%E7%B4%A2%E5%BC%95.md)
  这一页是主判断前门，优先回答“给谁看哪层、谁最后拍板、谁只是在消费投影”。
- [04-技能发现、静态 listing 与 remote skills 索引.md](./04-%E6%8A%80%E8%83%BD%E5%8F%91%E7%8E%B0%E3%80%81%E9%9D%99%E6%80%81%20listing%20%E4%B8%8E%20remote%20skills%20%E7%B4%A2%E5%BC%95.md)
  这一页只保留线程、回合路径、remote skills 与反馈面这类附加判断，不再承担第二前门。

如果继续把这一层压成最小 appeal chain，也只该剩三句：

1. 争议是“没加载，还是加载了但不在这张表”，先看 `02`。
2. 争议是“谁最后拍板、谁只是在投影”，先看 `03`。
3. 争议是“static listing / remote skills / relevant skills 为什么不一致”，先看 `04`。

和它相邻、但属于控制面长文的页面在：

- [MCP、插件、技能与 Hooks：如何选择正确扩展层.md](../../05-%E6%8E%A7%E5%88%B6%E9%9D%A2%E6%B7%B1%E6%8C%96/02-MCP%E3%80%81%E6%8F%92%E4%BB%B6%E3%80%81%E6%8A%80%E8%83%BD%E4%B8%8E%20Hooks%EF%BC%9A%E5%A6%82%E4%BD%95%E9%80%89%E6%8B%A9%E6%AD%A3%E7%A1%AE%E6%89%A9%E5%B1%95%E5%B1%82.md)

如果你只看一页，先看 `03`；如果你想看库存，再看 `01`；如果你想追“为什么没出现 / 为什么中途才出现”，再看 `02`；如果你要追线程、回合与 remote 附加边界，再看 `04`。
