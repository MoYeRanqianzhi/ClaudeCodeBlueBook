# 如何工程化地维持依赖图诚实性：leaf module、anti-cycle seam与single-source file

这一章回答五个问题：

1. 为什么 Claude Code 的依赖治理不是代码洁癖，而是运行时正确性工程。
2. 怎样理解 leaf module、anti-cycle seam、single-source file 与 risk-bearing naming 的分工。
3. 为什么适度不 DRY、限制导入范围、把注释写成制度记忆，反而是更成熟的工程选择。
4. 为什么 `config / deps`、`snapshot`、`single source` 这些小结构，能决定长期维护成本。
5. 怎样把“让依赖图说真话”迁移到自己的 agent runtime。

## 0. 代表性源码锚点

- `claude-code-source-code/src/utils/plugins/pluginPolicy.ts:1-20`
- `claude-code-source-code/src/query/config.ts:1-45`
- `claude-code-source-code/src/query/deps.ts:1-40`
- `claude-code-source-code/src/utils/queryContext.ts:1-87`
- `claude-code-source-code/src/types/permissions.ts:1-63`
- `claude-code-source-code/src/utils/configConstants.ts:1-18`
- `claude-code-source-code/src/utils/plugins/pluginDirectories.ts:1-79`
- `claude-code-source-code/src/state/teammateViewHelpers.ts:1-24`
- `claude-code-source-code/src/constants/systemPromptSections.ts:27-38`
- `claude-code-source-code/src/utils/fingerprint.ts:40-63`

这些锚点共同说明：

- Claude Code 愿意接受少量内联、窄 seam、极薄单文件与风险命名，只为让依赖图、单一真相和未来维护边界保持诚实。

## 1. 先说结论

更成熟的模块化，不是：

- 抽象得越统一越好

而是：

1. 高扇入共享规则必须足够薄，最好是 dependency-free 或 near-leaf。
2. 无法消失的脏边要关进 anti-cycle seam，并明确谁能导入。
3. 高风险真相要压成 single-source file，而不是散落在多个 helper 里。
4. 风险要在命名和注释阶段就被看见，而不是靠口头记忆补救。
5. 允许少量重复，只要它换来依赖图诚实与未来接手成本下降。

从第一性原理看，Claude Code 在优化的不是“行数更少”，而是：

- 未来改动不会偷偷新增一条看不见的重依赖边

## 2. 第一步：把高扇入共享规则压成 leaf module，而不是胖公共层

`pluginPolicy.ts` 的注释非常直接：

- 只依赖 settings，避免把整个 plugin 子系统拖成环

而它又承担：

- policy blocking 的 single source of truth

这说明真正成熟的共享面不该是“功能很多的公共工具箱”，而应该是：

- 越多人依赖，越薄、越硬、越单一

`configConstants.ts` 也一样，它直接写：

- 不要往文件里加 imports，必须保持 dependency-free

这类文件的价值不是抽几个常量，而是给全仓提供一块：

- 高扇入但低风险的稳定地基

实践上：

1. 高扇入共享规则优先做成 leaf module。
2. leaf module 不要顺手长业务逻辑。
3. 共享真相的价值不在“抽出来了”，而在“抽出来后仍然不会反咬模块图”。

## 3. 第二步：承认有些脏边不会消失，把它们关进 anti-cycle seam

`queryContext.ts` 不是 dependency-free 文件。

它反而明确写出：

1. 自己为什么必须单独存在；
2. 为什么这些 imports 放到别处会造成 cycle；
3. 为什么只有 entrypoint-layer 文件能导入它。

这代表的是另一种成熟：

- 不假装所有脏边都能消失，而是把它们关进受控 seam

`teammateViewHelpers.ts` 则更激进：

1. 为了避免 cycle，把 `PANEL_GRACE_MS` 直接内联；
2. 为了切断 runtime edge，宁可手写 type guard，也不去 import 更“优雅”的 helper。

