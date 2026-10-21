---
name: ci-ubuntu-migration
description: >-
  CI 构建的 APK 卡死根因是 R8 混淆 Kotlin 类型导致 Pigeon 反射签名不匹配，已添加
  proguard-rules.pro(-dontobfuscate) 修复
type: project
---

v3.7.0 CI 构建的 Android APK 卡死在闪屏页。根因：`shared_preferences_android 2.4+` 的 Pigeon 生成代码通过 JNI 按精确签名反射查找方法，R8 `minifyEnabled true` 将参数类型 `kotlin.coroutines.Continuation` 重命名为 `Q2.c`，导致 `NoSuchMethodError: SharedPreferencesApiRegistrar.getAll`，启动初始化失败卡死。v3.6.0 未触发是因为"交易筛选状态持久化"功能才在启动路径上调用 `getAll()`。

**Why:** build.gradle 引用了 `proguard-rules.pro` 但该文件一直不存在，R8 混淆长期处于无 keep 规则状态。本地 `flutter run --release` 正常是因为本地 JDK 的 R8 行为与 CI 不同。

**How to apply:**
- 已修复：创建 `android/app/proguard-rules.pro`，关键规则 `-dontobfuscate`(保留裁剪优化但禁止重命名)
- `ubuntu-latest` 已于 2026-10-19 迁移到 Ubuntu 26，workflow 中 build_android 已固定为 `ubuntu-24.04` 保证构建可复现
- 升级构建环境或 Pigeon 插件时，关注 `-dontobfuscate` 是否仍必要