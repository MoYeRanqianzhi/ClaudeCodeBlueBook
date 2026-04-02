# 安全工程阶段门速查表：phase、entry gate、exit criteria与forbidden shortcut

## 1. 这一页服务于什么

这一页服务于 [117-安全工程阶段门与退出标准：为什么每个迁移阶段都必须有明确的entry gate、exit criteria与禁止越级推进](../117-%E5%AE%89%E5%85%A8%E5%B7%A5%E7%A8%8B%E9%98%B6%E6%AE%B5%E9%97%A8%E4%B8%8E%E9%80%80%E5%87%BA%E6%A0%87%E5%87%86%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E6%AF%8F%E4%B8%AA%E8%BF%81%E7%A7%BB%E9%98%B6%E6%AE%B5%E9%83%BD%E5%BF%85%E9%A1%BB%E6%9C%89%E6%98%8E%E7%A1%AE%E7%9A%84entry%20gate%E3%80%81exit%20criteria%E4%B8%8E%E7%A6%81%E6%AD%A2%E8%B6%8A%E7%BA%A7%E6%8E%A8%E8%BF%9B.md)。

如果 `117` 的长文解释的是：

`为什么迁移阶段若没有阶段门，就仍然只是顺序化叙事，`

那么这一页只做一件事：

`把五个 phase 的 entry gate、exit criteria 与 forbidden shortcut 压成一张矩阵。`

## 2. 安全工程阶段门矩阵

| phase | entry gate | exit criteria | forbidden shortcut | 关键证据 |
| --- | --- | --- | --- | --- |
| Phase 0 | 已承认 extracted / feature-incomplete 边界 | 仓库定位统一收敛 | 直接把仓库当完整 upstream | `README.md:5-6`; `QUICKSTART.md:3-5,60-70,89-103` |
| Phase 1 | 研究边界已锁定，高风险对象已有术语与主线位置 | protocol / ledger / dispatch / invariants / verification 链闭合 | 未定义 invariant 就先补测试或先做统一抽象 | 当前 `107-116` 章节链 |
| Phase 2 | 已定义 `prepare-src` 与验证入口关系；已承认无 `tests`/CI 宿主 | 有统一 verify 入口、测试骨架、测试配置、首批 suite | 还没单一入口就先谈 CI 或强阻断 | `package.json:7-10`; `prepare-src.mjs:79-115`; `tsconfig.json:16-18,28-35`; `.github dirs: 0`; `test/spec files: 0` |
| Phase 3 | 最小验证制度已存在，失败语义已可解释 | 局部 guard 开始共享 transition / ledger / invariant 定义 | 在 extracted repo 上一次性全局统一状态机 | `build.mjs:52-170`; 前序制度章节链 |
| Phase 4 | 本地验证稳定，责任人与 triage 语义明确 | 自动执行宿主、pre-merge contract、suite ownership 已接上 | 用研究阶段启发式直接充当长期 merge gate | `.github dirs: 0` 说明当前尚未具备该阶段前提 |

## 3. 最短判断公式

判断当前能否进入下一阶段时，先问五句：

1. 这一阶段的前置不确定性是否已经被压缩到足够低
2. 这一阶段的输出物是否足以支撑下一阶段
3. 当前最诱人的越级动作是什么
4. 这个越级动作一旦发生，会制造哪种误压缩
5. 失败时能否解释错在规则、环境、缺失源码还是研究理解

## 4. 最常见的五类阶段门失效

| 失效方式 | 会造成什么问题 |
| --- | --- |
| 没有 entry gate | 阶段准入靠感觉，容易把前置未满足当成“可以先做着看” |
| 没有 exit criteria | 阶段完成靠叙事，容易把“做了一些”误写成“已经过关” |
| 没有 forbidden shortcut | 团队总会绕过最难的前置门，直接冲向外部性更高的动作 |
| 把研究结论直接升级成自动化规则 | 用伪确定性制造组织约束 |
| 把 extracted repo 当完整 upstream | 所有后续 gate 都建立在错误对象上 |

## 5. 一条硬结论

对这份研究版源码来说，  
真正成熟的迁移方式不是：

`先把 roadmap 写漂亮，`

而是：

`给每个 phase 补上明确的准入门、退出门与禁止捷径。`

