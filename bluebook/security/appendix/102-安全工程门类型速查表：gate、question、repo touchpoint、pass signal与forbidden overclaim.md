# 安全工程门类型速查表：gate、question、repo touchpoint、pass signal与forbidden overclaim

## 1. 这一页服务于什么

这一页服务于 [118-安全工程门的类型学：为什么研究版源码真正的阶段门是Reality Gate、Admission Gate、Normalization Gate、Static Gate、Isolation Gate、Bundle Gate、Smoke Gate与Verification Gap Gate](../118-%E5%AE%89%E5%85%A8%E5%B7%A5%E7%A8%8B%E9%97%A8%E7%9A%84%E7%B1%BB%E5%9E%8B%E5%AD%A6.md)。

如果 `118` 的长文解释的是：

`为什么不同 gate 其实在对不同命题签字，不能互相冒充，`

那么这一页只做一件事：

`把八类 gate 的问题、仓库触点、pass signal 与 forbidden overclaim 压成一张矩阵。`

## 2. 安全工程门类型矩阵

| gate | question | repo touchpoint | pass signal | forbidden overclaim |
| --- | --- | --- | --- | --- |
| Reality Gate | 当前对象到底是什么 | `README.md`、`QUICKSTART.md` | 已承认 extracted / feature-incomplete / best-effort 边界 | 把仓库当完整 upstream |
| Admission Gate | 有没有资格进入正式工具链 | `package.json`、`QUICKSTART.md` prerequisites | Node/npm/deps/scripts 前提满足 | 把入场资格说成正确性证明 |
| Normalization Gate | 源码是否已正规化到当前语境 | `prepare-src.mjs`、`package.json:prepare-src` | `bun:bundle` / `MACRO.*` / declaration 补齐 | 把 prepare 结果说成官方语义源码 |
| Static Gate | 当前静态视角下是否通过检查 | `package.json:check`、`tsconfig.json` | `prepare-src` 后可 `tsc --noEmit` | 把静态通过说成行为正确或 upstream 等价 |
| Isolation Gate | 构建变换是否污染研究源 | `build.mjs` Phase 1-3、`QUICKSTART.md` phase table | `src -> build-src` 隔离成立 | 把中间态与研究源混写 |
| Bundle Gate | 是否产出 best-effort artifact | `build.mjs` Phase 4、`QUICKSTART.md` Known Issues | `dist/cli.js` 产出 | 把 bundle 成功说成 full-fidelity rebuild |
| Smoke Gate | artifact 是否最小启动 | `package.json:start`、`QUICKSTART.md` run step | `node dist/cli.js --version` 级别证据成立 | 把能启动说成功能/安全正确 |
| Verification Gap Gate | 到这里为止还没有被证明什么 | 无 test script、无 `tests/`、无 `.github/` | 显式承认验证缺口 | 把 build/check/smoke 冒充 verify |

## 3. 最短判断公式

判断一个结论是否越权时，先问四句：

1. 这条结论是由哪一类 gate 签字的
2. 这道 gate 本来被授权证明什么
3. 这条结论有没有越过它的签字权限
4. 当前是否还有 `Verification Gap Gate` 明确保留的未证部分

## 4. 最常见的八类 overclaim

| overclaim | 真实问题 |
| --- | --- |
| `Reality Gate` -> “完整产品语义” | 对象边界被偷换 |
| `Admission Gate` -> “仓库正确” | 入场资格冒充正确性 |
| `Normalization Gate` -> “官方源码等价” | 语境转换冒充原始语义 |
| `Static Gate` -> “行为正确” | 类型通过冒充运行时正确 |
| `Isolation Gate` -> “可长期维护” | 中间态隔离冒充制度成熟 |
| `Bundle Gate` -> “正式编译成功” | 产物存在冒充语义等价 |
| `Smoke Gate` -> “安全正确” | 最小启动冒充全链正确 |
| 忽略 `Verification Gap Gate` | 未证事实被静默抹掉 |

## 5. 一条硬结论

对这份研究版源码来说，  
最重要的工程纪律不是：

`尽快过更多门，`

而是：

`每过一道门，都只说它有资格说的话。`

