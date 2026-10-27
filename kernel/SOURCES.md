# Kernel sources

- 7.1.3: Linux v7.1.3, commit 113be0295f4f632d61f4e9c93322f70e2365f54d;
  tag linux-7.1.3-kernsight-kasan-v1 (tree not a git checkout).
  XFS/VFS unmodified; KernSight changes are in the syzkaller tree.
- 7.2.11: Linux v7.2.11, commit 8316c24ec1b77dba19ba072ca4fe251b36dc65d3;
  release tarball sha256 fd0fc479f983a8c05313f13e9c36330fe6651cf725396748c40d5cd93fa1e6a4.
  XFS/VFS unmodified.
- 7.3.0: mainline Linux v7.3, commit 091b06388b117fefdcb63336ac09956a4914b961;
  release tarball sha256 87363c24f10e06321eb362765521094e94471f6bff8bce2d6b3e40f39f004953.
  XFS/VFS unmodified.

Only the kernel configuration was adapted for KASAN/KCOV and the KernSight
state collection. `CONFIG_XFS_DEBUG` / `CONFIG_XFS_ASSERT_FATAL` values are
in the respective kernel-*.config files.
