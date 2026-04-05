# 安全工程缺席语义速查表：artifact class、mention surface、existence signer与forbidden existence jump

## 1. 这一页服务于什么

这一页服务于 [122-安全工程沉默与缺席语义：为什么README里的verify命名、仓库里的文件缺席与package脚本缺席不能被混成同一种“存在”](../122-%E5%AE%89%E5%85%A8%E5%B7%A5%E7%A8%8B%E6%B2%89%E9%BB%98%E4%B8%8E%E7%BC%BA%E5%B8%AD%E8%AF%AD%E4%B9%89%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88README%E9%87%8C%E7%9A%84verify%E5%91%BD%E5%90%8D%E3%80%81%E4%BB%93%E5%BA%93%E9%87%8C%E7%9A%84%E6%96%87%E4%BB%B6%E7%BC%BA%E5%B8%AD%E4%B8%8Epackage%E8%84%9A%E6%9C%AC%E7%BC%BA%E5%B8%AD%E4%B8%8D%E8%83%BD%E8%A2%AB%E6%B7%B7%E6%88%90%E5%90%8C%E4%B8%80%E7%A7%8D%E2%80%9C%E5%AD%98%E5%9C%A8%E2%80%9D.md)。

如果 `122` 的长文解释的是：

`为什么文本命名、文件存在、入口存在与宿主存在是四层不同存在，`

那么这一页只做一件事：

`把主要对象的 mention surface、existence signer 与 forbidden existence jump 压成一张矩阵。`

## 2. 缺席语义矩阵

| artifact class | mention surface | existence signer | current observed state | forbidden existence jump |
| --- | --- | --- | --- | --- |
| `verify/*` 命名 | `README.md:167-174` | filesystem signer + entry signer + host signer | 仅 lexical existence；无文件、无脚本、无宿主 | README 提到 -> formal verify exists |
| `verify/test` 正式入口 | `package.json` | package script signer | `package.json:7-11` 未出现 | 没写 script -> 默认已有入口 |
| tests corpus | filesystem | tests tree signer | `test/spec files: 0` | 没看到 tests -> 先当 tests 在别处 |
| CI host | repo infra | host signer | `.github dirs: 0` | 没有宿主 -> 先按未来会有处理 |

## 3. 最短判断公式

判断“某物是否存在”时，先问四句：

1. 它是在哪一层被提到的
2. 真正拥有签字权的是哪一层
3. 当前签字人是否到场
4. 我是不是正在做 existence jump

## 4. 最常见的四类 existence jump

| existence jump | 实际问题 |
| --- | --- |
| README mention -> file exists | 文本层越权成工件层 |
| file exists -> formal entry exists | 工件层越权成入口层 |
| entry exists -> host exists | 入口层越权成宿主层 |
| silence -> provisional existence | 缺席被脑补为存在 |

## 5. 一条硬结论

对这份研究版源码来说，  
安全研究不能只问：

`有没有，`

而必须问：

`是哪一层有，哪一层缺，哪一层绝不能跳。`

