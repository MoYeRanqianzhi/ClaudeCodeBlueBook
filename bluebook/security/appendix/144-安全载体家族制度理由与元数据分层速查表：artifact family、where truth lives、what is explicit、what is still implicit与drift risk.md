# 安全载体家族制度理由与元数据分层速查表：artifact family、where truth lives、what is explicit、what is still implicit与drift risk

## 1. 这一页服务于什么

这一页服务于 [160-安全载体家族制度理由与元数据分层：为什么artifact-family cleanup rationale signer不能越级冒充artifact-family cleanup metadata signer](../160-%E5%AE%89%E5%85%A8%E8%BD%BD%E4%BD%93%E5%AE%B6%E6%97%8F%E5%88%B6%E5%BA%A6%E7%90%86%E7%94%B1%E4%B8%8E%E5%85%83%E6%95%B0%E6%8D%AE%E5%88%86%E5%B1%82%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88artifact-family%20cleanup%20rationale%20signer%E4%B8%8D%E8%83%BD%E8%B6%8A%E7%BA%A7%E5%86%92%E5%85%85artifact-family%20cleanup%20metadata%20signer.md)。

如果 `160` 的长文解释的是：

`为什么不同 artifact family 的制度理由虽然已经存在，但还没有被系统正式升级成统一可消费的 family metadata，`

那么这一页只做一件事：

`把每个 family 的 truth 当前分散在哪些文件、哪些 truth 已显式、哪些 truth 仍隐式、以及哪里最容易继续漂移，压成一张矩阵。`

## 2. 制度理由与元数据分层矩阵

| artifact family | where truth lives now | what is explicit | what is still implicit | drift risk | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| task outputs | `diskOutput.ts` path helper + comments | session-scoped temp path, non-clobber rationale | shared descriptor consumed by permission / cleanup / recovery planes | low to medium | `task/diskOutput.ts:33-55` |
| scratchpad | `filesystem.ts` path helper + read/write allow rules | current-session path, owner-only dir, current-session read/write truth | family descriptor shared beyond permission plane | low to medium | `permissions/filesystem.ts:381-423,1488-1506,1645-1684` |
| tool-results | `toolResultStorage.ts` path helper + `filesystem.ts` read rule + `cleanup.ts` traversal | session bucket, readable internal artifact, project sweep cleanup | unified persisted-output family metadata | medium | `toolResultStorage.ts:27,94-118`; `permissions/filesystem.ts:1655-1667`; `cleanup.ts:196-250` |
| transcripts / casts | `sessionStorage.ts` path helper + `cleanup.ts` top-level project sweep | project transcript path, session continuity artifact | central transcript family descriptor that also carries cleanup / retention / live-peer truth | medium | `sessionStorage.ts:198-225`; `cleanup.ts:181-195` |
| plans | `settings/types.ts` + `plans.ts` + `filesystem.ts` + `cleanup.ts` | default home-root storage, optional project-root override, current-session read rule, resume recovery | one plan-family metadata object that drives storage + permission + recovery + cleanup together | high | `settings/types.ts:824-830`; `plans.ts:79-110,164-233`; `permissions/filesystem.ts:245-254,1645-1652`; `cleanup.ts:300-303` |
| file-history backups | `fileHistory.ts` path helper + `cleanup.ts` per-session rm | home-root per-session restore retention | shared restore-family descriptor | low to medium | `fileHistory.ts:728-741,951-957`; `cleanup.ts:305-347` |
| session-env dirs | `sessionEnvironment.ts` path helper + loader + `cleanup.ts` per-session rm | home-root per-session env replay retention | shared replay-family descriptor | low to medium | `sessionEnvironment.ts:15-30,60-134`; `cleanup.ts:350-387` |
| cleanup plane overall | `cleanup.ts` hardcoded dispatcher list | family-specific functions do exist | registry / schema that makes dispatcher data-driven | high at architecture level | `cleanup.ts:575-595` |

## 3. 三个最重要的判断问题

判断一句“这些 family 的 policy 已经被系统自己保存好了”有没有越级，先问三句：

1. 这些 family truth 是不是还能追溯到同一个显式 descriptor，而不是只能靠跨文件拼图
2. 路径、权限、恢复与 cleanup 是否真的消费同一份 truth
3. 一处策略变化后，系统能否自动暴露 drift，而不是等后来者重新读代码才发现

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “有 helper 就等于有 metadata” | helper != shared policy object |
| “settings 有一个字段，所以全链都懂它” | schema knob != propagated family truth |
| “cleanup 已经分函数，所以元数据层已存在” | split executors != registry |
| “plans 目前还能工作，所以没有 metadata gap” | runtime still working != no propagation risk |
| “研究者能解释清楚，所以系统自己也保存清楚了” | human reconstruction != machine-readable self-description |

## 5. 一条硬结论

真正成熟的 artifact-family governance grammar 不是：

`different helpers + different comments + different cleanup functions`

而是：

`family truth -> explicit metadata -> multi-plane reuse -> drift detection`

只有中间这层被补上，  
artifact-family cleanup rationale 才不会继续停留在“研究者事后重建”的半显式状态。
