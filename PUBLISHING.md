# SlotReelKit 发布指南

**当前版本：1.0.0**

本文档说明如何将 `SlotReelKit` 发布为独立库，并在 **CocoaPods** 与 **Swift Package Manager (SPM)** 中被其他项目引用。

---

## 目录

1. [发布前准备](#1-发布前准备)
2. [创建独立 Git 仓库](#2-创建独立-git-仓库)
3. [CocoaPods 发布](#3-cocoapods-发布)
4. [Swift Package Manager 发布](#4-swift-package-manager-发布)
5. [其他项目如何引用](#5-其他项目如何引用)
6. [版本更新流程](#6-版本更新流程)
7. [常见问题](#7-常见问题)

---

## 1. 发布前准备

### 1.1 检查目录结构

当前库目录应如下：

```
SlotReelKit/
├── Package.swift              # SPM 配置（必需）
├── SlotReelKit.podspec        # CocoaPods 配置（必需）
├── LICENSE                    # 开源协议（必需）
├── README.md                  # 使用说明（推荐）
├── PUBLISHING.md              # 本文档
└── SlotReelKit/               # 源码目录
    ├── Configuration/
    ├── Engine/
    ├── Model/
    ├── UIKit/
    └── SwiftUI/
```

### 1.2 修改 podspec 中的占位信息

打开 `SlotReelKit.podspec`，确认版本号并替换占位信息：

```ruby
spec.version          = '1.0.0'
spec.homepage         = 'https://github.com/你的用户名/SlotReelKit'
spec.author           = { '你的名字' => 'your-email@example.com' }
spec.source           = { :git => 'https://github.com/你的用户名/SlotReelKit.git', :tag => spec.version.to_s }
```

### 1.3 准备账号

| 平台 | 用途 | 注册地址 |
|------|------|----------|
| GitHub | 托管源码 | https://github.com |
| CocoaPods Trunk | 发布到 CocoaPods 公共源 | 通过命令行注册 |

> SPM **不需要**单独注册账号，只要代码在 Git 仓库中且包含 `Package.swift` 即可。

---

## 2. 创建独立 Git 仓库

> 如果库还在 MGC 项目内，需要先拆成独立仓库再发布。

### 2.1 在 GitHub 创建空仓库

1. 登录 GitHub
2. 点击 **New repository**
3. 仓库名建议：`SlotReelKit`
4. 选择 **Public**（公开库才能被 CocoaPods 公共索引收录）
5. **不要**勾选 “Add a README”（本地已有）
6. 创建仓库

### 2.2 将本地 SlotReelKit 推送到 GitHub

在终端执行（路径按实际情况修改）：

```bash
# 进入库目录
cd /Users/min/Min/Project/dw/iOS/MGC/SlotReelKit

# 初始化 Git（若尚未初始化）
git init

# 添加文件
git add .
git commit -m "feat: initial release of SlotReelKit 1.0.0"

# 关联远程仓库（替换为你的 GitHub 地址）
git remote add origin https://github.com/你的用户名/SlotReelKit.git

# 推送主分支
git branch -M main
git push -u origin main
```

### 2.3 打版本 Tag（CocoaPods / SPM 都依赖 Tag）

```bash
git tag 1.0.0
git push origin 1.0.0
```

**重要：**

- 当前版本为 **1.0.0**
- Tag 名必须与 `SlotReelKit.podspec` 中的 `spec.version` 一致（均为 `1.0.0`）
- 后续发新版本时，需同步修改 `spec.version`、Git Tag 及文档中的版本号

---

## 3. CocoaPods 发布

### 3.1 安装 CocoaPods

```bash
sudo gem install cocoapods
```

验证：

```bash
pod --version
```

### 3.2 注册 CocoaPods Trunk 账号（首次发布需要）

```bash
pod trunk register your-email@example.com '你的名字' --description='MacBook'
```

邮箱会收到验证链接，点击完成注册。

查看已注册信息：

```bash
pod trunk me
```

### 3.3 本地校验 podspec

在 `SlotReelKit` 根目录执行：

```bash
cd /path/to/SlotReelKit

pod lib lint SlotReelKit.podspec --allow-warnings
```

常见参数：

| 参数 | 说明 |
|------|------|
| `--allow-warnings` | 允许 warning 通过校验 |
| `--verbose` | 输出详细日志 |
| `--skip-import-validation` | 跳过 import 校验（特殊场景） |

若校验失败，根据终端报错修复后重试。

### 3.4 发布到 CocoaPods 公共源

```bash
pod trunk push SlotReelKit.podspec --allow-warnings
```

成功后，其他开发者可通过以下方式安装：

```ruby
pod 'SlotReelKit', '1.0.0'
```

### 3.5 验证是否发布成功

```bash
pod search SlotReelKit
```

或在项目中：

```ruby
# Podfile
pod 'SlotReelKit', '1.0.0'
```

```bash
pod install
```

> 新库索引同步可能需要 **10~30 分钟**，若暂时搜不到请稍后再试。

### 3.6 私有 CocoaPods 源（可选）

若不想公开发布，可使用私有 Spec Repo：

```bash
# 1. 创建私有 spec 仓库（GitHub 上建 xxx-specs 仓库）
pod repo add MySpecs https://github.com/你的用户名/MySpecs.git

# 2. 向私有源添加 podspec
pod repo push MySpecs SlotReelKit.podspec --allow-warnings
```

使用者 Podfile：

```ruby
source 'https://github.com/你的用户名/MySpecs.git'
source 'https://cdn.cocoapods.org/'

pod 'SlotReelKit', '1.0.0'
```

---

## 4. Swift Package Manager 发布

SPM **不需要**像 CocoaPods 那样 `trunk push`，只需：

1. 仓库是公开的（或使用者有访问权限）
2. 根目录有 `Package.swift`
3. 打了 Git Tag `1.0.0`

以上三点满足即可。

### 4.1 验证 Package.swift

在库根目录执行：

```bash
cd /path/to/SlotReelKit
swift package describe
```

或：

```bash
swift build
```

### 4.2 推送 Tag 后即可被引用

```bash
git tag 1.0.0
git push origin 1.0.0
```

---

## 5. 其他项目如何引用

### 5.1 CocoaPods

**公开库（指定版本 1.0.0）：**

```ruby
# Podfile
platform :ios, '16.0'
use_frameworks!

target 'YourApp' do
  pod 'SlotReelKit', '1.0.0'
end
```

**本地开发调试：**

```ruby
pod 'SlotReelKit', :path => '../SlotReelKit'
```

**指定 Git Tag 1.0.0：**

```ruby
pod 'SlotReelKit', :git => 'https://github.com/你的用户名/SlotReelKit.git', :tag => '1.0.0'
```

安装：

```bash
pod install
```

代码中使用：

```swift
import SlotReelKit
```

---

### 5.2 Swift Package Manager（Xcode）

1. 打开 Xcode 工程
2. 菜单：**File → Add Package Dependencies...**
3. 输入仓库地址：

```
https://github.com/你的用户名/SlotReelKit.git
```

4. **Dependency Rule** 选择：
   - **Exact Version**：`1.0.0`（推荐，与当前版本一致）
   - 或 **Up to Next Major Version**：`1.0.0`
5. 点击 **Add Package**
6. 在 Target 中勾选 `SlotReelKit`

代码中使用：

```swift
import SlotReelKit
```

---

### 5.3 Swift Package Manager（Package.swift 项目）

```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "YourApp",
    platforms: [.iOS(.v16)],
    dependencies: [
        .package(url: "https://github.com/你的用户名/SlotReelKit.git", exact: "1.0.0")
    ],
    targets: [
        .target(
            name: "YourApp",
            dependencies: ["SlotReelKit"]
        )
    ]
)
```

---

## 6. 版本更新流程

当前首发版本为 **1.0.0**。后续如需发新版本，按以下顺序操作：

### 6.1 修改版本号

1. `SlotReelKit.podspec` → 将 `spec.version = '1.0.0'` 改为新版本号
2. `Package.swift` 无需改版本（SPM 用 Git Tag）
3. 同步更新 `README.md`、`PUBLISHING.md` 中的版本号

### 6.2 提交代码

```bash
git add .
git commit -m "chore: release 1.0.0"
git push origin main
```

### 6.3 打 Tag 并推送

```bash
git tag 1.0.0
git push origin 1.0.0
```

### 6.4 发布 CocoaPods

```bash
pod lib lint SlotReelKit.podspec --allow-warnings
pod trunk push SlotReelKit.podspec --allow-warnings
```

### 6.5 SPM 自动生效

SPM 使用者更新 Package 依赖即可获取新版本（Xcode 中 **File → Packages → Update to Latest Package Versions**）。

---

## 7. 常见问题

### Q1: `pod lib lint` 报错 `Unable to find a specification`

- 确认在 `SlotReelKit.podspec` 所在目录执行命令
- 确认 `spec.source_files` 路径正确：`'SlotReelKit/**/*.swift'`
- 确认 `spec.version` 为 `1.0.0`

### Q2: `pod trunk push` 提示无权限

- 先执行 `pod trunk register` 并完成邮箱验证
- 确认 GitHub 仓库与 podspec 中 `spec.source` 地址一致

### Q3: SPM 找不到 Package

- 确认仓库是 Public，或已授权访问
- 确认根目录存在 `Package.swift`
- 确认已推送 Tag `1.0.0`

### Q4: CocoaPods 搜不到刚发布的库

- 等待 10~30 分钟索引同步
- 或临时使用 `:git` 方式引用 Tag `1.0.0`

### Q5: MGC 项目当前如何引用

MGC 目前使用本地路径：

```ruby
pod 'SlotReelKit', :path => 'SlotReelKit'
```

发布成功后，可改为：

```ruby
pod 'SlotReelKit', '1.0.0'
```

---

## 快速命令清单

```bash
# === 首次发布 1.0.0 ===
cd /path/to/SlotReelKit
git init
git add .
git commit -m "feat: initial release 1.0.0"
git remote add origin https://github.com/你的用户名/SlotReelKit.git
git push -u origin main
git tag 1.0.0
git push origin 1.0.0

pod trunk register your-email@example.com '你的名字'
pod lib lint SlotReelKit.podspec --allow-warnings
pod trunk push SlotReelKit.podspec --allow-warnings

# === 后续版本 ===
# 1. 修改 podspec 中 spec.version（当前为 1.0.0）
# 2. git commit + push
# 3. git tag {新版本号} + push tag
# 4. pod trunk push
```

---

## 参考链接

- [CocoaPods 官方文档 - Getting Started](https://guides.cocoapods.org/using/getting-started.html)
- [CocoaPods 官方文档 - Trunk](https://guides.cocoapods.org/making/getting-setup-with-trunk.html)
- [Swift Package Manager 文档](https://www.swift.org/documentation/package-manager/)
- [GitHub 创建 Release](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository)