这看起来不够 DRY，但它更忠于系统级目标：

- 不为局部复用，付出全局依赖图失真的代价

## 4. 第三步：把 single-source file 当成维护协议，而不是 DRY 口号

`pluginDirectories.ts` 明写自己是 plugins directory path 的 single source of truth。

`types/permissions.ts` 也不是简单“把类型放一处”，而是明确为了：

- break import cycles

这说明 Claude Code 所谓的 single source，不是在追求抽象形式感，而是在防三件事：

1. 多处各写一版“差不多”的规则；
2. 类型层和实现层互相咬合；
3. 下游消费者从不同入口读到不同真相。

实践上：

1. 高风险路径规则、模式枚举、协议定义要有唯一入口。
2. 入口之外可以有投影，但不要有第二套判断。
3. single-source file 首先服务的是维护协议，其次才是复用美感。

## 5. 第四步：用 `config / deps` seam 让变化面显形

`query/config.ts` 把 immutable values snapshotted once at query entry 独立出来。

`query/deps.ts` 则把 I/O dependencies 单独抽成很窄的 `QueryDeps`。

这两步的价值不只是“代码好测试”，更重要的是：

- 未来维护者能一眼看出哪些是纯数据，哪些是副作用入口

这就是依赖图诚实性的另一层含义：

- 不只要让 import 图诚实，也要让变化图和副作用图诚实

实践上：

1. 会在一个 query 生命周期内保持不变的，优先收进 config。
2. 会与外界交互的副作用面，优先收进 deps。
3. seam 不必一步到位，但必须让未来抽离方向是可见的。

## 6. 第五步：让风险在命名与注释阶段就暴露出来

`DANGEROUS_uncachedSystemPromptSection(...)` 不是情绪化命名，而是在提前暴露：

- 这段改动会改变 cache 行为

`fingerprint.ts` 也直接写：

- 这个算法不要随便改，除非与外部 API 协调

这类命名与注释的共同作用是：

- 把 blast radius 编译进代码表面

这样维护者第一次读到这里时，不需要靠团队口头传承去猜：

1. 这里在保护什么真相；
2. 改动需要和谁协调；
3. 这是普通 helper，还是高风险 contract seam。

从第一性原理看，这不是“可读性修辞”，而是：

- 防误改的控制面

## 7. 第六步：把“让依赖图说真话”迁移到自己的 runtime

如果你要迁移 Claude Code 的方法，最值得复制的是这套工程纪律：

1. 高扇入共享规则做成 leaf module。
2. 消不掉的脏边放进 anti-cycle seam，并在文件头写清导入边界。
3. 高风险模式、路径和协议做成 single-source file。
4. 对爆炸半径大的边界，用风险命名和制度注释提前示警。
5. 接受少量 purposeful duplication，只要它换来图结构诚实。
6. 用 `config / deps / snapshot` 把未来重构 seam 提前长出来。

真正强的地方不是“今天目录看起来更漂亮”，而是：

- 明天新人接手时，不需要先把整仓 import 图重新脑补一遍

## 8. 苏格拉底式检查清单

在你准备继续抽 helper、合并模块或做“统一入口”前，先问自己：

1. 这次抽象是在减少认知债，还是在偷偷拉深依赖图。
2. 这个共享规则能不能做成更薄的 leaf module。
3. 这个脏边该不该被隔离成只允许少数入口导入的 seam。
4. 这里值不值得接受一点不 DRY，换取 runtime edge 不闭环。
5. 这个真相是不是已经需要 single source、风险命名或制度注释。
6. 未来维护者第一次读到这里，能不能直接看见哪里不能乱改。

如果这些问题答不清，抽象越漂亮，系统往往越容易在后续演化里撒谎。

## 9. 一句话总结

Claude Code 的依赖治理值得学的，不是“拆得多细”，而是用 leaf module、anti-cycle seam、single-source file、风险命名和制度注释，让依赖图、变化面与未来维护边界一起说真话。
