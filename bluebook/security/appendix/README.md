# 安全专题附录

`appendix/` 当前包含 122 篇速查文档和 1 个 README。

这里不展开主论证，只提供证据索引、字段矩阵、状态语义、恢复/续租速查和工程迁移检查表；安全主线仍以 [../README.md](<../README.md>) 为准。

## 目录分段

- `01-13`: 检测证据、统一安全控制台、宿主降级与宿主资格。
  入口：[`01-安全检测证据索引：从模块到结论的映射`](<01-安全检测证据索引：从模块到结论的映射.md>)、[`06-统一安全控制台总图：主体、主权、仲裁、包络、外部能力、状态与审批`](<06-统一安全控制台总图：主体、主权、仲裁、包络、外部能力、状态与审批.md>)、[`12-宿主降级速查表：宿主类型、支持子集、显式失败与安全风险`](<12-宿主降级速查表：宿主类型、支持子集、显式失败与安全风险.md>)、[`13-宿主资格速查表：观察、控制、证明三层责任与典型实现`](<13-宿主资格速查表：观察、控制、证明三层责任与典型实现.md>)。
- `14-29`: 真相源、账本、声明等级、动作与完成差异字段。
  入口：[`14-安全真相源速查表：实时真相、语义真相、复制真相、本地真相与UI投影`](<14-安全真相源速查表：实时真相、语义真相、复制真相、本地真相与UI投影.md>)、[`19-安全多账本速查表：语义账、复制账、可见账与恢复账的读者、边界与误判成本`](<19-安全多账本速查表：语义账、复制账、可见账与恢复账的读者、边界与误判成本.md>)、[`23-安全声明等级速查表：状态、理由、强度与典型误读`](<23-安全声明等级速查表：状态、理由、强度与典型误读.md>)、[`24-安全动作语法速查表：声明族、正确下一步与错误动作压缩`](<24-安全动作语法速查表：声明族、正确下一步与错误动作压缩.md>)、[`29-安全完成差异字段速查表：字段、来源、展示层级与缺失后果`](<29-安全完成差异字段速查表：字段、来源、展示层级与缺失后果.md>)。
- `30-44`: 卡片升级规则、恢复签字/中间态、文案禁令、清理权限与显式语义。
  入口：[`30-安全完成差异卡片速查表：卡片挂载点、展示优先级、默认动作与最危险埋深`](<30-安全完成差异卡片速查表：卡片挂载点、展示优先级、默认动作与最危险埋深.md>)、[`34-安全恢复签字层级速查表：signer、可恢复对象、不可恢复对象与典型误读`](<34-安全恢复签字层级速查表：signer、可恢复对象、不可恢复对象与典型误读.md>)、[`35-安全恢复中间态速查表：中间态、可见账本、可用动作、禁止文案与默认跳转`](<35-安全恢复中间态速查表：中间态、可见账本、可用动作、禁止文案与默认跳转.md>)、[`38-安全恢复验证闭环速查表：repair path、verifier、signer与可清除对象`](<38-安全恢复验证闭环速查表：repair path、verifier、signer与可清除对象.md>)、[`44-安全恢复显式语义速查表：hidden、suppressed、cleared与resolved`](<44-安全恢复显式语义速查表：hidden、suppressed、cleared与resolved.md>)。
- `45-60`: 词法主权、绿色词租约、续租失败、能力发布/撤回/声明仲裁。
  入口：[`45-安全恢复词法主权速查表：surface、visible inputs、max allowed lexicon与forbidden stronger terms`](<45-安全恢复词法主权速查表：surface、visible inputs、max allowed lexicon与forbidden stronger terms.md>)、[`48-安全恢复绿色词租约速查表：positive lexicon、renewal condition、revocation trigger与lease length`](<48-安全恢复绿色词租约速查表：positive lexicon、renewal condition、revocation trigger与lease length.md>)、[`50-安全恢复续租失败分级速查表：lease failure type、recovery capacity与next repair path`](<50-安全恢复续租失败分级速查表：lease failure type、recovery capacity与next repair path.md>)、[`55-安全能力发布主权速查表：surface、authoritative publisher、visible capability与forbidden overclaim`](<55-安全能力发布主权速查表：surface、authoritative publisher、visible capability与forbidden overclaim.md>)、[`59-安全能力声明仲裁速查表：surface、authority kind、conflict winner-loser与forced handoff`](<59-安全能力声明仲裁速查表：surface、authority kind、conflict winner-loser与forced handoff.md>)。
