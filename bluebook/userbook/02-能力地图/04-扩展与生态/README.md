# 扩展与生态

这一层最容易被写成“扩展清单”，但更稳的前门只有三句：

1. `source -> projection -> runtime gate -> activation`
   - 扩展不是“装没装”，而是从哪条来源链进入、被谁看见、何时激活。
2. `workspace trust -> source trust -> surface lock`
   - 不同来源与 surface 的权限不是同一把钥匙。
3. `projection != signer`
   - 菜单里看见、按名解析、当前会话激活、Agent 真能挂上，不是同一层 truth。

如果你还在把 MCP、plugin、skills、hooks 写成同一类“外部能力”，先回控制面页，不要继续把这里当库存目录。

- [01-MCP、插件、技能、Hooks 与外部扩展.md](./01-MCP%E3%80%81%E6%8F%92%E4%BB%B6%E3%80%81%E6%8A%80%E8%83%BD%E3%80%81Hooks%20%E4%B8%8E%E5%A4%96%E9%83%A8%E6%89%A9%E5%B1%95.md)

如果你只看一页，先看 `01`；如果你现在争议的是“哪条来源链在签当前扩展 truth”，退回 `05-控制面深挖/02` 与 `14-19`。
