# 安全工程结论上限速查表：evidence、claim ceiling、claim owner与forbidden stronger claim

## 1. 这一页服务于什么

这一页服务于 [119-安全工程结论签字权：为什么不同源码触点只能签不同强度的结论，而不能把README、check、bundle与smoke混成同一种“已验证”](../119-%E5%AE%89%E5%85%A8%E5%B7%A5%E7%A8%8B%E7%BB%93%E8%AE%BA%E7%AD%BE%E5%AD%97%E6%9D%83%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E4%B8%8D%E5%90%8C%E6%BA%90%E7%A0%81%E8%A7%A6%E7%82%B9%E5%8F%AA%E8%83%BD%E7%AD%BE%E4%B8%8D%E5%90%8C%E5%BC%BA%E5%BA%A6%E7%9A%84%E7%BB%93%E8%AE%BA%EF%BC%8C%E8%80%8C%E4%B8%8D%E8%83%BD%E6%8A%8AREADME%E3%80%81check%E3%80%81bundle%E4%B8%8Esmoke%E6%B7%B7%E6%88%90%E5%90%8C%E4%B8%80%E7%A7%8D%E2%80%9C%E5%B7%B2%E9%AA%8C%E8%AF%81%E2%80%9D.md)。

如果 `119` 的长文解释的是：

`为什么不同源码证据各自都有严格的结论上限，`

那么这一页只做一件事：

`把主要 evidence source 的 claim ceiling、claim owner 与 forbidden stronger claim 压成一张矩阵。`

## 2. 结论上限矩阵

| evidence | claim ceiling | claim owner | forbidden stronger claim | 关键证据 |
| --- | --- | --- | --- | --- |
| `README` 边界说明 | 当前对象不完整、缺失模块不可由公开 artifact 恢复 | Reality Gate | “可恢复完整产品”“当前构建等价官方上游” | `README.md:72-74,190-193` |
| `package.json` scripts | 正式承认的工程入口只有 `prepare-src/build/check/start` | Admission Gate | “verify/test/CI 已制度化” | `package.json:7-11` |
| `prepare-src.mjs` | 已完成语境正规化，允许进入当前 best-effort 流程 | Normalization Gate | “官方语义已复原”“Bun 语义已完整复制” | `prepare-src.mjs:3-9,79-115` |
| `check + tsconfig` | 当前静态配置下可通过检查，且边界有限 | Static Gate | “运行时正确”“tests 已被静态系统守护” | `tsconfig.json:8-9,16-18,28-35`; `package.json:10` |
| `build.mjs` | best-effort artifact 存在，且构建变换已与研究源隔离 | Isolation Gate / Bundle Gate | “官方等价构建已成功” | `build.mjs:52-170`; `QUICKSTART.md:58-66` |
| `start` / `dist --version` | 最小启动证据成立 | Smoke Gate | “功能正确”“安全正确”“行为与官方一致” | `package.json:11`; `QUICKSTART.md:43-45` |
| `.github/tests` 缺失检查 | 当前仓内无正式验证与自动化宿主 | Verification Gap Gate | “这里其实已经有验证闭环，只是没写出来” | 本地检查：`.github dirs: 0`; `test/spec files: 0` |

## 3. 最短判断公式

判断一句话是否过度声明时，先问四句：

1. 这句话的直接证据是什么
2. 这份证据的 claim ceiling 是什么
3. 当前表述是否超过了这个 ceiling
4. 若要说得更强，还缺哪一份联立证据

## 4. 最常见的七类 overclaim

| overclaim | 实际越权点 |
| --- | --- |
| README -> 产品能力声明 | 边界说明越权成能力结论 |
| scripts -> 制度闭环 | 正式入口越权成验证制度 |
| prepare -> 语义复原 | 语境归一化越权成官方等价 |
| check -> 行为正确 | 静态通过越权成运行时正确 |
| build -> 官方重建成功 | best-effort artifact 越权成 full rebuild |
| smoke -> 安全正确 | 最小启动越权成功能/安全验证 |
| 缺口检查被忽略 | 未证事实被静默抹去 |

## 5. 一条硬结论

对这份研究版源码来说，  
最重要的研究纪律不是：

`多找几份证据，`

而是：

`先守住每一份证据的结论上限。`

