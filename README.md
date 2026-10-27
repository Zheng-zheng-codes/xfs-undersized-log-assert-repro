# xfs: undersized log triggers assertion in xfs_log_mount()

Reproduction materials for a syzkaller report:

```
kernel BUG in xfs_assert: NUM (fs/xfs/xfs_log.c line593)
```

Mounting the attached XFS image triggers an assertion in `xfs_log_mount()`
after the log size check reports 516 blocks, below the required minimum of
636 blocks.

This is an observable assertion with a deliberately malformed XFS image.
We are not claiming a new vulnerability or a specific root cause.

## Status

- Original report: Linux 7.1.3 (fs/xfs/xfs_log.c:593)
- Reproduced on Linux 7.2.11 (state-primed) and Linux 7.3.0
  (fs/xfs/xfs_log.c:597; the line moved between releases)
- C reproducer: not available
- Reproduction counts: 7.3.0 1/1 cold boot; 7.2.11 1/1 state-primed;
  7.1.3 original report.  A repeated cold-boot run and a non-debug /
  `CONFIG_XFS_ASSERT_FATAL=n` kernel were not tested.
- The original 7.1.3 log was captured with the out-of-tree module `ltp_tpci`
  (taint O/E).  The 7.3.0 log used here is clean on that point; a 7.1.3
  re-validation without `ltp_tpci` has not been done.
- The 7.3.0 / 7.2.11 crash needs a state-construction pass first; both stages
  must run in the same VM.

## Contents

```
repro/repro.prog                syzkaller testcase (contains the XFS image)
repro/repro.kernsight.prog      state-construction recipe (7.2.11/7.3.0)
7.1.3/                          original 7.1.3 report, log, machine info, state
7.2.11/                         state-primed reproduction + full batch console
7.3/                            full 7.3.0 serial/console/dmesg + result
kernel/                         .config for 7.1.3/7.2.11/7.3.0 + SOURCES.md
reproduce.sh                    two-stage reproduction in one VM
verify.sh                       checks the files and quoted numbers
MANIFEST.sha256                 checksums
```

## Reproduction

```
./reproduce.sh          # expects syz-execprog/syz-executor in PATH or HERE
```

Manual form (same VM, do not reboot between the stages):

```
scp syz-execprog syz-executor repro/repro.kernsight.prog repro/repro.prog root@guest:/tmp/
ssh root@guest
cd /tmp && chmod +x syz-execprog syz-executor
./syz-execprog -procs=1 -repeat=1 -disable=swap -executor ./syz-executor ./repro.kernsight.prog
./syz-execprog -procs=1 -repeat=1 -disable=swap -executor ./syz-executor ./repro.prog
```

## 7.3.0 observed report

```
XFS (loop0): Log size 516 blocks too small, minimum size is 636 blocks
XFS: Assertion failed: 0, file: fs/xfs/xfs_log.c, line: 597
kernel BUG at fs/xfs/xfs_message.c:102!
RIP: 0010:assfail+0xa2/0xb0
 xfs_log_mount+0x4e3/0x590
Kernel panic - not syncing: Fatal exception
```

The 7.1.3 report has the same message at `fs/xfs/xfs_log.c:593`.
