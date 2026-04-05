# 安全载体家族宪法与制度理由分层速查表：artifact family、primary risk object、reader scope、recovery duty、host visibility与rationale drift

## 1. 这一页服务于什么

这一页服务于 [159-安全载体家族宪法与制度理由分层：为什么artifact-family cleanup constitution signer不能越级冒充artifact-family cleanup rationale signer](../159-安全载体家族宪法与制度理由分层：为什么artifact-family%20cleanup%20constitution%20signer不能越级冒充artifact-family%20cleanup%20rationale%20signer.md)。

如果 `159` 的长文解释的是：

`为什么不同 artifact family 不只活在不同 cleanup constitution 里，而且背后还有不同制度理由，甚至会出现 rationale drift，`

那么这一页只做一件事：

`把每个 family 的 primary risk object、reader scope、recovery duty、host visibility 与当前可见的 rationale drift 压成一张矩阵。`

## 2. 载体家族宪法与制度理由分层矩阵

| artifact family | primary risk object | reader scope | recovery duty | host visibility | current rationale cue | rationale drift check | 关键证据 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| task outputs | live process clobber / path reachability / symlink write risk | current session; same-project temp readers may exist | low, mainly in-flight output reachability | low to medium | explicit non-clobber comment pushes family to session temp constitution | low visible drift | `diskOutput.ts:14-18,33-55`; `filesystem.ts:1688-1700` |
| scratchpad | current-session private working notes | current session only for read/write | low, tied to active session cognition | low | owner-only dir + current-session path guard | low visible drift | `filesystem.ts:381-423,1499-1506,1645-1652,1676-1684` |
| tool-results | persisted large-output inspection after execution | session bucket under project tree; readable as persisted internal artifact | medium, supports post-hoc inspection | medium | project/session bucket + mtime sweep | medium: isolation rationale weaker than task outputs | `toolResultStorage.ts:94-118`; `cleanup.ts:196-250` |
| transcripts / casts | continuity, replay, debug trace, retrospective audit | project-root session transcript readers | high, tied to session continuity | high | top-level project transcript placement + project sweep | medium: cleanup path still not visibly consult live-session ledger | `sessionStorage.ts:198-215`; `cleanup.ts:181-195` |
| plans | active planning artifact plus user-facing plan retention | current session plan file is explicitly readable; storage may be home-root or project-root | high for resume / planning continuity | high | default home-root plan store + session-specific plan read + resume recovery | high: `plansDirectory` may move storage, but cleanup still hardcodes `~/.claude/plans` | `plans.ts:79-110,164-233`; `filesystem.ts:245-254,1645-1652`; `cleanup.ts:300-303`; `settings/types.ts:824-830` |
| file-history backups | restore user files after edits / resume safety net | mostly internal restore path, not project-facing narrative artifact | high, directly coupled to undo/restore | medium | home-root per-session backup dir | low to medium visible drift | `fileHistory.ts:951-957`; `cleanup.ts:305-347` |
| session-env dirs | replay shell/session environment captured from hooks | internal shell/session restoration path | high, needed for environment rehydration | low to medium | home-root per-session env dir + hook script loading | low to medium visible drift | `sessionEnvironment.ts:15-30,60-134`; `cleanup.ts:350-387` |

## 3. 三个最重要的判断问题

判断一句“这些 family 现在已经被同样合理地治理”有没有越级，先问三句：

1. 这个 family 的 primary risk object 到底是 live interference、inspection continuity，还是 restore / replay
2. 当前 reader scope 与 recovery duty 是否真的匹配它的 cleanup root
3. 存储路径一旦可配置或迁移，cleanup executor 是否也一起理解了新的制度理由

## 4. 最常见的五类误读

| 误读 | 实际问题 |
| --- | --- |
| “路径分开了，所以理由已经分清了” | path split != rationale clarity |
| “home-root 的都更成熟” | home-root placement != stronger philosophical justification |
| “sessionId 在路径里，所以一定是 live-session artifact” | session bucket may still serve persistence or replay |
| “可恢复就等于可长期保留” | recovery duty != unbounded retention right |
| “plans 已支持自定义目录，所以 cleanup 当然会跟着走” | configurable storage != configurable executor |

## 5. 一条硬结论

真正成熟的 cleanup rationale grammar 不是：

`different paths -> different constitutions -> done`

而是：

`different risk objects -> different reader scopes -> different recovery duties -> different cleanup laws -> explicit drift checks`

只有把最后这一步补上，  
artifact-family cleanup constitution 才不会悄悄退化成 artifact-family cleanup folklore。
