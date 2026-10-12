---
name: pack-and-push-workflow
description: 用户说"打包并推送"时执行的完整发布流程
type: feedback
---

当用户说"打包并推送"并提供版本号和发布说明时，执行以下步骤：

1. **更新 pubspec.yaml 版本号**：将 `version: X.Y.Z+N` 更新为新版本（build number 递增）
2. **提交改动**：`git add pubspec.yaml && git commit -m "vX.Y.Z 发布说明"`
3. **创建标签**：`git tag -a vX.Y.Z -m "发布说明"`
4. **推送代码和标签**：`git push origin main && git push origin vX.Y.Z`
5. **创建 GitHub Release**：`gh release create vX.Y.Z --title "vX.Y.Z" --notes "发布说明"`

**Why:** 用户习惯用"打包并推送"关键词触发完整的版本发布流程，包括版本号更新、提交、打标签、推送和创建 Release。
**How to apply:** 当用户说"打包并推送"并提供版本号时，按上述步骤依次执行，不要遗漏 pubspec.yaml 版本号更新步骤。