- `61-79`: 状态家族、句柄化、上下文连续性、恢复资格对象与重签发。
  入口：[`61-安全状态替换语法速查表：change pattern、operator、safe effect与forbidden shortcut`](<61-安全状态替换语法速查表：change pattern、operator、safe effect与forbidden shortcut.md>)、[`64-安全状态句柄化速查表：current carrier、missing scope、recommended handle fields与migration gain`](<64-安全状态句柄化速查表：current carrier、missing scope、recommended handle fields与migration gain.md>)、[`67-安全授权连续性速查表：context、continuity owner、allowed substitution与boundary failure`](<67-安全授权连续性速查表：context、continuity owner、allowed substitution与boundary failure.md>)、[`72-安全恢复资格证据门槛速查表：evidence piece、owner、threshold与failure downgrade`](<72-安全恢复资格证据门槛速查表：evidence piece、owner、threshold与failure downgrade.md>)、[`79-安全资格重签发协议速查表：artifact、revocation trigger、regrant path与forbidden shortcut`](<79-安全资格重签发协议速查表：artifact、revocation trigger、regrant path与forbidden shortcut.md>)。
- `80-99`: 资格中间态、投影协议、字段生命周期与验证蓝图。
  入口：[`80-安全资格中间态速查表：state、meaning、allowed promise与next action`](<80-安全资格中间态速查表：state、meaning、allowed promise与next action.md>)、[`87-安全资格显式投影协议字段速查表：field、meaning、example source与UI gain`](<87-安全资格显式投影协议字段速查表：field、meaning、example source与UI gain.md>)、[`91-安全资格字段生命周期协议化速查表：subsystem、current carrier、hidden lifecycle rule与recommended protocol fields`](<91-安全资格字段生命周期协议化速查表：subsystem、current carrier、hidden lifecycle rule与recommended protocol fields.md>)、[`98-安全最小可执行验证蓝图速查表：suite、first test、minimal assertion与rollout order`](<98-安全最小可执行验证蓝图速查表：suite、first test、minimal assertion与rollout order.md>)、[`99-安全验证制度化接口速查表：interface、current state、missing hook与recommended contract`](<99-安全验证制度化接口速查表：interface、current state、missing hook与recommended contract.md>)。
- `100-122`: 工程迁移阶段门、词法宪法、失败语义、缩域、状态机与遗忘契约。
  入口：[`100-安全工程迁移路线图速查表：phase、goal、repo touchpoint与exit criteria`](<100-安全工程迁移路线图速查表：phase、goal、repo touchpoint与exit criteria.md>)、[`101-安全工程阶段门速查表：phase、entry gate、exit criteria与forbidden shortcut`](<101-安全工程阶段门速查表：phase、entry gate、exit criteria与forbidden shortcut.md>)、[`109-安全工程词法协议速查表：term、allowed layer、meaning与forbidden stronger synonym`](<109-安全工程词法协议速查表：term、allowed layer、meaning与forbidden stronger synonym.md>)、[`115-安全真相状态机速查表：state family、entry condition、stay condition、exit operator与authoritative signer`](<115-安全真相状态机速查表：state family、entry condition、stay condition、exit operator与authoritative signer.md>)、[`122-安全遗忘宿主契约速查表：contract surface、current payload、missing cleanup semantics与upgrade target`](<122-安全遗忘宿主契约速查表：contract surface、current payload、missing cleanup semantics与upgrade target.md>)。

## 怎么配合主线读

- 读 [../README.md](<../README.md>) 时，把附录当速查卡，不当主阅读路径。
- 想快速核对“字段从哪来、谁能签字、哪条路径被禁止、当前该看哪张卡”，优先来附录。
- 需要完整论证、设计判断和章节间关系时，返回 [../README.md](<../README.md>)。
