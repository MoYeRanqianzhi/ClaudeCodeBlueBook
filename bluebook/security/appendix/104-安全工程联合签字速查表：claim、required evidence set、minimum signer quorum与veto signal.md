# 安全工程联合签字速查表：claim、required evidence set、minimum signer quorum与veto signal

## 1. 这一页服务于什么

这一页服务于 [120-安全工程联合签字协议：为什么更强结论必须由多类证据联立签发，而不能靠多个弱正向信号拼凑成假闭环](../120-%E5%AE%89%E5%85%A8%E5%B7%A5%E7%A8%8B%E8%81%94%E5%90%88%E7%AD%BE%E5%AD%97%E5%8D%8F%E8%AE%AE%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E6%9B%B4%E5%BC%BA%E7%BB%93%E8%AE%BA%E5%BF%85%E9%A1%BB%E7%94%B1%E5%A4%9A%E7%B1%BB%E8%AF%81%E6%8D%AE%E8%81%94%E7%AB%8B%E7%AD%BE%E5%8F%91%EF%BC%8C%E8%80%8C%E4%B8%8D%E8%83%BD%E9%9D%A0%E5%A4%9A%E4%B8%AA%E5%BC%B1%E6%AD%A3%E5%90%91%E4%BF%A1%E5%8F%B7%E6%8B%BC%E5%87%91%E6%88%90%E5%81%87%E9%97%AD%E7%8E%AF.md)。

如果 `120` 的长文解释的是：

`为什么更强结论只有在多证据联立且无否决信号时才允许升级，`

那么这一页只做一件事：

`把主要 claim 的 required evidence set、minimum signer quorum 与 veto signal 压成一张矩阵。`

## 2. 联合签字矩阵

| claim | required evidence set | minimum signer quorum | veto signal | forbidden weak composition |
| --- | --- | --- | --- | --- |
| 当前对象是 research-extracted / feature-incomplete 研究版源码 | `README` 边界说明 + `QUICKSTART` 能力上限说明 | Reality quorum | 无需额外 veto；单项不足以完整成立 | 只看 README 或只看 smoke |
| 当前存在正式的 best-effort build/check pipeline | `package.json` scripts + `prepare-src.mjs` + `tsconfig` + `build.mjs` | Admission + Normalization + Static + Build quorum | 若缺任一正式入口或前置门，则不得升级 | 只看 `build` 成功或只看 `check` 通过 |
| 当前 artifact 已存在且可最小启动 | `build` 产物证据 + `start/smoke` 启动证据 | Bundle + Smoke quorum | 若 artifact 不存在或无法最小启动，则否决 | `README + smoke`、`check + smoke` |
| 当前正式验证闭环缺失 | `package.json` 无 verify/test + 无 `tests` + 无 `.github` | Verification-gap quorum | 任一正式验证宿主出现都需重判 | 仅凭 “没看到 tests” 就下结论 |
| 当前已经形成验证闭环 | verify script + tests corpus + automation host + 明确 contract | Full verification quorum | 现状下被 `.github dirs: 0`、`test/spec files: 0` 否决 | `build + smoke + silence` |

## 3. 最短判断公式

判断某个强结论能否成立时，先问五句：

1. 这个结论需要几类不同层级的签字人
2. 这些签字人现在是否都到场
3. 它们支持的是不是同一命题
4. 当前是否有 gap signal 在行使否决权
5. 若删掉其中任一项，这个结论是否立刻降级

## 4. 最常见的四类假闭环

| 假闭环模式 | 真正缺的是什么 |
| --- | --- |
| `README + build + smoke` | 缺验证与等价性证明 |
| `check + smoke` | 缺行为、时序与安全验证 |
| `build + silence` | 缺对 gap signal 的诚实声明 |
| 单项证据重复堆叠 | 缺跨层互补签字 |

## 5. 一条硬结论

对这份研究版源码来说，  
真正可靠的 stronger claim 从来不是：

`很多正向证据摆在一起看起来差不多，`

而是：

`required evidence set 已齐、minimum signer quorum 已满足、veto signal 当前未触发。`

