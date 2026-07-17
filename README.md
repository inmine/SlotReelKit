# SlotReelKit

**当前版本：1.0.0**

高性能 iOS 老虎机滚轮组件库，支持 UIKit / SwiftUI / CocoaPods / SPM。

- 仓库地址：[https://github.com/inmine/SlotReelKit](https://github.com/inmine/SlotReelKit)
- SPM / Git 地址：`https://github.com/inmine/SlotReelKit.git`

[English](#english) | [中文](#中文)

---

## 中文

SlotReelKit 使用 **固定 Slot 视图 + 循环取模 + CADisplayLink 逐帧动画**，在快速滚动时不会出现空白帧，也不会像 `UICollectionView` 懒加载那样卡顿或发热。

### 效果展示

静态效果图：

![SlotReelKit 效果图](image/show_image.jpg)

滚动动画：

![SlotReelKit 滚动效果](image/show.gif)

### 特性

- 3×3 经典老虎机布局，支持自定义列数 / 行数 / 符号数
- 逐列延迟启动、逐列停止
- 内置严格中奖矩阵生成器（仅一条中奖线）
- 支持传入自定义结果矩阵
- UIKit / SwiftUI 双端接入
- 可配置动画时长、圈数、缓动曲线、外观样式

### 系统要求

- iOS 16.0+
- Swift 5.9+
- Xcode 15+

### 安装

| 方式 | 适用场景 | 配置 |
|------|----------|------|
| SPM（Xcode） | 推荐，零配置 | 见下方 [SPM](#swift-package-manager) |
| CocoaPods | 已有 Pod 工程 | `pod 'SlotReelKit', '1.0.0'` |
| CocoaPods（Git） | Pod 未收录 / 指定 Tag | 见下方 [CocoaPods Git](#cocoapods-git) |
| CocoaPods（本地） | 联调开发 | `pod 'SlotReelKit', :path => 'SlotReelKit'` |

#### Swift Package Manager

**Xcode 工程：**

1. **File → Add Package Dependencies...**
2. 输入地址：

```
https://github.com/inmine/SlotReelKit.git
```

3. 选择 **Exact Version** → `1.0.0`
4. Add Package，并在 Target 中勾选 `SlotReelKit`

**Package.swift：**

```swift
dependencies: [
    .package(url: "https://github.com/inmine/SlotReelKit.git", exact: "1.0.0")
],
targets: [
    .target(name: "YourApp", dependencies: ["SlotReelKit"])
]
```

#### CocoaPods

```ruby
pod 'SlotReelKit', '1.0.0'
```

#### CocoaPods（Git）

CocoaPods 公共源尚未收录，或需要锁定 Git 版本时：

```ruby
pod 'SlotReelKit', :git => 'https://github.com/inmine/SlotReelKit.git', :tag => '1.0.0'
```

### 快速开始（SwiftUI）

```swift
import SlotReelKit
import SwiftUI

struct DemoView: View {
    @StateObject private var engine = SlotReelEngine(configuration: .default())

    private let appearance = SlotReelAppearanceConfiguration(
        symbolImageProviderClosure: { index in
            UIImage(named: "symbol_\(index + 1)")
        }
    )

    var body: some View {
        VStack(spacing: 20) {
            SlotReelView(engine: engine, appearance: appearance)

            Button("Spin") {
                engine.startRoll(targetSymbolIndex: 2) {
                    print("Spin finished")
                }
            }
            .disabled(engine.isRolling)
        }
    }
}
```

### 快速开始（UIKit）

```swift
import SlotReelKit

final class DemoViewController: UIViewController {
    private let engine = SlotReelEngine(configuration: .default())

    override func viewDidLoad() {
        super.viewDidLoad()

        let appearance = SlotReelAppearanceConfiguration(
            symbolImageProviderClosure: { index in
                UIImage(named: "symbol_\(index + 1)")
            }
        )

        for column in 0..<engine.configuration.columnCount {
            let columnView = SlotReelColumnView(
                configuration: engine.configuration,
                appearance: appearance,
                animationConfiguration: engine.animationConfiguration
            )
            columnView.setContentOffset(engine.columnOffsets[column], animated: false)
            view.addSubview(columnView)
        }
    }
}
```

### 核心 API

| 类型 | 说明 |
|------|------|
| `SlotReelConfiguration` | 布局：列数、行数、尺寸、间距 |
| `SlotReelAnimationConfiguration` | 动画：圈数、时长、延迟、缓动 |
| `SlotReelAppearanceConfiguration` | 外观：背景、圆角、符号图片 |
| `SlotReelEngine` | 滚动引擎，管理 spin 与停轮 |
| `SlotReelView` | SwiftUI 入口 |
| `SlotReelColumnView` | UIKit 单列视图 |
| `SlotReelMatrixGenerator` | 严格中奖矩阵生成器 |

### 自定义结果矩阵

```swift
let matrix = SlotReelMatrix(values: [
    [0, 1, 2],
    [1, 2, 3],
    [2, 3, 4]
])

engine.startRoll(resultMatrix: matrix) {
    print("Stopped")
}
```

### 代理回调

```swift
final class ReelCoordinator: SlotReelEngineDelegate {
    func slotReelEngine(_ engine: SlotReelEngine, didFinishSpin session: SlotReelSpinSession) {
        print("All columns stopped")
    }
}
```

### License

MIT

---

## English

SlotReelKit is a high-performance slot-machine reel component for iOS.

- Repository: [https://github.com/inmine/SlotReelKit](https://github.com/inmine/SlotReelKit)
- Package URL: `https://github.com/inmine/SlotReelKit.git`

### Preview

Screenshot:

![SlotReelKit Screenshot](image/show_image.jpg)

Animation:

![SlotReelKit Animation](image/show.gif)

### Features

- Classic 3×3 slot layout with customizable grid
- Staggered column animation with precise stop control
- Built-in strict win-line matrix generator
- UIKit and SwiftUI support
- CocoaPods and SPM ready

### Requirements

- iOS 16.0+
- Swift 5.9+
- Xcode 15+

### Installation

| Method | Use Case |
|--------|----------|
| SPM (Xcode) | Recommended |
| CocoaPods | Existing Pod projects |
| CocoaPods (Git) | Before trunk indexing |
| CocoaPods (Local) | Local development |

#### Swift Package Manager

**Xcode:**

1. **File → Add Package Dependencies...**
2. URL: `https://github.com/inmine/SlotReelKit.git`
3. **Exact Version**: `1.0.0`
4. Add `SlotReelKit` to your target

**Package.swift:**

```swift
dependencies: [
    .package(url: "https://github.com/inmine/SlotReelKit.git", exact: "1.0.0")
]
```

#### CocoaPods

```ruby
pod 'SlotReelKit', '1.0.0'
```

#### CocoaPods (Git)

```ruby
pod 'SlotReelKit', :git => 'https://github.com/inmine/SlotReelKit.git', :tag => '1.0.0'
```

### SwiftUI Quick Start

```swift
import SlotReelKit

@StateObject private var engine = SlotReelEngine(configuration: .default())

SlotReelView(
    engine: engine,
    appearance: SlotReelAppearanceConfiguration(
        symbolImageProviderClosure: { UIImage(named: "symbol_\($0 + 1)") }
    )
)

engine.startRoll(targetSymbolIndex: 2) {
    print("finished")
}
```

### License

MIT
