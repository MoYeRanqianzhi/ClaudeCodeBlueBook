# 安全恢复词法失效速查表：new stronger evidence、invalidated old lexicon与affected surfaces

## 1. 这一页服务于什么

这一页服务于 [63-安全恢复词法失效：为什么高风险新证据出现时，旧绿色词必须被显式invalidated，不能允许多面并存](../63-%E5%AE%89%E5%85%A8%E6%81%A2%E5%A4%8D%E8%AF%8D%E6%B3%95%E5%A4%B1%E6%95%88%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E9%AB%98%E9%A3%8E%E9%99%A9%E6%96%B0%E8%AF%81%E6%8D%AE%E5%87%BA%E7%8E%B0%E6%97%B6%EF%BC%8C%E6%97%A7%E7%BB%BF%E8%89%B2%E8%AF%8D%E5%BF%85%E9%A1%BB%E8%A2%AB%E6%98%BE%E5%BC%8Finvalidated%EF%BC%8C%E4%B8%8D%E8%83%BD%E5%85%81%E8%AE%B8%E5%A4%9A%E9%9D%A2%E5%B9%B6%E5%AD%98.md)。

如果 `63` 的长文解释的是：

`为什么更强新证据出现时旧词必须退场，`

那么这一页只做一件事：

`把 new stronger evidence、invalidated old lexicon 与 affected surfaces 压成一张失效矩阵。`

## 2. 词法失效矩阵

| new stronger evidence | invalidated old lexicon | affected surfaces | 失效动作 | 为什么必须失效 | 关键证据 |
| --- | --- | --- | --- | --- | --- |
| `invalidates` 指向的更高优先级 notification | 旧 notification wording / 旧提示 key | notification current / queue | `invalidates`、重排 queue、替换 current | 新提示已显式宣告旧提示失效，二者不应继续并存 | `notifications.tsx:88-116,176-186` |
| IDE hint 条件消失、IDE 状态不再为空、JetBrains 特例出现 | `ide-status-hint` | notification surface | `removeNotification("ide-status-hint")` | 提示前提不再成立，继续悬挂会制造伪建议 | `useIDEStatusIndicator.tsx:49-75` |
| IDE 不再 `disconnected`、install error / JetBrains 特例覆盖 disconnected | `${ideName} disconnected` | notification surface | `removeNotification("ide-status-disconnected")` | 更具体或更强的 IDE 语义已出现，旧断连词必须退场 | `useIDEStatusIndicator.tsx:78-107` |
| JetBrains 特例消失 | `IDE plugin not connected · /status for info` | notification surface | `removeNotification("ide-status-jetbrains-disconnected")` | 特例词失去前提后不应继续代表当前真相 | `useIDEStatusIndicator.tsx:110-135` |
| IDE install error 消失 | `IDE extension install failed ...` | notification surface | `removeNotification("ide-status-install-error")` | 失败词不应在条件撤销后继续污染当前解释 | `useIDEStatusIndicator.tsx:138-154` |
| voice mode 进入 recording / processing | 现有通知前景与弱提示词 | 整个 notification 前景 | 整层替换为 `VoiceIndicator` | 更高优先级前景已接管当前叙述空间 | `PromptInput/Notifications.tsx:281-286` |
| external editor hint 条件消失 | `external-editor-hint` | notification surface | `removeNotification("external-editor-hint")` | 条件导向提示失去依据后必须退场 | `PromptInput/Notifications.tsx:147-170` |
| bridge 进入 failed | footer 上的弱状态词，如 `Remote Control active` / `reconnecting` | footer pill | 不再显示 failed 于 footer，failed 改由 notification 承担 | 高风险词不应与低占位弱词同层并存 | `PromptInputFooter.tsx:173-189` |

## 3. 最短判断公式

评审一个旧词是否该退场时，先问四句：

1. 有没有更高风险或更高优先级的新证据已经出现
2. 旧词依赖的语义前提是否已经失效
3. 当前应该是 remove、invalidate、fold 还是整层替换
4. 如果旧词不退场，用户会不会同时看到互相冲突的解释

## 4. 最常见的四类失效失败

| 失效失败 | 会造成什么问题 |
| --- | --- |
| 高风险通知出现后旧绿色词还留着 | 弱承诺继续污染当前真相 |
| 条件导向 hint 失去前提却不移除 | 用户收到过期建议 |
| 更具体错误词出现后旧泛化词仍并存 | 系统把冲突解释并排交给用户 |
| 高优先级前景接管时旧前景不退场 | 多个 surface 同时争夺当前叙述权 |

## 5. 一条硬结论

对 Claude Code 这类安全控制面来说，  
真正危险的不是词少一点或词多一点，  
而是：

`更强新证据已经出现，但旧的弱词还留在界面上继续说话。`
