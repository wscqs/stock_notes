---
name: ci-ubuntu-migration
description: >-
  GitHub Actions ubuntu-latest 于 2026-10-19 迁移到 Ubuntu 26,导致 CI 构建的 APK
  运行卡死,已固定为 ubuntu-24.04
type: project
---

GitHub Actions 的 `ubuntu-latest` 标签于 2026-10-19 迁移到 Ubuntu 26。v3.7.0 的 Android APK 在新环境构建后运行卡死在闪屏页,而 v3.6.0(迁移前构建)正常。已将 `.github/workflows/flutter_build.yml` 中 build_android 的 runner 固定为 `ubuntu-24.04`。

**Why:** Ubuntu 26 预装更新的 JDK/工具链,R8/D8 在新 JDK 下的 minify/shrink 行为变化导致 release APK 运行时卡死。本地 `flutter run --release` 正常(不走完整 R8 流程),CI 构建也无报错,问题仅在运行时暴露。排查了很久才通过 GitHub 构建页面的迁移警告定位。

**How to apply:** 
- 若未来 Android CI 包再次出现运行异常,优先检查 runner 镜像是否又发生了迁移
- `ubuntu-24.04` 未来也会被弃用,届时需排查 Ubuntu 26+ 上的 JDK/R8 兼容性(可在 workflow 中显式 setup-java 固定 JDK 版本,或补全缺失的 proguard-rules.pro)
- `minifyEnabled true` + 缺失 proguard-rules.pro 是潜在风险点,升级构建环境时需重点关注