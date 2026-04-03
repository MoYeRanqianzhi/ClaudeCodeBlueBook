# 安全验证制度化接口速查表：interface、current state、missing hook与recommended contract

## 1. 这一页服务于什么

这一页服务于 [115-安全验证制度化接口：为什么验证蓝图若不进入script、目录、tsconfig与CI挂载点，就仍然不是工程能力](../115-%E5%AE%89%E5%85%A8%E9%AA%8C%E8%AF%81%E5%88%B6%E5%BA%A6%E5%8C%96%E6%8E%A5%E5%8F%A3%EF%BC%9A%E4%B8%BA%E4%BB%80%E4%B9%88%E9%AA%8C%E8%AF%81%E8%93%9D%E5%9B%BE%E8%8B%A5%E4%B8%8D%E8%BF%9B%E5%85%A5script%E3%80%81%E7%9B%AE%E5%BD%95%E3%80%81tsconfig%E4%B8%8ECI%E6%8C%82%E8%BD%BD%E7%82%B9%EF%BC%8C%E5%B0%B1%E4%BB%8D%E7%84%B6%E4%B8%8D%E6%98%AF%E5%B7%A5%E7%A8%8B%E8%83%BD%E5%8A%9B.md)。

如果 `115` 的长文解释的是：

`验证必须进入稳定工程接口，`

那么这一页只做一件事：

`把各接口层当前状态、缺失挂载位与推荐契约压成一张制度化矩阵。`

## 2. 制度化接口矩阵

| interface | current state | missing hook | recommended contract | 关键证据 |
| --- | --- | --- | --- | --- |
| `package.json` scripts | 只有 `prepare-src/build/check/start` | 没有 `test` / `check:security` 入口 | `test`、`test:security`、`check:security` | `package.json:7-11` |
| `scripts/` pipeline | 已有 `prepare-src/build/stub/transform` | 验证尚未成为 phase pipeline | 把验证串进 `prepare -> check -> test` 链 | `scripts/` 文件结构；`build.mjs`; `prepare-src.mjs` |
| `tsconfig` | `rootDir=src`，`include` 仅 `src,stubs` | `tests/` 不在现有类型制度里 | `tsconfig.tests.json` 或专门 runner config | `tsconfig.json:16-18,28-35` |
| test directory | conventional test/spec 检索为 `0` | 没有固定测试骨架 | `tests/security/{property,table,integration,fixtures}` | 本地检索结果 `0` |
| CI host | `.github` 不存在 | 没有自动执行挂载位 | 将来统一以 `check:security` 为唯一 CI 入口 | 本地检查 `.github => no` |
| engineering contract | 目前主要靠文档研究结论 | 没有“哪些命令必须跑”的制度契约 | 本地日常 `test:security`，预合并 `check:security` | 由当前 build/check 模式自然外推 |

## 3. 最短判断公式

判断验证是否已制度化时，先问五句：

1. 它有没有稳定 script 名
2. 它有没有固定目录位置
3. 它有没有类型/runner 配置入口
4. 它有没有未来可挂 CI 的单一命令
5. 它有没有从“建议”升级成“仓库契约”

## 4. 最常见的五类制度化缺口

| 缺口方式 | 会造成什么问题 |
| --- | --- |
| 没有测试脚本入口 | 验证仍靠维护者记忆 |
| 没有目录骨架 | 测试无法稳定扩展 |
| 没有独立测试 tsconfig | 测试难以纳入类型制度 |
| 没有统一 CI 命令 | 本地与自动执行分叉 |
| 只有研究结论没有工程契约 | 安全原则难变成日常流程 |

## 5. 一条硬结论

对安全控制面来说，  
真正的制度化不是：

`文档里列出该补哪些测试，`

而是：

`让验证拥有稳定的入口、位置、配置与挂载点，从而成为仓库默认会执行的一部分。`
