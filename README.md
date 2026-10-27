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
- Reproduction counts (methods kept separate): full 37-program recipe on
  7.3.0: 1/1; standalone `mount-32.prog` on 7.3.0: 1/1; 7.2.11
  state-primed: 1/1; 7.1.3: original report. A repeated cold-boot run and a
  non-debug / `CONFIG_XFS_ASSERT_FATAL=n` kernel were not tested.
- The original 7.1.3 log was captured with the out-of-tree module `ltp_tpci`
  (taint O/E).  The 7.3.0 log used here is clean on that point; a 7.1.3
  re-validation without `ltp_tpci` has not been done.
- Independent trigger: `xfs-mounts/mount-32.prog` alone, run in a fresh
  7.3.0 VM with the same execprog arguments, triggers the same assertion
  (serial: 516 < 636, `fs/xfs/xfs_log.c:597`, kernel BUG). The full
  37-program recipe also triggers it. The other 9 extracted mount blocks
  did not show the crash in their captured serial logs. No preceding recipe
  replay was needed in the standalone mount-32 run; further minimisation of
  mount-32.prog has not been attempted.
- The evidence (programs, commands, per-run serials, results table) is in
  `xfs-mounts/` (`xfs-mounts/RESULTS.md`). Note that syz-execprog's
  `executed programs: 0` / `EXIT:0` lines are not proof of execution; the
  serial logs are the evidence.
- The 7.2.11 log records the crash during the crash-log replay (state
  construction), not from a separate repro.prog stage.
- `repro/repro.prog` is a tty/KDSKBSENT testcase (syz_open_dev$tty20 +
  ioctl$KDSKBSENT). It is **not** the XFS trigger and does not mount the
  image; it is the last testcase repeated inside the full recipe.
- The 7.2.11 log records the crash during the crash-log replay (state
  construction), not from a separate repro.prog stage.
- There is no standalone XFS image file: the image data is embedded in the
  `syz_mount_image$xfs` calls; `mount-32.prog` contains the same embedded
  image.

## Contents

```
repro/repro.prog                tty/KDSKBSENT testcase (NOT the XFS trigger)
repro/repro.kernsight.prog      full 37-program recipe; contains the XFS image/mounts
7.1.3/                          original 7.1.3 report, log, machine info, state
7.2.11/                         state-primed reproduction + full batch console
7.3/                            full 7.3.0 serial/console/cmdline/boot + result
kernel/                         .config for 7.1.3/7.2.11/7.3.0 + SOURCES.md
reproduce.sh                    single-stage reproduction (full recipe)
xfs-mounts/                     the 10 extracted mount blocks + standalone results
verify.sh                       checks the files and quoted numbers
MANIFEST.sha256                 checksums
```

## Reproduction

Single stage on a fresh 7.3.0 VM (the full recipe contains the XFS mounts and
the final tty testcase):

```
./reproduce.sh          # expects syz-execprog/syz-executor in PATH or HERE
```

Manual form:

```
scp syz-execprog syz-executor repro/repro.kernsight.prog root@guest:/tmp/
ssh root@guest
cd /tmp && chmod +x syz-execprog syz-executor
./syz-execprog -procs=1 -repeat=1 -disable=swap -executor ./syz-executor ./repro.kernsight.prog
```

The 10 XFS mount blocks were extracted from the recipe and each run alone in
a fresh VM; none of them triggered the assertion.

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
