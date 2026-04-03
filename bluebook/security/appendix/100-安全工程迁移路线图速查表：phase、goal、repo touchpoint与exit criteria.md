# 安全工程迁移路线图速查表：phase、goal、repo touchpoint与exit criteria

## 1. 这一页服务于什么

这一页服务于 [116-安全工程迁移路线图：为什么这份研究版源码若要走向可持续验证系统，必须先固化边界，再分阶段迁移而不能一次性重构](../116-%E5%AE%89%E5%85%A8%E5%B7%A5%E7%A8%8B%E8%BF%81%E7%A7%BB%E8%B7%AF%E7%BA%BF%E5%9B%BE%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E8%BF%99%E4%BB%BD%E7%A0%94%E7%A9%B6%E7%89%88%E6%BA%90%E7%A0%81%E8%8B%A5%E8%A6%81%E8%B5%B0%E5%90%91%E5%8F%AF%E6%8C%81%E7%BB%AD%E9%AA%8C%E8%AF%81%E7%B3%BB%E7%BB%9F%EF%BC%8C%E5%BF%85%E9%A1%BB%E5%85%88%E5%9B%BA%E5%8C%96%E8%BE%B9%E7%95%8C%EF%BC%8C%E5%86%8D%E5%88%86%E9%98%B6%E6%AE%B5%E8%BF%81%E7%A7%BB%E8%80%8C%E4%B8%8D%E8%83%BD%E4%B8%80%E6%AC%A1%E6%80%A7%E9%87%8D%E6%9E%84.md)。

如果 `116` 的长文解释的是：

`研究版源码应如何分阶段迁移到更完整的安全工程形态，`

那么这一页只做一件事：

`把各 phase 的目标、仓库触点与退出标准压成一张迁移矩阵。`

## 2. 安全工程迁移矩阵

| phase | goal | repo touchpoint | exit criteria | 关键证据 |
| --- | --- | --- | --- | --- |
| Phase 0 | 固化研究边界与缺失前提 | `README.md`、`QUICKSTART.md` | 明确 research/extracted/incomplete 定位 | `README.md:1-6,15`; `QUICKSTART.md:3-5,60-70,102-103` |
| Phase 1 | 固化制度知识 | `bluebook/security/` 当前章节体系 | 高风险制度已 catalog 化 | 当前 100+ 安全章节链 |
| Phase 2 | 接入最小验证制度 | `package.json`、`scripts/`、`tests/`、测试配置 | 有统一测试入口 + 首批 suite 落地 | `package.json:7-11`; `scripts/`; 本地 tests 检索 `0` |
| Phase 3 | 收口统一工程接口 | transition / ledger / invariant catalog | 高风险子系统开始共享统一制度定义 | `transitionPermissionMode`、`onChangeAppState` 这类已有雏形 |
| Phase 4 | 自动执行与长期维持 | future CI host、pre-merge contract、suite ownership | 验证从可执行升级成可持续 | `.github => no` 说明当前尚未进入此阶段 |

## 3. 最短判断公式

判断仓库现在处在哪个迁移阶段时，先问五句：

1. 边界是否已经被正确定义
2. 制度知识是否已经显式 catalog 化
3. 验证入口是否已经存在
4. 高风险子系统是否已经开始共享统一接口
5. 自动执行宿主是否已经接上

## 4. 最常见的五类迁移误判

| 误判方式 | 会造成什么问题 |
| --- | --- |
| 跳过 Phase 0 直接工程化 | 研究边界与工程边界混淆 |
| 跳过 Phase 1 直接补测试 | 不知道测试到底在守什么制度 |
| 跳过 Phase 2 直接做高层抽象 | 抽象期本身缺护栏 |
| 跳过 Phase 3 直接上 CI | 自动执行的是散乱规则 |
| 假设自己已经是完整上游仓库 | 路线图一开始就失真 |

## 5. 一条硬结论

对这份研究版源码来说，  
真正合理的迁移方式不是：

`一次性全面工程化，`

而是：

`先把当前对象是什么说清，再按阶段把制度、验证、接口与自动执行逐层接上。`
