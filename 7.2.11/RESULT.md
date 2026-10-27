# b2bf9497f461de6410e48ff25b9a1b4b4da01fd4

- 内核: 7.2.11 (`validation/linux-7.2.11-validate/bzImage`)
- 标题: kernel BUG in xfs_assert: NUM (fs/xfs/xfs_log.c line593)
- 结论: 2026-10-20T09:15:38Z 在 7.2.11 上通过 state-primed 复现（触发同一 crash，C=no）
- 手动复现（一条命令）: `bash /data/zhengzheng/7.2.11bug/demo-state.sh b2bf9497f461de6410e48ff25b9a1b4b4da01fd4`

关键产物:

```
repro.kernsight.prog   状态构造配方 + 崩溃用例(按顺序重放，-procs=1)
repro.prog             单独崩溃用例(状态相关时单独跑不一定触发)
repro.priming.prog     状态构造配方
repro.priming.json     候选选择/距离轨迹
repro.report           复现时的崩溃报告
pre_stateN / logN      原始 crash 现场(7.1.3)
```

> 独立复现 workdir: `/data/zhengzheng/kernsight/kernsight_workspace_select/batch-7.2.11-b2bf9497-20261020-164811`
