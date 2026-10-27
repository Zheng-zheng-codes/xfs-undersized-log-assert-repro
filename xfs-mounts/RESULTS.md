# Individual XFS mount blocks — standalone runs

Extracted from `repro/repro.kernsight.prog` (10 blocks containing
`syz_mount_image$xfs`). Each block was run alone in a fresh
7.3.0-kernsight-kasan VM with:

```
syz-execprog -procs=1 -repeat=1 -disable=swap -executor syz-executor mount-N.prog
```

| block | program | standalone result | log |
|---|---|---|---|
| 2  | mount-2.prog  | no crash in captured serial | results/mount-2/serial.log |
| 15 | mount-15.prog | no crash in captured serial | results/mount-15/serial.log |
| 16 | mount-16.prog | no crash in captured serial | results/mount-16/serial.log |
| 17 | mount-17.prog | no crash in captured serial | results/mount-17/serial.log |
| 18 | mount-18.prog | no crash in captured serial | results/mount-18/serial.log |
| 27 | mount-27.prog | no crash in captured serial | results/mount-27/serial.log |
| 28 | mount-28.prog | no crash in captured serial | results/mount-28/serial.log |
| 30 | mount-30.prog | no crash in captured serial | results/mount-30/serial.log |
| **32** | **mount-32.prog** | **TRIGGERED the target assertion** | **results/mount-32/serial.log** |
| 33 | mount-33.prog | no crash in captured serial | results/mount-33/serial.log |

`mount-32` serial:

```
XFS (loop0): Mounting V5 Filesystem a2f82aab-77f8-4286-afd4-a8f747a74bab
XFS (loop0): Log size 516 blocks too small, minimum size is 636 blocks
XFS: Assertion failed: 0, file: fs/xfs/xfs_log.c, line: 597
kernel BUG at fs/xfs/xfs_message.c:102!
Kernel panic - not syncing: Fatal exception
```

Note: syz-execprog's progress line `executed programs: 0` / `EXIT:0` is not
proof that a mount succeeded or failed; the serial log is the evidence.
`mount-32` independently triggers the assertion with the same binary and the
same execprog arguments. No preceding recipe replay was needed in this
standalone run; further minimisation of `mount-32.prog` has not been
attempted.
