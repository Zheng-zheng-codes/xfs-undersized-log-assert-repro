# Individual XFS mount blocks — standalone runs

Extracted from `repro/repro.kernsight.prog` (10 blocks containing
`syz_mount_image$xfs`). Each block was run alone in a fresh
7.3.0-kernsight-kasan VM with:

```
syz-execprog -procs=1 -repeat=1 -disable=swap -executor syz-executor mount-N.prog
```

| block | program | result | log |
|---|---|---|---|
| 2  | mount-2.prog  | no assertion; execprog exited 0 | results/mount-2/serial.log |
| 15 | mount-15.prog | no assertion; execprog exited 0 | results/mount-15/serial.log |
| 16 | mount-16.prog | no assertion; execprog exited 0 | results/mount-16/serial.log |
| 17 | mount-17.prog | no assertion; execprog exited 0 | results/mount-17/serial.log |
| 18 | mount-18.prog | no assertion; execprog exited 0 | results/mount-18/serial.log |
| 27 | mount-27.prog | no assertion; execprog exited 0 | results/mount-27/serial.log |
| 28 | mount-28.prog | no assertion; execprog exited 0 | results/mount-28/serial.log |
| 30 | mount-30.prog | no assertion; execprog exited 0 | results/mount-30/serial.log |
| 32 | mount-32.prog | no assertion; execprog exited 0 | results/mount-32/serial.log |
| 33 | mount-33.prog | no assertion; execprog exited 0 | results/mount-33/serial.log |

Conclusion: no individual XFS mount block triggers the assertion on its own.
The confirmed trigger is the full 37-program recipe; the minimal sequence and
the state dependency are not established.
